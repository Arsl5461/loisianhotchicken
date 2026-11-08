import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/toast.dart';
import '../../ProfileMaking/profile_making_controller/profile_controller.dart';
import '../profile_setup/profile_setup_controller.dart';
import '../profile_setup/profile_setup_routes.dart';
import 'bubba_auth_controller.dart';
import 'bubba_routes.dart';
import 'email_entry_screen.dart';
import 'existing_account_screen.dart';
import 'landing_screen.dart';
import 'onboarding_screens.dart';
import 'phone_number_screen.dart';
import 'signing_in_screen.dart';
import 'verify_code_screen.dart';
import 'widgets/get_started_sheet.dart';
import '../../settings/support_screens.dart';

class BubbaLandingPage extends StatelessWidget {
  const BubbaLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LandingScreen(
      onProviderPicked: BubbaFlow.startProvider,
      onSignIn: () => BubbaFlow.openSignInSheet(context),
    );
  }
}

class BubbaFlow {
  BubbaFlow._();

  static void startProvider(BubbaAuthProvider provider) {
    switch (provider) {
      case BubbaAuthProvider.phone:
      case BubbaAuthProvider.email:
      case BubbaAuthProvider.apple:
      case BubbaAuthProvider.google:
        Get.toNamed(BubbaRoutes.phone);
    }
  }

  static ProfileController get _profile => Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  static void submitEmail(String email) {
    final trimmed = email.trim();
    final profile = _profile;
    profile.emailController.text = trimmed;
    profile.email.value = trimmed;
    profile.profile.update((p) => p?.email = trimmed);
    Get.toNamed(BubbaRoutes.location);
  }

  /// The screen says location is required to continue, and the API keeps it on
  /// the user document, so the permission prompt is only half the job: the
  /// coordinates have to reach `user/updateLocation` before the flow moves on.
  static Future<void> requestLocation() async {
    final profile = _profile;
    if (profile.isLocLoading.value) return;
    final granted = await profile.requestPermissionAndSetLocation();
    if (!granted) {
      Toast.warning(profile.locError.value ?? 'Location permission is needed');
      return;
    }
    final saved = await profile.saveLocationToAccount();
    profile.isLocLoading.value = false;
    if (!saved) {
      Toast.error(profile.locError.value ?? 'Could not save your location');
      return;
    }
    Get.toNamed(BubbaRoutes.notifications);
  }

  /// "Allow notifications" has to actually ask. The design's second action is
  /// "Not now", so a refusal is a valid answer and the flow continues either
  /// way - what it must not do is claim to have asked without asking.
  static Future<void> allowNotifications() async {
    try {
      final status = await Permission.notification.request();
      if (status.isPermanentlyDenied) {
        Toast.warning(
          'Notifications are switched off for Bubba. You can turn them on in '
          'Settings.',
        );
      }
    } catch (_) {
      // A platform without the permission still gets through the flow.
    }
    finishNotifications();
  }

  static void finishNotifications() => Get.toNamed(BubbaRoutes.accountReady);

  /// "Need help?" appears once the number is locked out, so it has to reach
  /// support without an account. Contact Support is a logged-out-safe screen:
  /// it only picks a topic and opens the ticket form.
  static void openSupport() => Get.to(() => const BubbaContactSupportScreen());

  /// "Account ready" hands over to part 2, the "building your profile"
  /// questionnaire, rather than the legacy GENDER_SELECTION flow.
  ///
  /// The email and phone were captured in part 1 and `addProfile` saves the
  /// profile against the account, so they are carried across rather than left
  /// behind in the legacy controller.
  static void beginProfileSetup() {
    final setup = ProfileSetupController.instance;
    setup.email.value = _profile.email.value.trim();
    setup.phoneNumber.value =
        _profile.profile.value.phoneNumber?.trim() ?? '';
    Get.toNamed(ProfileSetupRoutes.name);
  }

  static Future<void> openAnotherWaySheet(
    BuildContext context,
    BubbaAuthProvider current, {
    VoidCallback? onRecover,
  }) async {
    final provider = await showSignInAnotherWaySheet(
      context,
      current: current,
      exclude: const {BubbaAuthProvider.email},
      onRecover: onRecover,
    );
    if (provider == null) return;
    switch (provider) {
      case BubbaAuthProvider.phone:
        Get.offNamed(BubbaRoutes.signInPhone);
      case BubbaAuthProvider.email:
        Get.offNamed(BubbaRoutes.signInEmail);
      case BubbaAuthProvider.apple:
      case BubbaAuthProvider.google:
        Get.back();
        BubbaAuthController.instance.signInWithProvider(provider);
    }
  }

  static Future<void> openSignInSheet(BuildContext context) async {
    final provider = await showGetStartedSheet(
      context,
      title: 'Welcome back',
      subtitle: 'Continue where you left off.',
      exclude: const {BubbaAuthProvider.email},
    );
    if (provider == null) return;
    switch (provider) {
      case BubbaAuthProvider.phone:
        Get.toNamed(BubbaRoutes.signInPhone);
      case BubbaAuthProvider.email:
        Get.toNamed(BubbaRoutes.signInEmail);
      case BubbaAuthProvider.apple:
      case BubbaAuthProvider.google:
        BubbaAuthController.instance.signInWithProvider(provider);
    }
  }
}

final List<GetPage> bubbaFlowPages = [
  GetPage(name: BubbaRoutes.landing, page: () => const BubbaLandingPage()),
  GetPage(name: BubbaRoutes.signingIn, page: () => const SigningInScreen()),
  GetPage(
    name: BubbaRoutes.phone,
    page: () => Obx(
      () => PhoneNumberScreen(
        busy: BubbaAuthController.instance.isLoading.value,
        onContinue: (country, number) =>
            BubbaAuthController.instance.requestCode(
          dialCode: country.dialCode,
          digits: number,
          intent: BubbaAuthIntent.signUp,
        ),
        onNeedHelp: BubbaFlow.openSupport,
      ),
    ),
  ),
  GetPage(
    name: BubbaRoutes.signInPhone,
    page: () => Obx(
      () => PhoneNumberScreen.signIn(
        busy: BubbaAuthController.instance.isLoading.value,
        onContinue: (country, number) =>
            BubbaAuthController.instance.requestCode(
          dialCode: country.dialCode,
          digits: number,
          intent: BubbaAuthIntent.signIn,
        ),
        onNeedHelp: BubbaFlow.openSupport,
        onSecondary: () => BubbaFlow.openAnotherWaySheet(
            Get.context!, BubbaAuthProvider.phone),
      ),
    ),
  ),
  GetPage(
    name: BubbaRoutes.verifyPhone,
    page: () => Obx(
      () => VerifyCodeScreen(
        destination: Get.arguments as String? ?? '',
        busy: BubbaAuthController.instance.isLoading.value,
        onVerified: BubbaAuthController.instance.verifyCode,
        onResend: BubbaAuthController.instance.resendCode,
        onChangeDestination: Get.back,
      ),
    ),
  ),
  GetPage(
    name: BubbaRoutes.email,
    page: () => EmailEntryScreen(onContinue: BubbaFlow.submitEmail),
  ),
  GetPage(
    name: BubbaRoutes.signInEmail,
    page: () => EmailEntryScreen.signIn(
      onContinue: (email) =>
          Get.toNamed(BubbaRoutes.verifyEmail, arguments: email),
      onSecondary: () =>
          BubbaFlow.openAnotherWaySheet(Get.context!, BubbaAuthProvider.email),
    ),
  ),
  GetPage(
    name: BubbaRoutes.verifyEmail,
    page: () => VerifyCodeScreen(
      destination: Get.arguments as String? ?? '',
      headingSecondLine: 'email',
      onVerified: (_) => Get.toNamed(BubbaRoutes.location),
      onChangeDestination: Get.back,
    ),
  ),
  GetPage(
    name: BubbaRoutes.existingAccount,
    page: () => ExistingAccountScreen(
      identifier: Get.arguments as String? ?? '',
      onContinue: () => Get.offNamed(BubbaRoutes.signInPhone),
      onUseDifferent: Get.back,
    ),
  ),
  GetPage(
    name: BubbaRoutes.location,
    page: () => LocationPermissionScreen(
      onUseCurrentLocation: BubbaFlow.requestLocation,
      onEnterManually: () => Get.toNamed(BubbaRoutes.notifications),
    ),
  ),
  GetPage(
    name: BubbaRoutes.notifications,
    page: () => NotificationPermissionScreen(
      onAllow: BubbaFlow.allowNotifications,
      onNotNow: BubbaFlow.finishNotifications,
    ),
  ),
  GetPage(
    name: BubbaRoutes.accountReady,
    page: () =>
        AccountReadyScreen(onBeginProfileSetup: BubbaFlow.beginProfileSetup),
  ),
];
