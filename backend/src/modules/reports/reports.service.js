const dashboardService = require('../dashboard/dashboard.service');
const dashboardRepository = require('../dashboard/dashboard.repository');
const { monthBounds, resolveDateRange } = require('../../utils/dateHelper');

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

async function tenderTypes(auth, query) {
  const range =
    query.startDate && query.endDate
      ? resolveDateRange({ range: 'custom', startDate: query.startDate, endDate: query.endDate })
      : monthBounds(query.month);
  const data = await dashboardRepository.aggregateTenderTypes(auth, {
    storeId: query.storeId,
    start: range.start,
    end: range.end,
  });
  return {
    month: range.month,
    start: range.start,
    end: range.end,
    ...data,
  };
}

async function incomeExpenseStatement(auth, query) {
  const range =
    query.startDate && query.endDate
      ? resolveDateRange({ range: 'custom', startDate: query.startDate, endDate: query.endDate })
      : monthBounds(query.month);
  const data = await dashboardRepository.aggregateIncomeExpenseStatement(auth, {
    storeId: query.storeId,
    start: range.start,
    end: range.end,
  });
  return {
    start: range.start,
    end: range.end,
    ...data,
  };
}

module.exports = { profitLoss, storeComparison, tenderTypes, incomeExpenseStatement };
