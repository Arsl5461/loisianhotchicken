import 'package:OApp/hardcoded_data.dart';
import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Progress/ProgressTracker.dart';

import 'package:OApp/core/constants/app_colors.dart';

class AgePickerPage extends GetView<ProfileController> {
  const AgePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
                progress: 2 / 16, // Step 2 of 16
              ),

              SizedBox(height: MediaQueryUtil.spacing(24)),

              // Title
              Text(
                "When's your\n birthday?",
                style: AppTextStyles.large(fontWeight: AppFontWeight.semiBold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQueryUtil.spacing(40)),

              // Age display
              Obx(() {
                if (controller.calculatedAge != null) {
                  return Column(
                    children: [
                      Text(
                        'YOU ARE',
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(8)),
                      Text(
                        '${controller.calculatedAge} years old',
                        style: AppTextStyles.heading(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),

              SizedBox(height: MediaQueryUtil.spacing(60)),

              // Date picker
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: MediaQueryUtil.dynamicSize(
                      small: 300,
                      medium: 350,
                      large: 400,
                      extraSmall: 280,
                      extraLarge: 450,
                    ),
                    child: _buildDatePicker(),
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(30)),

              // Go back link
              SizedBox(height: MediaQueryUtil.spacing(14)),
              Obx(
                () => AnimatedPadding(
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
                    child: Column(
                      children: [
                        // Go back link
                        GoBackLink(
                          onTap: () {
                            Get.toNamed(Routes.GENDER_SELECTION);
                          },
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(14)),

                        // Continue button
                        CustomContinueButton(
                          onPressed: () {
                            Get.toNamed(Routes.HOMETOWN);
                          },
                          isEnabled:
                              controller.profile.value.dateOfBirth != null,
                        ),
                      ],
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

  Widget _buildDatePicker() {
    return SizedBox(
      width: MediaQueryUtil.dynamicSize(
        small: 300,
        medium: 340,
        large: 380,
        extraSmall: 280,
        extraLarge: 420,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Column headers
          Row(
            children: [
              Expanded(
                child: Text(
                  'Month',
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Day',
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Year',
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQueryUtil.spacing(12)),

          // Scrollable date pickers
          SizedBox(
            height: MediaQueryUtil.dynamicSize(
              small: 200,
              medium: 220,
              large: 240,
              extraSmall: 180,
              extraLarge: 260,
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

                // Date picker wheels
                Obx(
                  () => Row(
                    children: [
                      // Month picker
                      Expanded(
                        child: _buildPickerColumn(
                          HardCodedData.monthNames(),
                          controller.selectedDate?.month ?? 4,
                          (value) {
                            controller.selectedDate = DateTime(
                              controller.selectedDate?.year ?? 1995,
                              value,
                              controller.selectedDate?.day ?? 25,
                            );
                            controller.calculateAge();
                            controller.profile.value.dateOfBirth = controller
                                .getSelectedDate(controller.selectedDate!);
                          },
                          isMonth: true,
                        ),
                      ),

                      // Day picker
                      Expanded(
                        child: _buildPickerColumn(
                          _getDays(),
                          controller.selectedDate?.day ?? 25,
                          (value) {
                            controller.selectedDate = DateTime(
                              controller.selectedDate?.year ?? 1995,
                              controller.selectedDate?.month ?? 4,
                              value,
                            );
                            controller.calculateAge();
                          },
                        ),
                      ),

                      // Year picker
                      Expanded(
                        child: _buildPickerColumn(
                          _getYears(),
                          controller.selectedDate?.year ?? 1995,
                          (value) {
                            controller.selectedDate = DateTime(
                              value,
                              controller.selectedDate?.month ?? 4,
                              controller.selectedDate?.day ?? 25,
                            );
                            controller.calculateAge();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerColumn(
    List<String> items,
    int selectedValue,
    Function(int) onChanged, {
    bool isMonth = false,
  }) {
    final itemExtent = MediaQueryUtil.dynamicSize(
      small: 44,
      medium: 48,
      large: 52,
      extraSmall: 42,
      extraLarge: 56,
    );

    int initialIndex;
    if (isMonth) {
      initialIndex = selectedValue - 1;
    } else {
      initialIndex = items.indexOf(selectedValue.toString());
    }

    return ListWheelScrollView.useDelegate(
      itemExtent: itemExtent,
      diameterRatio: 1.5,
      perspective: 0.003,
      physics: FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(
        initialItem: initialIndex >= 0 ? initialIndex : 0,
      ),
      onSelectedItemChanged: (index) {
        if (index >= 0 && index < items.length) {
          if (isMonth) {
            onChanged(index + 1);
          } else {
            onChanged(int.parse(items[index]));
          }
        }
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, index) {
          if (index < 0 || index >= items.length) return null;

          final item = items[index];
          bool isSelected;
          if (isMonth) {
            isSelected = (index + 1) == selectedValue;
          } else {
            isSelected = item == selectedValue.toString();
          }

          return Container(
            alignment: Alignment.center,
            child: Text(
              item,
              style: AppTextStyles.medium(
                color: isSelected ? AppColors.black87 : AppColors.grey[400],
                fontWeight: isSelected
                    ? AppFontWeight.semiBold
                    : AppFontWeight.semi,
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _getDays() {
    return List.generate(31, (index) => (index + 1).toString());
  }

  List<String> _getYears() {
    final currentYear = DateTime.now().year;
    return List.generate(100, (index) => (currentYear - 18 - index).toString());
  }
}
