import { useSelector } from 'react-redux';
import type { RootState } from '../app/store';

export function usePermissions() {
  const user = useSelector((state: RootState) => state.auth.user);

  const can = (permission: string) => {
    if (!user) return false;
    if (user.isSuperAdmin) return true;
    return user.permissions.includes(permission);
  };

  return { user, can, isSuperAdmin: Boolean(user?.isSuperAdmin) };
}

export function useStoreContext() {
  const selectedStoreId = useSelector((state: RootState) => state.storeContext.selectedStoreId);
  const stores = useSelector((state: RootState) => state.auth.user?.stores || []);
  return { selectedStoreId, stores };
}
