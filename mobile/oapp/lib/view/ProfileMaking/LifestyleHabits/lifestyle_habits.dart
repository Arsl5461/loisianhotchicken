import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../hardcoded_data.dart';
import '../../../widgets/Selection/selectableBox.dart';
import '../../../widgets/Toggle/DisplayToggle.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Progress/ProgressTracker.dart';
import '../profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LifestyleHabitsScreen extends GetView<ProfileController> {
  const LifestyleHabitsScreen({super.key});

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
                      ProgressTracker(
                        progress: 12 / 16, // Step 12 of 16
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Title
                      Text(
                        "Lifestyle and Habits",
                        style: AppTextStyles.large(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(10)),

                      // Instructional text
                      Text(
                        "Share as much as you're comfortable with",
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(32)),

                      // Drinking section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Drinking',
                            style: AppTextStyles.medium(
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: MediaQueryUtil.spacing(20)),
                          Obx(
                            () => Row(
                              children: HardCodedData.habitOptions.map((
                                option,
                              ) {
                                final isSelected =
                                    controller.profile.value.drinking == option;

                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          option !=
                                              HardCodedData.habitOptions.last
                                          ? MediaQueryUtil.spacing(8)
                                          : 0,
                                    ),
                                    child: SelectableBox(
                                      text: option,
                                      isSelected: isSelected,
                                      onTap: () {
                                        controller.profile.value.drinking =
                                            option;
                                        controller.profile.refresh();
                                      },
                                      selectedBackgroundColor:
                                          AppColors.cFF006C6A,
                                      borderRadius: MediaQueryUtil.spacing(12),
                                      textSize: MediaQueryUtil.fontSize(14),
                                      height: MediaQueryUtil.dynamicSize(
                                        small: 50,
                                        medium: 55,
                                        large: 60,
                                        extraSmall: 48,
                                        extraLarge: 65,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Smoking section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smoking',
                            style: AppTextStyles.medium(
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: MediaQueryUtil.spacing(20)),
                          Obx(
                            () => Row(
                              children: HardCodedData.habitOptions.map((
                                option,
                              ) {
                                final isSelected =
                                    controller.profile.value.smoking == option;

                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          option !=
                                              HardCodedData.habitOptions.last
                                          ? MediaQueryUtil.spacing(8)
                                          : 0,
                                    ),
                                    child: SelectableBox(
                                      text: option,
                                      isSelected: isSelected,
                                      onTap: () {
                                        controller.profile.value.smoking =
                                            option;
                                        controller.profile.refresh();
                                      },
                                      selectedBackgroundColor:
                                          AppColors.cFF006C6A,
                                      borderRadius: MediaQueryUtil.spacing(12),
                                      textSize: MediaQueryUtil.fontSize(14),
                                      height: MediaQueryUtil.dynamicSize(
                                        small: 50,
                                        medium: 55,
                                        large: 60,
                                        extraSmall: 48,
                                        extraLarge: 65,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Display toggle
                      Obx(
                        () => DisplayToggle(
                          label: 'Display on profile',
                          value: controller.profile.value.showDrinking,
                          onChanged: (value) {
                            controller.profile.value.showDrinking = value;
                            controller.profile.value.showSmoking = value;
                            controller.profile.refresh();
                          },
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
                            Get.toNamed(Routes.EMAIL);
                          },
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // Continue button
                      Obx(
                        () => CustomContinueButton(
                          onPressed:
                              (controller.profile.value.drinking != null &&
                                  controller.profile.value.smoking != null)
                              ? () {
                                  controller.addUserByIndex(index: 3);
                                }
                              : () {},
                          isEnabled:
                              controller.profile.value.drinking != null &&
                              controller.profile.value.smoking != null,
                          backgroundColor: AppColors.cFF4E535A,
                        ),
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
