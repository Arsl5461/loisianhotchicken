export function InlineSpinner({ className = 'border-slate-200 border-t-brand-red' }: { className?: string }) {
  return <span className={`inline-block h-4 w-4 animate-spin rounded-full border-2 ${className}`} />;
}

export function BusyOverlay({ show, label = 'Please wait...' }: { show: boolean; label?: string }) {
  if (!show) return null;
  return (
    <div className="fixed inset-0 z-[70] flex items-center justify-center bg-ink-900/35 backdrop-blur-[1px]">
      <div className="flex items-center gap-3 rounded-2xl bg-white px-5 py-4 shadow-xl">
        <span className="h-6 w-6 animate-spin rounded-full border-2 border-slate-200 border-t-brand-red" />
        <p className="text-sm font-semibold text-ink-900">{label}</p>
      </div>
    </div>
  );
}

export function LoadingSpinner() {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="h-10 w-10 animate-spin rounded-full border-2 border-slate-200 border-t-brand-red" />
    </div>
  );
}

export function SkeletonGrid({ count = 4 }: { count?: number }) {
  return (
    <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-5">
      {Array.from({ length: count }).map((_, index) => (
        <div key={index} className="card h-32 animate-pulse bg-slate-100" />
      ))}
    </div>
  );
}

export function ErrorState({ message }: { message?: string }) {
  return (
    <div className="rounded-2xl border border-red-100 bg-red-50 px-4 py-6 text-sm text-red-700">
      {message || 'Something went wrong while loading this view.'}
    </div>
  );
}
