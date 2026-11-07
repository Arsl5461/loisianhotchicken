const { DATE_RANGES, GROUP_BY } = require('../constants/enums');
const env = require('../config/environment');

const APP_TIMEZONE = env.appTimezone || 'America/Chicago';

function pad(value) {
  return String(value).padStart(2, '0');
}

function getZonedParts(date, timeZone = APP_TIMEZONE) {
  const formatter = new Intl.DateTimeFormat('en-US', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hourCycle: 'h23',
  });
  const parts = Object.fromEntries(formatter.formatToParts(date).map((part) => [part.type, part.value]));
  return {
    year: Number(parts.year),
    month: Number(parts.month),
    day: Number(parts.day),
    hour: Number(parts.hour),
    minute: Number(parts.minute),
    second: Number(parts.second),
  };
}

function formatYmd(date, timeZone = APP_TIMEZONE) {
  const parts = getZonedParts(new Date(date), timeZone);
  return `${parts.year}-${pad(parts.month)}-${pad(parts.day)}`;
}

function zonedTimeToUtc({ year, month, day, hour = 0, minute = 0, second = 0, ms = 0 }, timeZone = APP_TIMEZONE) {
  let utc = Date.UTC(year, month - 1, day, hour, minute, second, ms);
  for (let index = 0; index < 3; index += 1) {
    const parts = getZonedParts(new Date(utc), timeZone);
    const shown = Date.UTC(parts.year, parts.month - 1, parts.day, parts.hour, parts.minute, parts.second);
    const intended = Date.UTC(year, month - 1, day, hour, minute, second);
    utc += intended - shown;
  }
  return new Date(utc);
}

function parseYmd(value) {
  if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value)) {
    const [year, month, day] = value.split('-').map(Number);
    return { year, month, day };
  }
  const parts = getZonedParts(new Date(value), APP_TIMEZONE);
  return { year: parts.year, month: parts.month, day: parts.day };
}

function startOfDay(date) {
  const { year, month, day } = parseYmd(date);
  return zonedTimeToUtc({ year, month, day, hour: 0, minute: 0, second: 0, ms: 0 });
}

function endOfDay(date) {
  const { year, month, day } = parseYmd(date);
  return zonedTimeToUtc({ year, month, day, hour: 23, minute: 59, second: 59, ms: 999 });
}

function addCalendarDays(ymd, days) {
  const [year, month, day] = ymd.split('-').map(Number);
  const shifted = new Date(Date.UTC(year, month - 1, day + days));
  return `${shifted.getUTCFullYear()}-${pad(shifted.getUTCMonth() + 1)}-${pad(shifted.getUTCDate())}`;
}

function addCalendarMonths(ymd, months) {
  const [year, month, day] = ymd.split('-').map(Number);
  const shifted = new Date(Date.UTC(year, month - 1 + months, day));
  return `${shifted.getUTCFullYear()}-${pad(shifted.getUTCMonth() + 1)}-${pad(shifted.getUTCDate())}`;
}

function monthBounds(month) {
  const nowParts = getZonedParts(new Date(), APP_TIMEZONE);
  const value =
    typeof month === 'string' && /^\d{4}-\d{2}$/.test(month)
      ? month
      : `${nowParts.year}-${pad(nowParts.month)}`;
  const [year, monthIndex] = value.split('-').map(Number);
  const start = startOfDay(`${year}-${pad(monthIndex)}-01`);
  const lastDay = new Date(Date.UTC(year, monthIndex, 0)).getUTCDate();
  const end = endOfDay(`${year}-${pad(monthIndex)}-${pad(lastDay)}`);
  return { month: value, start, end };
}

function resolveDateRange({ range, startDate, endDate }) {
  const now = new Date();
  const end = endDate ? endOfDay(endDate) : endOfDay(now);
  const endYmd = formatYmd(end);
  let start;

  switch (range) {
    case DATE_RANGES.LAST_7_DAYS:
      start = startOfDay(addCalendarDays(endYmd, -6));
      break;
    case DATE_RANGES.LAST_3_MONTHS:
      start = startOfDay(addCalendarMonths(endYmd, -3));
      break;
    case DATE_RANGES.LAST_6_MONTHS:
      start = startOfDay(addCalendarMonths(endYmd, -6));
      break;
    case DATE_RANGES.THIS_YEAR:
      start = startOfDay(`${getZonedParts(end).year}-01-01`);
      break;
    case DATE_RANGES.CUSTOM:
      start = startDate ? startOfDay(startDate) : startOfDay(addCalendarDays(endYmd, -29));
      break;
    case DATE_RANGES.LAST_30_DAYS:
    default:
      start = startDate ? startOfDay(startDate) : startOfDay(addCalendarDays(endYmd, -29));
      break;
  }

  if (startDate && endDate && range === DATE_RANGES.CUSTOM) {
    return { start: startOfDay(startDate), end: endOfDay(endDate) };
  }

  return { start, end };
}

function previousPeriod({ start, end }) {
  const duration = end.getTime() - start.getTime();
  const prevEnd = new Date(start.getTime() - 1);
  const prevStart = new Date(prevEnd.getTime() - duration);
  return { start: prevStart, end: prevEnd };
}

function growthPercentage(current, previous) {
  if (previous === 0) {
    return current > 0 ? 100 : 0;
  }
  return Number((((current - previous) / previous) * 100).toFixed(1));
}

function resolveGroupBy(groupBy) {
  const allowed = Object.values(GROUP_BY);
  return allowed.includes(groupBy) ? groupBy : GROUP_BY.DAY;
}

function dateTruncUnit(groupBy) {
  const resolved = resolveGroupBy(groupBy);
  if (resolved === GROUP_BY.QUARTER) {
    return 'month';
  }
  return resolved;
}

function isStartOfAppDay(date) {
  const parts = getZonedParts(new Date(date));
  return parts.hour === 0 && parts.minute === 0 && parts.second === 0;
}

function inferIntendedYmd(date) {
  const value = new Date(date);
  if (Number.isNaN(value.getTime())) return null;
  if (isStartOfAppDay(value)) {
    return formatYmd(value);
  }
  if (value.getUTCHours() === 0 && value.getUTCMinutes() === 0 && value.getUTCSeconds() === 0) {
    return value.toISOString().slice(0, 10);
  }
  const legacyZone = env.legacyDateTimezone || Intl.DateTimeFormat().resolvedOptions().timeZone || APP_TIMEZONE;
  return formatYmd(value, legacyZone);
}

function toAppBusinessDate(date) {
  const ymd = inferIntendedYmd(date);
  return ymd ? startOfDay(ymd) : date;
}

module.exports = {
  APP_TIMEZONE,
  formatYmd,
  startOfDay,
  endOfDay,
  monthBounds,
  resolveDateRange,
  previousPeriod,
  growthPercentage,
  resolveGroupBy,
  dateTruncUnit,
  inferIntendedYmd,
  toAppBusinessDate,
};
