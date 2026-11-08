import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/referral_overview_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/utils/toast.dart';
import 'package:OApp/view/profileSetting/Invite/controller/invite_friends_controller.dart';
import 'package:OApp/widgets/Buttons/closeButton.dart' as custom;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class InviteFriendsScreen extends GetView<InviteFriendsController> {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.0, 0.35, 0.56, 0.7, 1.0],
                colors: [
                  Color(0xFFE8CFC2),
                  Color(0xFFD6E4DD),
                  Color(0xFF36CAB9),
                  Color(0xFF36CAB9),
                  Color(0xFF28AFA2),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.referralData.value == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.errorMessage.value.isNotEmpty &&
                        controller.referralData.value == null) {
                      return _buildErrorState();
                    }

                    return _buildContent();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: MediaQueryUtil.padding(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          custom.CustomCloseButton(onTap: () => Get.back()),
          Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.grey[700],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final data = controller.referralData.value;
    final invitationLink = data?.shareableReferralLink ?? '';

    return RefreshIndicator(
      onRefresh: controller.fetchReferralOverview,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: MediaQueryUtil.padding(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaQueryUtil.verticalSpace(44),
            Center(
              child: Text(
                'Invite your friends!',
                textAlign: TextAlign.center,
                style: AppTextStyles.large(fontWeight: AppFontWeight.semiBold),
              ),
            ),
            MediaQueryUtil.verticalSpace(18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildDescriptionText(
                'Right now, new members can only join through member invitations, originating from our initial waitlist.',
              ),
            ),
            MediaQueryUtil.verticalSpace(14),
            _buildDescriptionText(
              'We carefully manage growth this way in each city to ensure a healthy balance between men and women for an optimal user experience.',
            ),
            MediaQueryUtil.verticalSpace(26),
            // if (data != null) ...[
            //   _buildStatsOverview(data),
            //   MediaQueryUtil.verticalSpace(18),
            // ],
            if (invitationLink.isNotEmpty) ...[
              _buildLinkSection(invitationLink),
              MediaQueryUtil.verticalSpace(22),
            ],
            _buildShareSection(),
            MediaQueryUtil.verticalSpace(24),
            _buildRewardsCta(),
            MediaQueryUtil.verticalSpace(20),
            _buildBenefitText('You can invite up to 5 friends.'),
            MediaQueryUtil.verticalSpace(8),
            _buildBenefitText(
              'Receive a free month of Platinum membership for each new friend who joins through your link.',
            ),
            MediaQueryUtil.verticalSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: MediaQueryUtil.padding(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link_off, size: 42, color: AppColors.grey[700]),
            MediaQueryUtil.verticalSpace(12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: AppTextStyles.small(
                fontFamily: AppFontFamily.playfair,
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.grey[700],
              ),
            ),
            MediaQueryUtil.verticalSpace(16),
            ElevatedButton(
              onPressed: controller.fetchReferralOverview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cFF006C6A,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: MediaQueryUtil.borderRadius(12),
                ),
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsOverview(ReferralOverviewData data) {
    final stats = data.stats;
    final totalCount = data.referredUsersCount > 0
        ? data.referredUsersCount
        : stats.totalReferrals;

    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.72),
        borderRadius: MediaQueryUtil.borderRadius(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatTile('Total', totalCount.toString())),
              SizedBox(width: MediaQueryUtil.spacing(12)),
              Expanded(
                child: _buildStatTile(
                  'Successful',
                  stats.successfulReferrals.toString(),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQueryUtil.spacing(12)),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  'Claimable',
                  stats.claimableRewards.toString(),
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(12)),
              Expanded(
                child: _buildStatTile(
                  'Claimed',
                  stats.claimedRewards.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkSection(String invitationLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your invitation link',
          style: AppTextStyles.regular(
            fontWeight: AppFontWeight.semiBold,
            fontFamily: AppFontFamily.playfair,
          ),
        ),
        MediaQueryUtil.verticalSpace(14),
        GestureDetector(
          onTap: () => _copyText(invitationLink, 'Referral link copied'),
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQueryUtil.spacing(6)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey[400]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    invitationLink,
                    style: AppTextStyles.small(
                      fontFamily: AppFontFamily.playfair,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.grey[700],
                    ),
                  ),
                ),
                SizedBox(width: MediaQueryUtil.spacing(12)),
                Text(
                  'Copy link',
                  style: AppTextStyles.verySmall(
                    fontFamily: AppFontFamily.playfair,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share via',
          style: AppTextStyles.regular(
            fontWeight: AppFontWeight.semiBold,
            fontFamily: AppFontFamily.playfair,
          ),
        ),
        MediaQueryUtil.verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.canShareReferral
                    ? controller.shareWhatsApp
                    : null,
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: MediaQueryUtil.isTablet ? 20 : 18,
                ),
                label: Text(
                  'WhatsApp',
                  style: MediaQueryUtil.bodyStyle(
                    fontSize: MediaQueryUtil.isTablet ? 16 : 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: _shareButtonStyle(AppColors.cFF25D366),
              ),
            ),
            SizedBox(width: MediaQueryUtil.spacing(12)),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.generatedReferralLink.isEmpty
                    ? null
                    : controller.shareFacebook,
                icon: FaIcon(
                  FontAwesomeIcons.facebookF,
                  size: MediaQueryUtil.isTablet ? 20 : 18,
                ),
                label: Text(
                  'Facebook',
                  style: MediaQueryUtil.bodyStyle(
                    fontSize: MediaQueryUtil.isTablet ? 16 : 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: _shareButtonStyle(AppColors.cFF1877F2),
              ),
            ),
            SizedBox(width: MediaQueryUtil.spacing(12)),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.canShareReferral
                    ? controller.shareTwitter
                    : null,
                icon: FaIcon(
                  FontAwesomeIcons.xTwitter,
                  size: MediaQueryUtil.isTablet ? 20 : 18,
                ),
                label: Text(
                  'X',
                  style: MediaQueryUtil.bodyStyle(
                    fontSize: MediaQueryUtil.isTablet ? 16 : 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: _shareButtonStyle(AppColors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardsCta() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MediaQueryUtil.spacing(5)),
      // decoration: BoxDecoration(
      //   color: AppColors.white.withValues(alpha: 0.74),
      //   borderRadius: MediaQueryUtil.borderRadius(18),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Referral rewards',
          //   style: AppTextStyles.regular(
          //     fontWeight: AppFontWeight.semiBold,
          //     fontFamily: AppFontFamily.playfair,
          //   ),
          // ),
          // MediaQueryUtil.verticalSpace(8),
          // Text(
          //   'Track claimable rewards, view all unlocked history, and claim subscription rewards from a dedicated screen.',
          //   style: AppTextStyles.small(color: AppColors.grey[700]),
          // ),
          // MediaQueryUtil.verticalSpace(14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.REFERRAL_REWARDS),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cFF006C6A,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: MediaQueryUtil.borderRadius(12),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQueryUtil.spacing(13),
                ),
              ),
              child: const Text('View rewards'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: MediaQueryUtil.spacing(14),
        horizontal: MediaQueryUtil.spacing(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.82),
        borderRadius: MediaQueryUtil.borderRadius(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.medium(
              fontWeight: AppFontWeight.bold,
              color: AppColors.cFF006C6A,
            ),
          ),
          MediaQueryUtil.verticalSpace(4),
          Text(
            title,
            style: AppTextStyles.verySmall(color: AppColors.grey[700]),
          ),
        ],
      ),
    );
  }

  ButtonStyle _shareButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: backgroundColor.withValues(alpha: 0.45),
      disabledForegroundColor: AppColors.white.withValues(alpha: 0.7),
      padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(12)),
      shape: RoundedRectangleBorder(
        borderRadius: MediaQueryUtil.borderRadius(12),
      ),
    );
  }

  Widget _buildDescriptionText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.small(
        fontFamily: AppFontFamily.playfair,
        fontWeight: AppFontWeight.semiBold,
        color: AppColors.grey[600],
      ),
    );
  }

  Widget _buildBenefitText(String text) {
    return Text(
      text,
      style: AppTextStyles.small(
        fontFamily: AppFontFamily.playfair,
        fontWeight: AppFontWeight.semiBold,
        color: AppColors.grey[800],
      ),
    );
  }

  Future<void> _copyText(String text, String successMessage) async {
    await Clipboard.setData(ClipboardData(text: text));
    Toast.success(successMessage);
  }
}

extension InviteFriendsNavigation on BuildContext {
  void pushToInviteFriends() {
    Get.toNamed(Routes.INVITE_FRIENDS);
  }
}
