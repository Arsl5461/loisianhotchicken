import type { LucideIcon } from 'lucide-react';
import { ArrowDownRight, ArrowUpRight } from 'lucide-react';
import { cn, formatCurrency, formatNumber } from '../../utils/cn';

export function KpiCard({
  label,
  value,
  growth,
  icon: Icon,
  tone = 'red',
  money = true,
}: {
  label: string;
  value: number;
  growth: number;
  icon: LucideIcon;
  tone?: 'red' | 'orange' | 'green' | 'blue' | 'yellow';
  money?: boolean;
}) {
  const positive = growth >= 0;
  const tones = {
    red: 'bg-brand-red/10 text-brand-red',
    orange: 'bg-brand-orange/10 text-brand-orange',
    green: 'bg-emerald-50 text-emerald-600',
    blue: 'bg-blue-50 text-blue-600',
    yellow: 'bg-amber-50 text-amber-600',
  };

  return (
    <article className="card p-5">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-400">{label}</p>
          <p className="mt-2 text-2xl font-bold text-ink-900">{money ? formatCurrency(value) : formatNumber(value)}</p>
        </div>
        <span className={cn('flex h-11 w-11 items-center justify-center rounded-2xl', tones[tone])}>
          <Icon className="h-5 w-5" />
        </span>
      </div>
      <div className={cn('mt-4 inline-flex items-center gap-1 text-sm font-semibold', positive ? 'text-emerald-600' : 'text-rose-500')}>
        {positive ? <ArrowUpRight className="h-4 w-4" /> : <ArrowDownRight className="h-4 w-4" />}
        {Math.abs(growth)}%
        <span className="font-normal text-slate-400">vs previous period</span>
      </div>
    </article>
  );
}
