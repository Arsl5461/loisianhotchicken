import { useState } from 'react';
import { Plus } from 'lucide-react';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { DataTable } from '../../components/common/DataTable';
import { Pagination } from '../../components/common/Pagination';
import { SearchInput } from '../../components/common/SearchInput';
import { useBulkDeleteProductsMutation, useCreateProductMutation, useGetProductsQuery } from '../../api/usersApi';
import { useListParams } from '../../hooks/useListParams';
import { formatCurrencyExact } from '../../utils/cn';
import { DeleteAction, TableActions } from '../../components/common/TableActions';
import { ListingToolbar } from '../../components/common/ListingToolbar';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { Modal } from '../../components/common/Modal';
import { BusyOverlay, InlineSpinner, LoadingSpinner } from '../../components/common/LoadingSpinner';
import { useRowSelection } from '../../hooks/useRowSelection';
import type { ExportColumn } from '../../utils/export';

const emptyForm: { name: string; category: string; price: number | ''; costPrice: number | '' } = {
  name: '',
  category: 'CHICKEN',
  price: 0,
  costPrice: 0,
};

function clearZeroOnFocus(value: number | '') {
  return value === 0 || value === '' ? '' : value;
}

export default function Products() {
  const { page, setPage, limit, setLimit, search, setSearch, query } = useListParams();
  const { data, isLoading } = useGetProductsQuery(query);
  const [createProduct, { isLoading: creating }] = useCreateProductMutation();
  const [bulkDeleteProducts, { isLoading: deleting }] = useBulkDeleteProductsMutation();
  const [open, setOpen] = useState(false);
  const [deleteIds, setDeleteIds] = useState<string[]>([]);
  const [form, setForm] = useState(emptyForm);
  const rows = data?.data || [];
  const selection = useRowSelection(rows.map((row: any) => row._id));
  const exportRows = selection.selected.length ? rows.filter((row: any) => selection.selected.includes(row._id)) : rows;
  const exportColumns: ExportColumn<any>[] = [
    { header: 'Product', value: (row) => row.name },
    { header: 'Category', value: (row) => row.category },
    { header: 'Price', value: (row) => row.price },
    { header: 'Cost', value: (row) => row.costPrice },
    { header: 'Available', value: (row) => (row.isAvailable ? 'Yes' : 'No') },
  ];

  const closeModal = () => {
    setOpen(false);
    setForm(emptyForm);
  };

  return (
    <div>
      <PageHeader
        title="Products"
        subtitle="Organization catalog with store-level availability."
        actions={
          <button className="btn-primary" type="button" onClick={() => setOpen(true)}>
            <Plus className="h-4 w-4" />
            Add Product
          </button>
        }
      />
      <div className="card p-4">
        <div className="mb-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <SearchInput value={search} onChange={setSearch} placeholder="Search products" />
          <ListingToolbar
            title="Products"
            fileName="lhc-products"
            columns={exportColumns}
            rows={exportRows}
            selectedCount={selection.selected.length}
            deleting={deleting}
            onDeleteSelected={() => setDeleteIds(selection.selected)}
          />
        </div>
        {isLoading ? (
          <LoadingSpinner />
        ) : (
          <>
            <DataTable
              rows={rows}
              selectable
              selectedIds={selection.selected}
              onToggle={selection.toggle}
              onToggleAll={selection.toggleAll}
              columns={[
                { key: 'name', header: 'Product', render: (row: any) => <span className="font-semibold">{row.name}</span> },
                { key: 'category', header: 'Category', render: (row: any) => row.category },
                { key: 'price', header: 'Price', render: (row: any) => formatCurrencyExact(row.price) },
                { key: 'cost', header: 'Cost', render: (row: any) => formatCurrencyExact(row.costPrice) },
                { key: 'status', header: 'Available', render: (row: any) => (row.isAvailable ? 'Yes' : 'No') },
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
          </>
        )}
      </div>

      <Modal open={open} title="Add product" description="Add an item to the organization catalog." onClose={closeModal}>
        <form
          className="space-y-4"
          onSubmit={async (event) => {
            event.preventDefault();
            try {
              await createProduct({
                ...form,
                price: Number(form.price),
                costPrice: Number(form.costPrice),
              }).unwrap();
              toast.success('Product created');
              closeModal();
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to create product');
            }
          }}
        >
          <label className="block text-sm font-medium text-slate-700">
            Name
            <input
              className="soft-input mt-1.5"
              placeholder="Classic Hot Chicken Sandwich"
              value={form.name}
              onChange={(event) => setForm({ ...form, name: event.target.value })}
              required
            />
          </label>
          <label className="block text-sm font-medium text-slate-700">
            Category
            <select
              className="soft-input mt-1.5"
              value={form.category}
              onChange={(event) => setForm({ ...form, category: event.target.value })}
            >
              {['CHICKEN', 'SIDES', 'DRINKS', 'COMBOS', 'DESSERTS', 'OTHER'].map((item) => (
                <option key={item}>{item}</option>
              ))}
            </select>
          </label>
          <div className="grid gap-4 sm:grid-cols-2">
            <label className="block text-sm font-medium text-slate-700">
              Price
              <input
                className="soft-input mt-1.5"
                type="number"
                min={0}
                step="0.01"
                value={form.price}
                onFocus={() => setForm((current) => ({ ...current, price: clearZeroOnFocus(current.price) }))}
                onChange={(event) =>
                  setForm({ ...form, price: event.target.value === '' ? '' : Number(event.target.value) })
                }
                required
              />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              Cost
              <input
                className="soft-input mt-1.5"
                type="number"
                min={0}
                step="0.01"
                value={form.costPrice}
                onFocus={() => setForm((current) => ({ ...current, costPrice: clearZeroOnFocus(current.costPrice) }))}
                onChange={(event) =>
                  setForm({ ...form, costPrice: event.target.value === '' ? '' : Number(event.target.value) })
                }
              />
            </label>
          </div>
          <div className="flex justify-end gap-2">
            <button className="btn-secondary" type="button" onClick={closeModal}>
              Cancel
            </button>
            <button className="btn-primary" type="submit" disabled={creating}>
              {creating ? (
                <>
                  <InlineSpinner className="border-white/30 border-t-white" />
                  Saving...
                </>
              ) : (
                'Add product'
              )}
            </button>
          </div>
        </form>
      </Modal>

      <BusyOverlay show={deleting} label="Deleting products..." />
      <ConfirmDialog
        open={deleteIds.length > 0}
        title={deleteIds.length > 1 ? 'Delete selected products' : 'Delete product'}
        description="Selected products will be removed from the catalog."
        onClose={() => setDeleteIds([])}
        onConfirm={async () => {
          try {
            await bulkDeleteProducts(deleteIds).unwrap();
            toast.success(deleteIds.length > 1 ? 'Selected products deleted' : 'Product deleted');
            selection.clear();
            setDeleteIds([]);
          } catch (error: any) {
            toast.error(error?.data?.message || 'Unable to delete products');
          }
        }}
      />
    </div>
  );
}
