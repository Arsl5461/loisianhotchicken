const { ForbiddenError } = require('../utils/AppError');

const checkPermission = (permission) => (req, res, next) => {
  if (!req.auth) {
    return next(new ForbiddenError('Permission context missing'));
  }

  if (req.auth.isSuperAdmin) {
    return next();
  }

  if (!req.auth.permissions.includes(permission)) {
    return next(new ForbiddenError('You do not have permission to perform this action'));
  }

  return next();
};

module.exports = {
  checkPermission,
};
