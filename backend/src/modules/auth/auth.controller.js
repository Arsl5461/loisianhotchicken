const authService = require('./auth.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');
const { refreshCookieOptions, clearRefreshCookieOptions } = require('../../utils/token');

function setSessionCookie(res, result, message = 'Logged in successfully') {
  res.cookie('refreshToken', result.refreshToken, refreshCookieOptions());
  return ApiResponse.success(res, {
    message,
    data: {
      user: result.user,
      accessToken: result.accessToken,
    },
  });
}

const login = asyncHandler(async (req, res) => {
  const result = await authService.login(req.body);
  if (result.requiresOtp) {
    return ApiResponse.success(res, {
      message: 'A 6-digit sign-in code was sent to your email',
      data: {
        requiresOtp: true,
        challengeId: result.challengeId,
        email: result.email,
      },
    });
  }

  return setSessionCookie(res, result);
});

const verifyLoginOtp = asyncHandler(async (req, res) => {
  const result = await authService.verifyLoginOtp(req.body);
  return setSessionCookie(res, result);
});

const resendLoginOtp = asyncHandler(async (req, res) => {
  const result = await authService.resendLoginOtp(req.body);
  return ApiResponse.success(res, {
    message: 'A new 6-digit sign-in code was sent to your email',
    data: {
      requiresOtp: true,
      challengeId: result.challengeId,
      email: result.email,
    },
  });
});

const forgotPassword = asyncHandler(async (req, res) => {
  await authService.forgotPassword(req.body);
  return ApiResponse.success(res, {
    message: authService.FORGOT_PASSWORD_MESSAGE,
    data: {},
  });
});

const resetPassword = asyncHandler(async (req, res) => {
  await authService.resetPassword(req.body);
  return ApiResponse.success(res, {
    message: 'Password reset successfully. You can sign in with your new password.',
    data: {},
  });
});

const changePassword = asyncHandler(async (req, res) => {
  await authService.changePassword(req.user, req.body);
  return ApiResponse.success(res, {
    message: 'Password updated successfully',
    data: {},
  });
});

const refresh = asyncHandler(async (req, res) => {
  const token = req.cookies?.refreshToken || req.body?.refreshToken;
  const result = await authService.refresh(token);
  return setSessionCookie(res, result, 'Token refreshed');
});

const logout = asyncHandler(async (req, res) => {
  if (req.user?._id) {
    await authService.logout(req.user._id);
  }
  res.clearCookie('refreshToken', clearRefreshCookieOptions());
  return ApiResponse.success(res, { message: 'Logged out successfully', data: {} });
});

const me = asyncHandler(async (req, res) => {
  const user = await authService.me(req.user);
  return ApiResponse.success(res, { message: 'Profile fetched successfully', data: user });
});

module.exports = {
  login,
  verifyLoginOtp,
  resendLoginOtp,
  forgotPassword,
  resetPassword,
  changePassword,
  refresh,
  logout,
  me,
};
