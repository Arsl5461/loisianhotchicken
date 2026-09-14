import { Menu } from 'lucide-react';
import { useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { StoreSelector } from './StoreSelector';
import type { RootState } from '../../app/store';
import { useLogoutMutation } from '../../api/authApi';
import { endSession } from '../../features/auth/session';
import { Pulse } from '../common/LoadingSpinner';

function initials(name = '') {
  const parts = name.trim().split(/\s+/).filter(Boolean);
  if (parts.length >= 2) {
    return `${parts[0][0]}${parts[parts.length - 1][0]}`.toUpperCase();
  }
  return name.slice(0, 2).toUpperCase() || 'U';
}

export function Navbar({ onMenu }: { onMenu: () => void }) {
  const user = useSelector((state: RootState) => state.auth.user);
  const dispatch = useDispatch();
  const [logoutRequest] = useLogoutMutation();
  const [open, setOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const onPointerDown = (event: MouseEvent) => {
      if (!menuRef.current?.contains(event.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', onPointerDown);
    return () => document.removeEventListener('mousedown', onPointerDown);
  }, []);

  return (
    <header className="sticky top-0 z-20 flex items-center justify-between gap-3 border-b border-slate-200/80 bg-white/90 px-4 py-3 backdrop-blur md:px-6">
      <div className="flex items-center gap-3">
        <button type="button" className="rounded-xl border border-slate-200 p-2 lg:hidden" onClick={onMenu} aria-label="Open menu">
          <Menu className="h-4 w-4" />
        </button>
        <StoreSelector />
      </div>

      <div className="flex items-center gap-2">
        <div className="relative" ref={menuRef}>
          {!user ? (
            <div className="flex h-[42px] min-w-[200px] items-center gap-2 rounded-xl border border-slate-200 px-2 py-1.5">
              <Pulse className="h-8 w-8 rounded-lg" />
              <span className="hidden md:block">
                <Pulse className="h-3.5 w-28" />
                <Pulse className="mt-1.5 h-2.5 w-16" />
              </span>
            </div>
          ) : (
            <>
              <button
                type="button"
                className="flex h-[42px] min-w-[200px] items-center gap-2 rounded-xl border border-slate-200 px-2 py-1.5"
                onClick={() => setOpen((value) => !value)}
              >
                <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-brand-red text-xs font-bold text-white">
                  {initials(user.name)}
                </span>
                <span className="hidden min-w-0 flex-1 text-left text-sm md:block">
                  <span className="block truncate font-semibold leading-4">{user.name}</span>
                  <span className="truncate text-xs text-slate-500">{user.role?.name || 'User'}</span>
                </span>
              </button>
              {open ? (
                <div className="absolute right-0 mt-2 w-64 rounded-xl border border-slate-200 bg-white p-2 shadow-xl">
                  <div className="border-b border-slate-100 px-3 py-2">
                    <p className="text-sm font-semibold text-ink-900">{user.name}</p>
                    <p className="text-xs font-medium text-brand-red">{user.role?.name}</p>
                    <p className="mt-0.5 truncate text-xs text-slate-500">{user.email}</p>
                  </div>
                  <button
                    type="button"
                    className="mt-1 w-full rounded-lg px-3 py-2 text-left text-sm hover:bg-slate-50"
                    onClick={async () => {
                      try {
                        await logoutRequest().unwrap();
                      } finally {
                        endSession(dispatch);
                      }
                    }}
                  >
                    Sign out
                  </button>
                </div>
              ) : null}
            </>
          )}
        </div>
      </div>
    </header>
  );
}
