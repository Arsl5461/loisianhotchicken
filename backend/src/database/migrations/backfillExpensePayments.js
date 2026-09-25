const { Expense } = require('../models');
const logger = require('../../config/logger');

async function backfillExpensePayments() {
  const result = await Expense.updateMany(
    {
      $or: [{ payments: { $exists: false } }, { payments: { $size: 0 } }],
      paymentMethod: { $exists: true, $ne: '' },
      amount: { $gt: 0 },
    },
    [
      {
        $set: {
          payments: [
            {
              method: '$paymentMethod',
              amount: '$amount',
            },
          ],
        },
      },
    ]
  );

  if (result.modifiedCount) {
    logger.info(`Backfilled payment splits on ${result.modifiedCount} expenses`);
  }
}

module.exports = { backfillExpensePayments };
