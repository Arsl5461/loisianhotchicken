import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/profileSetting/ProfilrMainPage/widgets/profile_preview_dialog.dart';
import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:OApp/widget_helper/loading_helper.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _defaultProfileImage =
    'https://images.unsplash.com/photo-1604004555489-723a93d6ce74?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687';

class ProfileHeaderSection extends GetView<ProfileDisplayController> {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user.value;
      final isLoading = controller.isLoading.value;

      if (isLoading) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(16),
            vertical: MediaQueryUtil.spacing(12),
          ),
          child: Center(
            child: SizedBox(
              height: MediaQueryUtil.height * 0.1,
              child: const BlurShimmerPlaceholder(),
            ),
          ),
        );
      }

      final profileImage =
          (user?.photos != null && user!.photos!.isNotEmpty)
              ? user.photos!.first
              : _defaultProfileImage;

      return Container(
        height: controller.showCompactAvatar.value
            ? MediaQueryUtil.height * 0.1
            : MediaQueryUtil.height * 0.14,
        margin: EdgeInsets.only(top: MediaQueryUtil.spacing(30)),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(10),
        ),
        child: _AnimatedProfileHeader(user: user, profileImage: profileImage),
      );
    });
  }
}

class _AnimatedProfileHeader extends GetView<ProfileDisplayController> {
  const _AnimatedProfileHeader({
    required this.user,
    required this.profileImage,
  });

  final UserModel? user;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    final membershipText = controller.getPremiumTierLabel();

    return Obx(() {
      final showCompact = controller.showCompactAvatar.value;

      return AnimatedBuilder(
        animation: controller.avatarAnimation,
        builder: (context, child) {
          final compactOpacity = controller.avatarAnimation.value;
          final expandedOpacity = 1 - compactOpacity;

          return Stack(
            children: [
              IgnorePointer(
                ignoring: showCompact,
                child: Opacity(
                  opacity: expandedOpacity,
                  child: Transform.translate(
                    offset: Offset(0, -10 * compactOpacity),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileAvatarExpanded(
                          user: user,
                          profileImage: profileImage,
                        ),
                        SizedBox(width: MediaQueryUtil.spacing(10)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Mandy',
                              style: AppTextStyles.large(
                                fontFamily: AppFontFamily.urbanist,
                                fontWeight: AppFontWeight.bold,
                                color: AppColors.black,
                              ).copyWith(letterSpacing: 1.0),
                            ),
                            Text(
                              membershipText,
                              style: AppTextStyles.regular(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.black,
                              ).copyWith(letterSpacing: 1.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: !showCompact,
                child: Opacity(
                  opacity: compactOpacity,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - compactOpacity)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileAvatarCompact(
                          user: user,
                          profileImage: profileImage,
                        ),
                        SizedBox(width: MediaQueryUtil.spacing(5)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'Mandy',
                                style: AppTextStyles.medium(
                                  fontFamily: AppFontFamily.urbanist,
                                  fontWeight: AppFontWeight.bold,
                                  color: AppColors.black,
                                ).copyWith(letterSpacing: 1.0),
                              ),
                              Text(
                                membershipText,
                                style: AppTextStyles.small(
                                  fontWeight: AppFontWeight.semi,
                                  color: AppColors.black,
                                ).copyWith(letterSpacing: 1.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class _ProfileAvatarCompact extends GetView<ProfileDisplayController> {
  const _ProfileAvatarCompact({
    required this.user,
    required this.profileImage,
  });

  final UserModel? user;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    return _ProfileAvatarBase(
      user: user,
      profileImage: profileImage,
      size: MediaQueryUtil.spacing(60),
      ringWidth: 2.5,
      badgeRight: 13,
      padding: 4,
    );
  }
}

class _ProfileAvatarExpanded extends GetView<ProfileDisplayController> {
  const _ProfileAvatarExpanded({
    required this.user,
    required this.profileImage,
  });

  final UserModel? user;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    return _ProfileAvatarBase(
      user: user,
      profileImage: profileImage,
      size: MediaQueryUtil.spacing(90),
      ringWidth: 3.8,
      badgeRight: 25,
      padding: 6,
    );
  }
}

class _ProfileAvatarBase extends GetView<ProfileDisplayController> {
  const _ProfileAvatarBase({
    required this.user,
    required this.profileImage,
    required this.size,
    required this.ringWidth,
    required this.badgeRight,
    required this.padding,
  });

  final UserModel? user;
  final String profileImage;
  final double size;
  final double ringWidth;
  final double badgeRight;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final completion =
        controller.homeController.calculateProfileCompletion(user).round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => controller.dashboardController.changeIndex(3),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: MediaQueryUtil.spacing(30),
            color: AppColors.grey[700],
          ),
        ),
        SizedBox(width: MediaQueryUtil.spacing(10)),
        InkWell(
          onTap: () {
            if (user != null) {
              showProfilePreviewDialog(user: user!, profileImage: profileImage);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topLeft,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CustomPaint(
                  painter: ProgressRingPainter(
                    progress: completion / 100,
                    ringWidth: ringWidth,
                    ringColor: const Color(0xFF3aaeae),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: ClipOval(
                      child: Base64OrNetworkImage(
                        imageData: profileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: badgeRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(4),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: MediaQueryUtil.spacing(2),
                    left: MediaQueryUtil.spacing(2),
                    right: MediaQueryUtil.spacing(2),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(6),
                      vertical: MediaQueryUtil.spacing(2),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3aaeae),
                      borderRadius: BorderRadius.circular(
                        MediaQueryUtil.spacing(4),
                      ),
                    ),
                    child: Text(
                      '$completion%',
                      style: AppTextStyles.text(
                        customSize: MediaQueryUtil.fontSize(8),
                        fontWeight: AppFontWeight.semiBold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
