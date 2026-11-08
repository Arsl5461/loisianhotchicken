import 'package:OApp/widgets/Selection/selectableBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../hardcoded_data.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../widgets/Toggle/DisplayToggle.dart';
import '../../../widgets/Progress/ProgressTracker.dart';
import '../profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class GenderSelectionPage extends GetView<ProfileController> {
  const GenderSelectionPage({super.key});
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(20),
            vertical: MediaQueryUtil.spacing(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              ProgressTracker(
                progress: 1 / 16, // Step 1 of 16
              ),

              SizedBox(height: MediaQueryUtil.spacing(32)),

              // Title
              Text(
                "Cool, nice to have you",
                style: AppTextStyles.large(fontWeight: AppFontWeight.semiBold),
              ),

              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Subtitle
              Text(
                "Tell us a little bit about your gender and dating preferences",
                style: AppTextStyles.regular(
                  fontWeight: AppFontWeight.semi,
                  color: AppColors.grey[600],
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(80)),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gender Question
                      Text(
                        "What is your gender?",
                        style: AppTextStyles.medium(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      // Gender selection buttons
                      Obx(
                        () => Row(
                          children: HardCodedData.genderOptions.map((gender) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: MediaQueryUtil.spacing(12),
                                ),
                                child: SelectableBox(
                                  text: gender,
                                  isSelected:
                                      controller.profile.value.gender == gender,
                                  onTap: () {
                                    controller.profile.value.gender = gender;
                                    controller.profile.refresh();
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      // Display on profile toggle
                      Obx(
                        () => DisplayToggle(
                          label: "Display on profile",
                          value: controller.profile.value.showGender,
                          onChanged: (value) {
                            controller.profile.value.showGender = value;
                            controller.profile.refresh();
                          },
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),

                      // Dating preference question
                      Text(
                        "Who are you interested in dating?",
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(20),
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      // Dating preference buttons
                      Column(
                        children: [
                          Obx(
                            () => Wrap(
                              spacing: MediaQueryUtil.spacing(
                                15,
                              ), // horizontal space
                              runSpacing: MediaQueryUtil.spacing(
                                12,
                              ), // vertical space
                              children: HardCodedData.datingGenderOptions.map((
                                gender,
                              ) {
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3 -
                                      30,
                                  child: SelectableBox(
                                    text: gender,
                                    isSelected:
                                        controller
                                            .datingPreferences
                                            .value
                                            .gender ==
                                        gender,
                                    onTap: () {
                                      controller
                                              .datingPreferences
                                              .value
                                              .gender =
                                          gender;
                                      controller.datingPreferences.refresh();
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),
                    ],
                  ),
                ),
              ),

              AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  top: MediaQueryUtil.spacing(16),
                  bottom: keyboardHeight > 0
                      ? keyboardHeight + MediaQueryUtil.spacing(12)
                      : MediaQueryUtil.spacing(24),
                ),
                child: SafeArea(
                  top: false,
                  child: Obx(
                    () => CustomContinueButton(
                      isEnabled:
                          controller.profile.value.gender != null &&
                          controller.datingPreferences.value.gender != null,
                      onPressed: () async {
                        Get.toNamed(Routes.AGE_PICKER);

                        debugPrint('');
                      },
                    ),
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
