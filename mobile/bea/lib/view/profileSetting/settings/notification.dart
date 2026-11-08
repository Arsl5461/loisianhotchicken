import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            EditProfileHeader(
              title: 'Notifications',
              onBack: () => Get.back(),
              showCloseButton: false,
            ),

            // Content
            Expanded(child: _buildNotificationsList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQueryUtil.spacing(18),
              horizontal: MediaQueryUtil.spacing(44),
            ),
            child: Text(
              'Choose which kind of notifications you would like to receive',
              textAlign: TextAlign.center,
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[800],
              ),
            ),
          ),

          // Messages Section
          SectionHeader(title: 'Messages'),
          NotificationItem(
            title: 'New Messages',
            subtitle:
                'Turning off these notificaionts will make it a lesser experience',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'New Messages'},
              );
            },
          ),

          // Divider
          SizedBox(height: MediaQueryUtil.spacing(8)),
          Divider(height: 1),
          SizedBox(height: MediaQueryUtil.spacing(8)),
          // Connections Section
          SectionHeader(title: 'Connections'),
          NotificationItem(
            title: 'New Likes',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'New Likes'},
              );
            },
          ),
          NotificationItem(
            title: 'New Macthes',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'New Matches'},
              );
            },
          ),
          NotificationItem(
            title: 'Expiring Matches',
            subtitle:
                'Turning off these notificaionts will make it a lesser experience',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'Expiring Matches'},
              );
            },
          ),
          SizedBox(height: MediaQueryUtil.spacing(8)),
          Divider(height: 1),
          SizedBox(height: MediaQueryUtil.spacing(8)),

          // Stories Section
          SectionHeader(title: 'Stories'),
          NotificationItem(
            title: 'Likes',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'Likes'},
              );
            },
          ),
          NotificationItem(
            title: 'Messages',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'Messages'},
              );
            },
          ),

          // Other Section
          SectionHeader(title: 'Other'),
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQueryUtil.spacing(24),
              MediaQueryUtil.spacing(8),
              MediaQueryUtil.spacing(24),
              MediaQueryUtil.spacing(0),
            ),
            child: Text(
              'Turning off these notificaionts will make it a lesser experience',
              style: AppTextStyles.verySmall(color: AppColors.grey[500]),
            ),
          ),
          NotificationItem(
            title: 'Tips',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'Tips'},
              );
            },
          ),
          NotificationItem(
            title: 'Research and Surveys',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'Research and Surveys'},
              );
            },
          ),
          NotificationItem(
            title: 'News and Updates',
            subtitle:
                'Turning off these notificaionts will make it a lesser experience',
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION_IN_APP,
                arguments: {'category': 'News and Updates'},
              );
            },
          ),

          SizedBox(height: MediaQueryUtil.spacing(40)),
        ],
      ),
    );
  }
}

// Section Header Widget
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQueryUtil.spacing(24),
        MediaQueryUtil.spacing(8),
        MediaQueryUtil.spacing(24),
        MediaQueryUtil.spacing(4),
      ),
      child: Text(
        title,
        style: AppTextStyles.verySmall(
          color: AppColors.grey[600],
          fontWeight: AppFontWeight.semi,
        ).copyWith(letterSpacing: 0.5),
      ),
    );
  }
}

// Notification Item Widget
class NotificationItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(24),
          vertical: MediaQueryUtil.spacing(12),
        ),
        child: Row(
          children: [
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
                  if (subtitle != null) ...[
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      subtitle ?? "",
                      style: AppTextStyles.extraSmall(
                        color: AppColors.grey[800],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: MediaQueryUtil.fontSize(18),
              color: AppColors.grey[800],
            ),
          ],
        ),
      ),
    );
  }
}
