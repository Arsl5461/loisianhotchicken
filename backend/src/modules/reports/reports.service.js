const dashboardService = require('../dashboard/dashboard.service');

async function profitLoss(auth, query) {
  const overview = await dashboardService.getOverview(auth, query);
  return {
    range: overview.range,
    summary: {
      grossRevenue: overview.summary.totalRevenue,
      totalExpenses: overview.summary.totalExpenses,
      netProfit: overview.summary.netProfit,
      profitMargin: overview.summary.profitMargin,
    },
    series: overview.profitLossData,
    expenseBreakdown: overview.expenseBreakdown,
  };
}

async function storeComparison(auth, query) {
  const overview = await dashboardService.getOverview(auth, {
    ...query,
    storeId: undefined,
  });
  return {
    range: overview.range,
    stores: overview.storePerformance,
    ranking: overview.storePerformance.slice(0, 5),
  };
}

module.exports = { profitLoss, storeComparison };
