const borrowingRepository = require('./borrowing.repository');
const { NotFoundError, ValidationError } = require('../../utils/AppError');
const { startOfDay } = require('../../utils/dateHelper');

function money(value) {
  return Number((Number(value) || 0).toFixed(2));
}

function applyBalances(borrowing) {
  const amountPaid = money((borrowing.payments || []).reduce((sum, line) => sum + Number(line.amount || 0), 0));
  const amount = money(borrowing.amount);
  const amountOwed = money(Math.max(amount - amountPaid, 0));
  borrowing.amountPaid = amountPaid;
  borrowing.amountOwed = amountOwed;
  borrowing.status = amountOwed < 0.01 ? 'PAID' : 'OPEN';
  return borrowing;
}

async function listBorrowings(auth, query) {
  return borrowingRepository.list(auth, query);
}

async function getBorrowing(auth, id) {
  const borrowing = await borrowingRepository.findById(id, auth.organizationId);
  if (!borrowing) throw new NotFoundError('Money borrowed record not found');
  return borrowing;
}

async function createBorrowing(auth, payload) {
  const amount = money(payload.amount);
  return borrowingRepository.create({
    organizationId: auth.organizationId,
    storeId: payload.storeId,
    lender: payload.lender.trim(),
    note: payload.note || '',
    amount,
    amountPaid: 0,
    amountOwed: amount,
    status: 'OPEN',
    borrowedDate: payload.borrowedDate ? startOfDay(payload.borrowedDate) : new Date(),
    payments: [],
    createdBy: auth.userId,
  });
}

async function updateBorrowing(auth, id, payload) {
  const borrowing = await getBorrowing(auth, id);
  if (borrowing.payments?.length && payload.amount && money(payload.amount) < money(borrowing.amountPaid)) {
    throw new ValidationError('Amount borrowed cannot be less than what has already been paid back');
  }

  if (payload.lender) borrowing.lender = payload.lender.trim();
  if (payload.note !== undefined) borrowing.note = payload.note;
  if (payload.storeId) borrowing.storeId = payload.storeId;
  if (payload.amount) borrowing.amount = money(payload.amount);
  if (payload.borrowedDate) borrowing.borrowedDate = startOfDay(payload.borrowedDate);
  applyBalances(borrowing);
  await borrowing.save();
  return getBorrowing(auth, id);
}

async function repayBorrowing(auth, id, payload) {
  const borrowing = await getBorrowing(auth, id);
  if (borrowing.status === 'PAID' || borrowing.amountOwed < 0.01) {
    throw new ValidationError('This borrowed amount is already paid off');
  }

  const amount = money(payload.amount);
  if (amount - borrowing.amountOwed > 0.009) {
    throw new ValidationError(`Payment cannot be more than the ${borrowing.amountOwed.toFixed(2)} still owed`);
  }

  borrowing.payments.push({
    amount,
    paidDate: startOfDay(payload.paidDate),
    note: payload.note || '',
    createdBy: auth.userId,
  });
  applyBalances(borrowing);
  await borrowing.save();
  return getBorrowing(auth, id);
}

async function deleteBorrowing(auth, id) {
  const borrowing = await borrowingRepository.remove(id, auth.organizationId);
  if (!borrowing) throw new NotFoundError('Money borrowed record not found');
  return { deleted: true };
}

async function deleteBorrowings(auth, ids) {
  const deleted = await borrowingRepository.removeMany(ids, auth);
  return { deleted };
}

async function openBorrowings(auth, query) {
  return borrowingRepository.listOpen(auth, query);
}

module.exports = {
  listBorrowings,
  getBorrowing,
  createBorrowing,
  updateBorrowing,
  repayBorrowing,
  deleteBorrowing,
  deleteBorrowings,
  openBorrowings,
};
