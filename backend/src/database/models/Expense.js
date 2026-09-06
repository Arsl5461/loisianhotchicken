const mongoose = require('mongoose');
const { EXPENSE_CATEGORIES, PAYMENT_METHODS } = require('../../constants/enums');

const expenseSchema = new mongoose.Schema(
  {
    organizationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Organization',
      required: true,
    },
    storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store', required: true },
    title: { type: String, required: true, trim: true },
    description: { type: String, trim: true, default: '' },
    category: {
      type: String,
      enum: Object.values(EXPENSE_CATEGORIES),
      required: true,
    },
    amount: { type: Number, required: true, min: 0.01 },
    paymentMethod: {
      type: String,
      enum: Object.values(PAYMENT_METHODS),
      default: PAYMENT_METHODS.CASH,
    },
    expenseDate: { type: Date, required: true, default: Date.now },
    receiptUrl: { type: String, default: '' },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  },
  { timestamps: true }
);

expenseSchema.index({ organizationId: 1, storeId: 1, expenseDate: -1 });
expenseSchema.index({ organizationId: 1, category: 1, expenseDate: -1 });

module.exports = mongoose.model('Expense', expenseSchema);
