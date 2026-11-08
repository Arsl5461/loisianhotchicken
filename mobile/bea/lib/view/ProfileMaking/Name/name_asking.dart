import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../widgets/Input/CustomTextField.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Progress/ProgressTracker.dart';

import 'package:OApp/core/constants/app_colors.dart';

class NameAskingScreen extends GetView<ProfileController> {
  const NameAskingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(20),
            vertical: MediaQueryUtil.spacing(16),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // Progress bar
                      ProgressTracker(progress: 10 / 16),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(14),
                        ),
                        child: Text(
                          "Let's get started with basics.",
                          style: AppTextStyles.large(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(50)),

                      // Question
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "What is your name?",
                          style: AppTextStyles.medium(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // First name input field
                      CustomTextField(
                        controller: controller.firstNameController,
                        hintText: 'First name',
                        hintStyle: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey,
                        ),
                        focusColor: AppColors.cFF006C6A,
                        onChanged: (value) {
                          controller.profile.value.fullName = value;
                          controller.profile.refresh();
                        },
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
                  top: MediaQueryUtil.spacing(16),
                  bottom: MediaQueryUtil.spacing(24),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Center(
                        child: GoBackLink(
                          onTap: () {
                            Get.toNamed(Routes.TERMS_AND_GUIDELINES);
                          },
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // Continue button
                      Obx(() {
                        final isEnabled =
                            (controller.profile.value.fullName ?? "")
                                .trim()
                                .isNotEmpty;

                        return CustomContinueButton(
                          onPressed: isEnabled
                              ? () {
                                  controller.profile.value.fullName = controller
                                      .firstName
                                      .value
                                      .trim();
                                  controller.profile.refresh();
                                  Get.toNamed(Routes.SOCIAL_MEDIA);
                                }
                              : null,
                          isEnabled: isEnabled,
                          backgroundColor: AppColors.cFF4E535A,
                          text: 'Continue',
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
