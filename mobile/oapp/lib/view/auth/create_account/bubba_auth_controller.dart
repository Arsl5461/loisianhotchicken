import 'package:get/get.dart';

import '../../../core/routing/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../models/user_model.dart';
import '../../../models/verification_model.dart';
import '../../../services/firebaseauth_service.dart';
import '../../../utils/toast.dart';
import '../../ProfileMaking/profile_making_controller/profile_controller.dart';
import '../profile_setup/profile_setup_controller.dart';
import '../profile_setup/profile_setup_routes.dart';
import 'bubba_routes.dart';
import 'widgets/get_started_sheet.dart';

enum BubbaAuthIntent { signUp, signIn }

abstract class BubbaAuthApi {
  Future<AuthRequestResult> requestOtp(String phone, BubbaAuthIntent intent);

  Future<VerificationModel?> verifyOtp(
    String phone,
    String otp,
    BubbaAuthIntent intent,
  );

  Future<bool> resend(String phone, BubbaAuthIntent intent);

  Future<void> saveSession(VerificationModel data, {required bool clearReferral});

  Future<String?> referralCode();

  Future<String?> socialUid(BubbaAuthProvider provider);

  Future<VerificationModel?> loginWithKeys({
    required BubbaAuthProvider provider,
    required String uid,
  });

  Future<UserModel?> loadProfile();
}

class RepositoryBubbaAuthApi implements BubbaAuthApi {
  RepositoryBubbaAuthApi([AuthRepository? repository])
    : _repo = repository ?? Get.find<AuthRepository>();

  final AuthRepository _repo;

  @override
  Future<AuthRequestResult> requestOtp(String phone, BubbaAuthIntent intent) =>
      intent == BubbaAuthIntent.signUp
      ? _repo.requestSignUpOtp(phone)
      : _repo.requestSignInOtp(phone);

  @override
  Future<VerificationModel?> verifyOtp(
    String phone,
    String otp,
    BubbaAuthIntent intent,
  ) async {
    if (intent == BubbaAuthIntent.signUp) {
      return _repo.verifySignUpOtp(
        phoneNumber: phone,
        otp: otp,
        referralCode: await _repo.getReferralCode(),
      );
    }
    return _repo.verifySignInOtp(phoneNumber: phone, otp: otp);
  }

  @override
  Future<bool> resend(String phone, BubbaAuthIntent intent) =>
      intent == BubbaAuthIntent.signUp
      ? _repo.resendSignUpCode(phone)
      : _repo.resendSignInCode(phone);

  @override
  Future<void> saveSession(
    VerificationModel data, {
    required bool clearReferral,
  }) => _repo.saveSession(data, clearReferral: clearReferral);

  @override
  Future<String?> referralCode() => _repo.getReferralCode();

  @override
  Future<String?> socialUid(BubbaAuthProvider provider) async {
    final auth = Get.find<FirebaseAuthService>();
    final credential = switch (provider) {
      BubbaAuthProvider.apple => await auth.signInWithApple(),
      BubbaAuthProvider.google => await auth.signInWithGoogle(),
      BubbaAuthProvider.phone || BubbaAuthProvider.email => null,
    };
    return credential?.user?.uid;
  }

  @override
  Future<VerificationModel?> loginWithKeys({
    required BubbaAuthProvider provider,
    required String uid,
  }) => _repo.loginWithKeys(
    facebookKey: '',
    googleKey: provider == BubbaAuthProvider.google ? uid : '',
    appleKey: provider == BubbaAuthProvider.apple ? uid : '',
  );

  @override
  Future<UserModel?> loadProfile() async {
    final profile = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    await profile.fetchUserProfile();
    return profile.user.value;
  }
}

typedef BubbaNavigate = void Function(String route, {Object? arguments});
typedef BubbaNotify = void Function(String message);
typedef BubbaDismiss = void Function();

class BubbaAuthController extends GetxController {
  BubbaAuthController({
    BubbaAuthApi? api,
    BubbaNavigate? navigate,
    BubbaNavigate? replaceAll,
    BubbaNotify? notify,
    BubbaDismiss? dismiss,
  }) : _api = api ?? RepositoryBubbaAuthApi(),
       _navigate = navigate ?? _defaultNavigate,
       _replaceAll = replaceAll ?? _defaultReplaceAll,
       _notify = notify ?? Toast.error,
       _dismiss = dismiss ?? _defaultDismiss;

  final BubbaAuthApi _api;
  final BubbaNavigate _navigate;
  final BubbaNavigate _replaceAll;
  final BubbaNotify _notify;
  final BubbaDismiss _dismiss;

  static void _defaultNavigate(String route, {Object? arguments}) =>
      Get.toNamed(route, arguments: arguments);

  static void _defaultReplaceAll(String route, {Object? arguments}) =>
      Get.offAllNamed(route, arguments: arguments);

  static void _defaultDismiss() {
    if (Get.currentRoute == BubbaRoutes.signingIn) Get.back();
  }

  final RxBool isLoading = false.obs;
  final RxnString lastError = RxnString();

  String _phoneNumber = '';
  BubbaAuthIntent _intent = BubbaAuthIntent.signUp;

  String get phoneNumber => _phoneNumber;
  BubbaAuthIntent get intent => _intent;

  static BubbaAuthController get instance {
    if (!Get.isRegistered<BubbaAuthController>()) {
      Get.put(BubbaAuthController(), permanent: true);
    }
    return Get.find<BubbaAuthController>();
  }

  static String toE164(String dialCode, String digits) =>
      '+${'$dialCode$digits'.replaceAll(RegExp(r'\D'), '')}';

  Future<void> requestCode({
    required String dialCode,
    required String digits,
    required BubbaAuthIntent intent,
  }) async {
    if (isLoading.value) return;
    _intent = intent;
    _phoneNumber = toE164(dialCode, digits);

    isLoading.value = true;
    lastError.value = null;
    try {
      final result = await _api.requestOtp(_phoneNumber, intent);
      if (result.isSuccess) {
        _navigate(BubbaRoutes.verifyPhone, arguments: _phoneNumber);
        return;
      }
      lastError.value = result.errorMessage ?? 'Failed to send code';
      _notify(lastError.value!);
    } catch (_) {
      lastError.value = 'Something went wrong. Please try again.';
      _notify(lastError.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyCode(String otp) async {
    if (isLoading.value) return false;
    isLoading.value = true;
    lastError.value = null;
    try {
      final data = await _api.verifyOtp(_phoneNumber, otp, _intent);
      if (data == null) {
        lastError.value = 'This code isn’t right. Try again.';
        return false;
      }

      await _api.saveSession(
        data,
        clearReferral: _intent == BubbaAuthIntent.signUp,
      );

      if (_intent == BubbaAuthIntent.signUp) {
        _navigate(BubbaRoutes.email);
      } else {
        final user = await _api.loadProfile();
        _replaceAll(routeForUser(user, data.token));
      }
      return true;
    } catch (_) {
      lastError.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithProvider(BubbaAuthProvider provider) async {
    if (provider != BubbaAuthProvider.apple &&
        provider != BubbaAuthProvider.google) {
      return false;
    }
    if (isLoading.value) return false;

    isLoading.value = true;
    lastError.value = null;
    _navigate(BubbaRoutes.signingIn);
    try {
      final uid = await _api.socialUid(provider);
      if (uid == null || uid.isEmpty) {
        _dismiss();
        return false;
      }

      final data = await _api.loginWithKeys(provider: provider, uid: uid);
      if (data == null) {
        _dismiss();
        lastError.value =
            'No Bubba account is linked to that ${providerLabel(provider)} account yet. Sign in with your phone number first.';
        _notify(lastError.value!);
        return false;
      }

      await _api.saveSession(data, clearReferral: false);
      final user = await _api.loadProfile();
      _replaceAll(routeForUser(user, data.token));
      return true;
    } catch (_) {
      _dismiss();
      lastError.value = 'Something went wrong. Please try again.';
      _notify(lastError.value!);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  static String providerLabel(BubbaAuthProvider provider) =>
      provider == BubbaAuthProvider.apple ? 'Apple' : 'Google';

  /// Where an account with a token belongs.
  ///
  /// `steps_done` counts the four `addProfile` steps, and the part 2 flow posts
  /// all four in one go from its last screen - so anything under four means the
  /// questionnaire was never completed and has to be walked again. The legacy
  /// per-step screens are not where those users go any more: sending them there
  /// dropped them into the old location/religion/job screens mid-signup.
  static String routeForUser(UserModel? user, String token) {
    if (token.isEmpty || user == null) return Routes.OPTION_SCREEN;
    if ((user.stepsDone ?? 0) >= 4 || (user.isProfileCompleted ?? false)) {
      return Routes.HOME;
    }
    seedProfileSetup(user);
    // Part 1 asks for location before handing over, and it is saved on the
    // account, so a resume that has none picks up there instead.
    return user.location == null
        ? BubbaRoutes.location
        : ProfileSetupRoutes.name;
  }

  /// Carries what the account already knows into the part 2 flow, which holds
  /// its answers in memory only.
  static void seedProfileSetup(UserModel user) {
    final setup = ProfileSetupController.instance;
    if (setup.email.value.isEmpty) setup.email.value = user.email?.trim() ?? '';
    if (setup.phoneNumber.value.isEmpty) {
      setup.phoneNumber.value = user.phoneNumber?.trim() ?? '';
    }
    if (setup.fullName.isEmpty && (user.fullName ?? '').isNotEmpty) {
      setup.setName(user.fullName!);
    }
  }

  Future<bool> resendCode() async {
    if (_phoneNumber.isEmpty) return false;
    try {
      return await _api.resend(_phoneNumber, _intent);
    } catch (_) {
      return false;
    }
  }
}
