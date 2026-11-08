import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../../../../widgets/Toggle/DisplayToggle.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditHeightScreen extends GetView<EditController> {
  const EditHeightScreen({super.key});

  void _saveAndGoBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              EditProfileHeader(
                title: 'Height',
                onBack: _saveAndGoBack,
                onClose: _saveAndGoBack,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: _buildHeightPicker())),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQueryUtil.spacing(20),
                        vertical: MediaQueryUtil.spacing(16),
                      ),
                      child: DisplayToggle(
                        label: 'Display on profile',
                        value: controller.user.value?.showHeight ?? false,
                        onChanged: (bool value) {
                          controller.user.value?.showHeight = value;
                          controller.user.refresh();
                        },
                        activeColor: AppColors.cFF006C6A,
                        labelStyle: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeightPicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up_outlined),
          onPressed: () {
            if (controller.selectedHeightIndex.value > 0) {
              controller.selectedHeightIndex.value--;

              controller.heightScrollController.animateToItem(
                controller.selectedHeightIndex.value,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
        SizedBox(
          width: MediaQueryUtil.dynamicSize(
            small: 320,
            medium: 350,
            large: 380,
            extraSmall: 300,
            extraLarge: 400,
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
                    height: MediaQueryUtil.dynamicSize(
                      small: 56,
                      medium: 60,
                      large: 64,
                      extraSmall: 52,
                      extraLarge: 68,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cFFDEDEDE.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(
                        MediaQueryUtil.spacing(14),
                      ),
                    ),
                  ),
                ),
              ),
              ListWheelScrollView.useDelegate(
                itemExtent: MediaQueryUtil.dynamicSize(
                  small: 44,
                  medium: 48,
                  large: 52,
                  extraSmall: 42,
                  extraLarge: 56,
                ),
                diameterRatio: 2.5,
                perspective: 0.002,
                physics: const FixedExtentScrollPhysics(),
                controller: controller.heightScrollController,
                onSelectedItemChanged: (index) {
                  if (index >= 0 && index < controller.heightOptions.length) {
                    controller.selectedHeightIndex.value = index;
                    controller.user.value?.height =
                        controller.heightOptions[index];
                    controller.user.refresh();
                  }
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: controller.heightOptions.length,
                  builder: (context, index) {
                    if (index < 0 || index >= controller.heightOptions.length) {
                      return null;
                    }

                    final heightText = controller.heightOptions[index];
                    final isSelected =
                        index == controller.selectedHeightIndex.value;
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        heightText,
                        style: AppTextStyles.text(
                          customSize: isSelected ? 22 : 16,
                          color: isSelected
                              ? AppColors.black87
                              : AppColors.grey[400],
                          fontWeight: isSelected
                              ? AppFontWeight.semiBold
                              : AppFontWeight.regular,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          onPressed: () {
            if (controller.selectedHeightIndex.value <
                controller.heightOptions.length - 1) {
              controller.selectedHeightIndex.value++;

              controller.heightScrollController.animateToItem(
                controller.selectedHeightIndex.value,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ],
    );
  }
}
