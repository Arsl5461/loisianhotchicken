import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../widgets/Input/CustomTextField.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../utils/media_query.dart';
import '../../ProfileMaking/profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EmailScreen extends GetView<ProfileController> {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(20),
            vertical: MediaQueryUtil.spacing(16),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQueryUtil.spacing(40)),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What's your email?",
                  style: AppTextStyles.large(
                    fontWeight: AppFontWeight.semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Instructional text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "For access to the beta, please use the same email as waitlist. Your email can be used for account recovery",
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.grey[600],
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(32)),

              // Email input field
              CustomTextField(
                onChanged: (valu) {
                  controller.profile.value.email = valu;
                  controller.profile.refresh();
                },
                controller: controller.emailController,
                hintText: 'Email',
                hintStyle: AppTextStyles.regular(
                  fontWeight: AppFontWeight.semi,
                  color: AppColors.grey,
                ),
                focusColor: AppColors.cFF006C6A,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: MediaQueryUtil.spacing(24)),

              // Legal disclaimer
              Center(
                child: Text(
                  "By tapping 'Continue', you agree to our Terms of Service.\n Learn how we process your data in Privacy Policy and Cookies Policy.",
                  style: AppTextStyles.verySmall(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(20)),

              // Go back link
              Center(
                child: GoBackLink(
                  onTap: () {
                    Get.toNamed(Routes.SOCIAL_MEDIA);
                  },
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Continue button
              Obx(() {
                final enabled = controller.isEmailValid;

                return CustomContinueButton(
                  onPressed: enabled
                      ? () {
                          debugPrint('Email: ${controller.email.value}');
                          Get.toNamed(Routes.LIFESTYLE_HABITS);
                        }
                      : null, // IMPORTANT: prefer null to disable taps
                  isEnabled: enabled,
                  backgroundColor: enabled
                      ? AppColors
                            .cFF006C6A // enabled color
                      : AppColors.cFF4E535A, // disabled color
                );
              }),

              SizedBox(height: MediaQueryUtil.spacing(30)),
            ],
          ),
        ),
      ),
    );
  }
}
