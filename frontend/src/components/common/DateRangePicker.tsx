export function DateRangePicker({
  startDate,
  endDate,
  onChange,
}: {
  startDate?: string;
  endDate?: string;
  onChange: (next: { startDate?: string; endDate?: string }) => void;
}) {
  return (
    <div className="flex flex-wrap gap-2">
      <input
        className="soft-input"
        type="date"
        value={startDate || ''}
        onChange={(event) => onChange({ startDate: event.target.value, endDate })}
      />
      <input
        className="soft-input"
        type="date"
        value={endDate || ''}
        onChange={(event) => onChange({ startDate, endDate: event.target.value })}
      />
    </div>
  );
}
