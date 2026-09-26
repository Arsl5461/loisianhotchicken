import { useMemo, useState } from 'react';
import { FileDown } from 'lucide-react';
import { Link } from 'react-router-dom';
import { PageHeader } from '../../components/common/PageHeader';
import { DateRangePicker } from '../../components/common/DateRangePicker';
import { InlineSpinner, LoadingSpinner } from '../../components/common/LoadingSpinner';
import { useGetIncomeExpenseStatementQuery, useGetOverviewQuery, useGetTenderTypesQuery } from '../../api/dashboardApi';
import { useStoreContext } from '../../hooks/usePermissions';
import { formatCurrency, formatDate } from '../../utils/cn';
import { exportIncomeExpenseStatementPdf, type IncomeExpenseStatement } from '../../utils/statementPdf';
import { RevenueExpenseChart } from '../../components/dashboard/RevenueExpenseChart';
import { ExpenseBreakdownChart } from '../../components/dashboard/ExpenseBreakdownChart';
import { StorePerformanceChart } from '../../components/dashboard/StorePerformanceChart';
import { TenderMixChart } from '../../components/dashboard/TenderMixChart';
import { currentMonth, type TenderReport } from './TenderTypesTable';

function monthBounds(month: string) {
  const [year, monthIndex] = month.split('-').map(Number);
  const lastDay = new Date(year, monthIndex, 0).getDate();
  const pad = (value: number) => String(value).padStart(2, '0');
  return {
    startDate: `${year}-${pad(monthIndex)}-01`,
    endDate: `${year}-${pad(monthIndex)}-${pad(lastDay)}`,
  };
}

function periodLabel(startDate: string, endDate: string) {
  const label = (value: string) => {
    const [year, month, day] = value.split('-').map(Number);
    return new Date(year, month - 1, day).toLocaleDateString('en-US', {
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    });
  };
  return `${label(startDate)} - ${label(endDate)}`;
}

export default function Reports() {
  const defaults = monthBounds(currentMonth());
  const [startDate, setStartDate] = useState(defaults.startDate);
  const [endDate, setEndDate] = useState(defaults.endDate);
  const { selectedStoreId, stores } = useStoreContext();
  const storeId = selectedStoreId || undefined;
  const rangeQuery = useMemo(
    () => ({
      range: 'custom',
      startDate,
      endDate,
      groupBy: 'day',
      storeId,
    }),
    [endDate, startDate, storeId]
  );

  const overviewQuery = useGetOverviewQuery(rangeQuery);
  const tenderQuery = useGetTenderTypesQuery({ startDate, endDate, storeId });
  const statementQuery = useGetIncomeExpenseStatementQuery({ startDate, endDate, storeId });
  const overview = overviewQuery.data?.data;
  const tender = tenderQuery.data?.data as TenderReport | undefined;
  const statement = statementQuery.data?.data as IncomeExpenseStatement | undefined;
  const storeName = stores.find((store) => store._id === selectedStoreId)?.name || 'All Stores';
  const isLoading = overviewQuery.isLoading || statementQuery.isLoading;

  const exportPdf = () => {
    if (!statement) return;
    exportIncomeExpenseStatementPdf(statement, storeName);
  };

  return (
    <div>
      <PageHeader
        title="Reports"
        subtitle={`Income & expense statement for ${periodLabel(startDate, endDate)}.${
          statement?.isFinal === false ? ' This summary stays open until borrowed money is paid off.' : ''
        }`}
        actions={
          <div className="flex flex-wrap items-center gap-2">
            <DateRangePicker
              startDate={startDate}
              endDate={endDate}
              onChange={(next) => {
                if (next.startDate) setStartDate(next.startDate);
                if (next.endDate) setEndDate(next.endDate);
              }}
            />
            <button className="btn-primary" type="button" disabled={!statement} onClick={exportPdf}>
              <FileDown className="h-4 w-4" />
              Export to PDF
            </button>
          </div>
        }
      />

      {isLoading ? <LoadingSpinner /> : null}

      {overview ? (
        <div className="space-y-5">
          {statement?.isFinal === false ? (
            <div className="rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
              <p className="font-semibold">Final summary is open</p>
              <p className="mt-0.5">
                {formatCurrency(statement.amountOwed || 0)} is still owed. This report will not close as final until
                those borrowed amounts are paid off.{' '}
                <Link className="font-semibold underline" to="/money-borrowed">
                  Record a payment
                </Link>
              </p>
            </div>
          ) : statement ? (
            <div className="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800">
              Nothing is owed. This period summary is final.
            </div>
          ) : null}
          <div className="grid gap-4 md:grid-cols-5">
            {[
              ['Total Sales', statement?.totalSales ?? overview.summary.totalRevenue],
              ['Total Expenses', statement?.totalExpenses ?? overview.summary.totalExpenses],
              ['Operating Profit', statement?.operatingProfit ?? overview.summary.netProfit],
              ['Profit Margin', `${(statement?.profitMargin ?? overview.summary.profitMargin).toFixed(2)}%`],
              ['Money owed', statement?.amountOwed ?? 0],
            ].map(([label, value]) => (
              <div key={label} className="card p-5">
                <p className="text-xs uppercase tracking-wide text-slate-400">{label}</p>
                <p className="mt-2 text-2xl font-bold">
                  {typeof value === 'number' ? formatCurrency(value) : value}
                </p>
              </div>
            ))}
          </div>

          {statement?.isFinal === false && statement.openBorrowings?.length ? (
            <div className="card p-5">
              <h3 className="text-sm font-semibold text-ink-900">Borrowed money still owed</h3>
              <div className="mt-3 overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="text-left text-xs uppercase tracking-wide text-slate-400">
                      <th className="pb-2 font-semibold">Borrowed from</th>
                      <th className="pb-2 font-semibold">Store</th>
                      <th className="pb-2 font-semibold">Date</th>
                      <th className="pb-2 text-right font-semibold">Still owed</th>
                    </tr>
                  </thead>
                  <tbody>
                    {statement.openBorrowings.map((row) => (
                      <tr key={row.id} className="border-t border-slate-100">
                        <td className="py-2">{row.lender}</td>
                        <td className="py-2">{row.storeName || storeName}</td>
                        <td className="py-2">{formatDate(row.borrowedDate)}</td>
                        <td className="py-2 text-right font-semibold">{formatCurrency(row.amountOwed)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ) : null}

          <RevenueExpenseChart data={overview.revenueVsExpense || []} groupBy="day" />

          <div className="grid gap-5 xl:grid-cols-2">
            <TenderMixChart rows={tender?.rows || []} />
            <ExpenseBreakdownChart data={overview.expenseBreakdown || []} />
          </div>

          <StorePerformanceChart data={overview.storePerformance || []} />
        </div>
      ) : null}

      {(overviewQuery.isFetching || statementQuery.isFetching) && overview ? (
        <div className="mt-3 flex items-center gap-2 text-sm text-slate-500">
          <InlineSpinner />
          Updating report...
        </div>
      ) : null}
    </div>
  );
}
