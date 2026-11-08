import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'widgets/settings_chrome.dart';

const double _subtitleBaseline = 101.49;
const double _labelX = 25.64;
const double _chevronRightGap = 28.25;

class SettingsNotificationRow {
  const SettingsNotificationRow({
    required this.label,
    required this.labelBaseline,
    required this.chevronY,
    required this.bandEnd,
    this.dividerX,
    this.dividerY,
    this.dividerWidth,
  });

  final String label;
  final double labelBaseline;
  final double chevronY;
  final double bandEnd;
  final double? dividerX;
  final double? dividerY;
  final double? dividerWidth;
}

const List<(String, double, double)> settingsNotificationSections = [
  ('MESSAGES', 25.64, 163.77),
  ('CONNECTIONS', 25.64, 314.65),
  ('ACTIVITY', 25.64, 516.62),
];

const List<List<SettingsNotificationRow>> settingsNotificationRows = [
  [
    SettingsNotificationRow(
      label: 'New Messages',
      labelBaseline: 208.44,
      chevronY: 203.15,
      bandEnd: 248.44,
    ),
    SettingsNotificationRow(
      label: 'Expiring Conversations',
      labelBaseline: 264.44,
      chevronY: 256.27,
      bandEnd: 292.44,
      dividerX: 23.44,
      dividerY: 285.50,
      dividerWidth: 344.50,
    ),
  ],
  [
    SettingsNotificationRow(
      label: 'New Likes',
      labelBaseline: 356.94,
      chevronY: 348.71,
      bandEnd: 393.95,
    ),
    SettingsNotificationRow(
      label: 'New Matches',
      labelBaseline: 409.95,
      chevronY: 401.91,
      bandEnd: 447.95,
    ),
    SettingsNotificationRow(
      label: 'Expiring Matches',
      labelBaseline: 463.95,
      chevronY: 455.03,
      bandEnd: 492.00,
      dividerX: 20.85,
      dividerY: 483.70,
      dividerWidth: 344.50,
    ),
  ],
  [
    SettingsNotificationRow(
      label: 'Story Likes',
      labelBaseline: 561.29,
      chevronY: 554.66,
      bandEnd: 601.29,
    ),
    SettingsNotificationRow(
      label: 'Story Replies',
      labelBaseline: 617.29,
      chevronY: 607.78,
      bandEnd: 645.29,
      dividerX: 20.85,
      dividerY: 635.35,
      dividerWidth: 344.50,
    ),
  ],
];

class BubbaNotificationsScreen extends StatelessWidget {
  const BubbaNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsNotificationsView(
        onBack: Get.back,
        onCategory: (label) => Get.toNamed(
          Routes.NOTIFICATION_IN_APP,
          arguments: {'category': label},
        ),
      );
}

class SettingsNotificationsView extends StatelessWidget {
  const SettingsNotificationsView({super.key, this.onBack, this.onCategory});

  final VoidCallback? onBack;
  final ValueChanged<String>? onCategory;

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
      SettingsNavBar(title: 'Notifications', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    settingsSubtitle(
      context,
      flow,
      'Choose which notifications you’d like to receive.\n'
      'You can change these anytime.',
      _subtitleBaseline,
      lines: 2,
    );

    for (var s = 0; s < settingsNotificationSections.length; s++) {
      final (title, x, baseline) = settingsNotificationSections[s];
      settingsHeader(context, flow, title, x, baseline);
      for (final row in settingsNotificationRows[s]) {
        settingsRow(
          context,
          flow,
          SettingsRowSpec(
            label: row.label,
            labelX: _labelX,
            labelBaseline: row.labelBaseline,
            trailingY: row.chevronY,
            trailingRightGap: _chevronRightGap,
            dividerX: row.dividerX,
            dividerY: row.dividerY,
            dividerWidth: row.dividerWidth,
          ),
          bandEnd: row.bandEnd,
          onTap: onCategory == null ? null : () => onCategory!(row.label),
          trailing: const SettingsChevron(
            color: BubbaSettingsColors.chevronMuted,
          ),
        );
      }
    }
  }
}
