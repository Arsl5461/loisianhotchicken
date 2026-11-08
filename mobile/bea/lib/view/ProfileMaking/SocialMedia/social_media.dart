import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../hardcoded_data.dart';
import '../../../widgets/Input/CustomTextField.dart';
import '../../../widgets/Selection/selectableBox.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Progress/ProgressTracker.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SocialMediaScreen extends GetView<ProfileController> {
  const SocialMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Padding(
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
                        progress: 11 / 16, // Step 11 of 16
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Title
                      Text(
                        "Do you want to add a\nsocial media handle?",
                        style: AppTextStyles.large(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(10)),

                      Text(
                        'Share a handle if you want people to find you elsewhere.',
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(32)),

                      // Social Handle input field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Social Handle',
                            style: AppTextStyles.verySmall(
                              fontWeight: AppFontWeight.semi,
                              color: AppColors.grey[600],
                            ),
                          ),
                          SizedBox(height: MediaQueryUtil.spacing(8)),
                          CustomTextField(
                            controller: controller.socialHandleController,
                            onChanged: (value) {
                              controller.socialHandler.value = value;
                            },
                            hintText: '@username',
                            hintStyle: AppTextStyles.regular(
                              fontWeight: AppFontWeight.semi,
                              color: AppColors.grey,
                            ),
                            focusColor: AppColors.cFF006C6A,
                          ),
                        ],
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Platform selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Platform',
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

                              return Obx(
                                () => Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  children: HardCodedData.platforms.map((
                                    platform,
                                  ) {
                                    final isSelected =
                                        controller.selectedPlatforms.value ==
                                        platform;

                                    return SizedBox(
                                      width: itemWidth,
                                      child: SelectableBox(
                                        text: platform,
                                        isSelected: isSelected,
                                        onTap: () {
                                          controller.selectedPlatforms.value =
                                              isSelected ? '' : platform;
                                          controller.platform.value = isSelected
                                              ? ''
                                              : platform;
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
                                ),
                              );
                            },
                          ),
                        ],
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
                            Get.toNamed(Routes.NAME_ASKING);
                          },
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // Continue button
                      Obx(
                        () => CustomContinueButton(
                          onPressed:
                              (controller.socialHandler.isNotEmpty &&
                                  controller.platform.value.isNotEmpty)
                              ? () {
                                  debugPrint(
                                    'Social Handle: ${controller.socialHandleController.text}',
                                  );
                                  debugPrint(
                                    'Platform: ${controller.platform}',
                                  );
                                  Get.toNamed(Routes.EMAIL);
                                }
                              : () {},
                          isEnabled:
                              controller.socialHandler.isNotEmpty &&
                              controller.platform.value.isNotEmpty,
                          backgroundColor: AppColors.cFF4E535A,
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
