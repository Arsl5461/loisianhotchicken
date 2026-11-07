const nodemailer = require('nodemailer');
const env = require('../config/environment');
const logger = require('../config/logger');
const { AppError } = require('./AppError');

function createTransport() {
  if (!env.smtp.host || !env.smtp.user || !env.smtp.pass) {
    return null;
  }

  return nodemailer.createTransport({
    host: env.smtp.host,
    port: env.smtp.port,
    secure: env.smtp.port === 465,
    auth: {
      user: env.smtp.user,
      pass: env.smtp.pass,
    },
  });
}

function loginCodeHtml({ name, code }) {
  return `
    <div style="font-family:Arial,sans-serif;max-width:520px;margin:0 auto;padding:24px;color:#1f2937">
      <p style="margin:0 0 8px;font-size:12px;letter-spacing:0.16em;text-transform:uppercase;color:#c41e3a;font-weight:700">
        Louisiana's Hot Chicken
      </p>
      <h1 style="margin:0 0 16px;font-size:22px">Your sign-in code</h1>
      <p style="margin:0 0 16px;line-height:1.5">Hi ${name || 'there'}, use this 6-digit code to finish signing in. It expires in 10 minutes.</p>
      <p style="margin:0 0 20px;font-size:32px;letter-spacing:0.28em;font-weight:700;color:#c41e3a">${code}</p>
      <p style="margin:0;font-size:13px;color:#64748b">If you did not try to sign in, change your password immediately.</p>
    </div>
  `;
}

async function sendLoginCodeEmail({ to, name, code }) {
  const transport = createTransport();
  const subject = "Your Louisiana's Hot Chicken sign-in code";
  const text = `Hi ${name || 'there'},\n\nYour 6-digit sign-in code is ${code}. It expires in 10 minutes.\n\nIf you did not try to sign in, change your password immediately.`;

  if (!transport) {
    if (env.isProduction) {
      throw new AppError('Email delivery is not configured', 500);
    }
    logger.warn(`Login code for ${to}: ${code}`);
    return { delivered: false };
  }

  await transport.sendMail({
    from: env.smtp.from,
    to,
    subject,
    text,
    html: loginCodeHtml({ name, code }),
  });

  return { delivered: true };
}

function resetCodeHtml({ name, code }) {
  return `
    <div style="font-family:Arial,sans-serif;max-width:520px;margin:0 auto;padding:24px;color:#1f2937">
      <p style="margin:0 0 8px;font-size:12px;letter-spacing:0.16em;text-transform:uppercase;color:#c41e3a;font-weight:700">
        Louisiana's Hot Chicken
      </p>
      <h1 style="margin:0 0 16px;font-size:22px">Reset your password</h1>
      <p style="margin:0 0 16px;line-height:1.5">Hi ${name || 'there'}, use this 6-digit code to reset your password. It expires in 10 minutes.</p>
      <p style="margin:0 0 20px;font-size:32px;letter-spacing:0.28em;font-weight:700;color:#c41e3a">${code}</p>
      <p style="margin:0;font-size:13px;color:#64748b">If you did not ask to reset your password, you can ignore this email.</p>
    </div>
  `;
}

async function sendPasswordResetEmail({ to, name, code }) {
  const transport = createTransport();
  const subject = "Your Louisiana's Hot Chicken password reset code";
  const text = `Hi ${name || 'there'},\n\nYour 6-digit password reset code is ${code}. It expires in 10 minutes.\n\nIf you did not ask to reset your password, you can ignore this email.`;

  if (!transport) {
    if (env.isProduction) {
      throw new AppError('Email delivery is not configured', 500);
    }
    logger.warn(`Password reset code for ${to}: ${code}`);
    return { delivered: false };
  }

  await transport.sendMail({
    from: env.smtp.from,
    to,
    subject,
    text,
    html: resetCodeHtml({ name, code }),
  });

  return { delivered: true };
}

module.exports = {
  sendLoginCodeEmail,
  sendPasswordResetEmail,
};
