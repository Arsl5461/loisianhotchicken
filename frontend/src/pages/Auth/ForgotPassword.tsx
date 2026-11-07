import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { Link, useNavigate } from 'react-router-dom';
import { Eye, EyeOff } from 'lucide-react';
import { toast } from 'sonner';
import { useForgotPasswordMutation, useResetPasswordMutation } from '../../api/authApi';

const emailSchema = z.object({
  email: z.string().email(),
});

const resetSchema = z
  .object({
    code: z.string().regex(/^\d{6}$/, 'Enter the 6-digit code'),
    newPassword: z.string().min(8, 'New password must be at least 8 characters'),
    confirmPassword: z.string().min(8, 'Confirm your new password'),
  })
  .refine((values) => values.newPassword === values.confirmPassword, {
    path: ['confirmPassword'],
    message: 'Passwords do not match',
  });

function PasswordInput({
  id,
  registration,
  placeholder,
}: {
  id: string;
  registration: ReturnType<ReturnType<typeof useForm>['register']>;
  placeholder: string;
}) {
  const [visible, setVisible] = useState(false);
  return (
    <div className="flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-2.5 focus-within:border-brand-red/40 focus-within:ring-4 focus-within:ring-brand-red/10">
      <input
        id={id}
        className="w-full bg-transparent text-sm text-slate-800 outline-none"
        type={visible ? 'text' : 'password'}
        autoComplete="new-password"
        placeholder={placeholder}
        {...registration}
      />
      <button
        type="button"
        className="shrink-0 text-slate-400 transition hover:text-ink-900"
        onClick={() => setVisible((value) => !value)}
        aria-label={visible ? 'Hide password' : 'Show password'}
      >
        {visible ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
      </button>
    </div>
  );
}

export default function ForgotPassword() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [sent, setSent] = useState(false);
  const [forgotPassword, { isLoading: sending }] = useForgotPasswordMutation();
  const [resetPassword, { isLoading: resetting }] = useResetPasswordMutation();
  const emailForm = useForm<z.infer<typeof emailSchema>>({
    resolver: zodResolver(emailSchema),
    defaultValues: { email: '' },
  });
  const resetForm = useForm<z.infer<typeof resetSchema>>({
    resolver: zodResolver(resetSchema),
    defaultValues: { code: '', newPassword: '', confirmPassword: '' },
  });

  return (
    <div className="card p-7">
      <p className="text-xs font-bold uppercase tracking-[0.2em] text-brand-red">Account recovery</p>
      <h2 className="mt-2 text-2xl font-bold">{sent ? 'Enter reset code' : 'Forgot password'}</h2>
      <p className="mt-1 text-sm text-slate-500">
        {sent
          ? `A 6-digit code was sent to ${email}. Enter it below with your new password.`
          : 'Enter your email and we will send a 6-digit code to reset your password.'}
      </p>

      {sent ? (
        <form
          className="mt-6 space-y-4"
          onSubmit={resetForm.handleSubmit(async (values) => {
            try {
              await resetPassword({
                email,
                code: values.code,
                newPassword: values.newPassword,
              }).unwrap();
              toast.success('Password reset. Sign in with your new password.');
              navigate('/login');
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to reset password');
            }
          })}
        >
          <div>
            <label className="mb-1.5 block text-sm font-medium" htmlFor="reset-code">
              6-digit code
            </label>
            <input
              id="reset-code"
              className="soft-input tracking-[0.4em] text-center text-lg"
              inputMode="numeric"
              autoComplete="one-time-code"
              maxLength={6}
              placeholder="000000"
              {...resetForm.register('code')}
            />
            {resetForm.formState.errors.code ? (
              <p className="mt-1 text-xs text-brand-red">{resetForm.formState.errors.code.message}</p>
            ) : null}
          </div>
          <div>
            <label className="mb-1.5 block text-sm font-medium" htmlFor="reset-password">
              New password
            </label>
            <PasswordInput
              id="reset-password"
              placeholder="At least 8 characters"
              registration={resetForm.register('newPassword')}
            />
            {resetForm.formState.errors.newPassword ? (
              <p className="mt-1 text-xs text-brand-red">{resetForm.formState.errors.newPassword.message}</p>
            ) : null}
          </div>
          <div>
            <label className="mb-1.5 block text-sm font-medium" htmlFor="reset-confirm">
              Confirm new password
            </label>
            <PasswordInput
              id="reset-confirm"
              placeholder="Re-enter new password"
              registration={resetForm.register('confirmPassword')}
            />
            {resetForm.formState.errors.confirmPassword ? (
              <p className="mt-1 text-xs text-brand-red">{resetForm.formState.errors.confirmPassword.message}</p>
            ) : null}
          </div>
          <button className="btn-primary w-full" disabled={resetting} type="submit">
            {resetting ? 'Updating...' : 'Reset password'}
          </button>
          <div className="flex items-center justify-between gap-3 text-sm">
            <button
              type="button"
              className="text-slate-500 hover:text-ink-900"
              onClick={() => {
                setSent(false);
                resetForm.reset();
              }}
            >
              Use a different email
            </button>
            <button
              type="button"
              className="font-medium text-brand-red hover:underline disabled:opacity-60"
              disabled={sending}
              onClick={async () => {
                try {
                  await forgotPassword({ email }).unwrap();
                  toast.success('A new code was sent');
                } catch (error: any) {
                  toast.error(error?.data?.message || 'Unable to resend code');
                }
              }}
            >
              {sending ? 'Sending...' : 'Resend code'}
            </button>
          </div>
        </form>
      ) : (
        <form
          className="mt-6 space-y-4"
          onSubmit={emailForm.handleSubmit(async (values) => {
            try {
              await forgotPassword(values).unwrap();
              setEmail(values.email);
              setSent(true);
              resetForm.reset();
              toast.success('If that email is on file, a reset code was sent.');
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to send reset code');
            }
          })}
        >
          <div>
            <label className="mb-1.5 block text-sm font-medium" htmlFor="forgot-email">
              Email
            </label>
            <input
              id="forgot-email"
              className="soft-input"
              type="email"
              autoComplete="email"
              placeholder="Enter your email"
              {...emailForm.register('email')}
            />
          </div>
          <button className="btn-primary w-full" disabled={sending} type="submit">
            {sending ? 'Sending...' : 'Send reset code'}
          </button>
          <Link className="block text-center text-sm font-medium text-slate-500 hover:text-ink-900" to="/login">
            Back to sign in
          </Link>
        </form>
      )}
    </div>
  );
}
