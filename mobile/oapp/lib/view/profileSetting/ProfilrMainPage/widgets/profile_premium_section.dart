import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePremiumCard extends StatelessWidget {
  const ProfilePremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(20),
        vertical: MediaQueryUtil.spacing(40),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
        border: Border.all(
          color: const Color.fromARGB(255, 199, 197, 197),
          width: 4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Upgrade to Premium',
              style: AppTextStyles.regular(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(12)),
          Text(
            'Get all the benefits we have to offer to make the most of your dating experience.',
            textAlign: TextAlign.center,
            style: AppTextStyles.small(
              fontWeight: AppFontWeight.semi,
              color: AppColors.black,
            ).copyWith(letterSpacing: 0.9),
          ),
        ],
      ),
    );
  }
}

class ProfileUpgradeButton extends GetView<ProfileDisplayController> {
  const ProfileUpgradeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(10),
      ),
      child: SizedBox(
        width: double.infinity,
        height: MediaQueryUtil.spacing(50),
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.shouldNavigateToUpgrade
                ? () => Get.toNamed(Routes.PREMIUM_UPGRADE)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.premiumButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(25)),
              ),
              elevation: 0,
            ),
            child: Text(
              controller.premiumButtonText,
              style: AppTextStyles.regular(
                fontWeight: AppFontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
