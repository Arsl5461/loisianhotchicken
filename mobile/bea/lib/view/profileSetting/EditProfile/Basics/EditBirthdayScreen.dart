import 'package:OApp/hardcoded_data.dart';
import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import 'package:OApp/core/constants/app_colors.dart';

class EditBirthdayScreen extends GetView<EditController> {
  const EditBirthdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    void saveAndGoBack() => Get.back();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(
              title: 'Birthday',
              onBack: saveAndGoBack,
              onClose: saveAndGoBack,
            ),

            SizedBox(height: MediaQueryUtil.spacing(100)),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQueryUtil.spacing(20),
                        vertical: MediaQueryUtil.spacing(10),
                      ),
                      child: Text(
                        'Only your age and zodiac sign are displayed',
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    _buildDatePicker(),

                    /// AGE
                    Obx(() {
                      final age = controller.calculatedAge.value;
                      if (age == null) return const SizedBox.shrink();

                      return Text(
                        '$age years old',
                        style: AppTextStyles.large(
                          fontFamily: AppFontFamily.publicSans,
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.black,
                        ),
                      );
                    }),

                    SizedBox(height: MediaQueryUtil.spacing(8)),

                    /// ZODIAC
                    Obx(() {
                      final zodiac = controller.zodiacSign.value;
                      if (zodiac == null) return const SizedBox.shrink();

                      return Text(
                        zodiac,
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.grey[600],
                        ),
                      );
                    }),

                    SizedBox(height: MediaQueryUtil.spacing(40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    final itemExtent = MediaQueryUtil.dynamicSize(
      small: 44,
      medium: 48,
      large: 52,
      extraSmall: 42,
      extraLarge: 56,
    );

    return SizedBox(
      width: MediaQueryUtil.dynamicSize(
        small: 300,
        medium: 340,
        large: 380,
        extraSmall: 280,
        extraLarge: 420,
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
          Positioned.fill(
            child: Center(
              child: Container(
                height: itemExtent,
                decoration: BoxDecoration(
                  color: AppColors.cFFDEDEDE.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(8),
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            final currentDate =
                controller.selectedDate.value ?? DateTime(1995, 4, 25);

            return Row(
              children: [
                Expanded(
                  child: _buildPickerColumn(
                    HardCodedData.monthNames(),
                    currentDate.month,
                    (value) {
                      controller.selectedDate.value = DateTime(
                        currentDate.year,
                        value,
                        currentDate.day,
                      );
                      controller.calculateAge();
                    },
                    isMonth: true,
                  ),
                ),

                Expanded(
                  child: _buildPickerColumn(_getDays(), currentDate.day, (
                    value,
                  ) {
                    controller.selectedDate.value = DateTime(
                      currentDate.year,
                      currentDate.month,
                      value,
                    );
                    controller.calculateAge();
                  }),
                ),

                Expanded(
                  child: _buildPickerColumn(_getYears(), currentDate.year, (
                    value,
                  ) {
                    controller.selectedDate.value = DateTime(
                      value,
                      currentDate.month,
                      currentDate.day,
                    );
                    controller.calculateAge();
                  }),
                ),
              ],
            );
          }),
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

    int initialIndex = isMonth
        ? selectedValue - 1
        : items.indexOf(selectedValue.toString());

    if (initialIndex < 0) initialIndex = 0;
    if (initialIndex >= items.length) initialIndex = items.length - 1;

    return ListWheelScrollView.useDelegate(
      itemExtent: itemExtent,
      diameterRatio: 1.1,
      perspective: 0.005,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialIndex),
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
          final item = items[index];

          bool isSelected = isMonth
              ? (index + 1) == selectedValue
              : item == selectedValue.toString();

          return Center(
            child: Text(
              item,
              style: AppTextStyles.text(
                customSize: isSelected ? 20 : 16,
                color: isSelected ? AppColors.black87 : AppColors.grey[400],
                fontWeight: isSelected
                    ? AppFontWeight.semiBold
                    : AppFontWeight.regular,
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _getDays() =>
      List.generate(31, (index) => (index + 1).toString());

  List<String> _getYears() {
    final currentYear = DateTime.now().year;
    return List.generate(100, (index) => (currentYear - 18 - index).toString());
  }
}
