import 'dart:async';
import 'dart:io';
import 'package:OApp/config/error_handler.dart';
import 'package:OApp/core/routing/app_pages.dart';
import 'package:OApp/services/firebase_remote_config_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'core/design/widgets/bubba_loading.dart';
import 'widgets/error_fallback_widget.dart';
import 'firebase_options.dart';
import 'services/deep_link_service.dart';
import 'services/secure_storage_service.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      // Optional: make the zone mismatch warning fatal during debug`ging
      // BindingBase.debugZoneErrorsAreFatal = true;

      WidgetsFlutterBinding.ensureInitialized();
      await _clearIosKeychainOnFreshInstall();
      await dotenv.load(fileName: '.env');

      if (AppConfig.stripePublishableKey.isEmpty) {
        throw Exception(
          'Missing STRIPE_PUBLISHABLE_KEY in .env. Add it before launching the app.',
        );
      }

      Stripe.publishableKey = AppConfig.stripePublishableKey;
      Stripe.merchantIdentifier = AppConfig.stripeMerchantIdentifier;
      Stripe.urlScheme = 'oapp';
      await Stripe.instance.applySettings();

      // 1) Catch Flutter framework errors (build/layout/paint/etc.)
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        debugPrint('FLUTTER ERROR: ${details.exceptionAsString()}');
        if (details.stack != null) debugPrint('${details.stack}');
        // forward to Crashlytics/Sentry if needed
      };

      // 2) Replace the red error screen with a safe widget (optional)
      ErrorWidget.builder = (FlutterErrorDetails details) {
        debugPrint('ERROR WIDGET: ${details.exceptionAsString()}');
        return ErrorFallbackWidget(details: details);
      };

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
          name: 'OApp',
        );
        await AppConfigurations.initialize();
        config();
      } catch (e, st) {
        handleError(error: e.toString(), stack: st.toString(), tag: 'main');
      }

      try {
        await GetStorage.init();
      } catch (e, st) {
        handleError(error: e.toString(), stack: st.toString(), tag: 'main');
      }

      // SECURITY: never disable certificate validation in release builds.
      // Opt-in for local debugging only via:
      //   flutter run --dart-define=ALLOW_BAD_CERTS=true
      if (kDebugMode &&
          const bool.fromEnvironment('ALLOW_BAD_CERTS', defaultValue: false)) {
        HttpOverrides.global = MyHttpOverrides();
      }

      runApp(DevicePreview(enabled: false, builder: (context) => const OAPP()));
    },
    (error, stack) {
      debugPrint('UNHANDLED (zone) ERROR: $error');
      debugPrint('$stack');
      // forward to Crashlytics/Sentry if needed
    },
  );
}

void config() {
  Get.find<DeepLinkService>().init();
  Get.find<RemoteConfigService>().init();
}

Future<void> _clearIosKeychainOnFreshInstall() async {
  if (!Platform.isIOS) return;

  const installMarkerKey = 'has_launched_before';
  final prefs = await SharedPreferences.getInstance();
  final hasLaunchedBefore = prefs.getBool(installMarkerKey) ?? false;

  if (!hasLaunchedBefore) {
    await SecureStorageService.instance.deleteAllKeys();
    await prefs.setBool(installMarkerKey, true);
  }
}

class OAPP extends StatelessWidget {
  const OAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OApp',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      locale: DevicePreview.locale(context),
      builder: (context, child) => DevicePreview.appBuilder(
        context,
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => Stack(
            children: [
              child ?? const SizedBox.shrink(),
              const Positioned.fill(child: BubbaBusyOverlay()),
            ],
          ),
        ),
      ),

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}

/// DEBUG-ONLY: bypasses TLS certificate validation. This is gated behind
/// `kDebugMode` + the `ALLOW_BAD_CERTS` dart-define in [main] and must never be
/// enabled in a release build.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
