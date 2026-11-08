import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:intl/intl.dart';

class ReferralRewardBottomSheet extends StatelessWidget {
  final String? subscriptionTier;
  final String? expiresAt;

  const ReferralRewardBottomSheet({
    super.key,
    this.subscriptionTier,
    this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = expiresAt != null && _isDateAfterNow(expiresAt!);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(20),
            vertical: MediaQueryUtil.spacing(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
                    decoration: BoxDecoration(
                      color: AppColors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: MediaQueryUtil.spacing(20),
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Celebration Icon
              Container(
                width: MediaQueryUtil.spacing(70),
                height: MediaQueryUtil.spacing(70),
                decoration: BoxDecoration(
                  color: AppColors.cFF006C6A.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.card_giftcard,
                    size: MediaQueryUtil.spacing(40),
                    color: AppColors.cFF006C6A,
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(20)),

              // Title
              Text(
                'Congratulations! 🎉',
                textAlign: TextAlign.center,
                style: AppTextStyles.medium(
                  fontWeight: AppFontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Subtitle
              Text(
                'You\'ve unlocked Premium access!',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(
                  fontWeight: AppFontWeight.semi,
                  color: AppColors.darkGrey,
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(8)),

              // Description
              Container(
                padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
                decoration: BoxDecoration(
                  color: AppColors.cFF006C6A.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Thanks for joining through a referral code! You\'ve been rewarded with Premium access as a welcome bonus.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(24)),

              // Premium Benefits Section
              _buildBenefitsSection(),

              SizedBox(height: MediaQueryUtil.spacing(20)),

              // Subscription Info Card
              _buildSubscriptionInfoCard(isActive),

              SizedBox(height: MediaQueryUtil.spacing(24)),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: MediaQueryUtil.spacing(56),
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cFF006C6A,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start Exploring',
                    style: AppTextStyles.regular(
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Benefits:',
          style: AppTextStyles.small(
            fontWeight: AppFontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        _buildBenefitItem(
          icon: Icons.favorite,
          title: 'Unlimited Likes',
          description: 'Like as many profiles as you want',
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        _buildBenefitItem(
          icon: Icons.visibility,
          title: 'See Who Likes You',
          description: 'View all your admirers instantly',
        ),
        SizedBox(height: MediaQueryUtil.spacing(12)),
        _buildBenefitItem(
          icon: Icons.insights,
          title: 'Insights Report',
          description: 'Get detailed profile analytics',
        ),
      ],
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
      decoration: BoxDecoration(
        color: AppColors.cFFEFEFEF,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cFF006C6A.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQueryUtil.spacing(40),
            height: MediaQueryUtil.spacing(40),
            decoration: BoxDecoration(
              color: AppColors.cFF006C6A.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                size: MediaQueryUtil.spacing(20),
                color: AppColors.cFF006C6A,
              ),
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(4)),
                Text(
                  description,
                  style: AppTextStyles.extraSmall(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(8)),
          Icon(
            Icons.check_circle,
            size: MediaQueryUtil.spacing(20),
            color: AppColors.cFF006C6A,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionInfoCard(bool isActive) {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.cFF006C6A.withValues(alpha: 0.08)
            : AppColors.cFFEFEFEF,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppColors.cFF006C6A.withValues(alpha: 0.3)
              : AppColors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: MediaQueryUtil.spacing(44),
                height: MediaQueryUtil.spacing(44),
                decoration: BoxDecoration(
                  color: AppColors.cFF006C6A.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.calendar_today,
                    size: MediaQueryUtil.spacing(22),
                    color: AppColors.cFF006C6A,
                  ),
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription Status',
                      style: AppTextStyles.extraSmall(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      isActive ? 'Active' : 'Expired',
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.bold,
                        color: isActive
                            ? AppColors.cFF006C6A
                            : Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQueryUtil.spacing(12)),
          const Divider(height: 1, thickness: 0.5),
          SizedBox(height: MediaQueryUtil.spacing(12)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Type',
                      style: AppTextStyles.extraSmall(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      _getPlanLabel(subscriptionTier),
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expires On',
                      style: AppTextStyles.extraSmall(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      _formatExpiryDate(expiresAt),
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPlanLabel(String? tier) {
    switch (tier) {
      case 'standard':
        return 'Standard';
      case 'premium':
        return 'Premium';
      case 'paid':
        return 'Premium';
      case 'referral':
        return 'Premium (Referral)';
      default:
        return 'Premium';
    }
  }

  String _formatExpiryDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'N/A';
    }
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  bool _isDateAfterNow(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return date.isAfter(DateTime.now());
    } catch (_) {
      return true;
    }
  }
}
