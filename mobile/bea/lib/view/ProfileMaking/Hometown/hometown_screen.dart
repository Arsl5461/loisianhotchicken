import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Input/CustomTextField.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../widgets/Toggle/DisplayToggle.dart';
import '../../../widgets/Progress/ProgressTracker.dart';
import '../profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class HometownScreen extends GetView<ProfileController> {
  const HometownScreen({super.key});

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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // Progress bar
                      ProgressTracker(
                        progress: 3 / 16, // Step 3 of 16
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Title
                      Text(
                        "Where are you from?",
                        style: AppTextStyles.large(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      // Instructional text
                      Text(
                        "Some people may filter their dating by location. It's best to be honest!",
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(60)),
                      // Hometown input field
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: MediaQueryUtil.spacing(16),
                      //     vertical: MediaQueryUtil.spacing(4),
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: AppColors.white,
                      //     borderRadius: BorderRadius.circular(8),
                      //     boxShadow: [
                      //       BoxShadow(mnvcawaQEWREYR
                      //         color: AppColors.black12,
                      //         blurRadius: 4,
                      //         offset: Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),),
                      CustomTextField(
                        onChanged: (value) {
                          controller.hometownText.value =
                              value; // update Rx variable
                        },
                        controller: controller.hometownController,
                        hintText: 'Hometown',
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),

                      // Display on profile toggle
                      Obx(
                        () => DisplayToggle(
                          label: "Display on profile",
                          value: controller.profile.value.showHometown,
                          onChanged: (value) {
                            controller.profile.value.showHometown = value;
                            controller.profile.refresh();
                          },
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),
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
                      // Go back link
                      GoBackLink(
                        onTap: () {
                          Get.toNamed(Routes.AGE_PICKER);
                        },
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(12)),

                      // Continue button
                      Obx(
                        () => CustomContinueButton(
                          text: "Continue",
                          isEnabled: controller.hometownText.value
                              .trim()
                              .isNotEmpty,
                          onPressed: () {
                            Get.toNamed(Routes.HEIGHT_PICKER);
                          },
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
