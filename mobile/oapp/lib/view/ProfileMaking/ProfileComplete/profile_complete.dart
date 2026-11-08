import 'package:OApp/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Buttons/customContinueButton.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ProfileCompleteScreen extends GetView<HomeController> {
  const ProfileCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQueryUtil.spacing(60)),

              // Success Checkmark
              Container(
                width: MediaQueryUtil.spacing(120),
                height: MediaQueryUtil.spacing(120),
                decoration: BoxDecoration(
                  color: AppColors.cFF006C6A, // Teal color
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: MediaQueryUtil.iconSize(60),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(30)),

              // Congratulations Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🎉',
                    style: TextStyle(fontSize: MediaQueryUtil.fontSize(24)),
                  ),
                  SizedBox(width: MediaQueryUtil.spacing(2)),
                  Text(
                    'Congratulations!',
                    style: AppTextStyles.large(
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Profile Setup Complete
              Text(
                'Profile Setup Complete',
                style: AppTextStyles.large(fontWeight: AppFontWeight.semiBold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Description
              Text(
                'You\'ve successfully completed your profile setup. Your dating journey is about to begin!',
                style: AppTextStyles.regular(
                  color: AppColors.grey[700],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQueryUtil.spacing(40)),

              // Completion Metrics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Steps Completed
                  Column(
                    children: [
                      Text(
                        '12',
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(36),
                          fontWeight: FontWeight.bold,
                          color: AppColors.cFF006C6A, // Teal color
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(4)),
                      Text(
                        'Steps Completed',
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),

                  // Profile Complete
                  Column(
                    children: [
                      Text(
                        '100%',
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(36),
                          fontWeight: FontWeight.bold,
                          color: AppColors.cFF006C6A, // Teal color
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(4)),
                      Text(
                        'Profile Complete',
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: MediaQueryUtil.spacing(80)),

              // Go to Dashboard Button
              CustomContinueButton(
                onPressed: () {
                  Get.offAllNamed(Routes.HOME);
                  controller.isFirstTimeUser.value = true;
                  controller.showOnBoarding();
                },
                isEnabled: true,
                backgroundColor: AppColors.cFF006C6A, // Teal color
                text: 'Go to Dashboard',
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Go back link
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.IMAGE_SELECTION);
                  },
                  child: Text(
                    'Go back',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(16),
                      color: AppColors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(30)),
            ],
          ),
        ),
      ),
    );
  }
}
