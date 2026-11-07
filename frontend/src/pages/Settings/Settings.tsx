import { useEffect, useState } from 'react';
import { useForm, type UseFormRegisterReturn } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Building2, Eye, EyeOff, Mail, MapPin, Phone, ShieldCheck } from 'lucide-react';
import { toast } from 'sonner';
import { PageHeader } from '../../components/common/PageHeader';
import { BusyOverlay, InlineSpinner, LoadingSpinner } from '../../components/common/LoadingSpinner';
import { useChangePasswordMutation } from '../../api/authApi';
import { useGetOrganizationQuery, useUpdateOrganizationMutation } from '../../api/usersApi';
import { usePermissions } from '../../hooks/usePermissions';
import { PERMISSIONS } from '../../constants/permissions';
import logo from '../../assets/logos/louisiana-hot-chicken.jpg';

const passwordSchema = z
  .object({
    currentPassword: z.string().min(6, 'Enter your current password'),
    newPassword: z.string().min(8, 'New password must be at least 8 characters'),
    confirmPassword: z.string().min(8, 'Confirm your new password'),
  })
  .refine((values) => values.newPassword === values.confirmPassword, {
    path: ['confirmPassword'],
    message: 'Passwords do not match',
  });

function PasswordField({
  label,
  autoComplete,
  className,
  error,
  registration,
}: {
  label: string;
  autoComplete: string;
  className?: string;
  error?: string;
  registration: UseFormRegisterReturn;
}) {
  const [visible, setVisible] = useState(false);

  return (
    <label className={`text-sm font-medium text-slate-700 ${className || ''}`}>
      {label}
      <div className="mt-1.5 flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-2.5 focus-within:border-brand-red/40 focus-within:ring-4 focus-within:ring-brand-red/10">
        <input
          className="w-full bg-transparent text-sm text-slate-800 outline-none"
          type={visible ? 'text' : 'password'}
          autoComplete={autoComplete}
          {...registration}
        />
        <button
          type="button"
          className="shrink-0 text-slate-400 transition hover:text-ink-900"
          onClick={() => setVisible((value) => !value)}
          aria-label={visible ? 'Hide password' : 'Show password'}
          title={visible ? 'Hide password' : 'Show password'}
        >
          {visible ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
        </button>
      </div>
      {error ? <p className="mt-1 text-xs text-brand-red">{error}</p> : null}
    </label>
  );
}

const FIELDS = [
  { name: 'name' as const, label: 'Organization name', placeholder: 'Louisiana Hot Chicken', icon: Building2 },
  { name: 'email' as const, label: 'Headquarters email', placeholder: 'hq@louisianahotchicken.com', icon: Mail, type: 'email' },
  { name: 'phone' as const, label: 'Phone', placeholder: '225-555-0100', icon: Phone },
  { name: 'address' as const, label: 'Address', placeholder: 'Louisiana, United States', icon: MapPin },
];

export default function Settings() {
  const { can, isSuperAdmin } = usePermissions();
  const canEdit = can(PERMISSIONS.SETTINGS_UPDATE);
  const { data, isLoading } = useGetOrganizationQuery();
  const [updateOrganization, { isLoading: saving }] = useUpdateOrganizationMutation();
  const [changePassword, { isLoading: changingPassword }] = useChangePasswordMutation();
  const form = useForm({ defaultValues: { name: '', email: '', phone: '', address: '' } });
  const passwordForm = useForm<z.infer<typeof passwordSchema>>({
    resolver: zodResolver(passwordSchema),
    defaultValues: { currentPassword: '', newPassword: '', confirmPassword: '' },
  });
  const organization = data?.data;

  useEffect(() => {
    if (organization) {
      form.reset({
        name: organization.name || '',
        email: organization.email || '',
        phone: organization.phone || '',
        address: organization.address || '',
      });
    }
  }, [organization, form]);

  return (
    <div className="max-w-5xl">
      <PageHeader title="Settings" subtitle="Update the organization profile used across the platform." />

      {isLoading ? (
        <LoadingSpinner />
      ) : (
        <form
          className="space-y-5"
          onSubmit={form.handleSubmit(async (values) => {
            try {
              await updateOrganization(values).unwrap();
              toast.success('Settings saved');
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to save settings');
            }
          })}
        >
          <div className="card overflow-hidden">
            <div className="flex flex-col gap-5 p-6 md:flex-row md:items-center md:justify-between">
              <div className="flex items-center gap-4">
                <img
                  src={organization?.logo || logo}
                  alt={organization?.name || 'Organization logo'}
                  className="h-16 w-16 rounded-2xl object-cover ring-1 ring-slate-200"
                />
                <div>
                  <p className="text-lg font-semibold text-ink-900">{organization?.name || 'Organization'}</p>
                  <p className="text-sm text-slate-500">{organization?.email || 'No email on file'}</p>
                  <div className="mt-2 flex flex-wrap gap-2">
                    {organization?.slug ? (
                      <span className="rounded-full bg-slate-100 px-2.5 py-1 text-xs font-semibold text-slate-600">
                        {organization.slug}
                      </span>
                    ) : null}
                    <span
                      className={`inline-flex items-center gap-1 rounded-full px-2.5 py-1 text-xs font-semibold ${
                        organization?.isActive !== false ? 'bg-emerald-50 text-emerald-700' : 'bg-slate-100 text-slate-500'
                      }`}
                    >
                      <ShieldCheck className="h-3.5 w-3.5" />
                      {organization?.isActive !== false ? 'Active organization' : 'Inactive'}
                    </span>
                  </div>
                </div>
              </div>
              <p className="max-w-sm text-sm text-slate-500">
                This profile appears on exports, reports, and team communications.
              </p>
            </div>
          </div>

          <div className="card p-6">
            <div className="mb-5">
              <h2 className="text-base font-semibold text-ink-900">Organization profile</h2>
              <p className="mt-1 text-sm text-slate-500">Official name and contact details for headquarters.</p>
            </div>
            <div className="grid gap-4 md:grid-cols-2">
              {FIELDS.map((field) => (
                <label key={field.name} className={`text-sm font-medium text-slate-700 ${field.name === 'address' ? 'md:col-span-2' : ''}`}>
                  {field.label}
                  <div className="mt-1.5 flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-2.5 focus-within:border-brand-red/40 focus-within:ring-4 focus-within:ring-brand-red/10">
                    <field.icon className="h-4 w-4 shrink-0 text-slate-400" />
                    <input
                      className="w-full bg-transparent text-sm text-slate-800 outline-none disabled:cursor-not-allowed disabled:opacity-70"
                      type={field.type || 'text'}
                      placeholder={field.placeholder}
                      disabled={!canEdit}
                      {...form.register(field.name)}
                    />
                  </div>
                </label>
              ))}
            </div>
            {canEdit ? (
              <div className="mt-6 flex justify-end gap-2">
                <button
                  className="btn-secondary"
                  type="button"
                  onClick={() =>
                    form.reset({
                      name: organization?.name || '',
                      email: organization?.email || '',
                      phone: organization?.phone || '',
                      address: organization?.address || '',
                    })
                  }
                >
                  Reset
                </button>
                <button className="btn-primary" type="submit" disabled={saving}>
                  {saving ? (
                    <>
                      <InlineSpinner className="border-white/30 border-t-white" />
                      Saving...
                    </>
                  ) : (
                    'Save settings'
                  )}
                </button>
              </div>
            ) : (
              <p className="mt-6 text-sm text-slate-500">You have view-only access to organization settings.</p>
            )}
          </div>
        </form>
      )}
      {isSuperAdmin ? (
        <form
          className="mt-5"
          onSubmit={passwordForm.handleSubmit(async (values) => {
            try {
              await changePassword({
                currentPassword: values.currentPassword,
                newPassword: values.newPassword,
              }).unwrap();
              passwordForm.reset();
              toast.success('Password updated');
            } catch (error: any) {
              toast.error(error?.data?.message || 'Unable to update password');
            }
          })}
        >
          <div className="card p-6">
            <div className="mb-5">
              <h2 className="text-base font-semibold text-ink-900">Change password</h2>
              <p className="mt-1 text-sm text-slate-500">
                Update the Super Admin password. The next sign-in will still require a 6-digit email code.
              </p>
            </div>
            <div className="grid gap-4 md:grid-cols-2">
              <PasswordField
                label="Current password"
                autoComplete="current-password"
                className="md:col-span-2"
                registration={passwordForm.register('currentPassword')}
                error={passwordForm.formState.errors.currentPassword?.message}
              />
              <PasswordField
                label="New password"
                autoComplete="new-password"
                registration={passwordForm.register('newPassword')}
                error={passwordForm.formState.errors.newPassword?.message}
              />
              <PasswordField
                label="Confirm new password"
                autoComplete="new-password"
                registration={passwordForm.register('confirmPassword')}
                error={passwordForm.formState.errors.confirmPassword?.message}
              />
            </div>
            <div className="mt-6 flex justify-end">
              <button className="btn-primary" type="submit" disabled={changingPassword}>
                {changingPassword ? (
                  <>
                    <InlineSpinner className="border-white/30 border-t-white" />
                    Updating...
                  </>
                ) : (
                  'Update password'
                )}
              </button>
            </div>
          </div>
        </form>
      ) : null}
      <BusyOverlay show={saving || changingPassword} label={changingPassword ? 'Updating password...' : 'Saving settings...'} />
    </div>
  );
}
