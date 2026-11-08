import 'dart:developer' as developer;

class AppLogger {
  static void info(String message, {String tag = 'INFO'}) {
    developer.log('[$tag] $message');
  }

  static void warning(String message, {String tag = 'WARNING'}) {
    developer.log('[$tag] $message', level: 900); // 900 = WARNING
  }

  static void error(String message, {String tag = 'ERROR'}) {
    developer.log('[$tag] $message', level: 1000); // 1000 = ERROR
  }

  static void debug(String message, {String tag = 'DEBUG'}) {
    developer.log('[$tag] $message');
  }
}
