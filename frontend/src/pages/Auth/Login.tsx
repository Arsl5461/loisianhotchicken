import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { toast } from 'sonner';
import { useLoginMutation } from '../../api/authApi';
import { setCredentials } from '../../features/auth/authSlice';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

export default function Login() {
  const [login, { isLoading }] = useLoginMutation();
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: { email: 'admin@louisianahotchicken.com', password: 'ChangeMeNow!123' },
  });

  return (
    <div className="card p-7">
      <p className="text-xs font-bold uppercase tracking-[0.2em] text-brand-red">Welcome back</p>
      <h2 className="mt-2 text-2xl font-bold">Sign in to Admin</h2>
      <p className="mt-1 text-sm text-slate-500">Use your organization credentials to manage stores, sales, and P&L.</p>
      <form
        className="mt-6 space-y-4"
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
          <label className="mb-1.5 block text-sm font-medium">Email</label>
          <input className="soft-input" type="email" {...form.register('email')} />
        </div>
        <div>
          <label className="mb-1.5 block text-sm font-medium">Password</label>
          <input className="soft-input" type="password" {...form.register('password')} />
        </div>
        <button className="btn-primary w-full" disabled={isLoading} type="submit">
          {isLoading ? 'Signing in...' : 'Continue'}
        </button>
      </form>
    </div>
  );
}
