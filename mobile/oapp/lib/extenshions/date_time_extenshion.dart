import 'package:intl/intl.dart';

extension StringToDateTime on String {
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }
}

extension DateTimeFormatter on DateTime {
  String toFormattedDateTime() {
    return DateFormat('MM/dd/yy h:mm a').format(this);
  }
}
