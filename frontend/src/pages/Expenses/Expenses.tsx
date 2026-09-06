import { useState } from 'react';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { SearchInput } from '../../components/common/SearchInput';
import { DataTable } from '../../components/common/DataTable';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { LoadingSpinner } from '../../components/common/LoadingSpinner';
import { useBulkDeleteExpensesMutation, useCreateExpenseMutation, useGetExpensesQuery } from '../../api/expensesApi';
import { useStoreContext } from '../../hooks/usePermissions';
import { useListParams } from '../../hooks/useListParams';
import { formatCurrencyExact, formatDate } from '../../utils/cn';
import { Pagination } from '../../components/common/Pagination';
import { DeleteAction, TableActions } from '../../components/common/TableActions';
import { ListingToolbar } from '../../components/common/ListingToolbar';
import { useRowSelection } from '../../hooks/useRowSelection';
import type { ExportColumn } from '../../utils/export';

const CATEGORIES = ['INGREDIENTS', 'SALARY', 'RENT', 'ELECTRICITY', 'GAS', 'WATER', 'MARKETING', 'MAINTENANCE', 'EQUIPMENT', 'DELIVERY', 'OTHER'];

export default function Expenses() {
  const [open, setOpen] = useState(false);
  const [deleteIds, setDeleteIds] = useState<string[]>([]);
  const { selectedStoreId, stores } = useStoreContext();
  const { page, setPage, limit, setLimit, search, setSearch, query } = useListParams(20, [selectedStoreId]);
  const { data, isLoading } = useGetExpensesQuery({ ...query, storeId: selectedStoreId || undefined });
  const rows = data?.data || [];
  const selection = useRowSelection(rows.map((row: any) => row._id));
  const exportRows = selection.selected.length ? rows.filter((row: any) => selection.selected.includes(row._id)) : rows;
  const exportColumns: ExportColumn<any>[] = [
    { header: 'Title', value: (row) => row.title },
    { header: 'Store', value: (row) => row.storeId?.name || '' },
    { header: 'Category', value: (row) => row.category },
    { header: 'Amount', value: (row) => row.amount },
    { header: 'Date', value: (row) => formatDate(row.expenseDate) },
  ];
  const [createExpense] = useCreateExpenseMutation();
  const [bulkDeleteExpenses] = useBulkDeleteExpensesMutation();
  const [form, setForm] = useState({ storeId: '', title: '', category: 'INGREDIENTS', amount: 0, paymentMethod: 'CARD' });

  return (
    <div>
      <PageHeader
        title="Expenses"
        subtitle="Track operating costs by store, category, and date range."
        actions={<button className="btn-primary" type="button" onClick={() => setOpen(true)}>Add Expense</button>}
      />
      <div className="card p-4">
        <div className="mb-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <SearchInput value={search} onChange={setSearch} placeholder="Search expenses" />
          <ListingToolbar
            title="Expenses"
            fileName="lhc-expenses"
            columns={exportColumns}
            rows={exportRows}
            selectedCount={selection.selected.length}
            onDeleteSelected={() => setDeleteIds(selection.selected)}
          />
        </div>
        {isLoading ? <LoadingSpinner /> : (
          <div className="mt-4">
            <DataTable
              rows={rows}
              selectable
              selectedIds={selection.selected}
              onToggle={selection.toggle}
              onToggleAll={selection.toggleAll}
              columns={[
                { key: 'title', header: 'Title', render: (row: any) => row.title },
                { key: 'store', header: 'Store', render: (row: any) => row.storeId?.name },
                { key: 'category', header: 'Category', render: (row: any) => row.category },
                { key: 'amount', header: 'Amount', render: (row: any) => formatCurrencyExact(row.amount) },
                { key: 'date', header: 'Date', render: (row: any) => formatDate(row.expenseDate) },
                { key: 'actions', header: 'Actions', render: (row: any) => (
                  <TableActions>
                    <DeleteAction onClick={() => setDeleteIds([row._id])} />
                  </TableActions>
                ) },
              ]}
            />
            <Pagination meta={data?.meta} onPageChange={setPage} onLimitChange={setLimit} />
          </div>
        )}
      </div>
      {open ? (
        <div className="fixed inset-0 z-40 flex items-center justify-center bg-ink-900/40 p-4">
          <form
            className="card w-full max-w-lg space-y-3 p-6"
            onSubmit={async (event) => {
              event.preventDefault();
              await createExpense({
                ...form,
                storeId: form.storeId || selectedStoreId || stores[0]?._id,
                amount: Number(form.amount),
              }).unwrap();
              toast.success('Expense recorded');
              setOpen(false);
            }}
          >
            <h3 className="text-lg font-semibold">New expense</h3>
            <select className="soft-input" value={form.storeId} onChange={(e) => setForm({ ...form, storeId: e.target.value })}>
              <option value="">Select store</option>
              {stores.map((store) => <option key={store._id} value={store._id}>{store.name}</option>)}
            </select>
            <input className="soft-input" placeholder="Title" value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} />
            <select className="soft-input" value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })}>
              {CATEGORIES.map((item) => <option key={item}>{item}</option>)}
            </select>
            <input className="soft-input" type="number" placeholder="Amount" value={form.amount} onChange={(e) => setForm({ ...form, amount: Number(e.target.value) })} />
            <div className="flex justify-end gap-2">
              <button className="btn-secondary" type="button" onClick={() => setOpen(false)}>Cancel</button>
              <button className="btn-primary" type="submit">Save</button>
            </div>
          </form>
        </div>
      ) : null}
      <ConfirmDialog
        open={deleteIds.length > 0}
        title={deleteIds.length > 1 ? 'Delete selected expenses' : 'Delete expense'}
        description="Selected expenses will be removed from profit calculations."
        onClose={() => setDeleteIds([])}
        onConfirm={async () => {
          try {
            await bulkDeleteExpenses(deleteIds).unwrap();
            toast.success(deleteIds.length > 1 ? 'Selected expenses deleted' : 'Expense deleted');
            selection.clear();
            setDeleteIds([]);
          } catch (error: any) {
            toast.error(error?.data?.message || 'Unable to delete expenses');
          }
        }}
      />
    </div>
  );
}
