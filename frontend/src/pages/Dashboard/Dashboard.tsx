import { useState } from 'react';
import { useGetOverviewQuery } from '../../api/dashboardApi';
import { PageHeader } from '../../components/common/PageHeader';
import { ErrorState, SkeletonGrid } from '../../components/common/LoadingSpinner';
import { DashboardStats } from '../../components/dashboard/DashboardStats';
import { RevenueExpenseChart } from '../../components/dashboard/RevenueExpenseChart';
import { ExpenseBreakdownChart } from '../../components/dashboard/ExpenseBreakdownChart';
import { StoreRanking } from '../../components/dashboard/StorePerformanceChart';
import { RecentTransactions } from '../../components/dashboard/RecentTransactions';
import { TopExpenses } from '../../components/dashboard/TopExpenses';
import { useStoreContext } from '../../hooks/usePermissions';

const RANGES = [
  { id: '7d', label: '7 days', groupBy: 'day' },
  { id: '30d', label: '30 days', groupBy: 'day' },
  { id: '3m', label: '3 months', groupBy: 'week' },
  { id: '6m', label: '6 months', groupBy: 'month' },
  { id: 'ytd', label: 'This year', groupBy: 'month' },
];

export default function Dashboard() {
  const [range, setRange] = useState('30d');
  const { selectedStoreId } = useStoreContext();
  const selectedRange = RANGES.find((item) => item.id === range) || RANGES[1];
  const { data, isLoading, isError } = useGetOverviewQuery({
    range,
    groupBy: selectedRange.groupBy,
    storeId: selectedStoreId || undefined,
  });
  const overview = data?.data;

  return (
    <div>
      <PageHeader
        title="Dashboard"
        subtitle="Live multi-store performance for Louisiana Hot Chicken."
        actions={
          <div className="flex flex-wrap gap-2">
            {RANGES.map((item) => (
              <button
                key={item.id}
                type="button"
                onClick={() => setRange(item.id)}
                className={`rounded-xl px-3 py-2 text-sm font-medium ${
                  range === item.id ? 'bg-brand-red text-white' : 'bg-white text-slate-600 shadow-sm'
                }`}
              >
                {item.label}
              </button>
            ))}
          </div>
        }
      />

      {isLoading ? <SkeletonGrid count={5} /> : null}
      {isError ? <ErrorState message="Dashboard analytics could not be loaded." /> : null}

      {overview ? (
        <div className="space-y-5">
          <DashboardStats summary={overview.summary} />
          <div className="grid gap-5 xl:grid-cols-3">
            <div className="xl:col-span-2">
              <RevenueExpenseChart data={overview.revenueVsExpense} groupBy={overview.range?.groupBy || selectedRange.groupBy} />
            </div>
            <ExpenseBreakdownChart data={overview.expenseBreakdown} />
          </div>
          <div className="grid gap-5 xl:grid-cols-3">
            <div className="xl:col-span-2">
              <RecentTransactions rows={overview.recentTransactions} />
            </div>
            <div className="space-y-5">
              <StoreRanking data={overview.storePerformance} />
              <TopExpenses rows={overview.topExpenses} />
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}
