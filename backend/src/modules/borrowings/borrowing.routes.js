const express = require('express');
const controller = require('./borrowing.controller');
const { authenticateUser } = require('../../middleware/auth.middleware');
const { checkPermission } = require('../../middleware/permission.middleware');
const { checkStoreAccess } = require('../../middleware/storeAccess.middleware');
const { validate } = require('../../middleware/validation.middleware');
const {
  createBorrowingSchema,
  updateBorrowingSchema,
  repayBorrowingSchema,
} = require('./borrowing.validation');
const { PERMISSIONS } = require('../../constants/permissions');
const { bulkDeleteSchema } = require('../../utils/bulk');

const router = express.Router();
router.use(authenticateUser, checkStoreAccess);

router.get('/', checkPermission(PERMISSIONS.EXPENSES_READ), controller.list);
router.post('/bulk-delete', checkPermission(PERMISSIONS.EXPENSES_DELETE), validate(bulkDeleteSchema), controller.bulkRemove);
router.post('/', checkPermission(PERMISSIONS.EXPENSES_CREATE), validate(createBorrowingSchema), controller.create);
router.post(
  '/:id/repay',
  checkPermission(PERMISSIONS.EXPENSES_UPDATE),
  validate(repayBorrowingSchema),
  controller.repay
);
router.get('/:id', checkPermission(PERMISSIONS.EXPENSES_READ), controller.getById);
router.patch('/:id', checkPermission(PERMISSIONS.EXPENSES_UPDATE), validate(updateBorrowingSchema), controller.update);
router.delete('/:id', checkPermission(PERMISSIONS.EXPENSES_DELETE), controller.remove);

module.exports = router;
