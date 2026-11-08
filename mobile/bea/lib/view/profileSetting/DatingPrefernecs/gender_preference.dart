import 'package:OApp/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../hardcoded_data.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

import 'sub_widgets/common_dating_widgets.dart';

class GenderPreferencePage extends GetView<HomeController> {
  const GenderPreferencePage({super.key});

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
                      "Gender Preference",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(28),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black87,
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(40)),

                    /// Gender Options
                    Expanded(
                      child: ListView.builder(
                        itemCount: HardCodedData.genderOptions.length,
                        itemBuilder: (context, index) {
                          final gender = HardCodedData.genderOptions[index];

                          return Obx(() {
                            final isSelected =
                                controller.datingPreferences.value.gender ==
                                gender;

                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  controller.datingPreferences.value =
                                      controller.datingPreferences.value
                                          .copyWith(gender: null);
                                } else {
                                  controller.datingPreferences.value =
                                      controller.datingPreferences.value
                                          .copyWith(gender: gender);
                                }
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
                                  gender,
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

                    /// Go Back Button
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
