import { useState } from 'react';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { DataTable } from '../../components/common/DataTable';
import { Pagination } from '../../components/common/Pagination';
import { SearchInput } from '../../components/common/SearchInput';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { ListingToolbar } from '../../components/common/ListingToolbar';
import { DeleteAction, TableActions } from '../../components/common/TableActions';
import { useBulkDeleteOrdersMutation, useGetOrdersQuery, useUpdateOrderMutation } from '../../api/usersApi';
import { formatCurrencyExact, formatDate } from '../../utils/cn';
import { useStoreContext } from '../../hooks/usePermissions';
import { useListParams } from '../../hooks/useListParams';
import { useRowSelection } from '../../hooks/useRowSelection';
import type { ExportColumn } from '../../utils/export';

export default function Orders() {
  const { selectedStoreId } = useStoreContext();
  const { page, setPage, limit, setLimit, search, setSearch, query } = useListParams(20, [selectedStoreId]);
  const { data } = useGetOrdersQuery({ ...query, storeId: selectedStoreId || undefined });
  const [updateOrder] = useUpdateOrderMutation();
  const [bulkDeleteOrders] = useBulkDeleteOrdersMutation();
  const [deleteIds, setDeleteIds] = useState<string[]>([]);
  const rows = data?.data || [];
  const selection = useRowSelection(rows.map((row: any) => row._id));
  const exportRows = selection.selected.length ? rows.filter((row: any) => selection.selected.includes(row._id)) : rows;
  const exportColumns: ExportColumn<any>[] = [
    { header: 'Order', value: (row) => row.orderNumber },
    { header: 'Store', value: (row) => row.storeId?.name || '' },
    { header: 'Customer', value: (row) => row.customer?.name || '' },
    { header: 'Total', value: (row) => row.total },
    { header: 'Status', value: (row) => row.status },
    { header: 'Payment', value: (row) => row.paymentStatus },
    { header: 'Date', value: (row) => formatDate(row.orderDate) },
  ];

  return (
    <div>
      <PageHeader title="Orders" subtitle="Kitchen and fulfillment statuses for every assigned store." />
      <div className="card p-4">
        <div className="mb-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <SearchInput value={search} onChange={setSearch} placeholder="Search order number or customer" />
          <ListingToolbar
            title="Orders"
            fileName="lhc-orders"
            columns={exportColumns}
            rows={exportRows}
            selectedCount={selection.selected.length}
            onDeleteSelected={() => setDeleteIds(selection.selected)}
          />
        </div>
        <DataTable
          rows={rows}
          selectable
          selectedIds={selection.selected}
          onToggle={selection.toggle}
          onToggleAll={selection.toggleAll}
          columns={[
            { key: 'number', header: 'Order', render: (row: any) => row.orderNumber },
            { key: 'store', header: 'Store', render: (row: any) => row.storeId?.name },
            { key: 'customer', header: 'Customer', render: (row: any) => row.customer?.name },
            { key: 'total', header: 'Total', render: (row: any) => formatCurrencyExact(row.total) },
            {
              key: 'status',
              header: 'Status',
              render: (row: any) => (
                <select
                  className="soft-input"
                  value={row.status}
                  onChange={(event) => updateOrder({ id: row._id, data: { status: event.target.value } })}
                >
                  {['PENDING', 'PREPARING', 'READY', 'COMPLETED', 'CANCELLED'].map((status) => <option key={status}>{status}</option>)}
                </select>
              ),
            },
            { key: 'payment', header: 'Payment', render: (row: any) => row.paymentStatus },
            { key: 'date', header: 'Date', render: (row: any) => formatDate(row.orderDate) },
            {
              key: 'actions',
              header: 'Actions',
              render: (row: any) => (
                <TableActions>
                  <DeleteAction onClick={() => setDeleteIds([row._id])} />
                </TableActions>
              ),
            },
          ]}
        />
        <Pagination meta={data?.meta} onPageChange={setPage} onLimitChange={setLimit} />
      </div>
      <ConfirmDialog
        open={deleteIds.length > 0}
        title={deleteIds.length > 1 ? 'Delete selected orders' : 'Delete order'}
        description="Selected orders will be permanently removed."
        onClose={() => setDeleteIds([])}
        onConfirm={async () => {
          try {
            await bulkDeleteOrders(deleteIds).unwrap();
            toast.success(deleteIds.length > 1 ? 'Selected orders deleted' : 'Order deleted');
            selection.clear();
            setDeleteIds([]);
          } catch (error: any) {
            toast.error(error?.data?.message || 'Unable to delete orders');
          }
        }}
      />
    </div>
  );
}
