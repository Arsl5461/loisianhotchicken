import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
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

import 'package:OApp/core/constants/app_colors.dart';

class ReligiousViewsScreen extends GetView<ProfileController> {
  const ReligiousViewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Progress bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(20),
                ),
                child: ProgressTracker(
                  progress: 5 / 16, // Step 5 of 16
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
                          'What are your religious views?',
                          style: AppTextStyles.large(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(10)),

                        // Instructional text
                        // Text(
                        //   'For access to the beta, please use the same email as our waitlist. Your email can be used for account',
                        //   style: AppTextStyles.small(
                        //     fontWeight: AppFontWeight.semi,
                        //     color: AppColors.grey[600],
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                        SizedBox(height: MediaQueryUtil.spacing(20)),

                        // Grid View - 2 items per row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final spacing = MediaQueryUtil.spacing(8);
                            final itemWidth =
                                (constraints.maxWidth - spacing) / 2;

                            final views = HardCodedData.religiousViews;

                            return Wrap(
                              alignment: WrapAlignment.center,
                              spacing: spacing,
                              runSpacing: spacing,
                              children: views.map((view) {
                                final isSelected =
                                    controller.profile.value.religiousViews ==
                                    view;

                                return SizedBox(
                                  width: itemWidth,
                                  child: SelectionBox(
                                    text: view,
                                    isSelected: isSelected,
                                    onTap: () {
                                      controller.profile.value.religiousViews =
                                          view;
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

                        // "Prefer not to say" option
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
                  bottom: keyboardHeight > 0
                      ? keyboardHeight + MediaQueryUtil.spacing(12)
                      : MediaQueryUtil.spacing(24),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      DisplayToggle(
                        label: 'Display on profile',
                        value: controller.profile.value.showReligion,
                        onChanged: (value) {
                          controller.profile.value.showReligion = value;
                          controller.profile.refresh();
                        },
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),

                      // Bottom navigation with Skip and chevron button
                      BottomNavigationWithSkip(
                        onSkip: () {
                          Get.toNamed(Routes.LANGUAGE_SELECTION);
                        },
                        onContinue: () {
                          Get.toNamed(Routes.LANGUAGE_SELECTION);
                        },
                        isEnabled:
                            controller.profile.value.religiousViews != null,
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
