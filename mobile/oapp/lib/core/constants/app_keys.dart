/// Storage key constants for consistent key management throughout the application
/// Use these constants for all storage operations to ensure data consistency
class AppKeys {
  // Authentication Keys
  static const String authToken = 'auth_token';
  static const String userID = 'userID';
  static const String userModel = 'user_model';
  static const String rememberLogin = 'remember_login';

  // User Preferences Keys
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String firstLaunch = 'first_launch';
  static const String notificationsEnabled = 'notifications_enabled';

  // FCM Keys
  static const String fcmToken = 'fcm_token';

  // Session Keys
  static const String sessionExpiry = 'session_expiry';
  static const String lastLoginTime = 'last_login_time';

  // Security Keys
  static const String deviceId = 'device_id';
  static const String appVersion = 'app_version';
  static const String referralCode = 'referral_code';
  // Private constructor to prevent instantiation
  AppKeys._();
}
