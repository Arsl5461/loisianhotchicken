import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../widgets/ElevatedButton/customElevatedButtom.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../ProfileMaking/profile_making_controller/profile_controller.dart';

class NotificationSetupPage extends GetView<ProfileController> {
  const NotificationSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQueryUtil.spacing(40)),
                    Text(
                      "Allow Notifications",
                      style: AppTextStyles.large(
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(16)),

                    Text(
                      "Notifications are used to alert you of new matches and messages. A 24 hour timer begins once you match so you wont want to miss it!",
                      style: AppTextStyles.regular(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.grey[600],
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(24)),
                  ],
                ),
              ),
            ),

            AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: keyboardHeight > 0 ? keyboardHeight + 12 : 20,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: controller.skipNotificationSetup,
                      style: TextButton.styleFrom(
                        minimumSize: Size(
                          double.infinity,
                          MediaQueryUtil.spacing(58),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Not now',
                        style: AppTextStyles.medium(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.cFF00B1E9,
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(6)),

                    SizedBox(
                      height: MediaQueryUtil.spacing(58),
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Allow notifications',
                        onPressed: () {
                          controller.skipNotificationSetup();
                        },
                        backgroundColor: AppColors.cFF006C6A,
                        textColor: AppColors.white,
                        borderRadius: MediaQueryUtil.spacing(12),
                        textSize: MediaQueryUtil.fontSize(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
