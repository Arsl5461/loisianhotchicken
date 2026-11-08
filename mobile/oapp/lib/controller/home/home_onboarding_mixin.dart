import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/HomeScreen/widgets/referral_reward_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller_base.dart';

mixin HomeOnboardingMixin on HomeControllerBase {
  bool hasShownReferralReward = false;

  void showIntro() {
    dialogService.showIntroBubble(
      text: 'Whoops. Use reverse to see the previous profile again.',
      position: const Offset(120, 120),
    );
  }

  Future<void> showReferralRewardIfApplicable() async {
    if (hasShownReferralReward) return;

    final currentUser = globalService.getUserModel();
    if (currentUser == null) return;

    final tier = currentUser.subscription?.tier;
    final isReferral = tier == 'referral';

    if (isReferral && isFirstTimeUser.value) {
      hasShownReferralReward = true;
      await showReferralRewardBottomSheet(
        tier: tier,
        expiresAt: currentUser.subscription?.expiresAt,
      );
    }
  }

  Future<void> showReferralRewardBottomSheet({
    required String? tier,
    required String? expiresAt,
  }) async {
    await Get.to(
      () => ReferralRewardBottomSheet(
        subscriptionTier: tier,
        expiresAt: expiresAt,
      ),
      transition: Transition.fadeIn,
    );
  }

  Future<void> showOnBoarding() async {
    dashboardController.changeIndex(0);
    if (isFirstTimeUser.value) {
      await showReferralRewardIfApplicable();

      await Future.delayed(const Duration(seconds: 2));
      await dialogService.showIntroBubble(
        text: 'Whoops. Use reverse to see the previous profile again.',
        position: const Offset(15, 130),
      );
      await dialogService.showIntroBubble(
        text: 'Set your dating preferences here for stronger connections',
        // Keep bubble left of the filter icon so it does not cover the tap target.
        position: Offset(MediaQueryUtil.width - 300, 88),
        isReversed: true,
      );
      isFirstTimeUser.value = false;
    }
  }
}
