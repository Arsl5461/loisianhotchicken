import { Link, useParams } from 'react-router-dom';
import { useGetStoreQuery, useGetStoreUsersQuery } from '../../api/storesApi';
import { useGetOverviewQuery } from '../../api/dashboardApi';
import { PageHeader } from '../../components/common/PageHeader';
import { LoadingSpinner } from '../../components/common/LoadingSpinner';
import { DashboardStats } from '../../components/dashboard/DashboardStats';
import { RevenueExpenseChart } from '../../components/dashboard/RevenueExpenseChart';
import { formatDate } from '../../utils/cn';

export default function StoreDetails() {
  const { id = '' } = useParams();
  const { data, isLoading } = useGetStoreQuery(id);
  const users = useGetStoreUsersQuery(id);
  const overview = useGetOverviewQuery({ range: '30d', storeId: id });
  const store = data?.data;

  if (isLoading) return <LoadingSpinner />;
  if (!store) return null;

  return (
    <div>
      <PageHeader
        title={store.name}
        subtitle={`${store.storeCode} · ${store.city || ''} ${store.state || ''}`}
        actions={
          <Link to={`/stores/${store._id}/edit`} className="btn-primary">
            Edit Store
          </Link>
        }
      />
      <div className="mb-5 flex flex-wrap gap-2 text-sm">
        <span className="rounded-full bg-emerald-50 px-3 py-1 font-semibold text-emerald-700">{store.status}</span>
        <span className="rounded-full bg-white px-3 py-1 shadow-sm">Opened {formatDate(store.openingDate)}</span>
        <span className="rounded-full bg-white px-3 py-1 shadow-sm">Manager {store.manager?.name || 'Unassigned'}</span>
      </div>
      {overview.data?.data ? (
        <div className="space-y-5">
          <DashboardStats summary={overview.data.data.summary} />
          <RevenueExpenseChart data={overview.data.data.revenueVsExpense} />
        </div>
      ) : null}
      <div className="card mt-5 p-5">
        <h3 className="mb-3 text-lg font-semibold">Assigned users</h3>
        <div className="space-y-2">
          {(users.data?.data || []).map((user: any) => (
            <div key={user._id} className="flex justify-between rounded-xl bg-slate-50 px-3 py-2 text-sm">
              <span>{user.name}</span>
              <span className="text-slate-500">{user.roleId?.name}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
