const { Sale, Expense, Order, Store, Borrowing } = require('../models');
const logger = require('../../config/logger');
const { toAppBusinessDate } = require('../../utils/dateHelper');

function sameInstant(left, right) {
  return new Date(left).getTime() === new Date(right).getTime();
}

async function normalizeField(Model, field) {
  const docs = await Model.find({ [field]: { $exists: true, $ne: null } }).select(field);
  let updated = 0;

  for (const doc of docs) {
    const next = toAppBusinessDate(doc[field]);
    if (!next || sameInstant(doc[field], next)) continue;
    await Model.updateOne({ _id: doc._id }, { $set: { [field]: next } });
    updated += 1;
  }

  return updated;
}

async function normalizeBorrowingDates() {
  const docs = await Borrowing.find({}).select('borrowedDate payments.paidDate');
  let updated = 0;

  for (const doc of docs) {
    const set = {};
    if (doc.borrowedDate) {
      const next = toAppBusinessDate(doc.borrowedDate);
      if (next && !sameInstant(doc.borrowedDate, next)) set.borrowedDate = next;
    }

    if (doc.payments?.length) {
      const payments = doc.payments.map((payment) => {
        if (!payment.paidDate) return payment;
        const next = toAppBusinessDate(payment.paidDate);
        if (!next || sameInstant(payment.paidDate, next)) return payment;
        payment.paidDate = next;
        return payment;
      });
      if (payments.some((payment, index) => !sameInstant(payment.paidDate || 0, doc.payments[index].paidDate || 0))) {
        set.payments = payments;
      }
    }

    if (!Object.keys(set).length) continue;
    await Borrowing.updateOne({ _id: doc._id }, { $set: set });
    updated += 1;
  }

  return updated;
}

async function normalizeBusinessDates() {
  const [sales, expenses, orders, stores, borrowings] = await Promise.all([
    normalizeField(Sale, 'saleDate'),
    normalizeField(Expense, 'expenseDate'),
    normalizeField(Order, 'orderDate'),
    normalizeField(Store, 'openingDate'),
    normalizeBorrowingDates(),
  ]);

  const total = sales + expenses + orders + stores + borrowings;
  if (total) {
    logger.info(
      `Normalized business dates to America/Chicago: ${sales} sales, ${expenses} expenses, ${orders} orders, ${stores} stores, ${borrowings} borrowings`
    );
  }
}

module.exports = { normalizeBusinessDates };
