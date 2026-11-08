import 'package:OApp/widgets/Selection/selectableBox.dart';
import 'package:OApp/widgets/Input/CustomTextField.dart';
import 'package:OApp/widgets/Toggle/DisplayToggle.dart';
import 'package:OApp/widgets/Navigation/GoBackLink.dart';
import 'package:OApp/widgets/Buttons/customContinueButton.dart';
import 'package:OApp/widgets/Progress/ProgressTracker.dart';
import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../hardcoded_data.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EducationSelectionScreen extends GetView<ProfileController> {
  const EducationSelectionScreen({super.key});

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
                          progress: 8 / 16, // Step 8 of 16
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),

                        // Title
                        Text(
                          'What is your highest level of education?',
                          style: AppTextStyles.large(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(10)),

                        Text(
                          'Add your school and choose the highest level you completed.',
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.semi,
                            color: AppColors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(32)),

                        // School input field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'School',
                              style: AppTextStyles.verySmall(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(8)),
                            CustomTextField(
                              controller: controller.schoolNameController,
                              hintText: 'School Name',
                              hintStyle: AppTextStyles.regular(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey,
                              ),
                              focusColor: AppColors.cFF006C6A,
                              onChanged: (value) {
                                controller.profile.value.schoolName = value;
                                controller.profile.refresh();
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),

                        // Education level selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Highest level of education completed',
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(12)),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final spacing = MediaQueryUtil.spacing(12);
                                final itemWidth =
                                    (constraints.maxWidth - (spacing * 2)) / 3;

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  children: HardCodedData.educationLevels.map((
                                    level,
                                  ) {
                                    final isSelected =
                                        controller.profile.value.education ==
                                        level;

                                    return SizedBox(
                                      width: itemWidth,
                                      child: SelectableBox(
                                        text: level,
                                        isSelected: isSelected,
                                        onTap: () {
                                          controller.profile.value.education =
                                              level;
                                          controller.profile.refresh();
                                        },
                                        selectedBackgroundColor:
                                            AppColors.cFF006C6A,
                                        borderRadius: MediaQueryUtil.spacing(
                                          12,
                                        ),
                                        textSize: MediaQueryUtil.fontSize(12),
                                        height: MediaQueryUtil.dynamicSize(
                                          small: 60,
                                          medium: 65,
                                          large: 70,
                                          extraSmall: 58,
                                          extraLarge: 75,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),

                        // Divider
                        Container(height: 1, color: AppColors.grey[300]),

                        SizedBox(height: MediaQueryUtil.spacing(8)),

                        // Display toggle
                        DisplayToggle(
                          label: 'Display on profile',
                          value: controller.profile.value.showSchoolName,
                          onChanged: (value) {
                            controller.profile.value.showSchoolName = value;
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
                              Get.toNamed(Routes.ETHNICITY_SELECTION);
                            },
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(16)),

                        CustomContinueButton(
                          onPressed:
                              (controller.profile.value.education != null &&
                                  controller
                                      .schoolNameController
                                      .text
                                      .isNotEmpty)
                              ? () {
                                  controller.profile.value.schoolName =
                                      controller.schoolNameController.text;
                                  controller.profile.refresh();

                                  controller.addUserByIndex(index: 2);
                                }
                              : () {},
                          isEnabled:
                              controller.profile.value.education != null &&
                              controller.schoolNameController.text.isNotEmpty,
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
