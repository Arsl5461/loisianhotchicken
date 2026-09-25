const { z } = require('zod');

const createBorrowingSchema = z.object({
  storeId: z.string().min(1),
  lender: z.string().min(2, 'Enter who the money was borrowed from'),
  note: z.string().optional(),
  amount: z.coerce.number().positive('Enter the amount borrowed'),
  borrowedDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Select a date'),
});

const updateBorrowingSchema = createBorrowingSchema.partial();

const repayBorrowingSchema = z.object({
  amount: z.coerce.number().positive('Enter the amount paid'),
  paidDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Select a payment date'),
  note: z.string().optional(),
});

module.exports = {
  createBorrowingSchema,
  updateBorrowingSchema,
  repayBorrowingSchema,
};
