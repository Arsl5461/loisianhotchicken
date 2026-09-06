import { useState } from 'react';
import { CircleHelp } from 'lucide-react';
import { Link } from 'react-router-dom';
import { PageHeader } from '../../components/common/PageHeader';
import { LoadingSpinner } from '../../components/common/LoadingSpinner';
import { useGetTenderTypesQuery } from '../../api/dashboardApi';
import { useStoreContext } from '../../hooks/usePermissions';
import { formatCurrencyExact } from '../../utils/cn';

function currentMonth() {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
}

function monthLabel(value: string) {
  const [year, month] = value.split('-').map(Number);
  return new Date(year, month - 1, 1).toLocaleString('en-US', { month: 'long', year: 'numeric' });
}

function Hint({ text }: { text: string }) {
  return (
    <span className="inline-flex" title={text}>
      <CircleHelp className="h-3.5 w-3.5 text-slate-400" />
    </span>
  );
}

export default function TenderTypes() {
  const [month, setMonth] = useState(currentMonth);
  const { selectedStoreId } = useStoreContext();
  const { data, isLoading } = useGetTenderTypesQuery({
    month,
    storeId: selectedStoreId || undefined,
  });
  const report = data?.data as {
    month: string;
    rows: Array<{ tenderType: string; salesTotal: number; refundTotal: number; amountCollected: number }>;
    totals: { salesTotal: number; refundTotal: number; amountCollected: number };
  } | undefined;

  return (
    <div>
      <PageHeader
        title="Tender Types"
        subtitle={`Payment totals for ${monthLabel(month)}.`}
        actions={
          <label className="flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm font-medium text-slate-700">
            Month
            <input
              className="bg-transparent outline-none"
              type="month"
              value={month}
              onChange={(event) => setMonth(event.target.value)}
            />
          </label>
        }
      />

      {isLoading ? <LoadingSpinner /> : null}

      {report ? (
        <div className="card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full text-sm">
              <thead>
                <tr className="border-b border-slate-200 bg-white text-slate-500">
                  <th className="px-5 py-3 text-left font-semibold">Tender Types</th>
                  <th className="px-5 py-3 text-right font-semibold">
                    <span className="inline-flex items-center justify-end gap-1.5">
                      Sales Total
                      <Hint text="Gross sales recorded for this payment method in the selected month." />
                    </span>
                  </th>
                  <th className="px-5 py-3 text-right font-semibold">
                    <span className="inline-flex items-center justify-end gap-1.5">
                      Refund Total
                      <Hint text="Refunded orders for this payment method in the selected month." />
                    </span>
                  </th>
                  <th className="px-5 py-3 text-right font-semibold">
                    <span className="inline-flex items-center justify-end gap-1.5">
                      Amount Collected
                      <Hint text="Sales total minus refund total." />
                    </span>
                  </th>
                </tr>
              </thead>
              <tbody>
                {report.rows.length ? (
                  report.rows.map((row, index) => (
                    <tr key={row.tenderType} className={index % 2 ? 'bg-slate-50/80' : 'bg-white'}>
                      <td className="px-5 py-3.5 font-medium text-ink-900">{row.tenderType}</td>
                      <td className="px-5 py-3.5 text-right tabular-nums">{formatCurrencyExact(row.salesTotal)}</td>
                      <td className="px-5 py-3.5 text-right tabular-nums">{formatCurrencyExact(row.refundTotal)}</td>
                      <td className="px-5 py-3.5 text-right tabular-nums font-medium">{formatCurrencyExact(row.amountCollected)}</td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan={4} className="px-5 py-10 text-center text-slate-500">
                      No tender activity for this month.
                    </td>
                  </tr>
                )}
              </tbody>
              <tfoot>
                <tr className="border-t border-slate-200 bg-slate-50 font-semibold text-ink-900">
                  <td className="px-5 py-3.5">Total</td>
                  <td className="px-5 py-3.5 text-right tabular-nums">{formatCurrencyExact(report.totals.salesTotal)}</td>
                  <td className="px-5 py-3.5 text-right tabular-nums">{formatCurrencyExact(report.totals.refundTotal)}</td>
                  <td className="px-5 py-3.5 text-right tabular-nums">{formatCurrencyExact(report.totals.amountCollected)}</td>
                </tr>
              </tfoot>
            </table>
          </div>
          <div className="flex justify-end border-t border-slate-100 px-5 py-3">
            <Link className="text-sm font-semibold uppercase tracking-wide text-sky-600 hover:text-sky-700" to="/sales">
              Details
            </Link>
          </div>
        </div>
      ) : null}
    </div>
  );
}
