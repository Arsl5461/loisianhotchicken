import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/common_widgets/buttons.dart';
import 'package:OApp/view/messages/widgets/contact_list_widgets.dart';
import 'package:flutter/material.dart';

class ProfileLoadErrorView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Future<void> Function() onRetry;
  final VoidCallback onLogout;

  const ProfileLoadErrorView({
    super.key,
    required this.onRefresh,
    required this.onRetry,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const EmptySectionHeader(title: 'Profile', count: 0),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(16),
              vertical: MediaQueryUtil.spacing(14),
            ),
            child: Text(
              'Unable to load profile',
              style: AppTextStyles.verySmall(
                fontWeight: AppFontWeight.semiBold,
                fontFamily: AppFontFamily.playfair,
              ),
            ),
          ),
          Divider(color: AppColors.grey[300], height: 1),
          SizedBox(height: MediaQueryUtil.height * 0.16),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(24),
            ),
            child: Column(
              children: [
                Text(
                  'We could not load your profile',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.large(
                    fontWeight: AppFontWeight.semiBold,
                    fontFamily: AppFontFamily.playfair,
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(18)),
                Text(
                  'Please pull down to refresh or tap retry below. If the issue continues, you can log out and sign in again.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.darkGrey,
                    fontFamily: AppFontFamily.playfair,
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(40)),
                CommonButtons.commonButton(
                  borderRadius: 10,
                  text: 'Retry',
                  onPressed: onRetry,
                ),
                SizedBox(height: MediaQueryUtil.spacing(14)),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onLogout,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQueryUtil.spacing(14),
                      ),
                      side: const BorderSide(color: AppColors.black, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.semiBold,
                        color: AppColors.black,
                        fontFamily: AppFontFamily.playfair,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(40)),
        ],
      ),
    );
  }
}
