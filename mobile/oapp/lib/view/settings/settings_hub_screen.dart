import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../profileSetting/settings/controllers/settings_controller.dart';
import 'bubba_security_controller.dart';
import 'delete_account_screen.dart';
import 'pause_account_screen.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';

const double _preferencesBaseline = 110.77;
const double _preferencesX = 18.64;
const double _accountBaseline = 288.65;
const double _accountX = 19.07;
const double _accountStatusBaseline = 542.54;
const double _accountStatusX = 24.45;

class BubbaSettingsScreen extends StatelessWidget {
  const BubbaSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController());
    final security = BubbaSecurityController.to;
    return Obx(
      () => SettingsHubView(
        incognito: security.privacy.value.incognito,
        onIncognitoChanged: (value) async {
          final ok = await security.setIncognito(value);
          if (!ok) showSettingsError(security.error.value);
        },
        onNotifications: () => Get.toNamed(Routes.NOTIFICATIONS_PAGE),
        onMembership: () => Get.toNamed(Routes.BUBBA_MEMBERSHIP),
        onSecurity: () => Get.toNamed(Routes.BUBBA_SECURITY_PRIVACY),
        onSupport: () => Get.toNamed(Routes.SUPPORT),
        onInvitation: () => Get.toNamed(Routes.BUBBA_INVITATION_LINK),
        onPause: () => Get.to(() => const BubbaPauseAccountScreen()),
        onDelete: () => Get.to(() => const BubbaDeleteAccountScreen()),
        onLogout: controller.logout,
        onBack: Get.back,
      ),
    );
  }
}

class SettingsHubView extends StatelessWidget {
  const SettingsHubView({
    super.key,
    required this.incognito,
    this.onIncognitoChanged,
    this.onNotifications,
    this.onMembership,
    this.onSecurity,
    this.onSupport,
    this.onInvitation,
    this.onPause,
    this.onDelete,
    this.onLogout,
    this.onBack,
  });

  final bool incognito;
  final ValueChanged<bool>? onIncognitoChanged;
  final VoidCallback? onNotifications;
  final VoidCallback? onMembership;
  final VoidCallback? onSecurity;
  final VoidCallback? onSupport;
  final VoidCallback? onInvitation;
  final VoidCallback? onPause;
  final VoidCallback? onDelete;
  final VoidCallback? onLogout;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BubbaSettingsColors.pageBg,
      body: BubbaPage(
        padContent: false,
        background: BubbaSettingsColors.pageBg,
        content: _content,
      ),
    );
  }

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SettingsNavBar(title: 'Settings', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    settingsHeader(context, flow, 'PREFERENCES', _preferencesX, _preferencesBaseline);

    settingsRow(
      context,
      flow,
      const SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.bell,
        iconX: 26.99,
        iconY: 141.96,
        iconWidth: 15.62,
        iconHeight: 17.50,
        label: 'Notifications',
        labelX: 70.43,
        labelBaseline: 155.44,
        trailingY: 147.37,
        dividerY: 176.00,
        dividerX: 69.08,
        dividerWidth: 291.86,
      ),
      onTap: onNotifications,
      trailing: const SettingsChevron(),
      bandEnd: 195.44,
    );

    settingsRow(
      context,
      flow,
      const SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.incognito,
        iconX: 20.75,
        iconY: 199.00,
        iconWidth: 26.09,
        iconHeight: 13.38,
        label: 'Incognito Mode',
        labelX: 70.43,
        labelBaseline: 211.44,
        subtitle: 'Others won’t see you in discovery\nunless you like them first',
        subtitleBaseline: 230.19,
        trailingY: 205.88,
        trailingRightGap: 30.05,
        dividerY: 259.50,
        dividerX: 17.44,
        dividerWidth: 344.50,
      ),
      onTap: onIncognitoChanged == null ? null : () => onIncognitoChanged!(!incognito),
      trailing: SettingsToggle(value: incognito, label: 'Incognito Mode'),
      bandEnd: 267.50,
    );

    settingsHeader(context, flow, 'ACCOUNT', _accountX, _accountBaseline);

    settingsRow(
      context,
      flow,
      const SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.membership,
        iconX: 22.57,
        iconY: 309.92,
        iconWidth: 22.44,
        iconHeight: 17.39,
        label: 'Membership',
        labelX: 70.43,
        labelBaseline: 324.94,
        trailingY: 313.81,
        dividerY: 345.50,
        dividerX: 69.08,
        dividerWidth: 291.86,
      ),
      onTap: onMembership,
      trailing: const SettingsChevron(),
      bandEnd: 364.94,
    );

    settingsRow(
      context,
      flow,
      const SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.security,
        iconX: 26.26,
        iconY: 365.34,
        iconWidth: 15.07,
        iconHeight: 18.08,
        label: 'Security & Privacy',
        labelX: 70.43,
        labelBaseline: 380.94,
        trailingY: 369.77,
        dividerY: 401.50,
        dividerX: 69.08,
        dividerWidth: 291.86,
      ),
      onTap: onSecurity,
      trailing: const SettingsChevron(),
      bandEnd: 418.94,
    );

    settingsRow(
      context,
      flow,
      const SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.support,
        iconX: 24.55,
        iconY: 419.35,
        iconWidth: 18.48,
        iconHeight: 18.48,
        label: 'Support',
        labelX: 70.43,
        labelBaseline: 434.94,
        trailingY: 423.25,
        dividerY: 455.50,
        dividerX: 69.08,
        dividerWidth: 291.86,
      ),
      onTap: onSupport,
      trailing: const SettingsChevron(),
      bandEnd: 470.76,
    );

    settingsRow(
      context,
      flow,
      const SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.invitation,
        iconX: 25.92,
        iconY: 470.76,
        iconWidth: 19.44,
        iconHeight: 18.92,
        label: 'Invitation Link',
        labelX: 70.43,
        labelBaseline: 486.94,
        trailingY: 476.73,
        dividerY: 507.50,
        dividerX: 21.44,
        dividerWidth: 344.50,
      ),
      onTap: onInvitation,
      trailing: const SettingsChevron(),
      bandEnd: 515.50,
    );

    settingsHeader(
      context,
      flow,
      'ACCOUNT STATUS',
      _accountStatusX,
      _accountStatusBaseline,
    );

    settingsRow(
      context,
      flow,
      SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.pauseAccount,
        iconX: 24.64,
        iconY: 573.46,
        iconWidth: 18.31,
        iconHeight: 18.31,
        iconColor: BubbaSettingsColors.pauseIcon,
        label: 'Pause Account',
        labelX: 59.94,
        labelBaseline: 585.94,
        labelStyle: BubbaSettingsText.rowLabelStrong.copyWith(
          color: BubbaSettingsColors.pauseLabel,
        ),
        trailingY: 580.52,
        dividerY: 606.50,
        dividerX: 38.94,
        dividerWidth: 324.00,
      ),
      onTap: onPause,
      trailing: const SettingsChevron(),
      bandEnd: 623.94,
    );

    settingsRow(
      context,
      flow,
      SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.deleteAccount,
        iconX: 26.57,
        iconY: 626.53,
        iconWidth: 14.43,
        iconHeight: 17.32,
        iconColor: BubbaSettingsColors.deleteIcon,
        label: 'Delete Account',
        labelX: 59.94,
        labelBaseline: 639.94,
        labelStyle: BubbaSettingsText.rowLabelStrong.copyWith(
          color: BubbaSettingsColors.deleteLabel,
        ),
        trailingY: 633.64,
        dividerY: 660.50,
        dividerX: 38.94,
        dividerWidth: 324.00,
      ),
      onTap: onDelete,
      trailing: const SettingsChevron(),
      bandEnd: 679.29,
    );

    settingsRow(
      context,
      flow,
      SettingsRowSpec(
        glyph: BubbaSettingsGlyphs.logout,
        iconX: 25.41,
        iconY: 682.66,
        iconWidth: 16.94,
        iconHeight: 17.12,
        label: 'Logout',
        labelX: 60.09,
        labelBaseline: 695.29,
        labelStyle: BubbaSettingsText.rowLabelStrong,

      ),
      onTap: onLogout,
      bandEnd: 730.00,
    );
  }

}
