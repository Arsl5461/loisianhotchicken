import 'dart:async';

import 'package:OApp/view/Dashboard/dashboard_controller.dart';
import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/data/repositories/profile_repository.dart';
import 'package:OApp/utils/toast.dart';

import '../../../controller/home_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/global_service.dart';
import '../../../services/session_service.dart';

class ProfileDisplayController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ProfileRepository _profileRepo = Get.find<ProfileRepository>();
  static const double _avatarScrollThreshold = 30;

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool showCompactAvatar = false.obs;
  late final ScrollController scrollController;
  late final AnimationController avatarAnimationController;
  late final Animation<double> avatarAnimation;
  bool _isFetching = false; // Flag to prevent multiple simultaneous fetches
  GlobalService get _globalService => Get.find<GlobalService>();
  HomeController get homeController => Get.find<HomeController>();

  DashboardController get dashboardController =>
      Get.find<DashboardController>();
  ProfileController get profileController => Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_handleScroll);
    avatarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    avatarAnimation = CurvedAnimation(
      parent: avatarAnimationController,
      curve: Curves.easeInOut,
    );

    final args = Get.arguments;

    if (args != null && args is Map) {
      if (args.containsKey('userModel')) {
        user.value = args['userModel'] as UserModel;
        return;
      } else if (args.containsKey('userId')) {
        fetchUserProfile();
      } else {
        fetchUserProfile();
      }
    } else {
      fetchUserProfile();
    }
  }

  bool get isPremiumTier {
    final tier = user.value?.subscription?.tier;
    return tier == 'standard' ||
        tier == 'premium' ||
        tier == 'paid' ||
        tier == 'referral';
  }

  String getPremiumTierLabel() {
    final tier = user.value?.subscription?.tier;
    final isReferral = tier == 'referral';

    // Check if this is a referral-based premium user
    if (isReferral) {
      return 'Premium';
    }

    switch (tier) {
      case 'standard':
        return 'Standard';
      case 'premium':
        return 'Premium';
      case 'paid':
        return 'Premium';
      default:
        return 'Free';
    }
  }

  bool get isPremiumActive {
    final expiresAtStr = user.value?.subscription?.expiresAt;

    if (!isPremiumTier) return false;

    if (expiresAtStr != null && expiresAtStr.isNotEmpty) {
      try {
        final expiresAt = DateTime.parse(expiresAtStr);
        return expiresAt.isAfter(DateTime.now());
      } catch (_) {
        return true; // fallback if parsing fails
      }
    }

    return true;
  }

  String get premiumButtonText {
    if (isPremiumActive) return 'Subscription Active';
    if (isPremiumTier) return 'Renew Subscription';
    return 'Upgrade Plan';
  }

  Color get premiumButtonColor {
    return isPremiumActive ? AppColors.grey : AppColors.cFF006C6A;
  }

  bool get shouldNavigateToUpgrade {
    return !isPremiumActive;
  }

  void _handleScroll() {
    final shouldShowCompact = scrollController.offset > _avatarScrollThreshold;
    if (showCompactAvatar.value == shouldShowCompact) return;

    showCompactAvatar.value = shouldShowCompact;
    if (shouldShowCompact) {
      avatarAnimationController.forward();
    } else {
      avatarAnimationController.reverse();
    }
  }

  double progress() {
    return homeController.calculateProfileCompletion(user.value);
  }

  Future<void> logout() async {
    user.value = null;
    await Get.find<SessionService>().invalidateSession();
  }

  Future<void> fetchUserProfile({bool isWithoutLoading=false}) async {
    if (_isFetching) return;
    isLoading.value = true;
    _isFetching = true;
    try {
      final fetchedUser = await _profileRepo.fetchUser();

      if (fetchedUser != null) {
        user.value = fetchedUser;
        _globalService.setUserModel(fetchedUser);
      } else if (!isWithoutLoading) {
        Toast.error('Failed to load profile');
      }
    } catch (e) {
      Toast.error('Something went wrong');
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  void updateLocalSubscription(Subscription subscription) {
    final currentUser = user.value;
    if (currentUser == null) {
      return;
    }

    final updatedUser = currentUser.copyWith(subscription: subscription);
    user.value = updatedUser;
    _globalService.setUserModel(updatedUser);
  }

  @override
  void onClose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    avatarAnimationController.dispose();
    super.onClose();
  }
}
