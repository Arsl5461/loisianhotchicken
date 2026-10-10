import { useState } from 'react';
import { Calendar, Upload } from 'lucide-react';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { SearchInput } from '../../components/common/SearchInput';
import { DataTable } from '../../components/common/DataTable';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { BusyOverlay, InlineSpinner, LoadingSpinner } from '../../components/common/LoadingSpinner';
import { Modal } from '../../components/common/Modal';
import {
  useBulkDeleteSalesMutation,
  useCreateSaleMutation,
  useGetSaleCategoriesQuery,
  useGetSalesQuery,
  useUpdateSaleMutation,
} from '../../api/salesApi';
import { useGetPaymentMethodsQuery } from '../../api/paymentMethodsApi';
import { useStoreContext } from '../../hooks/usePermissions';
import { useListParams } from '../../hooks/useListParams';
import { todayInAppTimezone, toDateInputValue } from '../../constants/timezone';
import { formatCurrencyExact, formatDate } from '../../utils/cn';
import { clearZeroOnFocus, parseNumericInput, type NumericField } from '../../utils/numberInput';
import { Pagination } from '../../components/common/Pagination';
import { DeleteAction, EditAction, TableActions, ViewAction } from '../../components/common/TableActions';
import { ListingToolbar } from '../../components/common/ListingToolbar';
import { useRowSelection } from '../../hooks/useRowSelection';
import type { ExportColumn } from '../../utils/export';

function RequiredLabel({ children }: { children: string }) {
  return (
    <span className="mb-1.5 block text-sm font-medium text-slate-700">
      {children} <span className="text-brand-red">*</span>
    </span>
  );
}

function attachmentPath(url?: string) {
  if (!url) return '';
  const index = url.indexOf('/uploads/');
  return index >= 0 ? url.slice(index) : url;
}

function emptyForm() {
  return {
    storeId: '',
    amount: '' as NumericField,
    paymentMethod: '',
    category: '',
    saleDate: todayInAppTimezone(),
    customerName: 'Walk-in Guest',
  };
}

function formFromSale(row: any) {
  return {
    storeId: row.storeId?._id || row.storeId || '',
    amount: Number(row.totalAmount) || ('' as NumericField),
    paymentMethod: row.paymentMethod || '',
    category: row.category || '',
    saleDate: toDateInputValue(row.saleDate) || todayInAppTimezone(),
    customerName: row.customerName || 'Walk-in Guest',
  };
}

export default function Sales() {
  const [open, setOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [deleteIds, setDeleteIds] = useState<string[]>([]);
  const [attachment, setAttachment] = useState<File | null>(null);
  const [existingAttachment, setExistingAttachment] = useState('');
  const [viewAttachment, setViewAttachment] = useState<{ title: string; url: string } | null>(null);
  const { selectedStoreId, stores } = useStoreContext();
  const { page, setPage, limit, setLimit, search, setSearch, query } = useListParams(20, [selectedStoreId]);
  const { data, isLoading } = useGetSalesQuery({ ...query, storeId: selectedStoreId || undefined });
  const rows = data?.data || [];
  const selection = useRowSelection(rows.map((row: any) => row._id));
  const exportRows = selection.selected.length ? rows.filter((row: any) => selection.selected.includes(row._id)) : rows;
  const exportColumns: ExportColumn<any>[] = [
    { header: 'Store', value: (row) => row.storeId?.name || '' },
    { header: 'Customer', value: (row) => row.customerName },
    { header: 'Category', value: (row) => row.category || '' },
    { header: 'Amount', value: (row) => row.totalAmount },
    { header: 'Payment', value: (row) => row.paymentMethod },
    { header: 'Date', value: (row) => formatDate(row.saleDate) },
    { header: 'Attachment', value: (row) => (row.attachmentUrl ? 'Yes' : 'No') },
  ];
  const methodsQuery = useGetPaymentMethodsQuery({ limit: 100, status: 'ACTIVE', sortBy: 'name', sortOrder: 'asc' });
  const categoriesQuery = useGetSaleCategoriesQuery({ limit: 100, status: 'ACTIVE', sortBy: 'name', sortOrder: 'asc' });
  const paymentMethods = methodsQuery.data?.data || [];
  const categories = categoriesQuery.data?.data || [];
  const [createSale, { isLoading: creating }] = useCreateSaleMutation();
  const [updateSale, { isLoading: updating }] = useUpdateSaleMutation();
  const [bulkDeleteSales, { isLoading: deleting }] = useBulkDeleteSalesMutation();
  const [form, setForm] = useState(emptyForm);
  const saving = creating || updating;

  const closeForm = () => {
    setOpen(false);
    setEditingId(null);
    setExistingAttachment('');
    setAttachment(null);
    setForm(emptyForm());
  };

  const openCreate = () => {
    setEditingId(null);
    setExistingAttachment('');
    setAttachment(null);
    setForm(emptyForm());
    setOpen(true);
  };

  const openEdit = (row: any) => {
    setEditingId(row._id);
    setExistingAttachment(row.attachmentUrl || '');
    setAttachment(null);
    setForm(formFromSale(row));
    setOpen(true);
  };

  const openAttachment = (row: any) => {
    setViewAttachment({
      title: row.customerName || row.category || 'Sale',
      url: attachmentPath(row.attachmentUrl),
    });
  };

  return (
    <div>
      <PageHeader
        title="Sales Income"
        subtitle="Record and review store-level sales."
        actions={
          <button className="btn-primary" type="button" onClick={openCreate}>
            Add Sale
          </button>
        }
      />
      <div className="card p-4">
        <div className="mb-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <SearchInput value={search} onChange={setSearch} placeholder="Search customer or reference" />
          <ListingToolbar
            title="Sales Income"
            fileName="lhc-sales"
            columns={exportColumns}
            rows={exportRows}
            selectedCount={selection.selected.length}
            deleting={deleting}
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
                { key: 'store', header: 'Store', render: (row: any) => row.storeId?.name },
                { key: 'customer', header: 'Customer', render: (row: any) => row.customerName },
                { key: 'category', header: 'Category', render: (row: any) => row.category || '—' },
                { key: 'amount', header: 'Amount', render: (row: any) => formatCurrencyExact(row.totalAmount) },
                { key: 'method', header: 'Payment', render: (row: any) => row.paymentMethod },
                { key: 'date', header: 'Date', render: (row: any) => formatDate(row.saleDate) },
                {
                  key: 'attachment',
                  header: 'Attachment',
                  render: (row: any) =>
                    row.attachmentUrl ? (
                      <button
                        type="button"
                        className="text-sm font-semibold text-sky-600 hover:text-sky-700"
                        onClick={() => openAttachment(row)}
                      >
                        View
                      </button>
                    ) : (
                      <span className="text-slate-400">—</span>
                    ),
                },
                {
                  key: 'actions',
                  header: '',
                  render: (row: any) => (
                    <TableActions>
                      <EditAction onClick={() => openEdit(row)} />
                      {row.attachmentUrl ? (
                        <ViewAction label="View attachment" onClick={() => openAttachment(row)} />
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
        title={editingId ? 'Edit sale' : 'New sale'}
        description="Choose a category and date, then record the sale amount."
        onClose={closeForm}
      >
        <form
          className="space-y-3"
          onSubmit={async (event) => {
            event.preventDefault();
            const storeId = form.storeId || selectedStoreId || stores[0]?._id;
            if (!storeId || !form.paymentMethod || !form.amount || !form.category || !form.saleDate) {
              toast.error('Please fill in store, category, date, amount, and payment method');
              return;
            }
            try {
              const payload = new FormData();
              payload.append('storeId', String(storeId));
              payload.append('customerName', form.customerName);
              payload.append('category', form.category);
              payload.append('saleDate', form.saleDate);
              payload.append('paymentMethod', form.paymentMethod);
              payload.append('totalAmount', String(form.amount));
              if (attachment) payload.append('attachment', attachment);
              if (editingId) {
                await updateSale({ id: editingId, data: payload }).unwrap();
                toast.success('Sale updated');
              } else {
                await createSale(payload).unwrap();
                toast.success('Sale recorded');
              }
              closeForm();
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to save sale');
            }
          }}
        >
          <label className="block">
            <RequiredLabel>Store</RequiredLabel>
            <select className="soft-input" value={form.storeId} onChange={(e) => setForm({ ...form, storeId: e.target.value })} required>
              <option value="">Select store</option>
              {stores.map((store) => (
                <option key={store._id} value={store._id}>{store.name}</option>
              ))}
            </select>
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
                <option key={item._id} value={item.name}>{item.name}</option>
              ))}
            </select>
          </label>
          {!categories.length ? (
            <p className="text-xs text-slate-500">Add categories from Sale Category first.</p>
          ) : null}
          <label className="block">
            <RequiredLabel>Date</RequiredLabel>
            <span className="soft-input flex items-center gap-2">
              <Calendar className="h-4 w-4 shrink-0 text-brand-red" />
              <input
                className="w-full bg-transparent outline-none"
                type="date"
                value={form.saleDate}
                onChange={(e) => setForm({ ...form, saleDate: e.target.value })}
                required
              />
            </span>
          </label>
          <label className="block">
            <RequiredLabel>Sale amount</RequiredLabel>
            <input
              className="soft-input"
              type="number"
              min={0.01}
              step="0.01"
              placeholder="Sale amount"
              value={form.amount}
              onFocus={() => setForm((current) => ({ ...current, amount: clearZeroOnFocus(current.amount) }))}
              onChange={(e) => setForm({ ...form, amount: parseNumericInput(e.target.value) })}
              required
            />
          </label>
          <label className="block">
            <RequiredLabel>Payment method</RequiredLabel>
            <select className="soft-input" value={form.paymentMethod} onChange={(e) => setForm({ ...form, paymentMethod: e.target.value })} required>
              <option value="">Select payment method</option>
              {paymentMethods.map((method: any) => (
                <option key={method._id} value={method.name}>{method.name}</option>
              ))}
            </select>
          </label>
          {!paymentMethods.length ? (
            <p className="text-xs text-slate-500">Add methods from Payment Method first.</p>
          ) : null}
          <label className="block">
            <span className="mb-1.5 block text-sm font-medium text-slate-700">Attachment</span>
            <span className="soft-input flex cursor-pointer items-center gap-2">
              <Upload className="h-4 w-4 shrink-0 text-brand-red" />
              <input
                className="w-full bg-transparent text-sm file:mr-3 file:rounded-lg file:border-0 file:bg-slate-100 file:px-3 file:py-1 file:text-sm file:font-medium"
                type="file"
                accept="image/jpeg,image/png,image/webp,application/pdf"
                onChange={(event) => setAttachment(event.target.files?.[0] || null)}
              />
            </span>
            <p className="mt-1 text-xs text-slate-500">
              {existingAttachment && !attachment
                ? 'A file is already attached. Upload a new file only if you want to replace it.'
                : 'Optional. JPG, PNG, WEBP, or PDF up to 5 MB.'}
            </p>
          </label>
          <div className="flex justify-end gap-2">
            <button className="btn-secondary" type="button" onClick={closeForm}>Cancel</button>
            <button className="btn-primary" type="submit" disabled={saving || !categories.length || !paymentMethods.length}>
              {saving ? <><InlineSpinner className="border-white/30 border-t-white" /> Saving...</> : editingId ? 'Update' : 'Save'}
            </button>
          </div>
        </form>
      </Modal>

      <Modal
        open={Boolean(viewAttachment)}
        title={viewAttachment ? `Attachment · ${viewAttachment.title}` : 'Attachment'}
        onClose={() => setViewAttachment(null)}
        wide
      >
        {viewAttachment ? (
          <div className="space-y-3">
            {viewAttachment.url.toLowerCase().includes('.pdf') ? (
              <iframe title="Sale attachment" className="h-[70vh] w-full rounded-xl border border-slate-200" src={viewAttachment.url} />
            ) : (
              <img src={viewAttachment.url} alt="Sale attachment" className="max-h-[70vh] w-full rounded-xl object-contain bg-slate-50" />
            )}
            <a className="text-sm font-semibold text-sky-600 hover:text-sky-700" href={viewAttachment.url} target="_blank" rel="noreferrer">
              Open in new tab
            </a>
          </div>
        ) : null}
      </Modal>

      <BusyOverlay show={saving || deleting} label={deleting ? 'Deleting sales...' : 'Saving sale...'} />
      <ConfirmDialog
        open={deleteIds.length > 0}
        title={deleteIds.length > 1 ? 'Delete selected sales' : 'Delete sale'}
        description="Selected sales will be permanently removed from analytics."
        onClose={() => setDeleteIds([])}
        onConfirm={async () => {
          try {
            await bulkDeleteSales(deleteIds).unwrap();
            toast.success(deleteIds.length > 1 ? 'Selected sales deleted' : 'Sale deleted');
            selection.clear();
            setDeleteIds([]);
          } catch (error: any) {
            toast.error(error?.data?.message || 'Unable to delete sales');
          }
        }}
      />
    </div>
  );
}
