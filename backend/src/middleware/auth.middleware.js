const jwt = require('jsonwebtoken');
const env = require('../config/environment');
const { User, Role } = require('../database/models');
const { UnauthorizedError } = require('../utils/AppError');
const { ROLE_SLUGS } = require('../constants/roles');
const asyncHandler = require('../utils/asyncHandler');

const authenticateUser = asyncHandler(async (req, res, next) => {
  const header = req.headers.authorization;
  const token = header?.startsWith('Bearer ') ? header.split(' ')[1] : req.cookies?.accessToken;

  if (!token) {
    throw new UnauthorizedError('Authentication required');
  }

  let decoded;
  try {
    decoded = jwt.verify(token, env.jwt.accessSecret);
  } catch {
    throw new UnauthorizedError('Invalid or expired access token');
  }

  const user = await User.findById(decoded.sub).populate('roleId').populate('stores', 'name storeCode status');
  if (!user || !user.isActive) {
    throw new UnauthorizedError('Account is inactive or does not exist');
  }

  const role = user.roleId instanceof Role ? user.roleId : await Role.findById(user.roleId);
  req.user = user;
  req.auth = {
    userId: user._id,
    organizationId: user.organizationId,
    roleSlug: role?.slug,
    permissions: role?.permissions || [],
    storeIds: (user.stores || []).map((store) => store._id || store),
    isSuperAdmin: role?.slug === ROLE_SLUGS.SUPER_ADMIN,
  };

  next();
});

module.exports = {
  authenticateUser,
};
