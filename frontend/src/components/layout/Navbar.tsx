import { Menu } from 'lucide-react';
import { useDispatch, useSelector } from 'react-redux';
import { StoreSelector } from './StoreSelector';
import type { RootState } from '../../app/store';
import { useLogoutMutation } from '../../api/authApi';
import { logout } from '../../features/auth/authSlice';
import { useState } from 'react';

export function Navbar({ onMenu }: { onMenu: () => void }) {
  const user = useSelector((state: RootState) => state.auth.user);
  const dispatch = useDispatch();
  const [logoutRequest] = useLogoutMutation();
  const [open, setOpen] = useState(false);

  return (
    <header className="sticky top-0 z-20 flex items-center justify-between gap-3 border-b border-slate-200/80 bg-white/90 px-4 py-3 backdrop-blur md:px-6">
      <div className="flex items-center gap-3">
        <button type="button" className="rounded-xl border border-slate-200 p-2 lg:hidden" onClick={onMenu} aria-label="Open menu">
          <Menu className="h-4 w-4" />
        </button>
        <StoreSelector />
      </div>

      <div className="flex items-center gap-2">
        <div className="relative">
          <button type="button" className="flex items-center gap-2 rounded-xl border border-slate-200 px-2 py-1.5" onClick={() => setOpen((v) => !v)}>
            <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-brand-red text-xs font-bold text-white">
              {user?.name?.slice(0, 2).toUpperCase()}
            </span>
            <span className="hidden text-left text-sm md:block">
              <span className="block font-semibold leading-4">{user?.name}</span>
              <span className="text-xs text-slate-500">{user?.role?.name}</span>
            </span>
          </button>
          {open ? (
            <div className="absolute right-0 mt-2 w-48 rounded-xl border border-slate-200 bg-white p-2 shadow-xl">
              <button
                type="button"
                className="w-full rounded-lg px-3 py-2 text-left text-sm hover:bg-slate-50"
                onClick={async () => {
                  await logoutRequest();
                  dispatch(logout());
                }}
              >
                Sign out
              </button>
            </div>
          ) : null}
        </div>
      </div>
    </header>
  );
}
