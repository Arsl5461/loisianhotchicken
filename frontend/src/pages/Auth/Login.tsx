import { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { Eye, EyeOff } from 'lucide-react';
import { toast } from 'sonner';
import {
  isLoginOtpChallenge,
  useLoginMutation,
  useResendLoginOtpMutation,
  useVerifyLoginOtpMutation,
} from '../../api/authApi';
import { startSession } from '../../features/auth/session';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

const otpSchema = z.object({
  code: z.string().regex(/^\d{6}$/, 'Enter the 6-digit code'),
});

export default function Login() {
  const [login, { isLoading }] = useLoginMutation();
  const [verifyOtp, { isLoading: verifying }] = useVerifyLoginOtpMutation();
  const [resendOtp, { isLoading: resending }] = useResendLoginOtpMutation();
  const [showPassword, setShowPassword] = useState(false);
  const [challenge, setChallenge] = useState<{ email: string; challengeId: string } | null>(null);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '' },
  });
  const otpForm = useForm<z.infer<typeof otpSchema>>({
    resolver: zodResolver(otpSchema),
    defaultValues: { code: '' },
  });

  useEffect(() => {
    void import('../Dashboard/Dashboard');
  }, []);

  return (
    <div className="card p-7">
      <p className="text-xs font-bold uppercase tracking-[0.2em] text-brand-red">Welcome back</p>
      <h2 className="mt-2 text-2xl font-bold">{challenge ? 'Enter sign-in code' : 'Sign in'}</h2>
      <p className="mt-1 text-sm text-slate-500">
        {challenge
          ? `A 6-digit code was sent to ${challenge.email}.`
          : 'Use your organization credentials to manage stores, sales, and P&L.'}
      </p>
      {challenge ? (
        <form
          className="mt-6 space-y-4"
          autoComplete="off"
          onSubmit={otpForm.handleSubmit(async (values) => {
            try {
              const result = await verifyOtp({
                email: challenge.email,
                challengeId: challenge.challengeId,
                code: values.code,
              }).unwrap();
              startSession(dispatch, result.data.user, result.data.accessToken);
              toast.success('Signed in successfully');
              navigate('/');
            } catch (error: any) {
              toast.error(error?.data?.message || 'Invalid or expired code');
            }
          })}
        >
          <div>
            <label className="mb-1.5 block text-sm font-medium" htmlFor="login-otp">
              6-digit code
            </label>
            <input
              id="login-otp"
              className="soft-input tracking-[0.4em] text-center text-lg"
              inputMode="numeric"
              autoComplete="one-time-code"
              maxLength={6}
              placeholder="000000"
              {...otpForm.register('code')}
            />
            {otpForm.formState.errors.code ? (
              <p className="mt-1 text-xs text-brand-red">{otpForm.formState.errors.code.message}</p>
            ) : null}
          </div>
          <button className="btn-primary w-full" disabled={verifying} type="submit">
            {verifying ? 'Verifying...' : 'Verify code'}
          </button>
          <div className="flex items-center justify-between gap-3 text-sm">
            <button
              type="button"
              className="text-slate-500 hover:text-ink-900"
              onClick={() => {
                setChallenge(null);
                otpForm.reset();
              }}
            >
              Use a different account
            </button>
            <button
              type="button"
              className="font-medium text-brand-red hover:underline disabled:opacity-60"
              disabled={resending}
              onClick={async () => {
                try {
                  const result = await resendOtp({
                    email: challenge.email,
                    challengeId: challenge.challengeId,
                  }).unwrap();
                  setChallenge({
                    email: result.data.email,
                    challengeId: result.data.challengeId,
                  });
                  otpForm.reset();
                  toast.success('A new code was sent');
                } catch (error: any) {
                  toast.error(error?.data?.message || 'Unable to resend code');
                }
              }}
            >
              {resending ? 'Sending...' : 'Resend code'}
            </button>
          </div>
        </form>
      ) : (
        <form
          className="mt-6 space-y-4"
          autoComplete="off"
          onSubmit={form.handleSubmit(async (values) => {
            try {
              const result = await login(values).unwrap();
              if (isLoginOtpChallenge(result.data)) {
                setChallenge({
                  email: result.data.email,
                  challengeId: result.data.challengeId,
                });
                otpForm.reset();
                toast.success(result.message || 'A 6-digit code was sent to your email');
                return;
              }
              startSession(dispatch, result.data.user, result.data.accessToken);
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
      )}
    </div>
  );
}
