import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../hardcoded_data.dart';
import '../../../widgets/Selection/SelectionBox.dart';
import '../../../widgets/Toggle/DisplayToggle.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Progress/ProgressTracker.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PoliticsScreen extends GetView<ProfileController> {
  const PoliticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(20),
              vertical: MediaQueryUtil.spacing(16),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQueryUtil.spacing(16)),

                        // Progress bar
                        ProgressTracker(
                          progress: 14 / 16, // Step 14 of 16
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),

                        // Title
                        Text(
                          "What are your politics",
                          style: AppTextStyles.large(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(10)),

                        Text(
                          'Choose the option that best matches your political views.',
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.semi,
                            color: AppColors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(32)),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Political Affiliation',
                            style: AppTextStyles.small(
                              fontWeight: AppFontWeight.semi,
                              color: AppColors.grey[600],
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(12)),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final spacing = MediaQueryUtil.spacing(8);
                            final itemWidth =
                                (constraints.maxWidth - (spacing * 2)) / 3;

                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: HardCodedData.politicsOptions.map((
                                option,
                              ) {
                                final isSelected =
                                    controller
                                        .profile
                                        .value
                                        .politicalAffiliation ==
                                    option;

                                return SizedBox(
                                  width: itemWidth,
                                  child: SelectionBox(
                                    text: option,
                                    isSelected: isSelected,
                                    onTap: () {
                                      controller
                                              .profile
                                              .value
                                              .politicalAffiliation =
                                          option;
                                      controller.profile.refresh();
                                    },
                                    selectedBorderColor: AppColors.cFF006C6A,
                                    unselectedBorderColor: AppColors.grey[400],
                                    backgroundColor: AppColors.white,
                                    borderRadius: MediaQueryUtil.spacing(12),
                                    borderWidth: 1.4,
                                    height: MediaQueryUtil.dynamicSize(
                                      small: 52,
                                      medium: 56,
                                      large: 60,
                                      extraSmall: 48,
                                      extraLarge: 64,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: MediaQueryUtil.fontSize(13),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),

                        DisplayToggle(
                          label: 'Display on profile',
                          value:
                              controller.profile.value.showPoliticalAffiliation,
                          onChanged: (value) {
                            controller.profile.value.showPoliticalAffiliation =
                                value;
                            controller.profile.refresh();
                          },
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),
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
                        Center(
                          child: GoBackLink(
                            onTap: () {
                              Get.toNamed(Routes.ICEBREAKERS);
                            },
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(16)),

                        CustomContinueButton(
                          onPressed:
                              controller.profile.value.politicalAffiliation !=
                                  null
                              ? () {
                                  debugPrint(
                                    'Politics: ${controller.profile.value.politicalAffiliation}',
                                  );
                                  Get.toNamed(Routes.IMAGE_SELECTION);
                                }
                              : null,
                          isEnabled:
                              controller.profile.value.politicalAffiliation !=
                              null,
                          backgroundColor: AppColors.cFF4E535A,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
