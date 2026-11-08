import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:OApp/widgets/Toggle/DisplayToggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final String category;

  const NotificationSettingsScreen({
    super.key,
    this.category = 'Notifications',
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool pushNotifications = false;
  bool inAppNotifications = false;
  bool emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery utility
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
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: MediaQueryUtil.padding(vertical: 24),
      child: Column(
        children: [
          // Description text
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(24),
            ),
            child: Text(
              'These notifications enable you to do something special. Turnign them off may mean a lesser experience.',
              textAlign: TextAlign.center,
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[800],
              ),
            ),
          ),

          SizedBox(height: MediaQueryUtil.spacing(12)),

          // Toggle Options
          Column(
            children: [
              _buildToggleOption(
                title: 'Push Notifications',
                value: pushNotifications,
                onChanged: (value) => setState(() => pushNotifications = value),
              ),
              _buildToggleOption(
                title: 'In-App Notifications',
                value: inAppNotifications,
                onChanged: (value) =>
                    setState(() => inAppNotifications = value),
              ),
              _buildToggleOption(
                title: 'Email Notifications',
                value: emailNotifications,
                onChanged: (value) =>
                    setState(() => emailNotifications = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQueryUtil.spacing(8),
        horizontal: MediaQueryUtil.spacing(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.small(
              fontWeight: AppFontWeight.semi,
              color: AppColors.black,
            ),
          ),
          DisplayToggle(
            label: '',
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.cFF006C6A,
            inactiveColor: AppColors.grey[300],
          ),
        ],
      ),
    );
  }
}
