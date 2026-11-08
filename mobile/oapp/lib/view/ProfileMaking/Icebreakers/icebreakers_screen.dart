import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../widgets/Input/ExpandablePromptWidget.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Progress/ProgressTracker.dart';
import '../profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class IcebreakersScreen extends GetView<ProfileController> {
  const IcebreakersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    // Check if at least one prompt has an answer

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
                        progress: 13 / 16, // Step 13 of 16
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Title
                      Text(
                        "Icebreakers",
                        style: AppTextStyles.large(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      Text(
                        "We know it can get hard finding creative answers, but here's a chance to show your personality and break the ice. Only one prompt required.",
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // Recommendation text
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "We recommend atleast",
                          style: AppTextStyles.verySmall(
                            fontWeight: AppFontWeight.semi,
                            color: AppColors.grey[600],
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(10)),

                      // Prompts
                      Obx(
                        () => controller.icebreakers.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: MediaQueryUtil.spacing(40)),
                                  glassFetchButton(() {
                                    controller.fetchIceBreakers();
                                  }),
                                  SizedBox(height: MediaQueryUtil.spacing(20)),
                                  Text(
                                    "Loading prompts...",
                                    style: AppTextStyles.regular(
                                      fontWeight: AppFontWeight.semi,
                                      color: AppColors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: MediaQueryUtil.spacing(40)),
                                ],
                              )
                            : Column(
                                children: List.generate(
                                  controller.icebreakers.length,
                                  (index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQueryUtil.spacing(12),
                                      ),
                                      child: ExpandablePromptWidget(
                                        title:
                                            controller
                                                .icebreakers[index]
                                                ?.prompt ??
                                            "",
                                        answer:
                                            controller
                                                .icebreakers[index]
                                                ?.answer ??
                                            "",
                                        isExpanded: controller.expandedIds
                                            .contains(index),
                                        onAnswerChanged: (value) {
                                          controller
                                                  .icebreakers[index]
                                                  ?.answer =
                                              value;
                                          controller.icebreakers.refresh();
                                        },
                                        onPlusTap: () {
                                          if (controller.expandedIds.contains(
                                            index,
                                          )) {
                                            controller.expandedIds.remove(
                                              index,
                                            );
                                          } else {
                                            controller.expandedIds.add(index);
                                          }

                                          debugPrint(
                                            'Plus tapped for prompt ${index + 1}',
                                          );
                                        },
                                        onTap: () {
                                          controller.expandedIds.contains(index)
                                              ? controller.expandedIds.remove(
                                                  index,
                                                )
                                              : controller.expandedIds.add(
                                                  index,
                                                );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),

                      // Error message (only show if no answers)
                      Obx(() {
                        if (!controller.hasAtLeastOneAnswer) {
                          return Column(
                            children: [
                              SizedBox(height: MediaQueryUtil.spacing(4)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.red,
                                    size: MediaQueryUtil.spacing(16),
                                  ),
                                  SizedBox(width: MediaQueryUtil.spacing(8)),
                                  Text(
                                    "At least 1 prompt is required to continue",
                                    style: TextStyle(
                                      fontSize: MediaQueryUtil.fontSize(14),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        return const SizedBox();
                      }),

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
                            Get.toNamed(Routes.LIFESTYLE_HABITS);
                          },
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      // Continue button
                      Obx(
                        () => CustomContinueButton(
                          onPressed: controller.hasAtLeastOneAnswer
                              ? () {
                                  debugPrint(
                                    'Icebreaker answers: ${controller.answers}',
                                  );
                                  Get.toNamed(Routes.POLITICS);
                                }
                              : () {},
                          isEnabled:
                              controller.hasAtLeastOneAnswer ||
                              (controller.icebreakers.isEmpty),
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

  Widget glassFetchButton(VoidCallback onTap) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.25),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.refresh, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Fetch Again",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
