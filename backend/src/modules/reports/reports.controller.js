const reportsService = require('./reports.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');

const profitLoss = asyncHandler(async (req, res) => {
  const data = await reportsService.profitLoss(req.auth, req.query);
  return ApiResponse.success(res, { message: 'Profit and loss report fetched', data });
});

const storeComparison = asyncHandler(async (req, res) => {
  const data = await reportsService.storeComparison(req.auth, req.query);
  return ApiResponse.success(res, { message: 'Store comparison fetched', data });
});

module.exports = { profitLoss, storeComparison };
