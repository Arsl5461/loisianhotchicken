const mongoose = require('mongoose');
const { Sale, Expense, Order, Store } = require('../../database/models');
const { scopedStoreFilter } = require('../../middleware/storeAccess.middleware');
const { dateTruncUnit } = require('../../utils/dateHelper');

function toObjectId(id) {
  return new mongoose.Types.ObjectId(id);
}

function matchStage(auth, storeId, dateField, start, end) {
  const match = {
    organizationId: toObjectId(auth.organizationId),
    [dateField]: { $gte: start, $lte: end },
    ...scopedStoreFilter(auth, storeId),
  };

  if (match.storeId) {
    if (match.storeId.$in) {
      match.storeId = { $in: match.storeId.$in.map((id) => toObjectId(id)) };
    } else {
      match.storeId = toObjectId(match.storeId);
    }
  }

  return match;
}

function periodGroup(dateField, groupBy) {
  return {
    $dateTrunc: {
      date: `$${dateField}`,
      unit: dateTruncUnit(groupBy),
    },
  };
}

async function aggregateSales(auth, { storeId, start, end, groupBy }) {
  const match = matchStage(auth, storeId, 'saleDate', start, end);

  const [result] = await Sale.aggregate([
    { $match: match },
    {
      $facet: {
        totals: [
          {
            $group: {
              _id: null,
              totalRevenue: { $sum: '$totalAmount' },
              saleCount: { $sum: 1 },
            },
          },
        ],
        byPeriod: [
          {
            $group: {
              _id: periodGroup('saleDate', groupBy),
              revenue: { $sum: '$totalAmount' },
            },
          },
          { $sort: { _id: 1 } },
        ],
        byStore: [
          {
            $group: {
              _id: '$storeId',
              revenue: { $sum: '$totalAmount' },
              sales: { $sum: 1 },
            },
          },
          {
            $lookup: {
              from: 'stores',
              localField: '_id',
              foreignField: '_id',
              as: 'store',
            },
          },
          { $unwind: { path: '$store', preserveNullAndEmptyArrays: true } },
        ],
        recent: [
          { $sort: { saleDate: -1 } },
          { $limit: 10 },
          {
            $lookup: {
              from: 'stores',
              localField: 'storeId',
              foreignField: '_id',
              as: 'store',
            },
          },
          { $unwind: { path: '$store', preserveNullAndEmptyArrays: true } },
        ],
      },
    },
  ]);

  return result || { totals: [], byPeriod: [], byStore: [], recent: [] };
}

async function aggregateExpenses(auth, { storeId, start, end, groupBy }) {
  const match = matchStage(auth, storeId, 'expenseDate', start, end);

  const [result] = await Expense.aggregate([
    { $match: match },
    {
      $facet: {
        totals: [
          {
            $group: {
              _id: null,
              totalExpenses: { $sum: '$amount' },
              expenseCount: { $sum: 1 },
            },
          },
        ],
        byPeriod: [
          {
            $group: {
              _id: periodGroup('expenseDate', groupBy),
              expenses: { $sum: '$amount' },
            },
          },
          { $sort: { _id: 1 } },
        ],
        byCategory: [
          {
            $group: {
              _id: '$category',
              amount: { $sum: '$amount' },
            },
          },
          { $sort: { amount: -1 } },
        ],
        byStore: [
          {
            $group: {
              _id: '$storeId',
              expenses: { $sum: '$amount' },
            },
          },
          {
            $lookup: {
              from: 'stores',
              localField: '_id',
              foreignField: '_id',
              as: 'store',
            },
          },
          { $unwind: { path: '$store', preserveNullAndEmptyArrays: true } },
        ],
        topExpenses: [
          { $sort: { amount: -1 } },
          { $limit: 5 },
          {
            $lookup: {
              from: 'stores',
              localField: 'storeId',
              foreignField: '_id',
              as: 'store',
            },
          },
          { $unwind: { path: '$store', preserveNullAndEmptyArrays: true } },
        ],
        recent: [
          { $sort: { expenseDate: -1 } },
          { $limit: 10 },
          {
            $lookup: {
              from: 'stores',
              localField: 'storeId',
              foreignField: '_id',
              as: 'store',
            },
          },
          { $unwind: { path: '$store', preserveNullAndEmptyArrays: true } },
        ],
      },
    },
  ]);

  return result || { totals: [], byPeriod: [], byCategory: [], byStore: [], topExpenses: [], recent: [] };
}

async function aggregateOrders(auth, { storeId, start, end }) {
  const match = matchStage(auth, storeId, 'orderDate', start, end);

  const [result] = await Order.aggregate([
    { $match: match },
    {
      $facet: {
        totals: [{ $group: { _id: null, totalOrders: { $sum: 1 } } }],
        byStore: [
          {
            $group: {
              _id: '$storeId',
              orders: { $sum: 1 },
            },
          },
        ],
      },
    },
  ]);

  return result || { totals: [], byStore: [] };
}

async function countActiveStores(auth, storeId) {
  const filter = {
    organizationId: auth.organizationId,
    status: 'ACTIVE',
    deletedAt: null,
  };

  if (storeId) {
    filter._id = storeId;
  } else if (!auth.isSuperAdmin) {
    filter._id = { $in: auth.storeIds };
  }

  return Store.countDocuments(filter);
}

module.exports = {
  aggregateSales,
  aggregateExpenses,
  aggregateOrders,
  countActiveStores,
};
