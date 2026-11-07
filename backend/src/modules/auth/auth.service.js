const crypto = require('crypto');
const authRepository = require('./auth.repository');
const { UnauthorizedError, ForbiddenError, ValidationError } = require('../../utils/AppError');
const { ROLE_SLUGS } = require('../../constants/roles');
const { sendLoginCodeEmail, sendPasswordResetEmail } = require('../../utils/mailer');
const {
  signAccessToken,
  signRefreshToken,
  verifyRefreshToken,
  hashToken,
  hashResetToken,
  hashesEqual,
} = require('../../utils/token');

const OTP_TTL_MS = 10 * 60 * 1000;

function serializeUser(user) {
  const role = user.roleId;
  return {
    id: user._id,
    name: user.name,
    email: user.email,
    avatar: user.avatar,
    organizationId: user.organizationId,
    role: {
      id: role?._id,
      name: role?.name,
      slug: role?.slug,
    },
    permissions: role?.permissions || [],
    stores: (user.stores || []).filter(Boolean),
    defaultStore: user.defaultStore,
    isSuperAdmin: role?.slug === ROLE_SLUGS.SUPER_ADMIN,
    isActive: user.isActive,
    lastLogin: user.lastLogin,
  };
}

function isSuperAdminUser(user) {
  return user?.roleId?.slug === ROLE_SLUGS.SUPER_ADMIN;
}

async function issueSession(user) {
  const accessToken = signAccessToken(user);
  const refreshToken = signRefreshToken(user);
  const refreshTokenHash = await hashToken(refreshToken);
  await authRepository.saveRefreshToken(user._id, refreshTokenHash);

  return {
    user: serializeUser(user),
    accessToken,
    refreshToken,
  };
}

async function issueLoginOtp(user) {
  const code = String(crypto.randomInt(100000, 1000000));
  const challengeId = crypto.randomUUID();

  await authRepository.saveLoginOtp(user._id, {
    hash: hashResetToken(code),
    expires: new Date(Date.now() + OTP_TTL_MS),
    challengeId,
  });

  await sendLoginCodeEmail({
    to: user.email,
    name: user.name,
    code,
  });

  return {
    requiresOtp: true,
    challengeId,
    email: user.email,
  };
}

async function login({ email, password }) {
  const user = await authRepository.findByEmail(email);
  if (!user || !user.isActive) {
    throw new UnauthorizedError('Invalid email or password');
  }

  const valid = await user.comparePassword(password);
  if (!valid) {
    throw new UnauthorizedError('Invalid email or password');
  }

  if (isSuperAdminUser(user)) {
    return issueLoginOtp(user);
  }

  return issueSession(user);
}

async function verifyLoginOtp({ email, challengeId, code }) {
  const user = await authRepository.findByEmailForOtp(email);
  if (!user || !user.isActive || !isSuperAdminUser(user)) {
    throw new UnauthorizedError('Invalid or expired sign-in code');
  }

  if (!user.loginOtpChallenge || !hashesEqual(user.loginOtpChallenge, challengeId)) {
    throw new UnauthorizedError('Invalid or expired sign-in code');
  }

  if (!user.loginOtpExpires || user.loginOtpExpires.getTime() < Date.now()) {
    await authRepository.clearLoginOtp(user._id);
    throw new UnauthorizedError('Sign-in code has expired');
  }

  if (!user.loginOtpHash || !hashesEqual(user.loginOtpHash, hashResetToken(String(code).trim()))) {
    throw new UnauthorizedError('Invalid or expired sign-in code');
  }

  await authRepository.clearLoginOtp(user._id);
  return issueSession(user);
}

async function resendLoginOtp({ email, challengeId }) {
  const user = await authRepository.findByEmailForOtp(email);
  if (!user || !user.isActive || !isSuperAdminUser(user)) {
    throw new UnauthorizedError('Unable to resend sign-in code');
  }

  if (!user.loginOtpChallenge || !hashesEqual(user.loginOtpChallenge, challengeId)) {
    throw new UnauthorizedError('Unable to resend sign-in code');
  }

  return issueLoginOtp(user);
}

const FORGOT_PASSWORD_MESSAGE = 'If that email is on file, a 6-digit reset code was sent.';

async function forgotPassword({ email }) {
  const user = await authRepository.findByEmailForReset(email);
  if (!user || !user.isActive) {
    return { sent: true };
  }

  const code = String(crypto.randomInt(100000, 1000000));
  await authRepository.savePasswordReset(user._id, {
    hash: hashResetToken(code),
    expires: new Date(Date.now() + OTP_TTL_MS),
  });
  await sendPasswordResetEmail({
    to: user.email,
    name: user.name,
    code,
  });

  return { sent: true };
}

async function resetPassword({ email, code, newPassword }) {
  const user = await authRepository.findByEmailForReset(email);
  if (!user || !user.isActive) {
    throw new UnauthorizedError('Invalid or expired reset code');
  }

  if (!user.passwordResetExpires || user.passwordResetExpires.getTime() < Date.now()) {
    await authRepository.clearPasswordReset(user._id);
    throw new UnauthorizedError('Reset code has expired');
  }

  if (
    !user.passwordResetTokenHash ||
    !hashesEqual(user.passwordResetTokenHash, hashResetToken(String(code).trim()))
  ) {
    throw new UnauthorizedError('Invalid or expired reset code');
  }

  if (await user.comparePassword(newPassword)) {
    throw new ValidationError('New password must be different from the current password');
  }

  user.password = newPassword;
  user.passwordResetTokenHash = undefined;
  user.passwordResetExpires = undefined;
  user.refreshTokenHash = undefined;
  await user.save();
  await authRepository.clearRefreshToken(user._id);
  await authRepository.clearPasswordReset(user._id);

  return { reset: true };
}

async function changePassword(actor, { currentPassword, newPassword }) {
  if (!actor?.isSuperAdmin && actor?.roleId?.slug !== ROLE_SLUGS.SUPER_ADMIN) {
    throw new ForbiddenError('Only the super admin can change this password');
  }

  const user = await authRepository.findByIdWithPassword(actor._id);
  if (!user) {
    throw new UnauthorizedError('Account not found');
  }

  const valid = await user.comparePassword(currentPassword);
  if (!valid) {
    throw new ValidationError('Current password is incorrect');
  }

  if (currentPassword === newPassword) {
    throw new ValidationError('New password must be different from the current password');
  }

  user.password = newPassword;
  await user.save();

  return { changed: true };
}

async function refresh(refreshToken) {
  if (!refreshToken) {
    throw new UnauthorizedError('Refresh token missing');
  }

  let decoded;
  try {
    decoded = verifyRefreshToken(refreshToken);
  } catch {
    throw new UnauthorizedError('Invalid refresh token');
  }

  const user = await authRepository.findByIdForAuth(decoded.sub);
  if (!user || !user.isActive) {
    throw new UnauthorizedError('Account is inactive');
  }

  const matches = await authRepository.compareRefreshHash(refreshToken, user.refreshTokenHash);
  if (!matches) {
    throw new UnauthorizedError('Refresh token has been revoked');
  }

  return issueSession(user);
}

async function logout(userId) {
  await authRepository.clearRefreshToken(userId);
}

async function me(user) {
  const hydrated = await authRepository.findByIdForAuth(user._id);
  return serializeUser(hydrated);
}

module.exports = {
  login,
  verifyLoginOtp,
  resendLoginOtp,
  forgotPassword,
  resetPassword,
  FORGOT_PASSWORD_MESSAGE,
  changePassword,
  refresh,
  logout,
  me,
  serializeUser,
};
