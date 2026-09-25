const borrowingService = require('./borrowing.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');
const { parseListQuery, buildMeta } = require('../../utils/pagination');

const list = asyncHandler(async (req, res) => {
  const query = parseListQuery(req.query);
  const { items, total } = await borrowingService.listBorrowings(req.auth, {
    ...query,
    status: req.query.status,
  });
  return ApiResponse.success(res, {
    message: 'Money borrowed fetched successfully',
    data: items,
    meta: buildMeta({ page: query.page, limit: query.limit, total }),
  });
});

const getById = asyncHandler(async (req, res) => {
  const data = await borrowingService.getBorrowing(req.auth, req.params.id);
  return ApiResponse.success(res, { message: 'Money borrowed fetched successfully', data });
});

const create = asyncHandler(async (req, res) => {
  const data = await borrowingService.createBorrowing(req.auth, req.body);
  return ApiResponse.created(res, { message: 'Money borrowed recorded', data });
});

const update = asyncHandler(async (req, res) => {
  const data = await borrowingService.updateBorrowing(req.auth, req.params.id, req.body);
  return ApiResponse.success(res, { message: 'Money borrowed updated', data });
});

const repay = asyncHandler(async (req, res) => {
  const data = await borrowingService.repayBorrowing(req.auth, req.params.id, req.body);
  return ApiResponse.success(res, {
    message: data.status === 'PAID' ? 'Borrowed money paid off' : 'Payment recorded',
    data,
  });
});

const remove = asyncHandler(async (req, res) => {
  const data = await borrowingService.deleteBorrowing(req.auth, req.params.id);
  return ApiResponse.success(res, { message: 'Money borrowed deleted', data });
});

const bulkRemove = asyncHandler(async (req, res) => {
  const data = await borrowingService.deleteBorrowings(req.auth, req.body.ids);
  return ApiResponse.success(res, { message: 'Money borrowed deleted', data });
});

module.exports = { list, getById, create, update, repay, remove, bulkRemove };
