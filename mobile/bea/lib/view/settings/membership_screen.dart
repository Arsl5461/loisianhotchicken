import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'bubba_settings_controller.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';
import 'widgets/settings_confirm_scaffold.dart';

class SettingsBenefit {
  const SettingsBenefit(this.title, this.body);
  final String title;
  final String body;
}

class SettingsManagementRow {
  const SettingsManagementRow({
    required this.title,
    required this.body,
    required this.glyph,
    required this.glyphSize,
    required this.glyphOffset,
    required this.circleFill,
    this.circleBorder,
    this.glyphColour = BubbaSettingsColors.onDark,
    this.bodyLines = 1,
  });

  final String title;
  final String body;
  final BubbaGlyph glyph;
  final Size glyphSize;
  final Offset glyphOffset;
  final Color circleFill;
  final Color? circleBorder;
  final Color glyphColour;
  final int bodyLines;
}

const List<SettingsBenefit> settingsPremiumBenefits = [
  SettingsBenefit('Unlimited likes', 'Like as many people as you want.'),
  SettingsBenefit(
    'Explore mode',
    'Connect with people around the world with stories',
  ),
  SettingsBenefit('See who likes you', 'Unlock and see who already likes you'),
  SettingsBenefit(
    'Time extensions',
    'Extend up to 10 conversations each month by 24h',
  ),
];

const List<SettingsBenefit> settingsCancelledBenefits = [
  ...settingsPremiumBenefits,
  SettingsBenefit(
    'Advanced filters',
    'Narrow your search and find precise matches',
  ),
];

const List<SettingsManagementRow> settingsManagementRows = [
  SettingsManagementRow(
    title: 'Time packs',
    body: 'Keep the conversation going for 24 hours',
    glyph: BubbaSettingsGlyphs.mgmtTime,
    glyphSize: Size(12.04, 12.30),
    glyphOffset: Offset(9.40, 8.21),
    circleFill: BubbaSettingsColors.productBlue,
  ),
  SettingsManagementRow(
    title: 'Shine packs',
    body: 'Be seen by 10x more users',
    glyph: BubbaSettingsGlyphs.mgmtShine,
    glyphSize: Size(10.61, 10.49),
    glyphOffset: Offset(9.97, 10.13),
    circleFill: BubbaSettingsColors.productCoral,
    circleBorder: BubbaSettingsColors.productBorder,
  ),
  SettingsManagementRow(
    title: 'Payment method',
    body: 'Visa 2424',
    glyph: BubbaSettingsGlyphs.mgmtPayment,
    glyphSize: Size(14.88, 10.63),
    glyphOffset: Offset(7.63, 9.39),
    circleFill: BubbaSettingsColors.orderIconBg,
    glyphColour: BubbaSettingsColors.rowLabel,
  ),
  SettingsManagementRow(
    title: 'Change plan',
    body: 'See other plans and pricing',
    glyph: BubbaSettingsGlyphs.mgmtPlan,
    glyphSize: Size(12.76, 12.76),
    glyphOffset: Offset(9.09, 9.39),
    circleFill: BubbaSettingsColors.orderIconBg,
    glyphColour: BubbaSettingsColors.rowLabel,
  ),
  SettingsManagementRow(
    title: 'Purchase history',
    body: 'View your past payments and invoices',
    glyph: BubbaSettingsGlyphs.mgmtHistory,
    glyphSize: Size(13.82, 11.77),
    glyphOffset: Offset(8.02, 8.98),
    circleFill: BubbaSettingsColors.orderIconBg,
    glyphColour: BubbaSettingsColors.rowLabel,
  ),
  SettingsManagementRow(
    title: 'Manage in App Store',
    body: 'Update payment method, view receipts\nor cancel anytime.',
    glyph: BubbaSettingsGlyphs.mgmtAppStore,
    glyphSize: Size(13.97, 12.12),
    glyphOffset: Offset(8.13, 8.97),
    circleFill: BubbaSettingsColors.orderIconBg,
    glyphColour: BubbaSettingsColors.rowLabel,
    bodyLines: 2,
  ),
];

const double _heroX = 8.2;
const double _heroY = 78.2;
const double _heroW = 373;
const double _heroH = 232;

const double _standardHeroX = 7.8;
const double _standardHeroY = 68.3;
const double _standardHeroW = 374.5;
const double _standardHeroH = 244.7;

const double _statusHeroX = 18.51;
const double _statusHeroY = 170.68;
const double _statusHeroW = 354.03;
const double _statusHeroH = 212.52;

const double _bannerY = 86.61;
const double _bannerH = 67;

const double _cardX = 17.62;
const double _cardW = 354;

const double _benefitIcon = 17.50;
const double _benefitTitleTop = 27.95;
const double _benefitBodyTop = 46.94;
const double _benefitTitleX = 42.73;
const double _benefitBodyX = 44.03;
const double _benefitPitch = 47.75;

const double _lockedIconCentreX = 23.24;
const double _lockedIconCentreY = 32.91;
const double _lockedTitleX = 47.73;
const double _lockedBodyX = 49.03;
const double _lockedLockCentreX = 334.84;
const double _lockedLockCentreY = 30.94;

const double _mgmtRefY = 646.89;
const double _mgmtCardH = 452.82;
const List<double> _mgmtIconY = [663.58, 725.35, 790.79, 850.63, 913.01, 973.29];
const List<double> _mgmtIconX = [34.08, 34.46, 34.61, 35.15, 36.35, 38.36];
const List<double> _mgmtTitleBaseline = [
  672.15,
  733.91,
  799.36,
  859.20,
  921.58,
  981.85,
];
const List<double> _mgmtTitleX = [78.83, 79.21, 79.36, 79.90, 81.09, 83.10];
const List<double> _mgmtBodyBaseline = [
  691.16,
  752.93,
  818.37,
  878.22,
  940.59,
  1000.87,
];
const List<double> _mgmtChevronX = [343.99, 344.37, 344.52, 345.06, 346.26, 348.27];
const List<double> _mgmtChevronY = [676.48, 738.25, 803.69, 863.53, 925.91, 986.19];
const List<double> _mgmtRuleY = [711.05, 772.82, 835.50, 898.11, 958.39, 1027.87];
const List<double> _mgmtRuleX = [29.52, 29.90, 30.73, 30.59, 32.60, 35.59];

/// The four states `02_SCREEN_MAP.md` lists for Your Membership. Each one draws
/// a different hero and a different benefits list; everything below the second
/// section header is the same card on all four.
enum SettingsMembershipKind { premium, standard, changed, cancelled }

class _MembershipLayout {
  const _MembershipLayout({
    required this.benefitsSection,
    required this.benefitsLabel,
    required this.benefitsCardY,
    required this.benefitsCardH,
    required this.mgmtSection,
    required this.mgmtCardY,
  });

  final double benefitsSection;
  final String benefitsLabel;
  final double benefitsCardY;
  final double benefitsCardH;
  final double mgmtSection;
  final double mgmtCardY;
}

const Map<SettingsMembershipKind, _MembershipLayout> _layouts = {
  SettingsMembershipKind.premium: _MembershipLayout(
    benefitsSection: 329.04,
    benefitsLabel: 'YOUR BENEFITS',
    benefitsCardY: 341.70,
    benefitsCardH: 209,
    mgmtSection: 628.22,
    mgmtCardY: 646.89,
  ),
  SettingsMembershipKind.standard: _MembershipLayout(
    benefitsSection: 328.78,
    benefitsLabel: 'UNLOCK MORE WITH PREMIUM',
    benefitsCardY: 343.21,
    benefitsCardH: 209,
    mgmtSection: 626.16,
    mgmtCardY: 648.30,
  ),
  SettingsMembershipKind.changed: _MembershipLayout(
    benefitsSection: 416.70,
    benefitsLabel: 'YOUR BENEFITS',
    benefitsCardY: 429.36,
    benefitsCardH: 209,
    mgmtSection: 715.88,
    mgmtCardY: 734.55,
  ),
  SettingsMembershipKind.cancelled: _MembershipLayout(
    benefitsSection: 417.03,
    benefitsLabel: 'YOUR BENEFITS',
    benefitsCardY: 429.70,
    benefitsCardH: 258,
    mgmtSection: 716.21,
    mgmtCardY: 734.31,
  ),
};

const double _standardPriceNote = 574.82;
const double _standardLearnMore = 1124.66;

class SettingsMembershipView extends StatelessWidget {
  const SettingsMembershipView({
    super.key,
    this.kind = SettingsMembershipKind.premium,
    this.planName = 'Bubba Premium',
    this.renews = 'Renews June 24, 2026',
    this.price = r'$24.00 / month + tax',
    this.upsellPrice = r'$24.00 / month   •   Cancel anytime',
    this.suffix,
    this.banner,
    this.onBack,
    this.onManagement,
    this.onCancel,
    this.onUpgrade,
    this.onLearnMore,
  });

  final SettingsMembershipKind kind;
  final String planName;
  final String renews;
  final String price;
  final String upsellPrice;
  final String? suffix;
  final SettingsMembershipBanner? banner;
  final VoidCallback? onBack;
  final ValueChanged<int>? onManagement;
  final VoidCallback? onCancel;
  final VoidCallback? onUpgrade;
  final VoidCallback? onLearnMore;

  bool get _locked => kind == SettingsMembershipKind.standard;

  List<SettingsBenefit> get _benefits => kind ==
          SettingsMembershipKind.cancelled
      ? settingsCancelledBenefits
      : settingsPremiumBenefits;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          footerBand: 26,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    final layout = _layouts[kind]!;

    flow.block(
      SettingsNavBar(title: 'Your Membership', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    if (banner != null) {
      flow.block(_Banner(banner: banner!), top: _bannerY, height: _bannerH);
    }

    switch (kind) {
      case SettingsMembershipKind.premium:
        flow.block(
          _Hero(
            premium: true,
            planName: planName,
            renews: renews,
            price: price,
          ),
          top: _heroY,
          height: _heroH,
        );
      case SettingsMembershipKind.standard:
        flow.block(
          _StandardHero(onUpgrade: onUpgrade),
          top: _standardHeroY,
          height: _standardHeroH,
        );
      case SettingsMembershipKind.changed:
      case SettingsMembershipKind.cancelled:
        flow.block(
          _StatusHero(
            planName: planName,
            renews: renews,
            price: price,
            suffix: suffix,
          ),
          top: _statusHeroY,
          height: _statusHeroH,
        );
    }

    final sectionMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipSection);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19.29)),
          Text(layout.benefitsLabel,
              style: BubbaSettingsText.membershipSection),
        ],
      ),
      top: layout.benefitsSection - sectionMetrics.baseline,
      height: sectionMetrics.lineHeight,
    );

    flow.block(
      _BenefitsCard(
        benefits: _benefits,
        height: layout.benefitsCardH,
        locked: _locked,
      ),
      top: layout.benefitsCardY,
      height: layout.benefitsCardH,
    );

    if (_locked) {
      final noteMetrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.priceNote);
      flow.block(
        Text(
          upsellPrice,
          textAlign: TextAlign.center,
          style: BubbaSettingsText.priceNote,
        ),
        top: _standardPriceNote - noteMetrics.baseline,
        height: noteMetrics.lineHeight,
      );
    }

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19.29)),
          Text(
            'MEMBERSHIP MANAGEMENT',
            style: BubbaSettingsText.membershipSection,
          ),
        ],
      ),
      top: layout.mgmtSection - sectionMetrics.baseline,
      height: sectionMetrics.lineHeight,
    );

    flow.block(
      _ManagementCard(onRow: onManagement, onCancel: onCancel),
      top: layout.mgmtCardY,
      height: _mgmtCardH,
    );

    if (_locked) {
      final linkMetrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.learnMore);
      flow.block(
        SettingsCancelLink(
          label: 'Learn more about Bubba Premium',
          style: BubbaSettingsText.learnMore,
          onTap: onLearnMore,
        ),
        top: _standardLearnMore - linkMetrics.baseline,
        height: linkMetrics.lineHeight,
      );
    }
  }
}

class SettingsMembershipBanner {
  const SettingsMembershipBanner(this.title, this.body);
  final String title;
  final String body;
}

class _Banner extends StatelessWidget {
  const _Banner({required this.banner});

  final SettingsMembershipBanner banner;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.benefitTitle);
    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.benefitBody);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: d(top)),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(18.08)),
        Container(
          width: hd(355),
          height: d(_bannerH),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.noticeBannerBg,
            borderRadius: BorderRadius.circular(d(6.81)),
          ),
          child: Stack(
            children: [
              at(
                14.82,
                20.82,
                SizedBox(
                  width: d(22.98),
                  height: d(22.98),
                  child: Stack(
                    children: [
                      Container(
                        width: d(22.98),
                        height: d(22.98),
                        decoration: const BoxDecoration(
                          color: BubbaSettingsColors.noticeIconBg,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: d(6.14),
                            top: d(7.61),
                          ),
                          child: const BubbaGlyphIcon(
                            BubbaSettingsGlyphs.bannerCheck,
                            color: BubbaSettingsColors.noticeIconMark,
                            width: 10.69,
                            height: 7.66,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              at(
                46.68,
                26.03 - titleMetrics.baseline,
                Text(banner.title, style: BubbaSettingsText.benefitTitle),
              ),
              at(
                46.70,
                46.89 - bodyMetrics.baseline,
                Text(banner.body, style: BubbaSettingsText.benefitBody),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.premium,
    required this.planName,
    required this.renews,
    required this.price,
  });

  final bool premium;
  final String planName;
  final String renews;
  final String price;

  @override
  Widget build(BuildContext context) {
    final badgeMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipBadge);
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipName);
    final metaMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipMeta);
    final priceMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipPrice);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding:
                EdgeInsets.only(left: hd(left - _heroX), top: d(top - _heroY)),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(_heroX)),
        SizedBox(
          width: hd(_heroW),
          height: d(_heroH),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(d(10)),
                child: Image.asset(
                  premium
                      ? 'assets/bubba/settings/membership_hero_premium.png'
                      : 'assets/bubba/settings/membership_hero_standard.png',
                  width: hd(_heroW),
                  height: d(_heroH),
                  fit: BoxFit.cover,
                ),
              ),
              at(
                37.41,
                219.18 - badgeMetrics.baseline,
                Text(
                  'ACTIVE MEMBERSHIP',
                  style: BubbaSettingsText.membershipBadge,
                ),
              ),
              at(
                37.41,
                243.63 - nameMetrics.baseline,
                Text(planName, style: BubbaSettingsText.membershipName),
              ),
              at(
                37.41,
                264.27 - metaMetrics.baseline,
                Text(renews, style: BubbaSettingsText.membershipMeta),
              ),
              at(
                37.41,
                280.19 - priceMetrics.baseline,
                Text(price, style: BubbaSettingsText.membershipPrice),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// p034. The artboard places the standard hero as a raster and paints the plan
/// summary and the upgrade button over it.
class _StandardHero extends StatelessWidget {
  const _StandardHero({this.onUpgrade});

  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final badgeMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.standardBadge);
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipName);
    final copyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.standardCopy);
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.upgradeLabel);
    final captionMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.upgradeCaption);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(math.max(0, left - _standardHeroX)),
              top: d(math.max(0, top - _standardHeroY)),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(_standardHeroX)),
        SizedBox(
          width: hd(_standardHeroW),
          height: d(_standardHeroH),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(d(10)),
                child: Image.asset(
                  'assets/bubba/settings/membership_hero_standard.png',
                  width: hd(_standardHeroW),
                  height: d(_standardHeroH),
                  fit: BoxFit.cover,
                ),
              ),
              at(
                39.81,
                112.93 - badgeMetrics.baseline,
                Text('CURRENT PLAN', style: BubbaSettingsText.standardBadge),
              ),
              at(
                39.81,
                137.38 - nameMetrics.baseline,
                Text('Standard', style: BubbaSettingsText.membershipName),
              ),
              at(
                39.81,
                157.81 - copyMetrics.baseline,
                Text(
                  'You’re currently using\nBubba Standard.',
                  style: BubbaSettingsText.standardCopy,
                ),
              ),
              at(
                39.81,
                233.15,
                BubbaTapTarget(
                  onTap: onUpgrade,
                  label: 'Upgrade to Premium',
                  child: Container(
                    width: hd(132.16),
                    height: d(29.32),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: BubbaSettingsColors.upgradeFill,
                      borderRadius: BorderRadius.circular(d(7.33)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: d(252.40 - 233.15 - labelMetrics.baseline),
                      ),
                      child: Text(
                        'Upgrade to Premium',
                        style: BubbaSettingsText.upgradeLabel,
                      ),
                    ),
                  ),
                ),
              ),
              at(
                49.83,
                277.51 - captionMetrics.baseline,
                Text(
                  'Unlock all Premium features',
                  style: BubbaSettingsText.upgradeCaption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// p036 and p049. Both banner states replace the gradient hero with a flat
/// card whose plan summary sits against its lower edge.
class _StatusHero extends StatelessWidget {
  const _StatusHero({
    required this.planName,
    required this.renews,
    required this.price,
    this.suffix,
  });

  final String planName;
  final String renews;
  final String price;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final badgeMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipBadge);
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipName);
    final suffixMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.heroSuffix);
    final metaMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipMeta);
    final priceMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.membershipPrice);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(math.max(0, left)),
              top: d(math.max(0, top)),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(_statusHeroX)),
        Container(
          width: hd(_statusHeroW),
          height: d(_statusHeroH),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.heroCardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight / 2),
            ),
            borderRadius: BorderRadius.circular(d(11.66)),
          ),
          child: Stack(
            children: [
              at(
                18.89,
                136.49 - badgeMetrics.baseline,
                Text(
                  'ACTIVE MEMBERSHIP',
                  style: BubbaSettingsText.membershipBadge,
                ),
              ),
              at(
                18.89,
                160.94 - nameMetrics.baseline,
                Text(planName, style: BubbaSettingsText.membershipName),
              ),
              if (suffix != null)
                at(
                  156.41,
                  159.95 - suffixMetrics.baseline,
                  Text('($suffix)', style: BubbaSettingsText.heroSuffix),
                ),
              at(
                18.89,
                181.59 - metaMetrics.baseline,
                Text(renews, style: BubbaSettingsText.membershipMeta),
              ),
              at(
                18.89,
                197.50 - priceMetrics.baseline,
                Text(price, style: BubbaSettingsText.membershipPrice),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard({
    required this.benefits,
    required this.height,
    required this.locked,
  });

  final List<SettingsBenefit> benefits;
  final double height;
  final bool locked;

  static const List<BubbaGlyph> _lockedGlyphs = [
    BubbaSettingsGlyphs.benefitHeart,
    BubbaSettingsGlyphs.benefitGlobe,
    BubbaSettingsGlyphs.benefitEye,
    BubbaSettingsGlyphs.benefitClock,
  ];

  static const List<Size> _lockedSizes = [
    Size(19.81, 17.00),
    Size(18.39, 18.39),
    Size(21.26, 14.15),
    Size(18.39, 18.39),
  ];

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.benefitTitle);
    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.benefitBody);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(math.max(0, left)),
              top: d(math.max(0, top)),
            ),
            child: child,
          ),
        );

    final layers = <Widget>[];
    for (var i = 0; i < benefits.length; i++) {
      final benefit = benefits[i];
      final offset = _benefitPitch * i;

      if (locked && i < _lockedGlyphs.length) {
        final size = _lockedSizes[i];
        layers.add(at(
          _lockedIconCentreX - size.width / 2,
          _lockedIconCentreY + offset - size.height / 2,
          BubbaGlyphIcon(
            _lockedGlyphs[i],
            color: BubbaSettingsColors.rowLabel,
            width: size.width,
            height: size.height,
          ),
        ));
        layers.add(at(
          _lockedLockCentreX - 11.25 / 2,
          _lockedLockCentreY + offset - 12.65 / 2,
          const BubbaGlyphIcon(
            BubbaSettingsGlyphs.benefitLock,
            color: BubbaSettingsColors.benefitLock,
            width: 11.25,
            height: 12.65,
          ),
        ));
      } else {
        layers.add(at(
          _benefitIcon,
          _benefitIcon + offset,
          SizedBox(
            width: d(16),
            height: d(16),
            child: Stack(
              children: [
                Container(
                  width: d(16),
                  height: d(16),
                  decoration: const BoxDecoration(
                    color: BubbaSettingsColors.benefitBg,
                    shape: BoxShape.circle,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: d(4.28), top: d(5.31)),
                    child: const BubbaGlyphIcon(
                      BubbaSettingsGlyphs.benefitCheck,
                      color: BubbaSettingsColors.benefitMark,
                      width: 7.45,
                      height: 5.33,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }

      layers.add(at(
        locked ? _lockedTitleX : _benefitTitleX,
        _benefitTitleTop + offset - titleMetrics.baseline,
        Text(benefit.title, style: BubbaSettingsText.benefitTitle),
      ));
      layers.add(at(
        locked ? _lockedBodyX : _benefitBodyX,
        _benefitBodyTop + offset - bodyMetrics.baseline,
        Text(benefit.body, style: BubbaSettingsText.benefitBody),
      ));
    }

    return Row(
      children: [
        SizedBox(width: hd(_cardX)),
        Container(
          width: hd(_cardW),
          height: d(height),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(children: layers),
        ),
      ],
    );
  }
}

class _ManagementCard extends StatelessWidget {
  const _ManagementCard({this.onRow, this.onCancel});

  final ValueChanged<int>? onRow;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.mgmtTitle);
    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.mgmtBody);
    final cancelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.mgmtTitle);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(left - 18.17),
              top: d(top - _mgmtRefY),
            ),
            child: child,
          ),
        );

    final layers = <Widget>[];
    for (var i = 0; i < settingsManagementRows.length; i++) {
      final row = settingsManagementRows[i];
      layers.add(
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: d(_mgmtIconY[i] - 6 - _mgmtRefY)),
            child: Semantics(
              button: true,
              label: row.title,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onRow == null ? null : () => onRow!(i),
                child: SizedBox(width: hd(354), height: d(52)),
              ),
            ),
          ),
        ),
      );
      layers.add(at(
        _mgmtIconX[i],
        _mgmtIconY[i],
        SizedBox(
          width: d(30.20),
          height: d(30.20),
          child: Stack(
            children: [
              Container(
                width: d(30.20),
                height: d(30.20),
                decoration: BoxDecoration(
                  color: row.circleFill,
                  shape: BoxShape.circle,
                  border: row.circleBorder == null
                      ? null
                      : Border.all(
                          color: row.circleBorder!,
                          width: d(BubbaSettingsMetrics.dividerWeight),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: d(row.glyphOffset.dx),
                    top: d(row.glyphOffset.dy),
                  ),
                  child: BubbaGlyphIcon(
                    row.glyph,
                    color: row.glyphColour,
                    width: row.glyphSize.width,
                    height: row.glyphSize.height,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
      layers.add(at(
        _mgmtTitleX[i],
        _mgmtTitleBaseline[i] - titleMetrics.baseline,
        Text(row.title, style: BubbaSettingsText.mgmtTitle),
      ));
      layers.add(at(
        _mgmtTitleX[i],
        _mgmtBodyBaseline[i] - bodyMetrics.baseline,
        Text(row.body, style: BubbaSettingsText.mgmtBody),
      ));
      layers.add(at(
        _mgmtChevronX[i],
        _mgmtChevronY[i],
        const BubbaGlyphIcon(
          BubbaSettingsGlyphs.smallChevron,
          color: BubbaSettingsColors.mgmtChevron,
          width: 5.29,
          height: 9.35,
        ),
      ));
      layers.add(at(
        _mgmtRuleX[i],
        _mgmtRuleY[i] - 0.25,
        SizedBox(
          width: hd(328.50),
          height: d(0.5),
          child: const BubbaHairline(color: BubbaSettingsColors.cardBorder),
        ),
      ));
    }

    layers.add(
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: hd(44.09 - 18.17),
            top: d(1051.33 - cancelMetrics.baseline - _mgmtRefY),
          ),
          child: Semantics(
            button: true,
            label: 'Cancel subscription',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onCancel,
              child: Text(
                'Cancel subscription',
                style: BubbaSettingsText.mgmtTitle
                    .copyWith(color: BubbaSettingsColors.cancelLink),
              ),
            ),
          ),
        ),
      ),
    );
    layers.add(at(
      44.09,
      1070.36 - bodyMetrics.baseline,
      Text(
        'Your subscription will remain active\nuntil Jun 24,  2026',
        style: BubbaSettingsText.mgmtBody
            .copyWith(color: BubbaSettingsColors.planValue),
      ),
    ));

    return Row(
      children: [
        SizedBox(width: hd(18.17)),
        Container(
          width: hd(354),
          height: d(_mgmtCardH),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(children: layers),
        ),
      ],
    );
  }
}

const List<String> _membershipMonths = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String settingsLongDate(DateTime date) =>
    '${_membershipMonths[date.month - 1]} ${date.day}, ${date.year}';

/// p033 to p036 / p049. `cancelAtPeriodEnd` is what separates
/// `Renews June 24` from `Access until June 24`; without it the screen cannot
/// pick the right sentence, which is P3-9 in the ledger.
class BubbaMembershipScreen extends StatefulWidget {
  const BubbaMembershipScreen({super.key, this.kind});

  /// Only the golden fixtures pass this.
  final SettingsMembershipKind? kind;

  @override
  State<BubbaMembershipScreen> createState() => _BubbaMembershipScreenState();
}

class _BubbaMembershipScreenState extends State<BubbaMembershipScreen> {
  BubbaSettingsController get _controller => BubbaSettingsController.to;

  @override
  void initState() {
    super.initState();
    if (widget.kind == null) {
      _controller
        ..loadSubscription(force: true)
        ..loadPlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fixture = widget.kind;
    if (fixture != null) {
      return SettingsMembershipView(kind: fixture, onBack: Get.back);
    }

    return Obx(() {
      final sub = _controller.subscription.value;
      final expires = sub.expiresAt;

      final kind = !sub.isPaid
          ? SettingsMembershipKind.standard
          : sub.cancelAtPeriodEnd
              ? SettingsMembershipKind.cancelled
              : SettingsMembershipKind.premium;

      final dateLabel = expires == null
          ? ''
          : sub.cancelAtPeriodEnd
              ? 'Access until ${settingsLongDate(expires)}'
              : 'Renews ${settingsLongDate(expires)}';

      final premium = _controller.planNamed('premium');

      return SettingsMembershipView(
        kind: kind,
        upsellPrice: premium == null || premium.priceLabel.isEmpty
            ? ''
            : '${premium.priceLabel}   •   Cancel anytime',
        planName: 'Bubba ${sub.planLabel}',
        renews: dateLabel,
        price: sub.amount == null
            ? ''
            : '\$${(sub.amount! / 100).toStringAsFixed(2)} / month + tax',
        onBack: Get.back,
        onCancel: () async {
          if (_controller.saving.value) return;

          final ok = await _controller.setSubscriptionRenewal(false);
          if (!ok) showSettingsError(_controller.paymentError.value);
        },
        onUpgrade: () async {
          if (_controller.saving.value) return;

          if (sub.cancelAtPeriodEnd) {
            final ok = await _controller.setSubscriptionRenewal(true);
            if (!ok) showSettingsError(_controller.paymentError.value);
            return;
          }

          Get.toNamed(Routes.BUBBA_CHANGE_PLAN);
        },
        onLearnMore: () => Get.toNamed(Routes.BUBBA_CHANGE_PLAN),
        onManagement: (index) => switch (index) {
          0 => Get.toNamed(Routes.BUBBA_PAYMENT_METHODS),
          1 => Get.toNamed(Routes.BUBBA_PURCHASE_HISTORY),
          _ => Get.toNamed(Routes.BUBBA_CHANGE_PLAN),
        },
      );
    });
  }
}
