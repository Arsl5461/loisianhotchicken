const { Borrowing } = require('../../database/models');
const { escapeRegex } = require('../../utils/pagination');
const { scopedStoreFilter } = require('../../middleware/storeAccess.middleware');
const { startOfDay, endOfDay } = require('../../utils/dateHelper');

const populate = [
  { path: 'storeId', select: 'name storeCode' },
  { path: 'createdBy', select: 'name' },
];

function buildFilter(auth, query) {
  const filter = {
    organizationId: auth.organizationId,
    ...scopedStoreFilter(auth, query.storeId),
  };
  if (query.status) filter.status = query.status;
  if (query.startDate || query.endDate) {
    filter.borrowedDate = {};
    if (query.startDate) filter.borrowedDate.$gte = startOfDay(query.startDate);
    if (query.endDate) filter.borrowedDate.$lte = endOfDay(query.endDate);
  }
  if (query.search) {
    filter.$or = [
      { lender: { $regex: escapeRegex(query.search), $options: 'i' } },
      { note: { $regex: escapeRegex(query.search), $options: 'i' } },
    ];
  }
  return filter;
}

async function list(auth, query) {
  const filter = buildFilter(auth, query);
  const [items, total] = await Promise.all([
    Borrowing.find(filter)
      .populate(populate)
      .sort({ borrowedDate: query.sortOrder || -1, createdAt: -1 })
      .skip(query.skip)
      .limit(query.limit),
    Borrowing.countDocuments(filter),
  ]);
  return { items, total };
}

async function findById(id, organizationId) {
  return Borrowing.findOne({ _id: id, organizationId }).populate(populate);
}

async function create(payload) {
  const borrowing = await Borrowing.create(payload);
  return findById(borrowing._id, payload.organizationId);
}

async function updateById(id, organizationId, payload) {
  return Borrowing.findOneAndUpdate({ _id: id, organizationId }, payload, { new: true }).populate(populate);
}

async function remove(id, organizationId) {
  return Borrowing.findOneAndDelete({ _id: id, organizationId });
}

async function removeMany(ids, auth) {
  const result = await Borrowing.deleteMany({
    _id: { $in: ids },
    organizationId: auth.organizationId,
    ...scopedStoreFilter(auth),
  });
  return result.deletedCount || 0;
}

async function listOpen(auth, { storeId, asOf } = {}) {
  return Borrowing.find({
    organizationId: auth.organizationId,
    status: 'OPEN',
    amountOwed: { $gt: 0 },
    borrowedDate: { $lte: asOf || new Date() },
    ...scopedStoreFilter(auth, storeId),
  })
    .populate('storeId', 'name storeCode')
    .sort({ borrowedDate: 1 });
}

module.exports = { list, findById, create, updateById, remove, removeMany, listOpen };
