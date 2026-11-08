import 'package:OApp/services/dailog_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../core/dio_service/dio_service.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/home_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/referral_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/travel_repository.dart';
import '../services/deep_link_service.dart';
import '../services/firebase_remote_config_service.dart';
import '../services/firebaseauth_service.dart';
import '../services/firestore_service.dart';
import '../services/global_service.dart';
import '../services/secure_storage_service.dart';
import '../services/session_service.dart';
import '../services/socket_service.dart';
import '../services/storage_service.dart';
import '../view/preferences/prefs_map_surface.dart';

class AppConfigurations {
  static Future<void> initialize() async {
    Get.lazyPut<RemoteConfigService>(() => RemoteConfigService(), fenix: true);

    Get.lazyPut<FirestoreService>(() => FirestoreService.instance, fenix: true);
    Get.lazyPut<StorageService>(() => StorageService.instance, fenix: true);
    Get.lazyPut<SecureStorageService>(
      () => SecureStorageService.instance,
      fenix: true,
    );
    Get.lazyPut<SessionService>(() => SessionService(), fenix: true);
    Get.lazyPut<FirebaseAuthService>(
      () => FirebaseAuthService.instance,
      fenix: true,
    );
    Get.lazyPut<NetworkManager>(() => NetworkManager(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<HomeRepository>(() => HomeRepository(), fenix: true);
    Get.lazyPut<ChatRepository>(() => ChatRepository(), fenix: true);
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(), fenix: true);
    Get.lazyPut<ReferralRepository>(() => ReferralRepository(), fenix: true);
    Get.lazyPut<TravelRepository>(() => TravelRepository(), fenix: true);
    Get.lazyPut<PaymentRepository>(() => PaymentRepository(), fenix: true);
    Get.lazyPut<SettingsRepository>(() => SettingsRepository(), fenix: true);
    Get.lazyPut<SocketService>(() => SocketService(), fenix: true);
    Get.lazyPut<DeepLinkService>(() => DeepLinkService(), fenix: true);

    // The part 4 map boxes draw the measured plate by default so the goldens
    // stay deterministic. A running app can render tiles, so it gets the real
    // map.
    PrefsMapMode.live = true;

    Get.put<GlobalService>(GlobalService(), permanent: true);
    Get.lazyPut<DialogService>(() => DialogService(), fenix: true);
    // If any service requires async initialization, you can do:
    // await Get.putAsync(() async => await SomeService().init());
  }
}

class AppConfig {
  static const String _defaultBaseUrl =
      'https://24appbackend-production.up.railway.app/';

  static String? _runtimeBaseUrl;

  static String get baseUrl {
    final fromEnv = _envBaseUrl;

    // In debug, an explicit API_BASE_URL wins over Remote Config. Without this
    // the splash screen replaces it a second after launch, so the calls made
    // before the fetch go to the local backend and everything after goes to
    // production - which is exactly what happened the first time this was
    // pointed at localhost.
    if (kDebugMode && fromEnv != null) return fromEnv;

    if (_runtimeBaseUrl != null &&
        _runtimeBaseUrl!.isNotEmpty &&
        !(kReleaseMode && _isLocal(_runtimeBaseUrl!))) {
      return _normalizeBaseUrl(_runtimeBaseUrl!);
    }

    // In release, never let a bundled .env pointing at localhost (or a stale
    // Remote Config that resolved to it) leak into a store build.
    if (fromEnv != null && !(kReleaseMode && _isLocal(fromEnv))) return fromEnv;

    return _defaultBaseUrl;
  }

  /// Null unless `.env` is loaded and carries a non-empty override.
  static String? get _envBaseUrl {
    if (!dotenv.isInitialized) return null;
    final value = dotenv.env['API_BASE_URL']?.trim();
    if (value == null || value.isEmpty) return null;
    return _normalizeBaseUrl(value);
  }

  static set baseUrl(String value) {
    _runtimeBaseUrl = _normalizeBaseUrl(value);
  }

  /// True when the app is talking to something other than the deployed API,
  /// so a debug banner can say so.
  static bool get isUsingLocalBackend => _isLocal(baseUrl);

  static bool _isLocal(String url) =>
      url.contains('localhost') || url.contains('127.0.0.1');

  static String _normalizeBaseUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return _defaultBaseUrl;
    return trimmed.endsWith('/') ? trimmed : '$trimmed/';
  }

  /// Clears a remote-config override so [baseUrl] falls back to env/default.
  static void clearRuntimeBaseUrl() {
    _runtimeBaseUrl = null;
  }

  static bool get allowPhotoUploadFallback {
    if (!kDebugMode) return false;
    if (!dotenv.isInitialized) return false;
    final value = dotenv.env['ALLOW_PHOTO_UPLOAD_FALLBACK']?.trim().toLowerCase();
    if (value == null || value.isEmpty) return false;
    return value == 'true' || value == '1' || value == 'yes';
  }

  static String get inviteBaseUrl {
    final value = dotenv.isInitialized
        ? dotenv.env['INVITE_BASE_URL']?.trim()
        : null;
    if (value == null || value.isEmpty) return 'joinbubba.com';
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }

  static String inviteLink(String code) =>
      code.isEmpty ? '' : '$inviteBaseUrl/$code';

  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static const String stripeMerchantIdentifier = 'merchant.com.oapp';
  static const String stripeReturnUrl = 'oapp://payment/success';
}
