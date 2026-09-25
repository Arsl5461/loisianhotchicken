import { useState } from 'react';
import { Banknote, Plus } from 'lucide-react';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { SearchInput } from '../../components/common/SearchInput';
import { DataTable } from '../../components/common/DataTable';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { LoadingSpinner } from '../../components/common/LoadingSpinner';
import { Modal } from '../../components/common/Modal';
import {
  useBulkDeleteBorrowingsMutation,
  useCreateBorrowingMutation,
  useGetBorrowingsQuery,
  useRepayBorrowingMutation,
} from '../../api/borrowingsApi';
import { useGetStoresQuery } from '../../api/storesApi';
import { usePermissions, useStoreContext } from '../../hooks/usePermissions';
import { useListParams } from '../../hooks/useListParams';
import { formatCurrencyExact, formatDate } from '../../utils/cn';
import { clearZeroOnFocus, parseNumericInput, type NumericField } from '../../utils/numberInput';
import { Pagination } from '../../components/common/Pagination';
import { DeleteAction, TableActions } from '../../components/common/TableActions';
import { ListingToolbar } from '../../components/common/ListingToolbar';
import { useRowSelection } from '../../hooks/useRowSelection';
import { PERMISSIONS } from '../../constants/permissions';
import type { ExportColumn } from '../../utils/export';

function today() {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
}

const emptyForm = {
  storeId: '',
  lender: '',
  note: '',
  amount: 0 as NumericField,
  borrowedDate: today(),
};

const emptyRepay = { amount: 0 as NumericField, paidDate: today(), note: '' };

export default function MoneyBorrowed() {
  const { can } = usePermissions();
  const canCreate = can(PERMISSIONS.EXPENSES_CREATE);
  const canRepay = can(PERMISSIONS.EXPENSES_UPDATE);
  const [open, setOpen] = useState(false);
  const [repayRow, setRepayRow] = useState<any | null>(null);
  const [deleteIds, setDeleteIds] = useState<string[]>([]);
  const [form, setForm] = useState(emptyForm);
  const [repay, setRepay] = useState(emptyRepay);
  const { selectedStoreId } = useStoreContext();
  const { page, setPage, limit, setLimit, search, setSearch, query } = useListParams(20, [selectedStoreId]);
  const { data, isLoading } = useGetBorrowingsQuery({ ...query, storeId: selectedStoreId || undefined });
  const storesQuery = useGetStoresQuery({ limit: 100, sortBy: 'name', sortOrder: 'asc' });
  const stores = storesQuery.data?.data?.items || [];
  const rows = data?.data || [];
  const selection = useRowSelection(rows.map((row: any) => row._id));
  const exportRows = selection.selected.length ? rows.filter((row: any) => selection.selected.includes(row._id)) : rows;
  const exportColumns: ExportColumn<any>[] = [
    { header: 'Borrowed from', value: (row) => row.lender },
    { header: 'Store', value: (row) => row.storeId?.name || '' },
    { header: 'Amount', value: (row) => row.amount },
    { header: 'Paid', value: (row) => row.amountPaid },
    { header: 'Still owed', value: (row) => row.amountOwed },
    { header: 'Date', value: (row) => formatDate(row.borrowedDate) },
    { header: 'Status', value: (row) => (row.status === 'PAID' ? 'Paid off' : 'Open') },
  ];
  const [createBorrowing] = useCreateBorrowingMutation();
  const [repayBorrowing] = useRepayBorrowingMutation();
  const [bulkDeleteBorrowings] = useBulkDeleteBorrowingsMutation();
  const stillOwed = rows.reduce((sum: number, row: any) => sum + (Number(row.amountOwed) || 0), 0);

  const closeCreate = () => {
    setOpen(false);
    setForm({ ...emptyForm, borrowedDate: today() });
  };

  return (
    <div>
      <PageHeader
        title="Money borrowed"
        subtitle="Record borrowed money. The report summary stays open until every balance is paid off."
        actions={
          canCreate ? (
            <button className="btn-primary" type="button" onClick={() => setOpen(true)}>
              <Plus className="h-4 w-4" />
              Add borrowed money
            </button>
          ) : null
        }
      />

      {stillOwed > 0 ? (
        <div className="mb-4 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
          <p className="font-semibold">Summary is open</p>
          <p className="mt-0.5">
            {formatCurrencyExact(stillOwed)} is still owed. The final report will not close until this is paid off.
          </p>
        </div>
      ) : (
        <div className="mb-4 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800">
          Nothing is owed on this list. The report summary can be treated as final.
        </div>
      )}

      <div className="card p-4">
        <div className="mb-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <SearchInput value={search} onChange={setSearch} placeholder="Search who money was borrowed from" />
          <ListingToolbar
            title="Money borrowed"
            fileName="lhc-money-borrowed"
            columns={exportColumns}
            rows={exportRows}
            selectedCount={selection.selected.length}
            onDeleteSelected={() => setDeleteIds(selection.selected)}
          />
        </div>
        {isLoading ? (
          <LoadingSpinner />
        ) : (
          <div className="mt-4">
            <DataTable
              rows={rows}
              selectable
              selectedIds={selection.selected}
              onToggle={selection.toggle}
              onToggleAll={selection.toggleAll}
              emptyTitle="No borrowed money yet"
              emptyDescription="Add a borrowed amount to keep it on the books until it is paid off."
              columns={[
                { key: 'lender', header: 'Borrowed from', render: (row: any) => row.lender },
                { key: 'store', header: 'Store', render: (row: any) => row.storeId?.name },
                { key: 'amount', header: 'Borrowed', render: (row: any) => formatCurrencyExact(row.amount) },
                { key: 'paid', header: 'Paid back', render: (row: any) => formatCurrencyExact(row.amountPaid) },
                { key: 'owed', header: 'Still owed', render: (row: any) => formatCurrencyExact(row.amountOwed) },
                { key: 'date', header: 'Date', render: (row: any) => formatDate(row.borrowedDate) },
                {
                  key: 'status',
                  header: 'Status',
                  render: (row: any) => (
                    <span
                      className={`inline-flex rounded-full px-2.5 py-1 text-xs font-semibold ${
                        row.status === 'PAID' ? 'bg-emerald-50 text-emerald-700' : 'bg-amber-50 text-amber-800'
                      }`}
                    >
                      {row.status === 'PAID' ? 'Paid off' : 'Open'}
                    </span>
                  ),
                },
                {
                  key: 'actions',
                  header: 'Actions',
                  render: (row: any) => (
                    <TableActions>
                      {canRepay && row.status !== 'PAID' ? (
                        <button
                          type="button"
                          className="inline-flex h-8 w-8 items-center justify-center rounded-lg border border-slate-200 bg-white text-brand-red transition hover:bg-rose-50"
                          title="Record payment"
                          aria-label="Record payment"
                          onClick={() => {
                            setRepayRow(row);
                            setRepay({ amount: row.amountOwed, paidDate: today(), note: '' });
                          }}
                        >
                          <Banknote className="h-4 w-4" />
                        </button>
                      ) : null}
                      <DeleteAction onClick={() => setDeleteIds([row._id])} />
                    </TableActions>
                  ),
                },
              ]}
            />
            <Pagination meta={data?.meta} onPageChange={setPage} onLimitChange={setLimit} />
          </div>
        )}
      </div>

      <Modal
        open={open}
        title="Add borrowed money"
        description="This amount stays open on the final summary until it is paid off."
        onClose={closeCreate}
      >
        <form
          className="space-y-3"
          onSubmit={async (event) => {
            event.preventDefault();
            const storeId = form.storeId || selectedStoreId || stores[0]?._id;
            if (!storeId || !form.lender || !form.borrowedDate || !form.amount) {
              toast.error('Please fill in all required fields');
              return;
            }
            try {
              await createBorrowing({
                storeId,
                lender: form.lender,
                note: form.note,
                amount: Number(form.amount),
                borrowedDate: form.borrowedDate,
              }).unwrap();
              toast.success('Borrowed money recorded');
              closeCreate();
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to save borrowed money');
            }
          }}
        >
          <label className="block text-sm font-medium text-slate-700">
            Store <span className="text-brand-red">*</span>
            <select
              className="soft-input mt-1.5"
              value={form.storeId}
              onChange={(event) => setForm({ ...form, storeId: event.target.value })}
              required
            >
              <option value="">Select store</option>
              {stores.map((store: any) => (
                <option key={store._id} value={store._id}>
                  {store.name}
                </option>
              ))}
            </select>
          </label>
          <label className="block text-sm font-medium text-slate-700">
            Borrowed from <span className="text-brand-red">*</span>
            <input
              className="soft-input mt-1.5"
              placeholder="Owner, partner, or lender"
              value={form.lender}
              onChange={(event) => setForm({ ...form, lender: event.target.value })}
              required
            />
          </label>
          <label className="block text-sm font-medium text-slate-700">
            Amount <span className="text-brand-red">*</span>
            <input
              className="soft-input mt-1.5"
              type="number"
              min="0.01"
              step="0.01"
              value={form.amount}
              onFocus={() => setForm((current) => ({ ...current, amount: clearZeroOnFocus(current.amount) }))}
              onChange={(event) => setForm({ ...form, amount: parseNumericInput(event.target.value) })}
              required
            />
          </label>
          <label className="block text-sm font-medium text-slate-700">
            Date <span className="text-brand-red">*</span>
            <input
              className="soft-input mt-1.5"
              type="date"
              value={form.borrowedDate}
              onChange={(event) => setForm({ ...form, borrowedDate: event.target.value })}
              required
            />
          </label>
          <label className="block text-sm font-medium text-slate-700">
            Note
            <input
              className="soft-input mt-1.5"
              placeholder="Optional"
              value={form.note}
              onChange={(event) => setForm({ ...form, note: event.target.value })}
            />
          </label>
          <div className="flex justify-end gap-2">
            <button className="btn-secondary" type="button" onClick={closeCreate}>
              Cancel
            </button>
            <button className="btn-primary" type="submit">
              Save
            </button>
          </div>
        </form>
      </Modal>

      <Modal
        open={Boolean(repayRow)}
        title={repayRow ? `Pay back ${repayRow.lender}` : 'Record payment'}
        description={repayRow ? `${formatCurrencyExact(repayRow.amountOwed)} still owed.` : ''}
        onClose={() => {
          setRepayRow(null);
          setRepay(emptyRepay);
        }}
      >
        <form
          className="space-y-3"
          onSubmit={async (event) => {
            event.preventDefault();
            if (!repayRow || !repay.amount || !repay.paidDate) {
              toast.error('Enter the amount paid');
              return;
            }
            try {
              const result = await repayBorrowing({
                id: repayRow._id,
                data: {
                  amount: Number(repay.amount),
                  paidDate: repay.paidDate,
                  note: repay.note,
                },
              }).unwrap();
              toast.success(result.message || 'Payment recorded');
              setRepayRow(null);
              setRepay(emptyRepay);
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to record payment');
            }
          }}
        >
          <label className="block text-sm font-medium text-slate-700">
            Amount paid <span className="text-brand-red">*</span>
            <input
              className="soft-input mt-1.5"
              type="number"
              min="0.01"
              step="0.01"
              max={repayRow?.amountOwed}
              value={repay.amount}
              onFocus={() => setRepay((current) => ({ ...current, amount: clearZeroOnFocus(current.amount) }))}
              onChange={(event) => setRepay({ ...repay, amount: parseNumericInput(event.target.value) })}
              required
            />
          </label>
          <label className="block text-sm font-medium text-slate-700">
            Payment date <span className="text-brand-red">*</span>
            <input
              className="soft-input mt-1.5"
              type="date"
              value={repay.paidDate}
              onChange={(event) => setRepay({ ...repay, paidDate: event.target.value })}
              required
            />
          </label>
          <label className="block text-sm font-medium text-slate-700">
            Note
            <input
              className="soft-input mt-1.5"
              placeholder="Optional"
              value={repay.note}
              onChange={(event) => setRepay({ ...repay, note: event.target.value })}
            />
          </label>
          <div className="flex justify-end gap-2">
            <button
              className="btn-secondary"
              type="button"
              onClick={() => {
                setRepayRow(null);
                setRepay(emptyRepay);
              }}
            >
              Cancel
            </button>
            <button className="btn-primary" type="submit">
              Record payment
            </button>
          </div>
        </form>
      </Modal>

      <ConfirmDialog
        open={deleteIds.length > 0}
        title={deleteIds.length > 1 ? 'Delete selected records' : 'Delete borrowed money'}
        description="This removes the borrowed amount from the open summary."
        onClose={() => setDeleteIds([])}
        onConfirm={async () => {
          try {
            await bulkDeleteBorrowings(deleteIds).unwrap();
            toast.success(deleteIds.length > 1 ? 'Selected records deleted' : 'Record deleted');
            selection.clear();
            setDeleteIds([]);
          } catch (error: any) {
            toast.error(error?.data?.message || 'Unable to delete records');
          }
        }}
      />
    </div>
  );
}
