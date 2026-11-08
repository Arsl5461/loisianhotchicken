import 'package:OApp/view/common_widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../widgets/ElevatedButton/gradientButton.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

import 'controller/account_setup_controller.dart';

class AccountSetupPage extends GetView<AccountSetupController> {
  const AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.white,
          child: SafeArea(
            child: Column(
              children: [
                // Main content area that expands
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQueryUtil.spacing(40)),

                        // Title
                        Text(
                          "Account Setup",
                          style: AppTextStyles.heading(),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(5)),

                        // Description
                        Column(
                          spacing: MediaQueryUtil.spacing(12),
                          children: [
                            Text(
                              "Now that we know who you are, let's begin setting up your account.",

                              style: AppTextStyles.regular(
                                color: AppColors.grey[600],
                              ),

                              textAlign: TextAlign.left,
                            ),

                            _buildReferralCodeSection(context),
                          ],
                        ),

                        // Spacer pushes button to bottom
                        Spacer(),

                        // Begin Setup button
                        SizedBox(
                          height: MediaQueryUtil.dynamicSize(
                            small: 48,
                            medium: 56,
                            large: 64,
                          ),
                          child: GradientButton(
                            text: 'Begin Setup',

                            onPressed: () {
                              Get.toNamed(Routes.PHONE_VERIFICATION);
                            },
                            backgroundColor: AppColors.cFF006C6A,
                            textColor: AppColors.white,
                            borderRadius: MediaQueryUtil.spacing(12),
                            textSize: MediaQueryUtil.fontSize(16),
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReferralCodeSection(BuildContext context) {
    return Obx(() {
      if (controller.referralCode.value.isEmpty) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () => _showEditReferralSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.cFF006C6A.withValues(alpha: 0.08),
            border: Border.all(color: AppColors.cFF006C6A, width: 1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 15,
                color: AppColors.cFF006C6A,
              ),
              const SizedBox(width: 8),
              Text(
                "Referral code:",
                style: AppTextStyles.regular(
                  color: AppColors.cFF006C6A.withValues(alpha: 0.75),
                ).copyWith(fontSize: 13),
              ),
              const SizedBox(width: 5),
              Text(
                controller.referralCode.value,
                style: AppTextStyles.regular(color: AppColors.cFF006C6A)
                    .copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: AppColors.cFF006C6A,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showEditReferralSheet(BuildContext context) {
    final TextEditingController textController = TextEditingController(
      text: controller.referralCode.value,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit referral code",
              style: AppTextStyles.medium(
                fontWeight: AppFontWeight.semiBold,
                fontFamily: AppFontFamily.playfair,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: "Enter referral code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.cFF006C6A),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.cFF006C6A,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CommonButtons.commonButton(
                    borderRadius: 10,
                    text: "Cancel",
                    backgroundColor: AppColors.white,
                    textStyle: AppTextStyles.small(color: AppColors.cFF006C6A),

                    onPressed: () => Navigator.pop(context),
                  ),
                  // OutlinedButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   child: const Text("Cancel"),
                  // ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonButtons.commonButton(
                    borderRadius: 10,
                    text: "Confirm",

                    // backgroundColor: AppColors.white,
                    // textStyle: AppTextStyles.small(color: AppColors.cFF006C6A),
                    onPressed: () {
                      controller.saveReferralCode(textController.text);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                controller.saveReferralCode('');
                Navigator.pop(context);
              },
              child: const Text(
                "Remove referral code",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
