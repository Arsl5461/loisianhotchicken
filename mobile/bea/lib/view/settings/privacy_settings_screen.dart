import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'widgets/security_chrome.dart';

class BubbaPrivacySettingsScreen extends StatelessWidget {
  const BubbaPrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => PrivacySettingsView(
        onBack: Get.back,
        onProfileVisibility: () => Get.toNamed(Routes.BUBBA_PROFILE_VISIBILITY),
        onHideFromContacts: () => Get.toNamed(Routes.BUBBA_HIDE_FROM_CONTACTS),
        onLastActive: () => Get.toNamed(Routes.BUBBA_LAST_ACTIVE_STATUS),
        onReadReceipts: () => Get.toNamed(Routes.BUBBA_READ_RECEIPTS),
      );
}

class PrivacySettingsView extends StatelessWidget {
  const PrivacySettingsView({
    super.key,
    this.onBack,
    this.onProfileVisibility,
    this.onHideFromContacts,
    this.onLastActive,
    this.onReadReceipts,
  });

  final VoidCallback? onBack;
  final VoidCallback? onProfileVisibility;
  final VoidCallback? onHideFromContacts;
  final VoidCallback? onLastActive;
  final VoidCallback? onReadReceipts;

  static const double _cardTop = 297.59;
  static const double _cardHeight = 275.72;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Privacy Settings',
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
      const ['Control who can see you and', 'what others see about you.'],
      firstBaseline: 235.36,
    );

    flow.block(
      SecurityCard(
        minHeight: _cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SecurityCardRow(
              top: _cardTop,
              height: 364.02 - _cardTop - BubbaSecurityMetrics.ruleWeight,
              onTap: onProfileVisibility,
              spec: const SecurityRowSpec(
                glyph: BubbaSecurityGlyphs.personCircle,
                iconX: 38.55,
                iconY: 321.01,
                iconWidth: 22.41,
                iconHeight: 22.41,
                title: 'Profile Visibility',
                titleX: 76.80,
                titleBaseline: 328.11,
                subtitle: ['Who can discover you'],
                subtitleBaseline: 346.92,
                trailing: SecurityChevron(),
                trailingY: 326.92,
                trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
              ),
            ),
            const SecurityCardRule(),
            SecurityCardRow(
              top: 364.02,
              height: 441.16 - 364.02 - BubbaSecurityMetrics.ruleWeight,
              onTap: onHideFromContacts,
              spec: const SecurityRowSpec(
                glyph: BubbaSecurityGlyphs.contactCard,
                iconX: 37.69,
                iconY: 390.06,
                iconWidth: 21.55,
                iconHeight: 22.41,
                title: 'Hide From Contacts',
                titleX: 76.80,
                titleBaseline: 392.88,
                subtitle: [
                  'Prevent people in your contacts',
                  'from seeing you.',
                ],
                subtitleBaseline: 411.69,
                subtitlePitch: BubbaSecurityMetrics.subtitlePitchTight,
                trailing: SecurityChevron(),
                trailingY: 397.29,
                trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
              ),
            ),
            const SecurityCardRule(),
            SecurityCardRow(
              top: 441.16,
              height: 506.57 - 441.16 - BubbaSecurityMetrics.ruleWeight,
              onTap: onLastActive,
              spec: const SecurityRowSpec(
                glyph: BubbaSecurityGlyphs.clock,
                iconX: 38.55,
                iconY: 462.66,
                iconWidth: 22.41,
                iconHeight: 22.41,
                title: 'Last Active Status',
                titleX: 76.80,
                titleBaseline: 470.66,
                subtitle: ['Who can see when you’re active'],
                subtitleBaseline: 489.48,
                trailing: SecurityChevron(),
                trailingY: 469.47,
                trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
              ),
            ),
            const SecurityCardRule(),
            SecurityCardRow(
              top: 506.57,
              height: _cardTop + _cardHeight - 506.57,
              onTap: onReadReceipts,
              spec: const SecurityRowSpec(
                glyph: BubbaSecurityGlyphs.doubleCheck,
                iconX: 40.06,
                iconY: 531.50,
                iconWidth: 21.62,
                iconHeight: 12.41,
                title: 'Read Receipts',
                titleX: 76.80,
                titleBaseline: 535.37,
                subtitle: ['Show when you’ve read messages'],
                subtitleBaseline: 554.18,
                trailing: SecurityChevron(),
                trailingY: 534.18,
                trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
              ),
            ),
          ],
        ),
      ),
      top: _cardTop,
      height: _cardHeight,
    );

    final footnoteTop = _PrivacyFootnote.topFor(context);
    flow.block(
      _PrivacyFootnote(top: footnoteTop),
      top: footnoteTop,
      height: 752.47 - footnoteTop,
    );
  }
}

class _PrivacyFootnote extends StatelessWidget {
  const _PrivacyFootnote({required this.top});

  /// The block starts at whichever comes first, the lock or the title's own
  /// ascender - the title's top is 5.5pt above the lock, so anchoring on the
  /// lock alone would ask for a negative gap.
  static double topFor(BuildContext context) => math.min(
        iconY,
        titleBaseline -
            bubbaDesignTextMetrics(context, BubbaSecurityText.rowTitle).baseline,
      );

  final double top;

  static const double iconY = 703.80;
  static const double iconX = 34.32;
  static const double textX = 79.06;
  static const double titleBaseline = 709.26;
  static const double bodyBaseline = 728.07;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.rowTitle);
    final bodyStyle = BubbaSecurityText.rowSubtitle.copyWith(
      height: BubbaSecurityMetrics.subtitlePitchTight / 12,
    );
    final bodyMetrics = bubbaDesignTextMetrics(context, bodyStyle);
    final titleTop = titleBaseline - titleMetrics.baseline;
    final bodyTop = bodyBaseline - bodyMetrics.baseline;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: hd(iconX)),
        Column(
          children: [
            SizedBox(height: d(iconY - top)),
            const BubbaGlyphIcon(
              BubbaSecurityGlyphs.lock,
              color: BubbaSecurityColors.icon,
              width: 24,
              height: 27,
            ),
          ],
        ),
        SizedBox(width: hd(textX - iconX - 24)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: d(titleTop - top)),
              Text('Your privacy matters.', style: BubbaSecurityText.rowTitle),
              SizedBox(
                height: d(bodyTop - (titleTop + titleMetrics.lineHeight)),
              ),
              Text(
                'Bubba is designed with\nyour safety and privacy in mind.',
                style: bodyStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
