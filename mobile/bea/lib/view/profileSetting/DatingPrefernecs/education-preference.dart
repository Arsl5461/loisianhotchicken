import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/hardcoded_data.dart';

import '../../../controller/home_controller.dart';
import 'sub_widgets/common_dating_widgets.dart';

class EducationPreference extends GetView<HomeController> {
  const EducationPreference({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Back Button
            CommonDatingWidgets.goBackNavigation(),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQueryUtil.spacing(40)),

                    /// Title
                    Text(
                      "Education",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(28),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black87,
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(40)),

                    /// Education Options
                    Expanded(
                      child: ListView.builder(
                        itemCount: HardCodedData.educationLevels.length,
                        itemBuilder: (context, index) {
                          final education =
                              HardCodedData.educationLevels[index];

                          return Obx(() {
                            final isSelected =
                                controller.datingPreferences.value.education ==
                                education;
                            return GestureDetector(
                              onTap: () {
                                controller.datingPreferences.value = controller
                                    .datingPreferences
                                    .value
                                    .copyWith(education: education);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: MediaQueryUtil.spacing(12),
                                ),
                                height: MediaQueryUtil.dynamicSize(
                                  small: 50,
                                  medium: 55,
                                  large: 60,
                                  extraSmall: 48,
                                  extraLarge: 65,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.cFF006A68
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.cFF006A68
                                        : AppColors.grey[300]!,
                                  ),
                                ),
                                child: Text(
                                  education,
                                  style: TextStyle(
                                    fontSize: MediaQueryUtil.fontSize(16),
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.black87,
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(30)),

                    /// Go back
                    CommonDatingWidgets.goBackButton(),

                    SizedBox(height: MediaQueryUtil.spacing(30)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
