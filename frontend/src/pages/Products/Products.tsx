import { useState } from 'react';
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
import { useRowSelection } from '../../hooks/useRowSelection';
import type { ExportColumn } from '../../utils/export';

export default function Products() {
  const { page, setPage, limit, setLimit, search, setSearch, query } = useListParams();
  const { data } = useGetProductsQuery(query);
  const [createProduct] = useCreateProductMutation();
  const [bulkDeleteProducts] = useBulkDeleteProductsMutation();
  const [deleteIds, setDeleteIds] = useState<string[]>([]);
  const [form, setForm] = useState({ name: '', category: 'CHICKEN', price: 0, costPrice: 0 });
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

  return (
    <div>
      <PageHeader title="Products" subtitle="Organization catalog with store-level availability architecture for future inventory." />
      <form
        className="card mb-5 grid gap-3 p-4 md:grid-cols-5"
        onSubmit={async (event) => {
          event.preventDefault();
          await createProduct({ ...form, price: Number(form.price), costPrice: Number(form.costPrice) }).unwrap();
          toast.success('Product created');
        }}
      >
        <input className="soft-input" placeholder="Name" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
        <select className="soft-input" value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })}>
          {['CHICKEN', 'SIDES', 'DRINKS', 'COMBOS', 'DESSERTS', 'OTHER'].map((item) => <option key={item}>{item}</option>)}
        </select>
        <input className="soft-input" type="number" placeholder="Price" value={form.price} onChange={(e) => setForm({ ...form, price: Number(e.target.value) })} />
        <input className="soft-input" type="number" placeholder="Cost" value={form.costPrice} onChange={(e) => setForm({ ...form, costPrice: Number(e.target.value) })} />
        <button className="btn-primary" type="submit">Add product</button>
      </form>
      <div className="card p-4">
        <div className="mb-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <SearchInput value={search} onChange={setSearch} placeholder="Search products" />
          <ListingToolbar
            title="Products"
            fileName="lhc-products"
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
            { key: 'name', header: 'Product', render: (row: any) => row.name },
            { key: 'category', header: 'Category', render: (row: any) => row.category },
            { key: 'price', header: 'Price', render: (row: any) => formatCurrencyExact(row.price) },
            { key: 'cost', header: 'Cost', render: (row: any) => formatCurrencyExact(row.costPrice) },
            { key: 'status', header: 'Available', render: (row: any) => (row.isAvailable ? 'Yes' : 'No') },
            { key: 'actions', header: 'Actions', render: (row: any) => (
              <TableActions>
                <DeleteAction onClick={() => setDeleteIds([row._id])} />
              </TableActions>
            ) },
          ]}
        />
        <Pagination meta={data?.meta} onPageChange={setPage} onLimitChange={setLimit} />
      </div>
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
