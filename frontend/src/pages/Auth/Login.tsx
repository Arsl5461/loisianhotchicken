import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { Eye, EyeOff } from 'lucide-react';
import { toast } from 'sonner';
import { useLoginMutation } from '../../api/authApi';
import { setCredentials } from '../../features/auth/authSlice';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

export default function Login() {
  const [login, { isLoading }] = useLoginMutation();
  const [showPassword, setShowPassword] = useState(false);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '' },
  });

  return (
    <div className="card p-7">
      <p className="text-xs font-bold uppercase tracking-[0.2em] text-brand-red">Welcome back</p>
      <h2 className="mt-2 text-2xl font-bold">Sign in to Admin</h2>
      <p className="mt-1 text-sm text-slate-500">Use your organization credentials to manage stores, sales, and P&L.</p>
      <form
        className="mt-6 space-y-4"
        autoComplete="off"
        onSubmit={form.handleSubmit(async (values) => {
          try {
            const result = await login(values).unwrap();
            dispatch(setCredentials(result.data));
            toast.success('Signed in successfully');
            navigate('/');
          } catch (error: any) {
            toast.error(error?.data?.message || 'Unable to sign in');
          }
        })}
      >
        <div>
          <label className="mb-1.5 block text-sm font-medium" htmlFor="login-email">
            Email
          </label>
          <input
            id="login-email"
            className="soft-input"
            type="email"
            autoComplete="off"
            autoCapitalize="none"
            autoCorrect="off"
            spellCheck={false}
            placeholder="Enter your email"
            {...form.register('email')}
          />
        </div>
        <div>
          <label className="mb-1.5 block text-sm font-medium" htmlFor="login-password">
            Password
          </label>
          <div className="flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-2.5 focus-within:border-brand-red/40 focus-within:ring-4 focus-within:ring-brand-red/10">
            <input
              id="login-password"
              className="w-full bg-transparent text-sm text-slate-800 outline-none"
              type={showPassword ? 'text' : 'password'}
              autoComplete="new-password"
              placeholder="Enter your password"
              {...form.register('password')}
            />
            <button
              type="button"
              className="shrink-0 text-slate-400 transition hover:text-ink-900"
              onClick={() => setShowPassword((value) => !value)}
              aria-label={showPassword ? 'Hide password' : 'Show password'}
              title={showPassword ? 'Hide password' : 'Show password'}
            >
              {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
            </button>
          </div>
        </div>
        <button className="btn-primary w-full" disabled={isLoading} type="submit">
          {isLoading ? 'Signing in...' : 'Continue'}
        </button>
      </form>
    </div>
  );
}
