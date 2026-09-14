import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
final _compact = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 1);
final _day = DateFormat('MMM d, yyyy');
final _short = DateFormat('MMM d');
final _isoDate = DateFormat('yyyy-MM-dd');

String money(num value) => _currency.format(value);
String compactMoney(num value) => _compact.format(value);

String formatDate(DateTime? value) {
  if (value == null) return '—';
  return _day.format(value.toLocal());
}

String formatShortDate(DateTime? value) {
  if (value == null) return '—';
  return _short.format(value.toLocal());
}

String toIsoDate(DateTime value) => _isoDate.format(value);

String percent(num value) => '${value.toStringAsFixed(1)}%';

String growthLabel(num value) {
  final prefix = value >= 0 ? '+' : '';
  return '$prefix${value.toStringAsFixed(1)}%';
}
