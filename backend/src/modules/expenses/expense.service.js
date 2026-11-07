const expenseRepository = require('./expense.repository');
const expenseCategoryService = require('../expenseCategories/expenseCategory.service');
const paymentMethodService = require('../paymentMethods/paymentMethod.service');
const { NotFoundError, ValidationError } = require('../../utils/AppError');
const { startOfDay } = require('../../utils/dateHelper');

function money(value) {
  return Number((Number(value) || 0).toFixed(2));
}

function rawPayments(payload) {
  if (Array.isArray(payload.payments) && payload.payments.length) {
    return payload.payments;
  }
  if (payload.paymentMethod && payload.amount) {
    return [{ method: payload.paymentMethod, amount: payload.amount }];
  }
  return [];
}

async function normalizePayments(auth, payload) {
  const lines = rawPayments(payload);
  if (!lines.length) {
    throw new ValidationError('Add at least one payment method and amount');
  }

  const payments = [];
  for (const line of lines) {
    const method = await paymentMethodService.assertActiveMethod(auth, line.method);
    payments.push({ method, amount: money(line.amount) });
  }

  const amount = money(payments.reduce((sum, line) => sum + line.amount, 0));
  if (amount < 0.01) {
    throw new ValidationError('Enter an amount for each payment method');
  }

  return {
    payments,
    amount,
    paymentMethod: payments[0].method,
  };
}

async function listExpenses(auth, query) {
  return expenseRepository.list(auth, query);
}

async function getExpense(auth, id) {
  const expense = await expenseRepository.findById(id, auth.organizationId);
  if (!expense) throw new NotFoundError('Expense not found');
  return expense;
}

async function createExpense(auth, payload, receiptUrl = '') {
  const category = await expenseCategoryService.assertActiveCategory(auth, payload.category);
  const payment = await normalizePayments(auth, payload);
  return expenseRepository.create({
    ...payload,
    ...payment,
    category,
    receiptUrl,
    organizationId: auth.organizationId,
    createdBy: auth.userId,
    expenseDate: payload.expenseDate ? startOfDay(payload.expenseDate) : new Date(),
  });
}

async function updateExpense(auth, id, payload, receiptUrl) {
  await getExpense(auth, id);
  const update = { ...payload };
  if (payload.category) update.category = await expenseCategoryService.assertActiveCategory(auth, payload.category);
  if (payload.payments || payload.paymentMethod) {
    Object.assign(update, await normalizePayments(auth, payload));
  }
  if (payload.expenseDate) update.expenseDate = startOfDay(payload.expenseDate);
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
