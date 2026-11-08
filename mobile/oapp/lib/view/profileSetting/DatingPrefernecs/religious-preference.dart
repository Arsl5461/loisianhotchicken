import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/hardcoded_data.dart';

import '../../../controller/home_controller.dart';
import 'sub_widgets/common_dating_widgets.dart';

class ReligiousPreference extends GetView<HomeController> {
  const ReligiousPreference({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
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
                  children: [
                    SizedBox(height: MediaQueryUtil.spacing(40)),

                    /// Title
                    Text(
                      "What are your religious preferences?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(28),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black87,
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(40)),

                    /// Religion Grid
                    Expanded(
                      child: GridView.builder(
                        itemCount: HardCodedData.religiousViews.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 3.8,
                            ),
                        itemBuilder: (context, index) {
                          final religion = HardCodedData.religiousViews[index];

                          return Obx(() {
                            final isSelected = controller
                                .datingPreferences
                                .value
                                .religion
                                .contains(religion);

                            return GestureDetector(
                              onTap: () {
                                controller.datingPreferences.value = controller
                                    .datingPreferences
                                    .value
                                    .copyWith(religion: [religion]);
                              },
                              child: Container(
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
                                  religion,
                                  style: TextStyle(
                                    fontSize: MediaQueryUtil.fontSize(14),
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

                    /// Go Back
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
