const express = require('express');
const controller = require('./auth.controller');
const { validate } = require('../../middleware/validation.middleware');
const {
  loginSchema,
  verifyLoginOtpSchema,
  resendLoginOtpSchema,
  changePasswordSchema,
} = require('./auth.validation');
const { authenticateUser } = require('../../middleware/auth.middleware');
const { requireSuperAdmin } = require('../../middleware/permission.middleware');
const { authLimiter } = require('../../middleware/rateLimit.middleware');

const router = express.Router();

router.post('/login', authLimiter, validate(loginSchema), controller.login);
router.post('/verify-otp', authLimiter, validate(verifyLoginOtpSchema), controller.verifyLoginOtp);
router.post('/resend-otp', authLimiter, validate(resendLoginOtpSchema), controller.resendLoginOtp);
router.patch(
  '/change-password',
  authenticateUser,
  requireSuperAdmin,
  validate(changePasswordSchema),
  controller.changePassword
);
router.post('/refresh-token', controller.refresh);
router.post('/logout', authenticateUser, controller.logout);
router.get('/me', authenticateUser, controller.me);

module.exports = router;
