import { lazy, Suspense, useEffect } from 'react';
import { Navigate, Route, Routes } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { AuthLayout } from '../layouts/AuthLayout';
import { AdminLayout } from '../layouts/AdminLayout';
import { ProtectedRoute } from './ProtectedRoute';
import { LoadingSpinner } from '../components/common/LoadingSpinner';
import { useMeQuery } from '../api/authApi';
import { setCredentials, setInitialized } from '../features/auth/authSlice';
import type { RootState } from '../app/store';

const Login = lazy(() => import('../pages/Auth/Login'));
const Dashboard = lazy(() => import('../pages/Dashboard/Dashboard'));
const StoresList = lazy(() => import('../pages/Stores/StoresList'));
const AddStore = lazy(() => import('../pages/Stores/AddStore'));
const EditStore = lazy(() => import('../pages/Stores/EditStore'));
const StoreDetails = lazy(() => import('../pages/Stores/StoreDetails'));
const Sales = lazy(() => import('../pages/Sales/Sales'));
const Expenses = lazy(() => import('../pages/Expenses/Expenses'));
const ProfitLoss = lazy(() => import('../pages/ProfitLoss/ProfitLoss'));
const Products = lazy(() => import('../pages/Products/Products'));
const Orders = lazy(() => import('../pages/Orders/Orders'));
const Users = lazy(() => import('../pages/Users/Users'));
const Roles = lazy(() => import('../pages/Roles/Roles'));
const Reports = lazy(() => import('../pages/Reports/Reports'));
const Settings = lazy(() => import('../pages/Settings/Settings'));

export function AppRoutes() {
  const dispatch = useDispatch();
  const token = useSelector((state: RootState) => state.auth.accessToken);
  const { data, isError } = useMeQuery(undefined, { skip: !token });

  useEffect(() => {
    if (data?.data && token) {
      dispatch(setCredentials({ user: data.data, accessToken: token }));
    } else if (isError || !token) {
      dispatch(setInitialized());
    }
  }, [data, token, isError, dispatch]);

  return (
    <Suspense fallback={<LoadingSpinner />}>
      <Routes>
        <Route element={<AuthLayout />}>
          <Route path="/login" element={<Login />} />
        </Route>
        <Route element={<ProtectedRoute />}>
          <Route element={<AdminLayout />}>
            <Route path="/" element={<Dashboard />} />
            <Route path="/stores" element={<StoresList />} />
            <Route path="/stores/new" element={<AddStore />} />
            <Route path="/stores/:id" element={<StoreDetails />} />
            <Route path="/stores/:id/edit" element={<EditStore />} />
            <Route path="/sales" element={<Sales />} />
            <Route path="/expenses" element={<Expenses />} />
            <Route path="/profit-loss" element={<ProfitLoss />} />
            <Route path="/products" element={<Products />} />
            <Route path="/orders" element={<Orders />} />
            <Route path="/users" element={<Users />} />
            <Route path="/roles" element={<Roles />} />
            <Route path="/reports" element={<Reports />} />
            <Route path="/settings" element={<Settings />} />
          </Route>
        </Route>
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Suspense>
  );
}
