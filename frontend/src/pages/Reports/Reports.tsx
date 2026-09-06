import { useGetStoreComparisonQuery } from '../../api/dashboardApi';
import { PageHeader } from '../../components/common/PageHeader';
import { StorePerformanceChart, StoreRanking } from '../../components/dashboard/StorePerformanceChart';
import { formatCurrency } from '../../utils/cn';

export default function Reports() {
  const { data } = useGetStoreComparisonQuery({ range: '30d' });
  const report = data?.data as any;

  return (
    <div>
      <PageHeader title="Reports" />
      {report ? (
        <div className="space-y-5">
          <div className="grid gap-4 md:grid-cols-3">
            {report.ranking?.slice(0, 3).map((store: any) => (
              <div key={store.storeId} className="card p-5">
                <p className="text-xs font-bold text-brand-red">#{store.rank} {store.storeName}</p>
                <p className="mt-2 text-2xl font-bold">{formatCurrency(store.revenue)}</p>
                <p className="text-sm text-emerald-600">Profit {formatCurrency(store.profit)}</p>
              </div>
            ))}
          </div>
          <div className="grid gap-5 xl:grid-cols-2">
            <StorePerformanceChart data={report.stores || []} />
            <StoreRanking data={report.stores || []} />
          </div>
        </div>
      ) : null}
    </div>
  );
}
