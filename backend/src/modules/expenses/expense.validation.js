const { z } = require('zod');

const paymentLineSchema = z.object({
  method: z.string().min(1, 'Select a payment method'),
  amount: z.coerce.number().positive('Enter an amount for each payment method'),
});

function parsePayments(value) {
  if (value == null || value === '') return undefined;
  if (typeof value === 'string') {
    try {
      return JSON.parse(value);
    } catch {
      return value;
    }
  }
  return value;
}

const expenseFields = {
  storeId: z.string().min(1),
  title: z.string().min(2),
  description: z.string().optional(),
  category: z.string().min(1),
  amount: z.coerce.number().positive().optional(),
  paymentMethod: z.string().min(1).optional(),
  payments: z.preprocess(parsePayments, z.array(paymentLineSchema).optional()),
  expenseDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Select an expense date'),
};

function refineExpensePayments(data, ctx, required) {
  const payments = data.payments?.length
    ? data.payments
    : data.paymentMethod && data.amount
      ? [{ method: data.paymentMethod, amount: data.amount }]
      : [];

  if (!payments.length) {
    if (required) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['payments'],
        message: 'Add at least one payment method and amount',
      });
    }
    return;
  }

  const methods = payments.map((line) => line.method.trim().toLowerCase());
  if (new Set(methods).size !== methods.length) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['payments'],
      message: 'Each payment method can only be used once',
    });
  }

  const sum = payments.reduce((total, line) => total + Number(line.amount || 0), 0);
  if (data.amount && Math.abs(sum - Number(data.amount)) > 0.009) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['amount'],
      message: 'Payment amounts must add up to the expense total',
    });
  }
}

const createExpenseSchema = z.object(expenseFields).superRefine((data, ctx) => {
  refineExpensePayments(data, ctx, true);
});

const updateExpenseSchema = z.object(expenseFields).partial().superRefine((data, ctx) => {
  refineExpensePayments(data, ctx, false);
});

module.exports = { createExpenseSchema, updateExpenseSchema };
