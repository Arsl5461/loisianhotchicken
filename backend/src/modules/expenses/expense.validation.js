const { z } = require('zod');
const { EXPENSE_CATEGORIES, PAYMENT_METHODS } = require('../../constants/enums');

const createExpenseSchema = z.object({
  storeId: z.string().min(1),
  title: z.string().min(2),
  description: z.string().optional(),
  category: z.enum(Object.values(EXPENSE_CATEGORIES)),
  amount: z.coerce.number().positive(),
  paymentMethod: z.enum(Object.values(PAYMENT_METHODS)),
  expenseDate: z.string().optional(),
});

const updateExpenseSchema = createExpenseSchema.partial();

module.exports = { createExpenseSchema, updateExpenseSchema };
