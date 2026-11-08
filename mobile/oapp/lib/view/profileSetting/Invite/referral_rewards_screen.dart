import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/referral_reward_model.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/profileSetting/Invite/controller/referral_rewards_controller.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferralRewardsScreen extends GetView<ReferralRewardsController> {
  const ReferralRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F0EB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF4F0EB),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Referral Rewards',
            style: AppTextStyles.regular(fontWeight: AppFontWeight.semiBold),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(MediaQueryUtil.spacing(58)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQueryUtil.spacing(16),
                0,
                MediaQueryUtil.spacing(16),
                MediaQueryUtil.spacing(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(14),
                  ),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.cFF006C6A,
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(14),
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.grey[700],
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'Claimable'),
                    Tab(text: 'All Rewards'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Obx(() => _buildSummaryHeader()),
            Expanded(
              child: TabBarView(
                children: [
                  Obx(
                    () => _buildRewardsTab(
                      rewards: controller.claimableRewards,
                      isLoading: controller.isLoadingClaimable.value,
                      errorText: controller.claimableErrorMessage.value,
                      emptyTitle: 'No claimable rewards yet',
                      emptySubtitle:
                          'Keep inviting friends. Once a reward unlocks, you will be able to claim it here.',
                    ),
                  ),
                  Obx(
                    () => _buildRewardsTab(
                      rewards: controller.allRewards,
                      isLoading: controller.isLoadingAllRewards.value,
                      errorText: controller.allRewardsErrorMessage.value,
                      emptyTitle: 'No rewards found',
                      emptySubtitle:
                          'Your referral reward history will appear here as your invites progress.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQueryUtil.spacing(16),
        MediaQueryUtil.spacing(14),
        MediaQueryUtil.spacing(16),
        MediaQueryUtil.spacing(8),
      ),
      padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6A67), Color(0xFF17847F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryMetric(
              'Claimable',
              controller.claimableRewards.length.toString(),
            ),
          ),
          Expanded(
            child: _buildSummaryMetric(
              'Unlocked',
              controller.unlockedRewardsCount.toString(),
            ),
          ),
          Expanded(
            child: _buildSummaryMetric(
              'Claimed',
              controller.claimedRewardsCount.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.medium(
            color: AppColors.white,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(4)),
        Text(
          title,
          style: AppTextStyles.verySmall(
            color: AppColors.white.withValues(alpha: 0.82),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsTab({
    required List<ReferralRewardModel> rewards,
    required bool isLoading,
    required String errorText,
    required String emptyTitle,
    required String emptySubtitle,
  }) {
    if (isLoading && rewards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: controller.refreshRewards,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          MediaQueryUtil.spacing(16),
          MediaQueryUtil.spacing(8),
          MediaQueryUtil.spacing(16),
          MediaQueryUtil.spacing(28),
        ),
        children: [
          if (errorText.isNotEmpty)
            Container(
              margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(12)),
              padding: EdgeInsets.all(MediaQueryUtil.spacing(14)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F2),
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(14)),
              ),
              child: Text(
                errorText,
                style: AppTextStyles.small(color: AppColors.dangerRed),
              ),
            ),
          if (rewards.isEmpty && errorText.isEmpty)
            _buildEmptyState(emptyTitle, emptySubtitle)
          else
            ...rewards.map(_buildRewardCard),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(top: MediaQueryUtil.spacing(40)),
      padding: EdgeInsets.all(MediaQueryUtil.spacing(24)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.card_giftcard_rounded,
            size: MediaQueryUtil.spacing(38),
            color: AppColors.cFF006C6A,
          ),
          SizedBox(height: MediaQueryUtil.spacing(14)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular(fontWeight: AppFontWeight.semiBold),
          ),
          SizedBox(height: MediaQueryUtil.spacing(8)),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.small(color: AppColors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(ReferralRewardModel reward) {
    final isClaimable = reward.isClaimable && reward.claimSupported;
    final isClaimed = reward.claimedAt != null;
    final isDisabled = !isClaimable;

    return Opacity(
      opacity: isDisabled ? 0.58 : 1,
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(14)),
        padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(18)),
          border: Border.all(
            color: isClaimable
                ? AppColors.cFF006C6A.withValues(alpha: 0.28)
                : AppColors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.ruleName,
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(6)),
                      Text(
                        _rewardSubtitle(reward),
                        style: AppTextStyles.small(color: AppColors.grey[700]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: MediaQueryUtil.spacing(12)),
                _buildStatusBadge(reward),
              ],
            ),
            SizedBox(height: MediaQueryUtil.spacing(14)),
            Wrap(
              spacing: MediaQueryUtil.spacing(8),
              runSpacing: MediaQueryUtil.spacing(8),
              children: [
                _buildMetaChip(
                  Icons.workspace_premium_outlined,
                  _formatRewardType(reward.rewardType),
                ),
                if ((reward.rewardValue?.durationDays ?? 0) > 0)
                  _buildMetaChip(
                    Icons.calendar_month_outlined,
                    '${reward.rewardValue?.durationDays ?? 0} days',
                  ),
                if (reward.users.isNotEmpty)
                  _buildMetaChip(
                    Icons.group_outlined,
                    '${reward.users.length} users',
                  ),
              ],
            ),
            if (reward.users.isNotEmpty) ...[
              SizedBox(height: MediaQueryUtil.spacing(14)),
              Text(
                'Referred users',
                style: AppTextStyles.verySmall(
                  color: AppColors.grey[700],
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(10)),
              Wrap(
                spacing: MediaQueryUtil.spacing(8),
                runSpacing: MediaQueryUtil.spacing(8),
                children: reward.users.map(_buildUserChip).toList(),
              ),
            ],
            SizedBox(height: MediaQueryUtil.spacing(16)),
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                final isLoading = controller.isClaiming(reward.id);

                return ElevatedButton(
                  onPressed: isClaimable && !isLoading
                      ? () => controller.claimReward(reward)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isClaimable
                        ? AppColors.cFF006C6A
                        : AppColors.grey[300],
                    foregroundColor: isClaimable
                        ? AppColors.white
                        : AppColors.grey[700],
                    disabledBackgroundColor: AppColors.grey[300],
                    disabledForegroundColor: AppColors.grey[700],
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQueryUtil.spacing(13),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQueryUtil.spacing(12),
                      ),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isClaimable
                              ? _claimButtonLabel(reward)
                              : isClaimed
                              ? 'Already claimed'
                              : 'Not claimable yet',
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ReferralRewardModel reward) {
    final isClaimable = reward.isClaimable && reward.claimSupported;
    final isClaimed = reward.claimedAt != null;

    final label = isClaimable
        ? 'Claim now'
        : isClaimed
        ? 'Claimed'
        : reward.status.isNotEmpty
        ? reward.status
        : 'Locked';

    final background = isClaimable
        ? AppColors.cFF006C6A.withValues(alpha: 0.12)
        : isClaimed
        ? AppColors.grey[200]!
        : AppColors.grey[100]!;

    final foreground = isClaimable
        ? AppColors.cFF006C6A
        : isClaimed
        ? AppColors.grey[800]!
        : AppColors.grey[700]!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(10),
        vertical: MediaQueryUtil.spacing(6),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(999)),
      ),
      child: Text(
        label,
        style: AppTextStyles.verySmall(
          color: foreground,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(10),
        vertical: MediaQueryUtil.spacing(8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F4),
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: MediaQueryUtil.fontSize(14),
            color: AppColors.grey[700],
          ),
          SizedBox(width: MediaQueryUtil.spacing(6)),
          Text(
            text,
            style: AppTextStyles.verySmall(color: AppColors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildUserChip(UserModel user) {
    final photo = (user.photos ?? []).isNotEmpty ? user.photos!.first : '';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(10),
        vertical: MediaQueryUtil.spacing(8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: SizedBox(
              width: MediaQueryUtil.spacing(28),
              height: MediaQueryUtil.spacing(28),
              child: photo.isNotEmpty
                  ? Base64OrNetworkImage(imageData: photo)
                  : Container(
                      color: AppColors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: MediaQueryUtil.spacing(16),
                        color: AppColors.grey[700],
                      ),
                    ),
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(8)),
          Text(
            user.fullName ?? 'Unknown user',
            style: AppTextStyles.verySmall(fontWeight: AppFontWeight.semiBold),
          ),
        ],
      ),
    );
  }

  String _rewardSubtitle(ReferralRewardModel reward) {
    final duration = reward.rewardValue?.durationDays ?? 0;
    final users = reward.users.length;

    if (duration > 0 && users > 0) {
      return '$duration free days for $users referred users';
    }
    if (duration > 0) {
      return '$duration free days';
    }
    if (users > 0) {
      return '$users referred users';
    }
    return 'No referred users yet';
  }

  String _formatRewardType(String rewardType) {
    if (rewardType.isEmpty) {
      return 'Reward';
    }

    return rewardType
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _claimButtonLabel(ReferralRewardModel reward) {
    final duration = reward.rewardValue?.durationDays ?? 0;
    if (duration > 0) {
      return 'Claim $duration-day reward';
    }
    return 'Claim reward';
  }
}
