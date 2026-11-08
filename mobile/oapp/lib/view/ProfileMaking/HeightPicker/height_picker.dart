import 'package:OApp/widgets/Buttons/customContinueButton.dart';
import 'package:OApp/widgets/Navigation/GoBackLink.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Progress/ProgressTracker.dart';
import '../../../widgets/Toggle/DisplayToggle.dart';
import '../profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class HeightPickerPage extends GetView<ProfileController> {
  const HeightPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(20)),
          child: Column(
            children: [
              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Progress bar
              ProgressTracker(
                progress: 4 / 16, // Step 4 of 16
              ),

              SizedBox(height: MediaQueryUtil.spacing(25)),

              // Title
              Text(
                'How tall are you?',
                style: AppTextStyles.large(fontWeight: AppFontWeight.semiBold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQueryUtil.spacing(20)),

              // Subtitle
              Text(
                "Some people may filter their dating by height. It's best to be honest!",
                style: AppTextStyles.regular(
                  fontWeight: AppFontWeight.semi,
                  color: AppColors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              // Height picker
              Expanded(child: Center(child: _buildHeightPicker(controller))),

              Obx(
                () => DisplayToggle(
                  label: "Display on profile",
                  value: controller.profile.value.showHeight,
                  onChanged: (value) {
                    controller.profile.value.showHeight = value;
                    controller.profile.refresh();
                  },
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
                      // Go back link
                      GoBackLink(
                        onTap: () {
                          Get.toNamed(Routes.HOMETOWN);
                        },
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(14)),

                      // Continue button
                      CustomContinueButton(
                        onPressed: () {
                          controller.addUserByIndex(index: 1);
                        },
                        isEnabled: true,
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

  Widget _buildHeightPicker(ProfileController controller) {
    return SizedBox(
      width: MediaQueryUtil.dynamicSize(
        small: 220,
        medium: 250,
        large: 280,
        extraSmall: 200,
        extraLarge: 300,
      ),
      height: MediaQueryUtil.dynamicSize(
        small: 280,
        medium: 320,
        large: 360,
        extraSmall: 260,
        extraLarge: 400,
      ),
      child: Stack(
        children: [
          // Highlight bar
          Positioned.fill(
            child: Center(
              child: Container(
                height: MediaQueryUtil.dynamicSize(
                  small: 44,
                  medium: 48,
                  large: 52,
                  extraSmall: 42,
                  extraLarge: 56,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cFFDEDEDE.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(8),
                  ),
                ),
              ),
            ),
          ),

          // Height picker list
          Obx(
            () => ListWheelScrollView.useDelegate(
              itemExtent: MediaQueryUtil.dynamicSize(
                small: 44,
                medium: 48,
                large: 52,
                extraSmall: 42,
                extraLarge: 56,
              ),
              diameterRatio: 1.1,
              perspective: 0.005,
              physics: FixedExtentScrollPhysics(),
              controller: FixedExtentScrollController(
                initialItem: controller.selectedHeightIndex,
              ),
              onSelectedItemChanged: (index) {
                if (index >= 0 && index < controller.heightOptions.length) {
                  controller.selectedHeightIndex = index;
                  controller.profile.value.height =
                      controller.heightOptions[index];
                  controller.profile.refresh();
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: controller.heightOptions.length,
                builder: (context, index) {
                  if (index < 0 || index >= controller.heightOptions.length) {
                    return null;
                  }

                  final heightText = controller.heightOptions[index];
                  final isSelected = index == controller.selectedHeightIndex;

                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      heightText,
                      style: AppTextStyles.medium(
                        color: isSelected
                            ? AppColors.black87
                            : AppColors.grey[400],
                        fontWeight: isSelected
                            ? AppFontWeight.semiBold
                            : AppFontWeight.semi,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
