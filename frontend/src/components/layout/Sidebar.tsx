import { NavLink } from 'react-router-dom';
import {
  LayoutDashboard,
  Store,
  Receipt,
  Wallet,
  UtensilsCrossed,
  ShoppingBag,
  PieChart,
  BarChart3,
  Users,
  Shield,
  Settings,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import logo from '../../assets/logos/louisiana-hot-chicken.jpg';
import { cn } from '../../utils/cn';
import { usePermissions } from '../../hooks/usePermissions';
import { PERMISSIONS } from '../../constants/permissions';

const NAV = [
  {
    label: 'Dashboard',
    items: [{ to: '/', label: 'Dashboard', icon: LayoutDashboard, permission: PERMISSIONS.DASHBOARD_READ }],
  },
  {
    label: 'Management',
    items: [
      { to: '/stores', label: 'Stores', icon: Store, permission: PERMISSIONS.STORES_READ },
      { to: '/sales', label: 'Sales', icon: Receipt, permission: PERMISSIONS.SALES_READ },
      { to: '/expenses', label: 'Expenses', icon: Wallet, permission: PERMISSIONS.EXPENSES_READ },
      { to: '/products', label: 'Products', icon: UtensilsCrossed, permission: PERMISSIONS.PRODUCTS_READ },
      { to: '/orders', label: 'Orders', icon: ShoppingBag, permission: PERMISSIONS.ORDERS_READ },
    ],
  },
  {
    label: 'Finance',
    items: [
      { to: '/profit-loss', label: 'Profit & Loss', icon: PieChart, permission: PERMISSIONS.REPORTS_READ },
      { to: '/reports', label: 'Reports', icon: BarChart3, permission: PERMISSIONS.REPORTS_READ },
    ],
  },
  {
    label: 'Administration',
    items: [
      { to: '/users', label: 'Users', icon: Users, permission: PERMISSIONS.USERS_READ },
      { to: '/roles', label: 'Roles & Permissions', icon: Shield, permission: PERMISSIONS.ROLES_READ },
    ],
  },
  {
    label: 'System',
    items: [{ to: '/settings', label: 'Settings', icon: Settings, permission: PERMISSIONS.SETTINGS_READ }],
  },
];

export function Sidebar({
  collapsed,
  onToggle,
  mobile = false,
}: {
  collapsed: boolean;
  onToggle: () => void;
  mobile?: boolean;
}) {
  const { can } = usePermissions();

  return (
    <div
      className={cn(
        'sticky top-0 z-30 h-screen shrink-0',
        mobile ? 'block' : 'hidden lg:block',
        collapsed ? 'w-[88px]' : 'w-[272px]'
      )}
    >
    <aside
      className={cn(
        'relative flex h-full flex-col overflow-hidden bg-ink-900 text-white transition-all duration-300',
        collapsed ? 'w-[88px]' : 'w-[272px]'
      )}
    >
      <div className="flex items-center gap-3 px-4 py-5">
        <img src={logo} alt="Louisiana Hot Chicken" className="h-12 w-12 rounded-2xl object-cover ring-2 ring-white/10" />
        {!collapsed ? (
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-brand-yellow">Louisiana</p>
            <p className="text-sm font-bold">Hot Chicken</p>
          </div>
        ) : null}
      </div>

      <nav className="sidebar-scroll flex-1 space-y-5 overflow-y-auto px-3 pb-4">
        {NAV.map((group) => {
          const items = group.items.filter((item) => can(item.permission));
          if (!items.length) return null;
          return (
            <div key={group.label}>
              {!collapsed ? (
                <p className="mb-2 px-3 text-[11px] font-semibold uppercase tracking-[0.16em] text-white/35">
                  {group.label}
                </p>
              ) : null}
              <div className="space-y-1">
                {items.map((item) => (
                  <NavLink
                    key={item.to}
                    to={item.to}
                    end={item.to === '/'}
                    className={({ isActive }) =>
                      cn(
                        'flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium text-white/70 transition hover:bg-white/5 hover:text-white',
                        isActive && 'bg-brand-red text-white shadow-lg shadow-black/20'
                      )
                    }
                  >
                    <item.icon className="h-4 w-4 shrink-0" />
                    {!collapsed ? <span>{item.label}</span> : null}
                  </NavLink>
                ))}
              </div>
            </div>
          );
        })}
      </nav>
    </aside>

      {!mobile ? (
        <button
          type="button"
          onClick={onToggle}
          aria-label={collapsed ? 'Open sidebar' : 'Close sidebar'}
          title={collapsed ? 'Open sidebar' : 'Close sidebar'}
          className="absolute -right-3 top-[88px] z-40 flex h-8 w-8 items-center justify-center rounded-full border border-slate-200 bg-white text-ink-900 shadow-md transition hover:bg-brand-red hover:text-white"
        >
          {collapsed ? <ChevronRight className="h-4 w-4" /> : <ChevronLeft className="h-4 w-4" />}
        </button>
      ) : null}
    </div>
  );
}
