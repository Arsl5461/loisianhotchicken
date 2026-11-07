import 'dart:io';

enum ApiEnvironment { local, live }

class AppConfig {
  const AppConfig._();

  static const appName = 'Louisiana Hot Chicken';
  static const privacyPolicyUrl = 'https://lhc-holdings.com/privacy-policy';
  static const privacyContactEmail = 'admin@louisianahotchicken.com';

  /// Change this to switch APIs.
  /// `ApiEnvironment.live`  → https://lhc-holdings.com/api/v1
  /// `ApiEnvironment.local` → http://127.0.0.1:5050/api/v1 (Android emulator: 10.0.2.2)
  static const environment = ApiEnvironment.live;

  static const liveApiBaseUrl = 'https://lhc-holdings.com/api/v1';

  static String get localApiBaseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5050/api/v1';
    }
    return 'http://127.0.0.1:5050/api/v1';
  }

  static String get apiBaseUrl {
    return _trimSlash(
      environment == ApiEnvironment.live ? liveApiBaseUrl : localApiBaseUrl,
    );
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

  static String _trimSlash(String value) {
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }
}
