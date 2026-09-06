const expenseRepository = require('./expense.repository');
const { NotFoundError } = require('../../utils/AppError');

async function listExpenses(auth, query) {
  return expenseRepository.list(auth, query);
}

async function getExpense(auth, id) {
  const expense = await expenseRepository.findById(id, auth.organizationId);
  if (!expense) throw new NotFoundError('Expense not found');
  return expense;
}

async function createExpense(auth, payload, receiptUrl = '') {
  return expenseRepository.create({
    ...payload,
    receiptUrl,
    organizationId: auth.organizationId,
    createdBy: auth.userId,
    expenseDate: payload.expenseDate ? new Date(payload.expenseDate) : new Date(),
  });
}

async function updateExpense(auth, id, payload, receiptUrl) {
  await getExpense(auth, id);
  const update = { ...payload };
  if (payload.expenseDate) update.expenseDate = new Date(payload.expenseDate);
  if (receiptUrl) update.receiptUrl = receiptUrl;
  return expenseRepository.updateById(id, auth.organizationId, update);
}

async function deleteExpense(auth, id) {
  const expense = await expenseRepository.remove(id, auth.organizationId);
  if (!expense) throw new NotFoundError('Expense not found');
  return { deleted: true };
}

async function deleteExpenses(auth, ids) {
  const deleted = await expenseRepository.removeMany(ids, auth);
  return { deleted };
}

module.exports = { listExpenses, getExpense, createExpense, updateExpense, deleteExpense, deleteExpenses };
