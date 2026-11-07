/// App business timezone helpers (matches web `America/Chicago`).
class AppTimezone {
  const AppTimezone._();

  static const name = 'America/Chicago';

  /// Second Sunday in March → first Sunday in November (US Central DST).
  static bool _isCentralDaylight(DateTime utc) {
    final year = utc.year;
    final dstStart = _nthWeekdayOfMonth(year, 3, DateTime.sunday, 2).add(const Duration(hours: 7));
    final dstEnd = _nthWeekdayOfMonth(year, 11, DateTime.sunday, 1).add(const Duration(hours: 6));
    return !utc.isBefore(dstStart) && utc.isBefore(dstEnd);
  }

  static DateTime _nthWeekdayOfMonth(int year, int month, int weekday, int nth) {
    var date = DateTime.utc(year, month, 1);
    while (date.weekday != weekday) {
      date = date.add(const Duration(days: 1));
    }
    return date.add(Duration(days: (nth - 1) * 7));
  }

  static DateTime now() {
    final utc = DateTime.now().toUtc();
    final offsetHours = _isCentralDaylight(utc) ? 5 : 6;
    return utc.subtract(Duration(hours: offsetHours));
  }

  static String todayYmd() => toYmd(now());

  static String currentMonth() => todayYmd().substring(0, 7);

  static String toYmd(DateTime value) {
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String toDateInputValue(DateTime? value) {
    if (value == null) return todayYmd();
    return toYmd(value);
  }
}
