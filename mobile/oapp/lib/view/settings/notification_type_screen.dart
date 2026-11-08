import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../models/settings_models.dart';
import 'bubba_settings_controller.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';

const double _subtitleBaseline = 101.49;
const double _labelX = 25.64;
const double _firstBaseline = 180.44;
const double _rowPitch = 57.25;
const double _toggleGapAboveBaseline = 15.99;
const double _toggleRightGap = 26.53;

class SettingsNotificationType {
  const SettingsNotificationType(this.label, this.enabled);

  final String label;
  final bool enabled;
}

const Map<String, List<String>> settingsNotificationTypes = {
  'New Messages': ['Push Notifications', 'In-App Notifications', 'Email'],
  'Expiring Conversations': [
    'Push Notifications',
    'In-App Notifications',
    'Email',
  ],
  'New Likes': ['Push Notifications', 'In-App Notifications', 'Email'],
  'New Matches': ['Push Notifications', 'In-App Notifications', 'Email'],
  'Expiring Matches': ['Push Notifications', 'In-App Notifications', 'Email'],
  'Story Likes': ['Push Notifications', 'In-App Notifications', 'Email'],
  'Story Replies': ['Push Notifications', 'In-App Notifications', 'Email'],
};

/// p003. The three channels for one category, each a live switch.
class BubbaNotificationTypeScreen extends StatelessWidget {
  const BubbaNotificationTypeScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSettingsController.to;
    final key = NotificationPreferences.categoryFor(category) ??
        NotificationPreferences.categories.first;

    return Obx(() {
      final prefs = controller.notifications.value;

      return SettingsNotificationTypeView(
        rows: [
          for (final channel in NotificationPreferences.channels)
            SettingsNotificationType(
              NotificationPreferences.channelLabels[channel] ?? channel,
              prefs.valueFor(key, channel),
            ),
        ],
        onChanged: (index, value) async {
          final channel = NotificationPreferences.channels[index];
          final ok = await controller.setNotification(key, channel, value);
          if (!ok) showSettingsError(controller.error.value);
        },
        onBack: Get.back,
      );
    });
  }
}

class SettingsNotificationTypeView extends StatelessWidget {
  const SettingsNotificationTypeView({
    super.key,
    required this.rows,
    this.onChanged,
    this.onBack,
  });

  final List<SettingsNotificationType> rows;
  final void Function(int index, bool value)? onChanged;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SettingsNavBar(title: 'Notification Type', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    settingsSubtitle(
      context,
      flow,
      'Manage each type of notification',
      _subtitleBaseline,
    );

    for (var i = 0; i < rows.length; i++) {
      final baseline = _firstBaseline + _rowPitch * i;
      settingsRow(
        context,
        flow,
        SettingsRowSpec(
          label: rows[i].label,
          labelX: _labelX,
          labelBaseline: baseline,
          trailingY: baseline - _toggleGapAboveBaseline,
          trailingRightGap: _toggleRightGap,
        ),
        bandEnd: baseline + _rowPitch - 16,
        onTap: onChanged == null ? null : () => onChanged!(i, !rows[i].enabled),
        trailing: SettingsToggle(
          value: rows[i].enabled,
          label: rows[i].label,
        ),
      );
    }
  }
}
