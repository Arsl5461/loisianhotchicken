const bcrypt = require('bcryptjs');
const { User } = require('../../database/models');

async function findByEmail(email) {
  return User.findOne({ email: email.toLowerCase() })
    .select('+password +refreshTokenHash')
    .populate('roleId')
    .populate('stores', 'name storeCode status city');
}

async function findByIdForAuth(id) {
  return User.findById(id)
    .select('+refreshTokenHash')
    .populate('roleId')
    .populate('stores', 'name storeCode status city');
}

async function saveRefreshToken(userId, tokenHash) {
  return User.findByIdAndUpdate(userId, { refreshTokenHash: tokenHash, lastLogin: new Date() });
}

async function clearRefreshToken(userId) {
  return User.findByIdAndUpdate(userId, { $unset: { refreshTokenHash: 1 } });
}

async function compareRefreshHash(token, hash) {
  if (!token || !hash) return false;
  return bcrypt.compare(token, hash);
}

module.exports = {
  findByEmail,
  findByIdForAuth,
  saveRefreshToken,
  clearRefreshToken,
  compareRefreshHash,
};
