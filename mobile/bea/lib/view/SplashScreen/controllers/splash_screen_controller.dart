import 'dart:async';

import 'package:OApp/services/firebase_remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_config.dart';
import '../../../config/error_handler.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/routing/app_routes.dart';
import '../../../models/user_model.dart';
import '../../../services/firebaseauth_service.dart';
import '../../../services/secure_storage_service.dart';
import '../../ProfileMaking/profile_making_controller/profile_controller.dart';
import '../../auth/create_account/bubba_auth_controller.dart';
import '../../auth/models/remote_config_model.dart';

class OappSplashController extends GetxController
    with GetTickerProviderStateMixin {
  OappSplashController({SecureStorageService? storage})
    : secureStorage = storage ?? SecureStorageService.instance;

  final SecureStorageService secureStorage;

  final RxBool isSigningIn = false.obs;

  late final AnimationController logoController;
  late final AnimationController taglineController;
  late final AnimationController loaderController;
  late final AnimationController pulseController;
  late final AnimationController exitController;

  late final Animation<double> logoScale;
  late final Animation<double> logoOpacity;
  late final Animation<double> taglineOpacity;
  late final Animation<Offset> taglineSlide;
  late final Animation<double> loaderOpacity;
  late final Animation<double> pulseScale;
  late final Animation<double> exitOpacity;

  RemoteConfigModel remoteConfigModel = DefaultRemoteConfig.model;
  final loadingMessage = 'Loading...'.obs;

  FirebaseAuthService get _auth => Get.find<FirebaseAuthService>();
  RemoteConfigService get remoteConfig => Get.find<RemoteConfigService>();
  ProfileController get profileController => Get.find<ProfileController>();

  static const Duration _minSplashDuration = Duration(milliseconds: 2400);

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    unawaited(_initializeAndNavigate());
  }

  void _initAnimations() {
    logoController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    taglineController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    loaderController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    exitController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutCubic),
    );
    logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: logoController, curve: Curves.easeOut));
    taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: taglineController, curve: Curves.easeOut),
    );
    taglineSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: taglineController,
            curve: Curves.easeOutCubic,
          ),
        );
    loaderOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: loaderController, curve: Curves.easeIn));
    pulseScale = Tween<double>(begin: 1.0, end: 1.045).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
    exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: exitController, curve: Curves.easeIn));

    unawaited(_playEntranceAnimations());
  }

  Future<void> _playEntranceAnimations() async {
    await logoController.forward();
    if (!Get.isRegistered<OappSplashController>()) return;

    await Future.delayed(const Duration(milliseconds: 120));
    if (!Get.isRegistered<OappSplashController>()) return;
    await taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 180));
    if (!Get.isRegistered<OappSplashController>()) return;
    await loaderController.forward();

    pulseController.repeat(reverse: true);
  }

  Future<void> getTenants() async {
    try {
      await _auth.ensureFirebaseSignedIn();
      final logo = remoteConfig.getJson(remoteConfig.jsonname);
      remoteConfigModel = RemoteConfigModel.fromJson(logo);
      AppConfig.baseUrl = remoteConfigModel.liveUrl;
    } catch (e, s) {
      handleError(
        tag: 'Splash Screen',
        stack: s.toString(),
        error: e.toString(),
      );
      remoteConfigModel = DefaultRemoteConfig.model;
    }
  }

  Future<void> _initializeAndNavigate() async {
    loadingMessage.value = 'Setting things up...';

    await Future.wait([getTenants(), Future.delayed(_minSplashDuration)]);

    if (!Get.isRegistered<OappSplashController>()) return;

    loadingMessage.value = 'Almost ready...';

    final token = await secureStorage.getKey(AppKeys.authToken);
    isSigningIn.value = token != null;
    UserModel? user;

    if (token != null) {
      await profileController.fetchUserProfile(isWithoutLoading: true);
      user = profileController.user.value;
    }

    pulseController.stop();
    await exitController.forward();

    if (!Get.isRegistered<OappSplashController>()) return;

    if (token != null) {
      navigateBaised(user, token);
    } else {
      Get.offAllNamed(Routes.OPTION_SCREEN);
    }
  }

  @override
  void onClose() {
    logoController.dispose();
    taglineController.dispose();
    loaderController.dispose();
    pulseController.dispose();
    exitController.dispose();
    super.onClose();
  }

  /// One place decides where a signed-in account belongs, shared with the
  /// sign-in path so a relaunch and a fresh sign-in cannot disagree.
  void navigateBaised(UserModel? user, String? token) {
    Get.offAllNamed(BubbaAuthController.routeForUser(user, token ?? ''));
  }
}
