import { useForm } from 'react-hook-form';
import { useNavigate, useParams } from 'react-router-dom';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { BusyOverlay, InlineSpinner } from '../../components/common/LoadingSpinner';
import { useCreateStoreMutation, useGetStoreQuery, useUpdateStoreMutation } from '../../api/storesApi';
import { useEffect } from 'react';

export default function StoreForm({ mode }: { mode: 'create' | 'edit' }) {
  const { id } = useParams();
  const navigate = useNavigate();
  const { data } = useGetStoreQuery(id || '', { skip: mode === 'create' || !id });
  const [createStore, createState] = useCreateStoreMutation();
  const [updateStore, updateState] = useUpdateStoreMutation();
  const form = useForm({
    defaultValues: {
      name: '',
      storeCode: '',
      email: '',
      phone: '',
      address: '',
      city: '',
      state: '',
      country: 'United States',
      postalCode: '',
      status: 'ACTIVE',
    },
  });

  useEffect(() => {
    if (data?.data) {
      form.reset({
        name: data.data.name,
        storeCode: data.data.storeCode,
        email: data.data.email || '',
        phone: data.data.phone || '',
        address: data.data.address || '',
        city: data.data.city || '',
        state: data.data.state || '',
        country: data.data.country || 'United States',
        postalCode: data.data.postalCode || '',
        status: data.data.status,
      });
    }
  }, [data, form]);

  return (
    <div className="max-w-3xl">
      <BusyOverlay show={createState.isLoading || updateState.isLoading} label="Saving store..." />
      <PageHeader title={mode === 'create' ? 'Add New Store' : 'Edit Store'} subtitle="Store codes must stay unique across the organization." />
      <form
        className="card grid gap-4 p-6 md:grid-cols-2"
        onSubmit={form.handleSubmit(async (values) => {
          try {
            if (mode === 'create') {
              await createStore(values).unwrap();
              toast.success('Store created');
            } else if (id) {
              await updateStore({ id, data: values }).unwrap();
              toast.success('Store updated');
            }
            navigate('/stores');
          } catch (error: any) {
            toast.error(error?.data?.message || 'Unable to save store');
          }
        })}
      >
        {['name', 'storeCode', 'email', 'phone', 'address', 'city', 'state', 'country', 'postalCode'].map((field) => (
          <label key={field} className="text-sm font-medium capitalize">
            {field}
            <input className="soft-input mt-1" {...form.register(field as 'name')} />
          </label>
        ))}
        <label className="text-sm font-medium">
          Status
          <select className="soft-input mt-1" {...form.register('status')}>
            <option value="ACTIVE">ACTIVE</option>
            <option value="INACTIVE">INACTIVE</option>
            <option value="TEMPORARILY_CLOSED">TEMPORARILY_CLOSED</option>
          </select>
        </label>
        <div className="md:col-span-2">
          <button className="btn-primary" disabled={createState.isLoading || updateState.isLoading} type="submit">
            {createState.isLoading || updateState.isLoading ? (
              <>
                <InlineSpinner className="border-white/30 border-t-white" />
                Saving...
              </>
            ) : (
              'Save store'
            )}
          </button>
        </div>
      </form>
    </div>
  );
}
