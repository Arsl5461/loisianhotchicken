export const APP_TIMEZONE = 'America/Chicago';

export const APP_DATE_FORMAT: Intl.DateTimeFormatOptions = {
  timeZone: APP_TIMEZONE,
  month: 'short',
  day: 'numeric',
  year: 'numeric',
};

function readPart(parts: Intl.DateTimeFormatPart[], type: string) {
  return parts.find((part) => part.type === type)?.value || '';
}

export function todayInAppTimezone() {
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: APP_TIMEZONE,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(new Date());
  return `${readPart(parts, 'year')}-${readPart(parts, 'month')}-${readPart(parts, 'day')}`;
}

export function currentMonthInAppTimezone() {
  return todayInAppTimezone().slice(0, 7);
}
