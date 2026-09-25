const { z } = require('zod');

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

const verifyLoginOtpSchema = z.object({
  email: z.string().email(),
  challengeId: z.string().min(8),
  code: z.string().regex(/^\d{6}$/, 'Enter the 6-digit code'),
});

const resendLoginOtpSchema = z.object({
  email: z.string().email(),
  challengeId: z.string().min(8),
});

const changePasswordSchema = z.object({
  currentPassword: z.string().min(6),
  newPassword: z.string().min(8, 'New password must be at least 8 characters'),
});

module.exports = {
  loginSchema,
  verifyLoginOtpSchema,
  resendLoginOtpSchema,
  changePasswordSchema,
};
