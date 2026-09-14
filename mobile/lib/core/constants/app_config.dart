import 'dart:io';

class AppConfig {
  const AppConfig._();

  static const appName = 'Louisiana Hot Chicken Admin';

  static String get apiBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) {
      return fromEnv.endsWith('/') ? fromEnv.substring(0, fromEnv.length - 1) : fromEnv;
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5050/api/v1';
    }
    return 'http://127.0.0.1:5050/api/v1';
  }

  static String get origin {
    final base = apiBaseUrl;
    const suffix = '/api/v1';
    if (base.endsWith(suffix)) {
      return base.substring(0, base.length - suffix.length);
    }
    return base;
  }

  static String resolveUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('/')) return '$origin$path';
    return '$origin/$path';
  }
}
