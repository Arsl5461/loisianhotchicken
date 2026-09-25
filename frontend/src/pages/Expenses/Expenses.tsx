import { useState } from 'react';
import { Calendar, Plus, Trash2, Upload } from 'lucide-react';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { SearchInput } from '../../components/common/SearchInput';
import { DataTable } from '../../components/common/DataTable';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { LoadingSpinner } from '../../components/common/LoadingSpinner';
import { Modal } from '../../components/common/Modal';
import {
  useBulkDeleteExpensesMutation,
  useCreateExpenseMutation,
  useGetExpenseCategoriesQuery,
  useGetExpensesQuery,
} from '../../api/expensesApi';
import { useGetStoresQuery } from '../../api/storesApi';
import { useGetPaymentMethodsQuery } from '../../api/paymentMethodsApi';
import { useStoreContext } from '../../hooks/usePermissions';
import { useListParams } from '../../hooks/useListParams';
import { formatCurrencyExact, formatDate } from '../../utils/cn';
import { clearZeroOnFocus, parseNumericInput, type NumericField } from '../../utils/numberInput';
import { Pagination } from '../../components/common/Pagination';
import { DeleteAction, TableActions, ViewAction } from '../../components/common/TableActions';
import { ListingToolbar } from '../../components/common/ListingToolbar';
import { useRowSelection } from '../../hooks/useRowSelection';
import type { ExportColumn } from '../../utils/export';

type PaymentLine = { method: string; amount: NumericField };

const emptyPayment = (): PaymentLine => ({ method: '', amount: 0 });

const emptyForm: {
  storeId: string;
  title: string;
  category: string;
  expenseDate: string;
  payments: PaymentLine[];
} = { storeId: '', title: '', category: '', expenseDate: '', payments: [emptyPayment()] };

function paymentTotal(payments: PaymentLine[]) {
  return payments.reduce((sum, line) => sum + (Number(line.amount) || 0), 0);
}

function formatExpensePayments(row: { payments?: Array<{ method?: string; amount?: number }>; paymentMethod?: string; amount?: number }) {
  const payments =
    row.payments?.length
      ? row.payments
      : row.paymentMethod
        ? [{ method: row.paymentMethod, amount: row.amount }]
        : [];
  if (!payments.length) return '—';
  return payments
    .map((line) =>
      payments.length > 1 ? `${line.method} ${formatCurrencyExact(Number(line.amount) || 0)}` : line.method
    )
    .join(' + ');
}

function RequiredLabel({ children }: { children: string }) {
  return (
    <span className="mb-1.5 block text-sm font-medium text-slate-700">
      {children} <span className="text-brand-red">*</span>
    </span>
  );
}

function receiptPath(url?: string) {
  if (!url) return '';
  const index = url.indexOf('/uploads/');
  return index >= 0 ? url.slice(index) : url;
}

export default function Expenses() {
  const [open, setOpen] = useState(false);
  const [deleteIds, setDeleteIds] = useState<string[]>([]);
  const [receipt, setReceipt] = useState<File | null>(null);
  const [viewReceipt, setViewReceipt] = useState<{ title: string; url: string } | null>(null);
  const { selectedStoreId } = useStoreContext();
  const { page, setPage, limit, setLimit, search, setSearch, query } = useListParams(20, [selectedStoreId]);
  const { data, isLoading } = useGetExpensesQuery({ ...query, storeId: selectedStoreId || undefined });
  const storesQuery = useGetStoresQuery({ limit: 100, sortBy: 'name', sortOrder: 'asc' });
  const categoriesQuery = useGetExpenseCategoriesQuery({ limit: 100, status: 'ACTIVE', sortBy: 'name', sortOrder: 'asc' });
  const methodsQuery = useGetPaymentMethodsQuery({ limit: 100, status: 'ACTIVE', sortBy: 'name', sortOrder: 'asc' });
  const stores = storesQuery.data?.data?.items || [];
  const categories = categoriesQuery.data?.data || [];
  const paymentMethods = methodsQuery.data?.data || [];
  const rows = data?.data || [];
  const selection = useRowSelection(rows.map((row: any) => row._id));
  const exportRows = selection.selected.length ? rows.filter((row: any) => selection.selected.includes(row._id)) : rows;
  const exportColumns: ExportColumn<any>[] = [
    { header: 'Title', value: (row) => row.title },
    { header: 'Store', value: (row) => row.storeId?.name || '' },
    { header: 'Category', value: (row) => row.category },
    { header: 'Payment', value: (row) => formatExpensePayments(row) },
    { header: 'Amount', value: (row) => row.amount },
    { header: 'Date', value: (row) => formatDate(row.expenseDate) },
    { header: 'Receipt', value: (row) => (row.receiptUrl ? 'Yes' : 'No') },
  ];
  const [createExpense] = useCreateExpenseMutation();
  const [bulkDeleteExpenses] = useBulkDeleteExpensesMutation();
  const [form, setForm] = useState(emptyForm);

  return (
    <div>
      <PageHeader
        title="Expenses"
        subtitle="Track operating costs by store, category, and date range."
        actions={
          <button className="btn-primary" type="button" onClick={() => setOpen(true)}>
            <Plus className="h-4 w-4" />
            Add Expense
          </button>
        }
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
              columns={[
                { key: 'title', header: 'Title', render: (row: any) => row.title },
                { key: 'store', header: 'Store', render: (row: any) => row.storeId?.name },
                { key: 'category', header: 'Category', render: (row: any) => row.category },
                {
                  key: 'payment',
                  header: 'Payment',
                  render: (row: any) => (
                    <span className="block max-w-[220px] text-sm leading-5">{formatExpensePayments(row)}</span>
                  ),
                },
                { key: 'amount', header: 'Amount', render: (row: any) => formatCurrencyExact(row.amount) },
                { key: 'date', header: 'Date', render: (row: any) => formatDate(row.expenseDate) },
                {
                  key: 'receipt',
                  header: 'Receipt',
                  render: (row: any) =>
                    row.receiptUrl ? (
                      <button
                        type="button"
                        className="text-sm font-semibold text-sky-600 hover:text-sky-700"
                        onClick={() => setViewReceipt({ title: row.title, url: receiptPath(row.receiptUrl) })}
                      >
                        View
                      </button>
                    ) : (
                      <span className="text-slate-400">—</span>
                    ),
                },
                {
                  key: 'actions',
                  header: 'Actions',
                  render: (row: any) => (
                    <TableActions>
                      {row.receiptUrl ? (
                        <ViewAction
                          label="View receipt"
                          onClick={() => setViewReceipt({ title: row.title, url: receiptPath(row.receiptUrl) })}
                        />
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
        title="New expense"
        description="Choose a category, then split the cost across one or more payment methods."
        onClose={() => {
          setOpen(false);
          setForm({ ...emptyForm, payments: [emptyPayment()] });
          setReceipt(null);
        }}
      >
        <form
          className="space-y-3"
          onSubmit={async (event) => {
            event.preventDefault();
            const storeId = form.storeId || selectedStoreId || stores[0]?._id;
            const payments = form.payments
              .filter((line) => line.method && Number(line.amount) > 0)
              .map((line) => ({ method: line.method, amount: Number(line.amount) }));
            const total = paymentTotal(payments);
            if (!storeId || !form.title || !form.category || !form.expenseDate || !payments.length) {
              toast.error('Please fill in all required fields');
              return;
            }
            if (payments.length !== form.payments.length) {
              toast.error('Enter a payment method and amount for each row');
              return;
            }
            if (new Set(payments.map((line) => line.method)).size !== payments.length) {
              toast.error('Each payment method can only be used once');
              return;
            }
            try {
              const payload = new FormData();
              payload.append('storeId', String(storeId));
              payload.append('title', form.title);
              payload.append('category', form.category);
              payload.append('expenseDate', form.expenseDate);
              payload.append('amount', String(total));
              payload.append('payments', JSON.stringify(payments));
              if (receipt) payload.append('receipt', receipt);
              await createExpense(payload).unwrap();
              toast.success('Expense recorded');
              setOpen(false);
              setForm({ ...emptyForm, payments: [emptyPayment()] });
              setReceipt(null);
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to save expense');
            }
          }}
        >
          <label className="block">
            <RequiredLabel>Store</RequiredLabel>
            <select className="soft-input" value={form.storeId} onChange={(e) => setForm({ ...form, storeId: e.target.value })} required>
              <option value="">Select store</option>
              {stores.map((store: any) => (
                <option key={store._id} value={store._id}>
                  {store.name}
                </option>
              ))}
            </select>
          </label>
          <label className="block">
            <RequiredLabel>Title</RequiredLabel>
            <input
              className="soft-input"
              placeholder="Title"
              value={form.title}
              onChange={(e) => setForm({ ...form, title: e.target.value })}
              required
            />
          </label>
          <label className="block">
            <RequiredLabel>Category</RequiredLabel>
            <select
              className="soft-input"
              value={form.category}
              onChange={(e) => setForm({ ...form, category: e.target.value })}
              required
            >
              <option value="">Select category</option>
              {categories.map((item: any) => (
                <option key={item._id} value={item.name}>
                  {item.name}
                </option>
              ))}
            </select>
          </label>
          {!categories.length ? (
            <p className="text-xs text-slate-500">Add categories from Expense Categories first.</p>
          ) : null}
          <label className="block">
            <RequiredLabel>Date</RequiredLabel>
            <span className="soft-input flex items-center gap-2">
              <Calendar className="h-4 w-4 shrink-0 text-brand-red" />
              <input
                className="w-full bg-transparent outline-none"
                type="date"
                value={form.expenseDate}
                onChange={(e) => setForm({ ...form, expenseDate: e.target.value })}
                required
              />
            </span>
          </label>
          <div className="block">
            <RequiredLabel>Payment methods</RequiredLabel>
            <div className="space-y-2">
              {form.payments.map((line, index) => {
                const used = form.payments.map((item) => item.method).filter(Boolean);
                return (
                  <div
                    key={`payment-${index}`}
                    className="grid grid-cols-[minmax(0,1fr)_5.5rem_2.5rem] items-center gap-2"
                  >
                    <select
                      className="soft-input min-w-0"
                      value={line.method}
                      onChange={(event) => {
                        const payments = form.payments.map((item, itemIndex) =>
                          itemIndex === index ? { ...item, method: event.target.value } : item
                        );
                        setForm({ ...form, payments });
                      }}
                      required
                    >
                      <option value="">Select method</option>
                      {paymentMethods.map((item: any) => (
                        <option
                          key={item._id}
                          value={item.name}
                          disabled={used.includes(item.name) && item.name !== line.method}
                        >
                          {item.name}
                        </option>
                      ))}
                    </select>
                    <input
                      className="soft-input !w-[5.5rem] px-2 text-right tabular-nums"
                      type="number"
                      min="0.01"
                      step="0.01"
                      placeholder="0.00"
                      value={line.amount}
                      onFocus={() =>
                        setForm((current) => ({
                          ...current,
                          payments: current.payments.map((item, itemIndex) =>
                            itemIndex === index ? { ...item, amount: clearZeroOnFocus(item.amount) } : item
                          ),
                        }))
                      }
                      onChange={(event) => {
                        const amount = parseNumericInput(event.target.value);
                        setForm({
                          ...form,
                          payments: form.payments.map((item, itemIndex) =>
                            itemIndex === index ? { ...item, amount } : item
                          ),
                        });
                      }}
                      required
                    />
                    {form.payments.length > 1 ? (
                      <button
                        type="button"
                        className="inline-flex h-10 w-10 items-center justify-center rounded-xl text-slate-400 hover:bg-slate-100 hover:text-brand-red"
                        aria-label="Remove payment method"
                        onClick={() =>
                          setForm({
                            ...form,
                            payments: form.payments.filter((_, itemIndex) => itemIndex !== index),
                          })
                        }
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    ) : (
                      <span />
                    )}
                  </div>
                );
              })}
            </div>
            {form.payments.length < paymentMethods.length ? (
              <button
                type="button"
                className="mt-2 inline-flex items-center gap-1 text-sm font-medium text-brand-red hover:underline"
                onClick={() => setForm({ ...form, payments: [...form.payments, emptyPayment()] })}
              >
                <Plus className="h-3.5 w-3.5" />
                Add payment method
              </button>
            ) : null}
            <div className="mt-2 flex items-center justify-between text-sm">
              <span className="text-slate-500">Expense total</span>
              <span className="font-semibold text-ink-900">{formatCurrencyExact(paymentTotal(form.payments))}</span>
            </div>
          </div>
          {!paymentMethods.length ? (
            <p className="text-xs text-slate-500">Add methods from Payment Method first.</p>
          ) : null}
          <label className="block">
            <span className="mb-1.5 block text-sm font-medium text-slate-700">Receipt</span>
            <span className="soft-input flex cursor-pointer items-center gap-2">
              <Upload className="h-4 w-4 shrink-0 text-brand-red" />
              <input
                className="w-full bg-transparent text-sm file:mr-3 file:rounded-lg file:border-0 file:bg-slate-100 file:px-3 file:py-1 file:text-sm file:font-medium"
                type="file"
                accept="image/jpeg,image/png,image/webp,application/pdf"
                onChange={(event) => setReceipt(event.target.files?.[0] || null)}
              />
            </span>
            <p className="mt-1 text-xs text-slate-500">Optional. JPG, PNG, WEBP, or PDF up to 5 MB.</p>
          </label>
          <div className="flex justify-end gap-2">
            <button className="btn-secondary" type="button" onClick={() => { setOpen(false); setForm({ ...emptyForm, payments: [emptyPayment()] }); setReceipt(null); }}>
              Cancel
            </button>
            <button className="btn-primary" type="submit" disabled={!categories.length || !paymentMethods.length}>
              Save
            </button>
          </div>
        </form>
      </Modal>
      <Modal
        open={Boolean(viewReceipt)}
        title={viewReceipt ? `Receipt · ${viewReceipt.title}` : 'Receipt'}
        onClose={() => setViewReceipt(null)}
        wide
      >
        {viewReceipt ? (
          <div className="space-y-3">
            {viewReceipt.url.toLowerCase().includes('.pdf') ? (
              <iframe title="Expense receipt" className="h-[70vh] w-full rounded-xl border border-slate-200" src={viewReceipt.url} />
            ) : (
              <img src={viewReceipt.url} alt="Expense receipt" className="max-h-[70vh] w-full rounded-xl object-contain bg-slate-50" />
            )}
            <a className="text-sm font-semibold text-sky-600 hover:text-sky-700" href={viewReceipt.url} target="_blank" rel="noreferrer">
              Open in new tab
            </a>
          </div>
        ) : null}
      </Modal>
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
