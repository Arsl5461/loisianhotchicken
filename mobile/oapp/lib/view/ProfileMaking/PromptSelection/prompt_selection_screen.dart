import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/routing/app_routes.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PromptSelectionScreen extends GetView<ProfileController> {
  const PromptSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(16),
                vertical: MediaQueryUtil.spacing(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      LucideIcons.chevronLeft,
                      size: MediaQueryUtil.spacing(24),
                      color: AppColors.black,
                    ),
                  ),

                  // Title
                  Text(
                    "Select prompt",
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),

                  // Close button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      LucideIcons.x,
                      size: MediaQueryUtil.spacing(24),
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(height: 1, color: AppColors.grey[200]),

            // Prompts list
            Expanded(
              child: ListView.builder(
                itemCount: controller.icebreakers.length,
                itemBuilder: (context, index) {
                  final prompt =
                      controller.icebreakers[index]?.prompt ??
                      'Prompt ${index + 1}';

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to answer screen with selected prompt
                          // context.push('/prompt-answer', extra: prompt);
                          Get.toNamed(
                            Routes.ETHNICITY_SELECTION,
                            arguments: prompt,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQueryUtil.spacing(16),
                            vertical: MediaQueryUtil.spacing(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  prompt,
                                  style: TextStyle(
                                    fontSize: MediaQueryUtil.fontSize(16),
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                LucideIcons.chevronRight,
                                size: MediaQueryUtil.spacing(16),
                                color: AppColors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Divider
                      if (index < controller.icebreakers.length - 1)
                        Container(
                          height: 1,
                          margin: EdgeInsets.only(
                            left: MediaQueryUtil.spacing(16),
                          ),
                          color: AppColors.grey[200],
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
