const mongoose = require('mongoose');

const repaymentSchema = new mongoose.Schema(
  {
    amount: { type: Number, required: true, min: 0.01 },
    paidDate: { type: Date, required: true },
    note: { type: String, trim: true, default: '' },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  },
  { timestamps: true }
);

const borrowingSchema = new mongoose.Schema(
  {
    organizationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Organization',
      required: true,
    },
    storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store', required: true },
    lender: { type: String, required: true, trim: true },
    note: { type: String, trim: true, default: '' },
    amount: { type: Number, required: true, min: 0.01 },
    amountPaid: { type: Number, default: 0, min: 0 },
    amountOwed: { type: Number, required: true, min: 0 },
    borrowedDate: { type: Date, required: true, default: Date.now },
    status: { type: String, enum: ['OPEN', 'PAID'], default: 'OPEN' },
    payments: { type: [repaymentSchema], default: [] },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  },
  { timestamps: true }
);

borrowingSchema.index({ organizationId: 1, storeId: 1, borrowedDate: -1 });
borrowingSchema.index({ organizationId: 1, status: 1, borrowedDate: -1 });

module.exports = mongoose.model('Borrowing', borrowingSchema);
