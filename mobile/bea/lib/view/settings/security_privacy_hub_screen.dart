import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'bubba_security_controller.dart';
import 'widgets/security_chrome.dart';

class BubbaSecurityPrivacyScreen extends StatelessWidget {
  const BubbaSecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSecurityController.to;

    return Obx(() => SecurityPrivacyHubView(
          faceIdOn: controller.faceId.value,
          connectedSummary: controller.connectedSummary,
          onBack: Get.back,
          onFaceId: () => Get.toNamed(Routes.BUBBA_FACE_ID),
          onConnectAccounts: () => Get.toNamed(Routes.BUBBA_CONNECTED_ACCOUNTS),
          onPrivacySettings: () => Get.toNamed(Routes.BUBBA_PRIVACY_SETTINGS),
          onBlockedUsers: () => Get.toNamed(Routes.BUBBA_BLOCKED_USERS),
        ));
  }
}

class SecurityPrivacyHubView extends StatelessWidget {
  const SecurityPrivacyHubView({
    super.key,
    this.faceIdOn = true,
    this.connectedSummary = 'Phone, Apple, Email',
    this.onBack,
    this.onFaceId,
    this.onConnectAccounts,
    this.onPrivacySettings,
    this.onBlockedUsers,
  });

  final bool faceIdOn;
  final String connectedSummary;
  final VoidCallback? onBack;
  final VoidCallback? onFaceId;
  final VoidCallback? onConnectAccounts;
  final VoidCallback? onPrivacySettings;
  final VoidCallback? onBlockedUsers;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Security & Privacy',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      const SecurityHeroCircle(
        glyph: BubbaSecurityGlyphs.shieldCheck,
        glyphX: 182.94,
        glyphY: 134.97,
        glyphWidth: 24.35,
        glyphHeight: 29.22,
      ),
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );

    securityLead(
      context,
      flow,
      const ['Manage how you sign in', 'and keep your account safe.'],
      firstBaseline: BubbaSecurityMetrics.hubLeadBaseline,
    );

    flow.block(
      SecurityNavCard(
        top: 297.59,
        height: 82,
        onTap: onFaceId,
        spec: SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.faceId,
          iconX: 38.11,
          iconY: 326.92,
          iconWidth: 23.24,
          iconHeight: 23.24,
          title: 'Face ID',
          titleX: 76.80,
          titleBaseline: 337.85,
          subtitle: [faceIdOn ? 'On' : 'Off'],
          subtitleBaseline: 354.00,
          subtitleColor: faceIdOn
              ? BubbaSecurityColors.statusOn
              : BubbaSecurityColors.rowSubtitle,
          trailing: const SecurityChevron(),
          trailingY: 333.29,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 297.59,
      height: 82,
    );

    flow.block(
      SecurityNavCard(
        top: 395.09,
        height: 94,
        onTap: onConnectAccounts,
        spec: SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.link,
          iconX: 38.82,
          iconY: 431.30,
          iconWidth: 24.15,
          iconHeight: 20.75,
          title: 'Connect Accounts',
          titleX: 74.80,
          titleBaseline: 437.85,
          subtitle: [connectedSummary],
          subtitleBaseline: 458.30,
          trailing: const SecurityChevron(),
          trailingY: 436.79,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 395.09,
      height: 94,
    );

    flow.block(
      SecurityNavCard(
        top: 507.09,
        height: 82,
        onTap: onPrivacySettings,
        spec: const SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.eyeOff,
          iconX: 38.25,
          iconY: 537.76,
          iconWidth: 24.56,
          iconHeight: 19.81,
          title: 'Privacy Settings',
          titleX: 76.80,
          titleBaseline: 550.84,
          trailing: SecurityChevron(),
          trailingY: 542.79,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 507.09,
      height: 82,
    );

    flow.block(
      SecurityNavCard(
        top: 609.09,
        height: 82,
        onTap: onBlockedUsers,
        spec: const SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.blockCircle,
          iconX: 43.01,
          iconY: 639.96,
          iconWidth: 18.68,
          iconHeight: 18.68,
          title: 'Blocked Users',
          titleX: 76.80,
          titleBaseline: 653.84,
          trailing: SecurityChevron(),
          trailingY: 644.79,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 609.09,
      height: 82,
    );
  }
}
