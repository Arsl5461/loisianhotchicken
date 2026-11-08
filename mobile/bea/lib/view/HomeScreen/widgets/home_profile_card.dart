import 'package:OApp/controller/home_controller.dart';
import 'package:OApp/view/HomeScreen/widgets/SwipeFeedbackIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Images/Base64OrNetworkImage.dart';
import 'datingHeartButton.dart';
import 'home_profile_sheets.dart';

class HomeProfileCard {
  HomeProfileCard._();

  static Widget buildProfileCard({
    required BuildContext context,
    required UserModel user,
    required double cardHeight,
    required HomeController controller,
    bool showUserView = true,
  }) {
    return GestureDetector(
      onTap: () => HomeProfileSheets.showImageViewerModal(
        context: context,
        currentProfile: user,
        controller: controller,
      ),

      onPanStart: (_) => showUserView ? controller.onPanStart() : null,
      onPanUpdate: showUserView
          ? (details) {
              final w = MediaQuery.of(context).size.width;
              controller.onPanUpdate(details.delta.dx, w);
            }
          : null,
      onPanEnd: showUserView
          ? (details) {
              controller.onPanEnd(
                velocityDx: details.velocity.pixelsPerSecond.dx,
                runSwipeAnimation: ({required bool isLeft}) async {
                  controller.isSwipeLeft.value = isLeft;
                  await controller.runSwipeAnimation(isLeft: isLeft);
                },
              );
            }
          : null,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(
                alpha: 0.6,
              ), // light transparent shadow
              offset: Offset(0, 4), // x = 0 (no horizontal), y = 4 (downwards)
              blurRadius: 6, // soft blur
              spreadRadius: 0, // no spread
            ),
          ],
        ),
        width: double.infinity,
        height: cardHeight,
        child: Stack(
          children: [
            Obx(() {
              final photos = user.photos ?? const <String>[];
              final selectedIndex = controller.selectedImageIndex.value;
              final imageData = photos.isEmpty
                  ? ''
                  : (selectedIndex >= 0 && selectedIndex < photos.length
                        ? photos[selectedIndex]
                        : photos.first);

              return ClipRRect(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(24)),
                child: SizedBox(
                  width: double.infinity,
                  height: cardHeight,
                  child: Base64OrNetworkImage(
                    imageData: imageData,
                    width: double.infinity,
                    height: cardHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: cardHeight * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(MediaQueryUtil.spacing(24)),
                    bottomRight: Radius.circular(MediaQueryUtil.spacing(24)),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.transparent,
                      AppColors.black.withValues(alpha: 0.3),
                      AppColors.black.withValues(alpha: 0.6),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: MediaQueryUtil.spacing(16),
              left: MediaQueryUtil.spacing(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.fullName ?? "User"}, ${user.ages ?? ""}',
                    style: AppTextStyles.text(
                      customSize: 21.sp,
                      fontFamily: AppFontFamily.publicSans,
                      color: AppColors.white,
                      // fontSize: MediaQueryUtil.fontSize(13),
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: user.showJobTitle ?? true,
                    child: Text(
                      "${user.jobTitle ?? ""} at ${user.companyName ?? ""}"
                          .trim(),
                      style: AppTextStyles.text(
                        customSize: MediaQueryUtil.fontSize(15),
                        fontFamily: AppFontFamily.publicSans,
                        color: AppColors.white,
                        // fontSize: MediaQueryUtil.fontSize(13),
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ),
                  if (user.socialHandle != null) ...[
                    Text(
                      "@${user.socialHandle} ",
                      style: AppTextStyles.small(
                        fontFamily: AppFontFamily.publicSans,
                        color: AppColors.cFF51B4AC,

                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ],
                  Obx(
                    () => SizedBox(
                      width: MediaQueryUtil.width * 0.5,
                      child: Text(
                        "${controller.locationNameText.value.isNotEmpty ? controller.locationNameText.value : user.hometown} ${controller.getLocationDifference(user.location)}"
                            .trim(),
                        style: AppTextStyles.verySmall(
                          fontFamily: AppFontFamily.publicSans,
                          color: AppColors.white,

                          fontWeight: AppFontWeight.semi,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showUserView,
              child: heartWidgetCall(user: user, controller: controller),
            ),

            Obx(() {
              final show = controller.showSwipeFeedback.value;
              final progress = controller.swipeProgress.value;

              if (!show || progress.abs() <= 0.1) {
                return const SizedBox.shrink();
              }

              return Center(
                child: SwipeFeedbackIcon(
                  isLike: progress > 0,
                  opacity: (progress.abs() * 2).clamp(0.0, 1.0),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  static heartWidgetCall({
    required UserModel user,
    required HomeController controller,
  }) {
    return Positioned(
      bottom: MediaQueryUtil.spacing(16),
      right: MediaQueryUtil.spacing(16),
      child: HeartWidget(
        heartBorderWidth: 2,
        size: 60,
        width: 60,
        innerCircleScale: 0.98,
        circleBorderWidth: 2,
        circleBorderColor: Colors.white,
        backgroundColor: const Color(0xFFE2E2E2).withValues(alpha: 0.88),
        onTap: () {
          HomeProfileSheets.openLikeSheet(
            currentProfile: user,
            controller: controller,
          );
        },
      ),
    );
  }
}
