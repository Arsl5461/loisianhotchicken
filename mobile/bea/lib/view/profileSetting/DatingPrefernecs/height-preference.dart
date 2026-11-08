import 'package:OApp/controller/home_controller.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/sub_widgets/common_dating_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../hardcoded_data.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class HeightPreference extends GetView<HomeController> {
  const HeightPreference({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(),
          child: SafeArea(
            child: Column(
              children: [
                // Back button
                CommonDatingWidgets.goBackNavigation(),
                // Main content area
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQueryUtil.spacing(40)),

                        // Title
                        Text(
                          "What height do you prefer?",
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(28),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black87,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(40)),

                        // Height picker - Single 3D wheel
                        Obx(() => _buildHeightPicker()),

                        SizedBox(height: MediaQueryUtil.spacing(40)),

                        SizedBox(height: MediaQueryUtil.spacing(20)),

                        // Go back link
                        CommonDatingWidgets.goBackButton(),

                        // This will push the button to the bottom
                        Spacer(),
                      ],
                    ),
                  ),
                ),

                // Bottom spacing
                SizedBox(height: MediaQueryUtil.spacing(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeightPicker() {
    return Center(
      child: SizedBox(
        width: MediaQueryUtil.dynamicSize(
          small: 200,
          medium: 250,
          large: 300,
          extraSmall: 180,
          extraLarge: 350,
        ),
        height: MediaQueryUtil.dynamicSize(
          small: 300,
          medium: 350,
          large: 400,
          extraSmall: 280,
          extraLarge: 450,
        ),
        child: ListWheelScrollView.useDelegate(
          itemExtent: MediaQueryUtil.dynamicSize(
            small: 50,
            medium: 60,
            large: 70,
            extraSmall: 45,
            extraLarge: 80,
          ),
          diameterRatio: 1.2, // Bigger 3D effect
          perspective: 0.001, // Stronger 3D perspective
          physics: const FixedExtentScrollPhysics(),
          controller: FixedExtentScrollController(
            initialItem: controller.datingPreferences.value.height != null
                ? HardCodedData.heightOptions.indexOf(
                    controller.datingPreferences.value.height!,
                  )
                : 0,
          ),
          onSelectedItemChanged: (index) {
            controller.datingPreferences.value = controller
                .datingPreferences
                .value
                .copyWith(
                  height:
                      index >= 0 && index < HardCodedData.heightOptions.length
                      ? HardCodedData.heightOptions[index]
                      : null,
                );
            HardCodedData.heightOptions[index];
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: HardCodedData.heightOptions.length,
            builder: (context, index) {
              if (index < 0 || index >= HardCodedData.heightOptions.length) {
                return null;
              }
              final heightText = HardCodedData.heightOptions[index];
              final isSelected =
                  heightText == controller.datingPreferences.value.height;

              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQueryUtil.spacing(4),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.cFF006C6A
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(12),
                  ),
                  border: isSelected
                      ? Border.all(color: AppColors.grey[300]!, width: 1)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.cFF006C6A.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    heightText,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(isSelected ? 22 : 18),
                      color: isSelected ? AppColors.white : AppColors.grey[600],
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
