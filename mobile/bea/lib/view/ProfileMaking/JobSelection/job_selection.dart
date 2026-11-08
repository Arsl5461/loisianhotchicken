import 'package:OApp/hardcoded_data.dart';
import 'package:OApp/widgets/Selection/selectableBox.dart';
import 'package:OApp/widgets/Input/CustomTextField.dart';
import 'package:OApp/widgets/Toggle/DisplayToggle.dart';
import 'package:OApp/widgets/Navigation/GoBackLink.dart';
import 'package:OApp/widgets/Buttons/customContinueButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Progress/ProgressTracker.dart';
import '../profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class JobSelectionScreen extends GetView<ProfileController> {
  const JobSelectionScreen({super.key});

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
                          progress: 9 / 16, // Step 9 of 16
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),

                        // Title
                        Text(
                          'What is your job title?',
                          style: AppTextStyles.large(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(20)),

                        // Job Title input field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job Title',
                              style: AppTextStyles.verySmall(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(8)),
                            CustomTextField(
                              controller: controller.jobTitleController,
                              hintText: 'Job Title',
                              hintStyle: AppTextStyles.regular(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey,
                              ),
                              focusColor: AppColors.cFF006C6A,
                              onChanged: (value) {
                                controller.profile.value.jobTitle = value;
                                controller.profile.refresh();
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(15)),

                        // Quick Options selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Options',
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
                                  children: HardCodedData.quickJobOptions.map((
                                    job,
                                  ) {
                                    final isSelected =
                                        controller.profile.value.jobTitle ==
                                        job;

                                    return SizedBox(
                                      width: itemWidth,
                                      child: SelectableBox(
                                        text: job,
                                        isSelected: isSelected,
                                        onTap: () {
                                          controller.profile.value.jobTitle =
                                              job;
                                          controller.jobTitleController.text =
                                              job;
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

                        SizedBox(height: MediaQueryUtil.spacing(15)),

                        // Company Name input field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company Name',
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(8)),
                            CustomTextField(
                              controller: controller.companyNameController,
                              hintText: 'Company Name',
                              hintStyle: AppTextStyles.regular(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey,
                              ),
                              focusColor: AppColors.cFF006C6A,
                              onChanged: (value) {
                                controller.profile.value.companyName = value;
                                controller.profile.refresh();
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(24)),

                        // Divider
                        Container(height: 1, color: AppColors.grey[300]),

                        SizedBox(height: MediaQueryUtil.spacing(12)),

                        // Display toggle
                        DisplayToggle(
                          label: 'Display on profile',
                          value: controller.profile.value.showCompanyName,
                          onChanged: (value) {
                            controller.profile.value.showCompanyName = value;
                            controller.profile.refresh();
                          },
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(30)),

                        // Preview text
                        Center(
                          child: Text(
                            '${controller.jobTitleController.text.isNotEmpty ? controller.jobTitleController.text : "Job Title"} at ${controller.companyNameController.text.isNotEmpty ? controller.companyNameController.text : "Company Name"}',
                            style: AppTextStyles.small(
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                              Get.toNamed(Routes.EDUCATION_SELECTION);
                            },
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(16)),

                        CustomContinueButton(
                          onPressed:
                              (controller.jobTitleController.text.isNotEmpty &&
                                  controller
                                      .companyNameController
                                      .text
                                      .isNotEmpty)
                              ? () {
                                  controller.profile.value.jobTitle =
                                      controller.jobTitleController.text;
                                  controller.profile.value.companyName =
                                      controller.companyNameController.text;
                                  controller.profile.refresh();

                                  debugPrint(
                                    'Job Title: ${controller.jobTitleController.text}',
                                  );
                                  debugPrint(
                                    'Company: ${controller.companyNameController.text}',
                                  );
                                  Get.toNamed(Routes.TERMS_AND_GUIDELINES);
                                }
                              : () {},
                          isEnabled:
                              controller.jobTitleController.text.isNotEmpty &&
                              controller.companyNameController.text.isNotEmpty,
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
