import { Outlet } from 'react-router-dom';
import logo from '../assets/logos/louisiana-hot-chicken.jpg';

export function AuthLayout() {
  return (
    <div className="grid min-h-screen lg:grid-cols-2">
      <div className="relative hidden overflow-hidden bg-brand-red lg:block">
        <img src={logo} alt="Louisiana Hot Chicken" className="absolute inset-0 h-full w-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-black/10" />
        <div className="absolute bottom-10 left-10 right-10 text-white">
          <p className="text-sm font-semibold uppercase tracking-[0.24em] text-brand-yellow">Multi-store command center</p>
          <h1 className="mt-3 max-w-md text-4xl font-bold">Run every Louisiana Hot Chicken branch from one dashboard.</h1>
        </div>
      </div>
      <div className="flex items-center justify-center bg-[#F8F9FA] px-6 py-10">
        <div className="w-full max-w-md">
          <div className="mb-8 flex items-center gap-3 lg:hidden">
            <img src={logo} alt="Louisiana Hot Chicken" className="h-12 w-12 rounded-2xl object-cover" />
            <div>
              <p className="text-xs font-bold uppercase tracking-[0.2em] text-brand-red">Louisiana</p>
              <p className="font-semibold">Hot Chicken Admin</p>
            </div>
          </div>
          <Outlet />
        </div>
      </div>
    </div>
  );
}
