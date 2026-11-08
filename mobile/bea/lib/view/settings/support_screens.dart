import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'widgets/settings_card_list.dart';
import 'widgets/settings_chrome.dart';

class SettingsCardScreen extends StatelessWidget {
  const SettingsCardScreen({
    super.key,
    required this.navTitle,
    required this.card,
    this.lead,
    this.leadX,
    this.leadBaseline,
    this.leadBold = false,
    this.secondLead,
    this.secondLeadX,
    this.secondLeadBaseline,
    this.onBack,
  });

  final String navTitle;
  final SettingsCardList card;
  final String? lead;
  final double? leadX;
  final double? leadBaseline;
  final bool leadBold;
  final String? secondLead;
  final double? secondLeadX;
  final double? secondLeadBaseline;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: (context, flow) {
            flow.block(
              SettingsNavBar(title: navTitle, onBack: onBack),
              top: 0,
              height: BubbaSettingsMetrics.navHeight,
            );
            if (lead != null) {
              settingsLead(
                context,
                flow,
                lead!,
                leadX!,
                leadBaseline!,
                bold: leadBold,
              );
            }
            if (secondLead != null) {
              settingsLead(
                context,
                flow,
                secondLead!,
                secondLeadX!,
                secondLeadBaseline!,
              );
            }
            flow.block(card, top: card.y, height: card.height);
          },
        ),
      );
}

const _supportRows = [
  SettingsCardRow(
    title: 'Contact Support',
    titleX: 34.12,
    titleBaseline: 198.97,
    subtitle: 'Get help from our team',
    subtitleX: 35.42,
    subtitleBaseline: 222.92,
    chevronX: 341.67,
    chevronY: 205.45,
    bandTop: 161.50,
    bandBottom: 241.25,
    dividerX: 29.40,
    dividerY: 241.75,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'FAQ',
    titleX: 32.58,
    titleBaseline: 272.66,
    subtitle: 'Find answers quickly',
    subtitleX: 33.88,
    subtitleBaseline: 296.61,
    chevronX: 340.12,
    chevronY: 279.15,
    bandTop: 242.25,
    bandBottom: 314.95,
    dividerX: 27.85,
    dividerY: 315.45,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Safety Center',
    titleX: 31.58,
    titleBaseline: 343.66,
    subtitle: 'Tools and resources to stay safe',
    subtitleX: 32.88,
    subtitleBaseline: 367.61,
    chevronX: 339.12,
    chevronY: 350.15,
    bandTop: 315.95,
    bandBottom: 385.95,
    dividerX: 26.85,
    dividerY: 386.45,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Legal',
    titleX: 31.87,
    titleBaseline: 414.86,
    subtitle: 'Find answers quickly',
    subtitleX: 33.17,
    subtitleBaseline: 438.81,
    chevronX: 339.41,
    chevronY: 421.35,
    bandTop: 386.95,
    bandBottom: 462.50,
  ),
];

const _faqRows = [
  SettingsCardRow(
    title: 'How does membership work',
    titleX: 44.18,
    titleBaseline: 210.90,
    chevronX: 339.20,
    chevronY: 203.45,
    bandTop: 173.50,
    bandBottom: 235.00,
    dividerX: 30.55,
    dividerY: 235.50,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'How do time packs work',
    titleX: 43.01,
    titleBaseline: 266.94,
    chevronX: 339.20,
    chevronY: 258.24,
    bandTop: 236.00,
    bandBottom: 290.50,
    dividerX: 30.55,
    dividerY: 291.00,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'How does travel mode work',
    titleX: 44.51,
    titleBaseline: 324.98,
    chevronX: 339.20,
    chevronY: 313.03,
    bandTop: 291.50,
    bandBottom: 346.00,
    dividerX: 30.55,
    dividerY: 346.50,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'How to change my location',
    titleX: 44.51,
    titleBaseline: 377.51,
    chevronX: 339.20,
    chevronY: 367.82,
    bandTop: 347.00,
    bandBottom: 401.50,
    dividerX: 30.55,
    dividerY: 402.00,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'How to delete my account',
    titleX: 44.51,
    titleBaseline: 437.05,
    chevronX: 339.20,
    chevronY: 422.61,
    bandTop: 402.50,
    bandBottom: 457.00,
    dividerX: 30.55,
    dividerY: 457.50,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Can i get a refund',
    titleX: 45.01,
    titleBaseline: 488.09,
    chevronX: 339.20,
    chevronY: 477.40,
    bandTop: 458.00,
    bandBottom: 521.50,
  ),
];

const _contactRows = [
  SettingsCardRow(
    title: 'Billing & Payments',
    titleX: 36.18,
    titleBaseline: 210.97,
    chevronX: 339.20,
    chevronY: 203.45,
    bandTop: 173.5,
    bandBottom: 235.0,
    dividerX: 30.55,
    dividerY: 235.5,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Membership',
    titleX: 35.01,
    titleBaseline: 267.01,
    chevronX: 339.20,
    chevronY: 258.24,
    bandTop: 236.0,
    bandBottom: 290.5,
    dividerX: 30.55,
    dividerY: 291.0,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Safety ',
    titleX: 36.51,
    titleBaseline: 325.05,
    chevronX: 339.20,
    chevronY: 313.03,
    bandTop: 291.5,
    bandBottom: 346.0,
    dividerX: 30.55,
    dividerY: 346.5,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Account Access',
    titleX: 36.51,
    titleBaseline: 377.58,
    chevronX: 339.20,
    chevronY: 367.82,
    bandTop: 347.0,
    bandBottom: 401.5,
    dividerX: 30.55,
    dividerY: 402.0,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Technical Issue',
    titleX: 36.51,
    titleBaseline: 437.12,
    chevronX: 339.20,
    chevronY: 422.61,
    bandTop: 402.5,
    bandBottom: 457.0,
    dividerX: 30.55,
    dividerY: 457.5,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Other',
    titleX: 37.01,
    titleBaseline: 488.16,
    chevronX: 339.20,
    chevronY: 477.4,
    bandTop: 458.0,
    bandBottom: 509.5,
  ),
];

const _safetyRows = [
  SettingsCardRow(
    title: 'Protect your information',
    titleX: 31.58,
    titleBaseline: 210.97,
    subtitle: 'Report inappropriate behavior',
    subtitleX: 31.58,
    subtitleBaseline: 236.39,
    subtitleLarge: true,
    chevronX: 341.67,
    chevronY: 210.45,
    bandTop: 173.50,
    bandBottom: 253.25,
    dividerX: 29.40,
    dividerY: 253.75,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Safety Tips',
    titleX: 31.91,
    titleBaseline: 286.71,
    subtitle: 'Tools and resources to stay safe',
    subtitleX: 31.91,
    subtitleBaseline: 312.14,
    subtitleLarge: true,
    chevronX: 339.45,
    chevronY: 286.20,
    bandTop: 254.25,
    bandBottom: 329.00,
    dividerX: 27.18,
    dividerY: 329.50,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Emergency Resources',
    titleX: 31.91,
    titleBaseline: 357.91,
    subtitle: 'Local and global resources',
    subtitleX: 31.91,
    subtitleBaseline: 383.33,
    subtitleLarge: true,
    chevronX: 339.74,
    chevronY: 357.40,
    bandTop: 330.00,
    bandBottom: 403.50,
  ),
];

const _legalRows = [
  SettingsCardRow(
    title: 'Privacy Policy',
    titleX: 39.18,
    titleBaseline: 210.97,
    chevronX: 339.20,
    chevronY: 203.45,
    bandTop: 173.50,
    bandBottom: 235.00,
    dividerX: 30.55,
    dividerY: 235.50,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Terms of Service',
    titleX: 38.01,
    titleBaseline: 267.01,
    chevronX: 339.20,
    chevronY: 258.24,
    bandTop: 236.00,
    bandBottom: 290.50,
    dividerX: 30.55,
    dividerY: 291.00,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Community Guidelines',
    titleX: 39.51,
    titleBaseline: 325.05,
    chevronX: 339.20,
    chevronY: 313.03,
    bandTop: 291.50,
    bandBottom: 346.00,
    dividerX: 30.55,
    dividerY: 346.50,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Cookie Policy',
    titleX: 39.51,
    titleBaseline: 377.58,
    chevronX: 339.20,
    chevronY: 367.82,
    bandTop: 347.00,
    bandBottom: 401.50,
    dividerX: 30.55,
    dividerY: 402.00,
    dividerWidth: 318,
  ),
  SettingsCardRow(
    title: 'Licenses',
    titleX: 39.51,
    titleBaseline: 437.12,
    chevronX: 339.20,
    chevronY: 422.61,
    bandTop: 402.50,
    bandBottom: 472.50,
  ),
];

List<SettingsCardRow> _tapped(
  List<SettingsCardRow> rows,
  Map<String, VoidCallback>? taps,
) =>
    [for (final row in rows) row.withTap(taps?[row.title])];

class SettingsSupportView extends StatelessWidget {
  const SettingsSupportView({super.key, this.onBack, this.taps});

  final VoidCallback? onBack;
  final Map<String, VoidCallback>? taps;

  @override
  Widget build(BuildContext context) => SettingsCardScreen(
        navTitle: 'Support',
        onBack: onBack,
        lead: 'Choose a topic below',
        leadX: 16.78,
        leadBaseline: 149.63,
        card: SettingsCardList(
          x: 14.40,
          y: 161.50,
          width: 354,
          height: 301,
          rows: _tapped(_supportRows, taps),
        ),
      );
}

class SettingsFaqView extends StatelessWidget {
  const SettingsFaqView({super.key, this.onBack, this.taps});

  final VoidCallback? onBack;
  final Map<String, VoidCallback>? taps;

  @override
  Widget build(BuildContext context) => SettingsCardScreen(
        navTitle: 'FAQ',
        onBack: onBack,
        lead: 'Popular topics',
        leadX: 20.64,
        leadBaseline: 145.77,
        leadBold: true,
        card: SettingsCardList(
          x: 14.40,
          y: 173.50,
          width: 354,
          height: 348,
          fill: BubbaSettingsColors.pageBg,
          rows: _tapped(_faqRows, taps),
        ),
      );
}

class SettingsSafetyCentreView extends StatelessWidget {
  const SettingsSafetyCentreView({super.key, this.onBack, this.taps});

  final VoidCallback? onBack;
  final Map<String, VoidCallback>? taps;

  @override
  Widget build(BuildContext context) => SettingsCardScreen(
        navTitle: 'Safety Center',
        onBack: onBack,
        lead: 'We’re here to help',
        leadX: 18.64,
        leadBaseline: 110.77,
        leadBold: true,
        secondLead: 'Choose a topic below',
        secondLeadX: 20.78,
        secondLeadBaseline: 142.63,
        card: SettingsCardList(
          x: 18.00,
          y: 173.50,
          width: 354,
          height: 230,
          rows: _tapped(_safetyRows, taps),
        ),
      );
}

class SettingsLegalView extends StatelessWidget {
  const SettingsLegalView({super.key, this.onBack, this.taps});

  final VoidCallback? onBack;
  final Map<String, VoidCallback>? taps;

  @override
  Widget build(BuildContext context) => SettingsCardScreen(
        navTitle: 'Legal',
        onBack: onBack,
        lead: 'How can we help?',
        leadX: 20.64,
        leadBaseline: 145.77,
        leadBold: true,
        card: SettingsCardList(
          x: 14.40,
          y: 173.50,
          width: 354,
          height: 299,
          rows: _tapped(_legalRows, taps),
        ),
      );
}

class SettingsContactSupportView extends StatelessWidget {
  const SettingsContactSupportView({super.key, this.onBack, this.taps});

  final VoidCallback? onBack;
  final Map<String, VoidCallback>? taps;

  @override
  Widget build(BuildContext context) => SettingsCardScreen(
        navTitle: 'Contact Support',
        onBack: onBack,
        lead: 'How can we help?',
        leadX: 20.64,
        leadBaseline: 145.77,
        leadBold: true,
        card: SettingsCardList(
          x: 14.40,
          y: 173.50,
          width: 354,
          height: 336,
          rows: _tapped(_contactRows, taps),
        ),
      );
}

class BubbaContactSupportScreen extends StatelessWidget {
  const BubbaContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsContactSupportView(
        onBack: Get.back,
        taps: {
          for (final topic in const [
            'Billing & Payments',
            'Membership',
            'Safety ',
            'Account Access',
            'Technical Issue',
            'Other',
          ])
            topic: () => Get.toNamed(
                  Routes.BUBBA_TECHNICAL_ISSUE,
                  arguments: {'topic': topic.trim()},
                ),
        },
      );
}

class BubbaSupportScreen extends StatelessWidget {
  const BubbaSupportScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsSupportView(
        onBack: Get.back,
        taps: {
          'Contact Support': () =>
              Get.to(() => const BubbaContactSupportScreen()),
          'FAQ': () => Get.to(() => const BubbaFaqScreen()),
          'Safety Center': () => Get.to(() => const BubbaSafetyCentreScreen()),
          'Legal': () => Get.to(() => const BubbaLegalScreen()),
        },
      );
}

class BubbaFaqScreen extends StatelessWidget {
  const BubbaFaqScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsFaqView(
        onBack: Get.back,
        taps: {
          for (final question in const [
            'How does membership work',
            'How do time packs work',
            'How does travel mode work',
            'How to change my location',
            'How to delete my account',
            'Can i get a refund',
          ])
            question: () => Get.toNamed(
                  Routes.BUBBA_FAQ_EXPANDED,
                  arguments: {'question': question},
                ),
        },
      );
}

class BubbaSafetyCentreScreen extends StatelessWidget {
  const BubbaSafetyCentreScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsSafetyCentreView(
        onBack: Get.back,
        taps: {
          'Protect your information': () =>
              Get.toNamed(Routes.BUBBA_PROTECT_INFORMATION),
          'Report inappropriate behavior': () =>
              Get.toNamed(Routes.BUBBA_TECHNICAL_ISSUE, arguments: {
                'topic': 'Report inappropriate behavior',
              }),
          'Safety Tips': () => Get.toNamed(Routes.BUBBA_SAFETY_TIPS),
          'Tools and resources to stay safe': () =>
              Get.toNamed(Routes.BUBBA_SAFETY_TIPS),
          'Emergency Resources': () =>
              Get.toNamed(Routes.BUBBA_EMERGENCY_RESOURCES),
          'Local and global resources': () =>
              Get.toNamed(Routes.BUBBA_EMERGENCY_RESOURCES),
        },
      );
}

class BubbaLegalScreen extends StatelessWidget {
  const BubbaLegalScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsLegalView(
        onBack: Get.back,
        taps: {
          'Privacy Policy': () => Get.toNamed(Routes.PRIVACY_POLICY_PAGE),
          'Terms of Service': () => Get.toNamed(Routes.TERMS_OF_SERVICE),
          'Community Guidelines': () =>
              Get.toNamed(Routes.BUBBA_COMMUNITY_GUIDELINES),
          'Cookie Policy': () => Get.toNamed(Routes.BUBBA_COOKIE_POLICY),
          'Licenses': () => Get.toNamed(Routes.BUBBA_LICENSES),
        },
      );
}
