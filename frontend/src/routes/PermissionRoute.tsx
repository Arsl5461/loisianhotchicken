import { Navigate, Outlet } from 'react-router-dom';
import { usePermissions } from '../hooks/usePermissions';

export function PermissionRoute({ permission }: { permission: string }) {
  const { can, user } = usePermissions();
  if (user && !can(permission)) return <Navigate to="/" replace />;
  return <Outlet />;
}
