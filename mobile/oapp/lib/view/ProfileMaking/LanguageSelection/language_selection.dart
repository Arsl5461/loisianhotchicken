import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../hardcoded_data.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Selection/SelectionBox.dart';
import '../../../widgets/Toggle/DisplayToggle.dart';
import '../../../widgets/Navigation/BottomNavigationWithSkip.dart';
import '../../../widgets/Progress/ProgressTracker.dart';
import '../profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LanguageSelectionScreen extends GetView<ProfileController> {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Progress indicator
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(20),
                ),
                child: ProgressTracker(
                  progress: 6 / 16, // Step 6 of 16
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(24)),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Which languages do you speak?',
                          style: AppTextStyles.large(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(10)),

                        SizedBox(height: MediaQueryUtil.spacing(10)),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final spacing = MediaQueryUtil.spacing(8);
                            final itemWidth =
                                (constraints.maxWidth - spacing) / 2;

                            return Wrap(
                              alignment: WrapAlignment.center,
                              spacing: spacing,
                              runSpacing: spacing,
                              children: HardCodedData.languages.map((language) {
                                final isSelected = controller
                                    .profile
                                    .value
                                    .languages
                                    .contains(language);

                                return SizedBox(
                                  width: itemWidth,
                                  child: SelectionBox(
                                    text: language,
                                    isSelected: isSelected,
                                    onTap: () {
                                      if (!isSelected) {
                                        controller.profile.value.languages.add(
                                          language,
                                        );
                                      } else {
                                        controller.profile.value.languages
                                            .remove(language);
                                      }
                                      controller.profile.refresh();
                                    },
                                    selectedBorderColor: AppColors.cFF006C6A,
                                    unselectedBorderColor: AppColors.grey[400],
                                    backgroundColor: AppColors.white,
                                    borderRadius: MediaQueryUtil.spacing(12),
                                    borderWidth: 1.4,
                                    height: MediaQueryUtil.dynamicSize(
                                      small: 45,
                                      medium: 50,
                                      large: 55,
                                      extraSmall: 42,
                                      extraLarge: 60,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: MediaQueryUtil.fontSize(14),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(20)),

                        // "Other" option
                        SizedBox(height: MediaQueryUtil.spacing(20)),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Section
              AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: MediaQueryUtil.spacing(20),
                  right: MediaQueryUtil.spacing(20),
                  top: MediaQueryUtil.spacing(16),
                  bottom: MediaQueryUtil.spacing(24),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      // Display on profile toggle
                      DisplayToggle(
                        label: 'Display on profile',
                        value: controller.profile.value.showLanguages,
                        onChanged: (value) {
                          controller.profile.value.showLanguages = value;
                          controller.profile.refresh();
                        },
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),

                      // Bottom navigation with Skip and chevron button
                      BottomNavigationWithSkip(
                        onSkip: () {
                          Get.toNamed(Routes.ETHNICITY_SELECTION);
                        },
                        onContinue: () {
                          Get.toNamed(Routes.ETHNICITY_SELECTION);
                        },
                        isEnabled:
                            controller.profile.value.languages.isNotEmpty,
                      ),
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
