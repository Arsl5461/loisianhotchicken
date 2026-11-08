import 'package:OApp/hardcoded_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home_controller.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

import 'sub_widgets/common_dating_widgets.dart';

class PoliticsPreference extends GetView<HomeController> {
  const PoliticsPreference({super.key});

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
                      "What are your political preferences?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(28),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black87,
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(40)),

                    /// Options Grid
                    Expanded(
                      child: GridView.builder(
                        itemCount: HardCodedData.politicalOptions.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 3.8,
                            ),
                        itemBuilder: (context, index) {
                          final politics =
                              HardCodedData.politicalOptions[index];

                          return Obx(() {
                            final isSelected = controller
                                .datingPreferences
                                .value
                                .politics
                                .contains(politics);

                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  controller.datingPreferences.value =
                                      controller.datingPreferences.value
                                          .copyWith(
                                            politics: controller
                                                .datingPreferences
                                                .value
                                                .politics
                                                .where((p) => p != politics)
                                                .toList(),
                                          );
                                } else {
                                  controller.datingPreferences.value =
                                      controller.datingPreferences.value
                                          .copyWith(
                                            politics: [
                                              ...controller
                                                  .datingPreferences
                                                  .value
                                                  .politics,
                                              politics,
                                            ],
                                          );
                                }
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
                                  politics,
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

                    SizedBox(height: MediaQueryUtil.spacing(20)),

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
