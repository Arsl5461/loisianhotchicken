// ignore_for_file: must_be_immutable

import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/profileSetting/ProfilrMainPage/widgets/profile_account_item.dart';
import 'package:OApp/view/profileSetting/ProfilrMainPage/widgets/profile_header_section.dart';
import 'package:OApp/view/profileSetting/ProfilrMainPage/widgets/profile_load_error_view.dart';
import 'package:OApp/view/profileSetting/ProfilrMainPage/widgets/profile_premium_section.dart';
import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:OApp/widgets/custom_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemedProfileScreen extends GetView<ProfileDisplayController> {
  bool showEditProfileDialog = false;

  ThemedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQueryUtil.spacing(40)),
        child: Obx(() {
          final isLoading = controller.isLoading.value;
          final user = controller.user.value;

          if (isLoading && user == null) {
            return const Center(child: BlurShimmerPlaceholder());
          }
          if (user == null) {
            return ProfileLoadErrorView(
              onRefresh: controller.fetchUserProfile,
              onRetry: controller.fetchUserProfile,
              onLogout: controller.logout,
            );
          }

          return RefreshIndicator(
            edgeOffset: 0,
            displacement: 32,
            onRefresh: controller.fetchUserProfile,
            child: CustomScrollView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: ProfileHeaderSection()),
                if (!controller.isPremiumTier) ...[
                  const SliverToBoxAdapter(child: ProfilePremiumCard()),
                  const SliverToBoxAdapter(child: ProfileUpgradeButton()),
                ],
                _buildAccountSliver(user),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQueryUtil.spacing(20)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  SliverPadding _buildAccountSliver(UserModel user) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(10),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: MediaQueryUtil.spacing(20)),
          Text(
            'Account',
            style: AppTextStyles.regular(
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.black,
            ).copyWith(letterSpacing: 1.0),
          ),
          SizedBox(height: MediaQueryUtil.spacing(10)),
          if (user.location == null)
            ProfileAccountItem(
              icon: Icon(Icons.map_outlined, size: MediaQueryUtil.spacing(16)),
              title: 'Set Location',
              subtitle: 'Tell everyone about your location',
              onTap: () => Get.toNamed(Routes.SET_LOCATION, arguments: user),
            ),
          ProfileAccountItem(
            icon: CustomSvgIcons.editProfile(
              color: AppColors.black,
              size: MediaQueryUtil.spacing(16),
            ),
            title: 'Edit Profile',
            subtitle: 'Tell everyone about yourself',
            onTap: () => Get.toNamed(Routes.EDIT_PROFILE, arguments: user),
          ),
          SizedBox(height: MediaQueryUtil.spacing(14)),
          ProfileAccountItem(
            icon: CustomSvgIcons.datingPreferences(
              color: AppColors.black,
              size: MediaQueryUtil.spacing(12),
            ),
            title: 'Dating Preferences',
            subtitle: 'Let us know what you like to filter your \ndiscovery',
            onTap: () {
              controller.homeController.isTraveliingPreference.value = false;
              Get.toNamed(Routes.BUBBA_PREFS_HUB);
            },
          ),
          SizedBox(height: MediaQueryUtil.spacing(14)),
          ProfileAccountItem(
            icon: CustomSvgIcons.support(
              color: AppColors.black,
              size: MediaQueryUtil.spacing(16),
            ),
            title: 'Support',
            subtitle: 'We\'re here if you need help',
            onTap: () => Get.toNamed(Routes.SUPPORT),
          ),
          SizedBox(height: MediaQueryUtil.spacing(14)),
          ProfileAccountItem(
            icon: CustomSvgIcons.settings(
              color: AppColors.black,
              size: MediaQueryUtil.spacing(16),
            ),
            title: 'Settings',
            subtitle: 'Anything related to your account',
            onTap: () => Get.toNamed(Routes.SETTINGS),
          ),
          SizedBox(height: MediaQueryUtil.spacing(14)),
          ProfileAccountItem(
            icon: CustomSvgIcons.inviteFriend(
              color: AppColors.black,
              size: MediaQueryUtil.spacing(16),
            ),
            title: 'Invite',
            subtitle:
                'Invite your friends to our \ncommunits with a unique link',
            onTap: () => Get.toNamed(Routes.INVITE_FRIENDS),
          ),
        ]),
      ),
    );
  }
}
