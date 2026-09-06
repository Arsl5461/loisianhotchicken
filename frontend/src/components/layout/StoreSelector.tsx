import { useEffect } from 'react';
import { ChevronDown, Store } from 'lucide-react';
import { useDispatch } from 'react-redux';
import { setSelectedStore } from '../../features/auth/storeContextSlice';
import { api } from '../../api/axios';
import { useStoreContext } from '../../hooks/usePermissions';

export function StoreSelector() {
  const dispatch = useDispatch();
  const { selectedStoreId, stores, storesLoaded } = useStoreContext();

  useEffect(() => {
    if (!storesLoaded || !selectedStoreId) return;
    const stillExists = stores.some((store) => store._id === selectedStoreId);
    if (!stillExists) {
      dispatch(setSelectedStore(null));
      dispatch(api.util.invalidateTags(['Dashboard', 'Sale', 'Expense', 'Report', 'Order']));
    }
  }, [dispatch, selectedStoreId, stores, storesLoaded]);

  return (
    <label className="relative flex min-w-[240px] items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-2.5">
      <Store className="h-4 w-4 shrink-0 text-brand-orange" />
      <select
        className="w-full appearance-none bg-transparent pr-6 text-sm font-medium text-slate-800 outline-none"
        value={selectedStoreId || ''}
        onChange={(event) => {
          dispatch(setSelectedStore(event.target.value || null));
          dispatch(api.util.invalidateTags(['Dashboard', 'Sale', 'Expense', 'Report', 'Order']));
        }}
      >
        <option value="">All Stores</option>
        {stores.map((store) => (
          <option key={store._id} value={store._id}>
            {store.name}
          </option>
        ))}
      </select>
      <ChevronDown className="pointer-events-none absolute right-3 h-4 w-4 text-slate-400" />
    </label>
  );
}
