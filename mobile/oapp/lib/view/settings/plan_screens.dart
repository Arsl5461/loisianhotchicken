import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../../models/settings_models.dart';
import 'bubba_settings_controller.dart';
import 'membership_screen.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';
import 'widgets/settings_confirm_scaffold.dart';

class SettingsPlanCardData {
  const SettingsPlanCardData({
    required this.badge,
    required this.title,
    required this.status,
    required this.renews,
    required this.price,
    this.statusColour = BubbaSettingsColors.planActive,
    this.mark = true,
    this.chevron = false,
    this.fill = BubbaSettingsColors.planCardBg,
    this.titleColour = BubbaSettingsColors.planTitle,
    this.height = 105,
  });

  final String badge;
  final String title;
  final String status;
  final String renews;
  final String price;
  final Color statusColour;
  final bool mark;
  final bool chevron;
  final Color fill;
  final Color titleColour;
  final double height;
}

class SettingsPlanRow {
  const SettingsPlanRow({
    required this.label,
    required this.value,
    this.trailing,
    this.trailingX,
    this.trailingBaseline,
  });

  final String label;
  final String value;
  final String? trailing;
  final double? trailingX;
  final double? trailingBaseline;
}

const double _planCardX = 18.66;
const double _planCardY = 94.61;
const double _planCardW = 348.50;
const double _planCardH = 105;
const double _planChevronX = 348.96;
const double _planChevronY = 141.62;
const double _listRefTop = 289.99;
const double _listX = 16.16;
const double _listW = 354;
const List<double> _rowLabelBaselines = [321.47, 385.30, 453.87];
const List<double> _rowValueBaselines = [340.56, 404.39, 472.96];
const List<double> _rowRules = [359.89, 423.72];

class SettingsPlanSummaryView extends StatelessWidget {
  const SettingsPlanSummaryView({
    super.key,
    required this.navTitle,
    required this.card,
    required this.sectionLabel,
    required this.rows,
    required this.ctaLabel,
    this.ctaFill = BubbaSettingsColors.rowLabel,
    this.note,
    this.secondaryLabel,
    this.listHeight = 200,
    this.sectionBaseline = 277.53,
    this.listTop = 289.99,
    this.noteBaseline = 714.12,
    this.ctaTop = 752,
    this.secondaryBaseline = 826,
    this.onBack,
    this.onCta,
    this.onSecondary,
  });

  final String navTitle;
  final SettingsPlanCardData card;
  final String sectionLabel;
  final List<SettingsPlanRow> rows;
  final String ctaLabel;
  final Color ctaFill;
  final String? note;
  final String? secondaryLabel;
  final double listHeight;
  final double sectionBaseline;
  final double listTop;
  final double noteBaseline;
  final double ctaTop;
  final double secondaryBaseline;
  final VoidCallback? onBack;
  final VoidCallback? onCta;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          footerBand: 28,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SettingsNavBar(title: navTitle, onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    flow.block(
      SettingsPlanCard(data: card),
      top: _planCardY,
      height: _planCardH,
    );

    final sectionMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planSection);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(20.50)),
          Text(sectionLabel, style: BubbaSettingsText.planSection),
        ],
      ),
      top: sectionBaseline - sectionMetrics.baseline,
      height: sectionMetrics.lineHeight,
    );

    flow.block(
      _PlanRows(rows: rows, height: listHeight),
      top: listTop,
      height: listHeight,
    );

    if (note != null) {
      final noteMetrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.planNote);
      flow.block(
        Text(
          note!,
          textAlign: TextAlign.center,
          style: BubbaSettingsText.planNote,
        ),
        top: noteBaseline - noteMetrics.baseline,
        height: noteMetrics.lineHeight * 2,
      );
    }

    flow.block(
      SettingsCtaButton(label: ctaLabel, fill: ctaFill, onTap: onCta),
      top: ctaTop,
      height: 58,
    );

    if (secondaryLabel != null) {
      final metrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.cancelLabel);
      final box = BubbaScale.tapBox(d(metrics.lineHeight)) / BubbaScale.factor;
      flow.block(
        SettingsCancelLink(label: secondaryLabel!, onTap: onSecondary),
        top: secondaryBaseline -
            metrics.baseline -
            (box - metrics.lineHeight) / 2,
        height: box,
      );
    }
  }
}

class SettingsPlanCard extends StatelessWidget {
  const SettingsPlanCard({super.key, required this.data});

  final SettingsPlanCardData data;

  @override
  Widget build(BuildContext context) {
    final badgeMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planSection);
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planTitle);
    final metaStyle = data.mark
        ? BubbaSettingsText.planMeta
        : BubbaSettingsText.planMetaSmall;
    final metaMetrics = bubbaDesignTextMetrics(context, metaStyle);
    final priceStyle = data.mark
        ? BubbaSettingsText.planPrice
        : BubbaSettingsText.planPrice
            .copyWith(color: BubbaSettingsColors.planPriceDark);
    final priceMetrics = bubbaDesignTextMetrics(context, priceStyle);

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

    final badgeTop = 22.33;
    final titleLeft = data.mark ? 49.28 : 13.25;
    final titleTop = data.mark ? 51.24 : 45.04;
    final statusLeft = data.mark ? 50.11 : 14.08;
    final statusTop = data.mark ? 70.92 : 64.72;
    final renewsLeft = data.mark ? 90.95 : 60.92;
    final priceLeft = data.mark ? 49.68 : 14.88;
    final priceTop = data.mark ? 89.84 : 82.55;

    return Row(
      children: [
        SizedBox(width: hd(_planCardX)),
        Container(
          width: hd(_planCardW),
          height: d(data.height),
          decoration: BoxDecoration(
            color: data.fill,
            borderRadius: BorderRadius.circular(d(9.24)),
          ),
          child: Stack(
            children: [
              at(
                data.mark ? 14.02 : 13.39,
                badgeTop - badgeMetrics.baseline,
                Text(data.badge, style: BubbaSettingsText.planSection),
              ),
              if (data.mark)
                at(
                  13.47,
                  40.53,
                  SizedBox(
                    width: d(28.06),
                    height: d(28.06),
                    child: Stack(
                      children: [
                        Container(
                          width: d(28.06),
                          height: d(28.06),
                          decoration: const BoxDecoration(
                            color: BubbaSettingsColors.planMark,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: d(8.38),
                              top: d(8.38),
                            ),
                            child: const BubbaGlyphIcon(
                              BubbaSettingsGlyphs.planPlusMark,
                              color: BubbaSettingsColors.onDark,
                              width: 11.31,
                              height: 11.29,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              at(
                titleLeft,
                titleTop - titleMetrics.baseline,
                Text(
                  data.title,
                  style: BubbaSettingsText.planTitle
                      .copyWith(color: data.titleColour),
                ),
              ),
              at(
                statusLeft,
                statusTop - metaMetrics.baseline,
                Text(
                  data.status,
                  style: metaStyle.copyWith(color: data.statusColour),
                ),
              ),
              at(
                renewsLeft,
                statusTop - metaMetrics.baseline,
                Text(data.renews, style: metaStyle),
              ),
              at(
                priceLeft,
                priceTop - priceMetrics.baseline,
                Text(data.price, style: priceStyle),
              ),
              if (data.chevron)
                at(
                  _planChevronX - _planCardX,
                  _planChevronY - _planCardY,
                  const BubbaGlyphIcon(
                    BubbaSettingsGlyphs.rowChevron,
                    color: BubbaSettingsColors.planChevron,
                    width: 6.00,
                    height: 10.60,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanRows extends StatelessWidget {
  const _PlanRows({required this.rows, required this.height});

  final List<SettingsPlanRow> rows;
  final double height;

  @override
  Widget build(BuildContext context) {
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planRowLabel);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planRowValue);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(left - _listX),
              top: d(top - _listRefTop),
            ),
            child: child,
          ),
        );

    final layers = <Widget>[];
    for (var i = 0; i < rows.length && i < _rowLabelBaselines.length; i++) {
      final row = rows[i];
      layers.add(at(
        32.75,
        _rowLabelBaselines[i] - labelMetrics.baseline,
        Text(row.label, style: BubbaSettingsText.planRowLabel),
      ));
      layers.add(at(
        32.75,
        _rowValueBaselines[i] - valueMetrics.baseline,
        Text(row.value, style: BubbaSettingsText.planRowValue),
      ));
      if (row.trailing != null) {
        layers.add(at(
          row.trailingX ?? 265.03,
          (row.trailingBaseline ?? _rowValueBaselines[i]) -
              valueMetrics.baseline,
          Text(row.trailing!, style: BubbaSettingsText.planRowValue),
        ));
      }
      if (i < _rowRules.length && i < rows.length - 1) {
        layers.add(at(
          28.91,
          _rowRules[i] - 0.25,
          SizedBox(
            width: hd(328.50),
            height: d(0.5),
            child: const BubbaHairline(color: BubbaSettingsColors.cardBorder),
          ),
        ));
      }
    }

    return Row(
      children: [
        SizedBox(width: hd(_listX)),
        Container(
          width: hd(_listW),
          height: d(height),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius: BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(children: layers),
        ),
      ],
    );
  }
}

const _premiumCard = SettingsPlanCardData(
  badge: 'NEW PLAN',
  title: 'Bubba Premium',
  status: 'Active',
  renews: '• Renews May 12, 2027',
  price: r'$24.00 / month + tax',
);

const _standardCard = SettingsPlanCardData(
  badge: 'NEW PLAN',
  title: 'Bubba Standard',
  status: 'Inactive',
  renews: '• Begins May 12, 2027',
  price: 'Free',
  statusColour: BubbaSettingsColors.planInactive,
  mark: false,
  fill: BubbaSettingsColors.planCardGrey,
  titleColour: BubbaSettingsColors.planTitleDark,
  height: 103,
);

const _currentCard = SettingsPlanCardData(
  badge: 'CURRENT PLAN',
  title: 'Bubba Premium',
  status: 'Active',
  renews: '• Renews May 12, 2027',
  price: r'$24.00 / month + tax',
  chevron: true,
);

const _note = 'Changes take effect at the end of your\n'
    'current billing period on June 24, 2026.';

class SettingsUpgradeConfirmView extends StatelessWidget {
  const SettingsUpgradeConfirmView({
    super.key,
    this.planName = 'Bubba Premium',
    this.billingDate = 'June 24, 2026',
    this.price = r'$24.00 / month',
    this.note = _note,
    this.card,
    this.onBack,
    this.onContinue,
  });

  final String planName;
  final String billingDate;
  final String price;
  final String note;
  final SettingsPlanCardData? card;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) => SettingsPlanSummaryView(
        navTitle: 'Change Plan',
        onBack: onBack,
        onCta: onContinue,
        card: card ?? _premiumCard,
        sectionLabel: 'WHAT’S CHANGING',
        note: note,
        ctaLabel: 'Continue',
        rows: [
          SettingsPlanRow(label: 'New plan', value: planName),
          SettingsPlanRow(
            label: 'Billing starts',
            value: billingDate,
            trailing: price,
            trailingX: 272.20,
            trailingBaseline: 396.25,
          ),
          const SettingsPlanRow(
            label: 'Your benefits',
            value: 'All Premium features',
            trailing: 'Uncapped access',
            trailingBaseline: 461.57,
          ),
        ],
      );
}

class SettingsDowngradeConfirmView extends StatelessWidget {
  const SettingsDowngradeConfirmView({
    super.key,
    this.planName = 'Bubba Standard',
    this.billingDate = 'June 24, 2026',
    this.price = 'Free',
    this.note = _note,
    this.card,
    this.onBack,
    this.onContinue,
  });

  final String planName;
  final String billingDate;
  final String price;
  final String note;
  final SettingsPlanCardData? card;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) => SettingsPlanSummaryView(
        navTitle: 'Change Plan',
        onBack: onBack,
        onCta: onContinue,
        card: card ?? _standardCard,
        sectionLabel: 'WHAT’S CHANGING',
        note: note,
        ctaLabel: 'Continue',
        rows: [
          SettingsPlanRow(label: 'New plan', value: planName),
          SettingsPlanRow(
            label: 'Billing starts',
            value: billingDate,
            trailing: price,
            trailingX: 272.20,
            trailingBaseline: 396.25,
          ),
          const SettingsPlanRow(
            label: 'Your benefits',
            value: 'All Premium features',
            trailing: 'Limited access',
            trailingBaseline: 461.57,
          ),
        ],
      );
}

class SettingsCancelSubscriptionView extends StatelessWidget {
  const SettingsCancelSubscriptionView({
    super.key,
    this.cancelled = false,
    this.accessUntil = 'June 24, 2026',
    this.revertTo,
    this.paymentMethod = 'Visa 2424',
    this.card,
    this.onBack,
    this.onCta,
    this.onGoBack,
  });

  final bool cancelled;
  final String accessUntil;
  final String? revertTo;
  final String paymentMethod;
  final SettingsPlanCardData? card;
  final VoidCallback? onBack;
  final VoidCallback? onCta;
  final VoidCallback? onGoBack;

  @override
  Widget build(BuildContext context) => SettingsPlanSummaryView(
        navTitle: 'Cancel Subscription',
        onBack: onBack,
        onCta: onCta,
        onSecondary: onGoBack,
        card: card ?? _currentCard,
        sectionBaseline: 231.53,
        listTop: 249.50,
        noteBaseline: 673.12,
        ctaTop: 711,
        secondaryBaseline: 792.97,
        sectionLabel: cancelled
            ? 'YOUR PLAN HAS BEEN CANCELLED'
            : 'YOU’RE ABOUT TO CANCEL',
        note: () {
          final target =
              revertTo ?? (cancelled ? 'Bubba Standard' : 'Bea Free');
          return accessUntil.isEmpty
              ? 'At the end of your billing period your account\nwill revert to $target'
              : 'After $accessUntil your account will revert\nto $target';
        }(),
        ctaLabel: cancelled ? 'Reactivate subscription' : 'Cancel subscription',
        ctaFill: cancelled
            ? BubbaSettingsColors.reactivate
            : BubbaSettingsColors.deleteCta,
        secondaryLabel: 'Go back',
        rows: [
          SettingsPlanRow(label: 'Access until', value: accessUntil),
          SettingsPlanRow(
            label: 'Billing ends',
            value: accessUntil.isEmpty
                ? 'No further charges'
                : 'No charges after $accessUntil',
          ),
          SettingsPlanRow(label: 'Payment method', value: paymentMethod),
        ],
      );
}

class BubbaUpgradeConfirmScreen extends StatefulWidget {
  const BubbaUpgradeConfirmScreen({
    super.key,
    this.planType = 'premium',
    this.planName,
    this.price,
    this.downgrade = false,
  });

  final String planType;
  final String? planName;
  final String? price;
  final bool downgrade;

  @override
  State<BubbaUpgradeConfirmScreen> createState() =>
      _BubbaUpgradeConfirmScreenState();
}

class _BubbaUpgradeConfirmScreenState extends State<BubbaUpgradeConfirmScreen> {
  String get planType => widget.planType;
  String? get planName => widget.planName;
  String? get price => widget.price;
  bool get downgrade => widget.downgrade;

  @override
  void initState() {
    super.initState();
    BubbaSettingsController.to.loadSubscription();
  }

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSettingsController.to;

    return Obx(() {
      final sub = controller.subscription.value;
      final startsOn = sub.expiresAt;
      final billingDate =
          startsOn == null ? '' : settingsLongDate(startsOn);
      final note = startsOn == null
          ? 'Changes take effect at the end of your\ncurrent billing period.'
          : 'Changes take effect at the end of your\n'
              'current billing period on ${settingsLongDate(startsOn)}.';

      Future<void> confirm() async {
        if (controller.saving.value) return;

        final ok = await controller.purchasePlan(planType);
        if (!ok) {
          showSettingsError(controller.paymentError.value);
          return;
        }
        Get.until((route) => route.settings.name == Routes.BUBBA_MEMBERSHIP);
      }

      if (downgrade) {
        final name = planName ?? 'Bea Standard';
        return SettingsDowngradeConfirmView(
          planName: name,
          billingDate: billingDate,
          price: price ?? '',
          note: note,
          card: SettingsPlanCardData(
            badge: 'NEW PLAN',
            title: name,
            status: 'Inactive',
            renews: billingDate.isEmpty ? '' : '• Begins $billingDate',
            price: price ?? '',
            statusColour: BubbaSettingsColors.planInactive,
            mark: false,
            fill: BubbaSettingsColors.planCardGrey,
            titleColour: BubbaSettingsColors.planTitleDark,
            height: 103,
          ),
          onBack: Get.back,
          onContinue: confirm,
        );
      }

      final name = planName ?? 'Bea Premium';
      return SettingsUpgradeConfirmView(
        planName: name,
        billingDate: billingDate,
        price: price ?? '',
        note: note,
        card: SettingsPlanCardData(
          badge: 'NEW PLAN',
          title: name,
          status: 'Active',
          renews: billingDate.isEmpty ? '' : '• Renews $billingDate',
          price: price ?? '',
        ),
        onBack: Get.back,
        onContinue: confirm,
      );
    });
  }
}

class BubbaCancelSubscriptionScreen extends StatefulWidget {
  const BubbaCancelSubscriptionScreen({super.key, this.cancelled = false});

  final bool cancelled;

  @override
  State<BubbaCancelSubscriptionScreen> createState() =>
      _BubbaCancelSubscriptionScreenState();
}

class _BubbaCancelSubscriptionScreenState
    extends State<BubbaCancelSubscriptionScreen> {
  bool get cancelled => widget.cancelled;

  @override
  void initState() {
    super.initState();
    BubbaSettingsController.to
      ..loadSubscription()
      ..loadCards();
  }

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSettingsController.to;

    return Obx(() {
      final sub = controller.subscription.value;
      final expires = sub.expiresAt;
      final card = controller.cards.firstWhereOrNull((c) => c.isDefault) ??
          (controller.cards.isEmpty ? null : controller.cards.first);

      return SettingsCancelSubscriptionView(
        cancelled: cancelled || sub.cancelAtPeriodEnd,
        accessUntil: expires == null ? '' : settingsLongDate(expires),

        paymentMethod: card == null
            ? ''
            : '${card.brandLabel} ${card.last4 ?? ''}'.trim(),
        card: SettingsPlanCardData(
          badge: 'CURRENT PLAN',
          title: sub.isPaid ? 'Bea ${sub.planLabel}' : 'Bea Free',
          status: sub.isPaid
              ? (sub.cancelAtPeriodEnd ? 'Cancelled' : 'Active')
              : 'Free',
          renews: expires == null
              ? ''
              : sub.cancelAtPeriodEnd
                  ? '• Access until ${settingsLongDate(expires)}'
                  : '• Renews ${settingsLongDate(expires)}',
          price: sub.amount == null
              ? (sub.isPaid ? '' : r'$0 / month')
              : '\$${(sub.amount! / 100).toStringAsFixed(2)} / month + tax',
        ),
        onBack: Get.back,
        onGoBack: Get.back,
        onCta: cancelled
            ? () async {
                if (controller.saving.value) return;
                final ok = await controller.setSubscriptionRenewal(true);
                if (!ok) {
                  showSettingsError(controller.paymentError.value);
                  return;
                }
                Get.back();
              }
            : () async {
                if (controller.saving.value) return;

                final ok = await controller.setSubscriptionRenewal(false);
                if (!ok) {
                  showSettingsError(controller.paymentError.value);
                  return;
                }
                Get.off(
                  () => const BubbaCancelSubscriptionScreen(cancelled: true),
                );
              },
      );
    });
  }
}

class SettingsPlanOption {
  const SettingsPlanOption({
    required this.name,
    required this.price,
    required this.nameX,
    required this.nameBaseline,
    required this.priceBaseline,
    required this.radioX,
    required this.radioY,
    this.ruleY,
    this.badge,
    this.badgeX,
    this.badgeY,
    this.badgeWidth,
    this.badgeTextX,
    this.badgeBaseline,
    this.badgeFill,
  });

  final String name;
  final String price;
  final double nameX;
  final double nameBaseline;
  final double priceBaseline;
  final double radioX;
  final double radioY;
  final double? ruleY;
  final String? badge;
  final double? badgeX;
  final double? badgeY;
  final double? badgeWidth;
  final double? badgeTextX;
  final double? badgeBaseline;
  final Color? badgeFill;
}

const List<SettingsPlanOption> settingsPlanOptions = [
  SettingsPlanOption(
    name: 'Bea Free',
    price: r'$0 / month',
    nameX: 71.59,
    nameBaseline: 291.98,
    priceBaseline: 311.06,
    radioX: 32.40,
    radioY: 286.50,
    ruleY: 330.40,
  ),
  SettingsPlanOption(
    name: 'Bea Week',
    price: r'$12 / week',
    nameX: 70.86,
    nameBaseline: 355.80,
    priceBaseline: 374.89,
    radioX: 31.67,
    radioY: 350.33,
    ruleY: 394.23,
  ),
  SettingsPlanOption(
    name: 'Bea Premium',
    price: r'$24 / month',
    nameX: 70.77,
    nameBaseline: 424.38,
    priceBaseline: 443.47,
    radioX: 31.24,
    radioY: 418.95,
    ruleY: 462.80,
    badge: 'CURRENT',
    badgeX: 287.73,
    badgeY: 418.41,
    badgeWidth: 64.17,
    badgeTextX: 296.58,
    badgeBaseline: 432.65,
    badgeFill: BubbaSettingsColors.badgeCurrentBg,
  ),
  SettingsPlanOption(
    name: 'Bea 3 month',
    price: r'$16 / month',
    nameX: 70.77,
    nameBaseline: 489.38,
    priceBaseline: 508.47,
    radioX: 31.58,
    radioY: 483.90,
    badge: 'SAVE 33%',
    badgeX: 285.41,
    badgeY: 482.02,
    badgeWidth: 64.17,
    badgeTextX: 293.00,
    badgeBaseline: 496.26,
    badgeFill: BubbaSettingsColors.badgeSaveBg,
  ),
];

class SettingsChangePlanView extends StatelessWidget {
  const SettingsChangePlanView({
    super.key,
    this.selected = 2,
    this.current = 2,
    this.plan,
    this.term,
    this.options,
    this.onSelect,
    this.onBack,
    this.onContinue,
  });

  final int selected;
  final int current;
  final SettingsPlanCardData? plan;
  final String? term;
  final List<SettingsPlanOption>? options;
  final ValueChanged<int>? onSelect;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  bool get _enabled => selected != current;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          footerBand: 28,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SettingsNavBar(title: 'Change Plan', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    flow.block(
      _CurrentPlanCard(plan: plan, term: term),
      top: 97.87,
      height: 105,
    );

    final sectionMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formSection);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(20.50)),
          Text('CHOOSE A PLAN', style: BubbaSettingsText.formSection),
        ],
      ),
      top: 246.53 - sectionMetrics.baseline,
      height: sectionMetrics.lineHeight,
    );

    flow.block(
      _PlanOptions(
        selected: selected,
        onSelect: onSelect,
        options: options ?? settingsPlanOptions,
      ),
      top: 260.50,
      height: 277,
    );

    final noteMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planNote);
    flow.block(
      Text(
        _note,
        textAlign: TextAlign.center,
        style: BubbaSettingsText.planNote,
      ),
      top: 714.12 - noteMetrics.baseline,
      height: noteMetrics.lineHeight * 2,
    );

    flow.block(
      SettingsCtaButton(
        label: 'Continue',
        fill: _enabled
            ? BubbaSettingsColors.rowLabel
            : BubbaSettingsColors.rowLabel.withValues(
                alpha: BubbaSettingsMetrics.disabledLabelAlpha,
              ),
        labelColor: _enabled
            ? null
            : BubbaSettingsColors.onDark.withValues(
                alpha: BubbaSettingsMetrics.disabledLabelAlpha,
              ),
        onTap: _enabled ? onContinue : null,
      ),
      top: 752,
      height: 58,
    );
  }
}

class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({this.plan, this.term});

  final SettingsPlanCardData? plan;
  final String? term;

  @override
  Widget build(BuildContext context) {
    final badgeMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planBadge);
    return Stack(
      children: [
        SettingsPlanCard(
          data: plan ??
              const SettingsPlanCardData(
                badge: 'CURRENT PLAN',
                title: 'Bubba Premium',
                status: 'Active',
                renews: '• Renews May 12, 2027',
                price: r'$24.00 / month + tax',
              ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(200.56), top: d(131.38 - 94.61)),
            child: Container(
              width: hd(61.35),
              height: d(21.01),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: BubbaSettingsColors.badgeMonthBg,
                borderRadius: BorderRadius.circular(d(10.51)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: d(badgeMetrics.descent * 0)),
                child: Text(
                  term ?? '1 MONTH',
                  style: BubbaSettingsText.planBadge,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanOptions extends StatelessWidget {
  const _PlanOptions({
    required this.selected,
    this.onSelect,
    this.options = settingsPlanOptions,
  });

  final int selected;
  final ValueChanged<int>? onSelect;
  final List<SettingsPlanOption> options;

  @override
  Widget build(BuildContext context) {
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planRowLabel);
    final priceMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.planRowValue);
    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left - 18), top: d(top - 260.50)),
            child: child,
          ),
        );

    final layers = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      final option = options[i];
      final isSelected = i == selected;
      layers.add(
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: d(option.radioY - 12 - 260.50)),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: option.name,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSelect == null ? null : () => onSelect!(i),
                child: SizedBox(width: hd(354), height: d(46)),
              ),
            ),
          ),
        ),
      );
      layers.add(at(
        option.radioX,
        option.radioY,
        Container(
          width: d(21),
          height: d(21),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? BubbaSettingsColors.rowLabel
                  : BubbaSettingsColors.radioIdle,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
          ),
          child: isSelected
              ? Container(
                  width: d(15),
                  height: d(15),
                  decoration: const BoxDecoration(
                    color: BubbaSettingsColors.rowLabel,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
      ));
      layers.add(at(
        option.nameX,
        option.nameBaseline - nameMetrics.baseline,
        Text(option.name, style: BubbaSettingsText.planRowLabel),
      ));
      layers.add(at(
        option.nameX,
        option.priceBaseline - priceMetrics.baseline,
        Text(option.price, style: BubbaSettingsText.planRowValue),
      ));
      if (option.badge != null) {
        layers.add(at(
          option.badgeX!,
          option.badgeY!,
          Container(
            width: hd(option.badgeWidth!),
            height: d(21.01),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: option.badgeFill,
              borderRadius: BorderRadius.circular(d(10.51)),
            ),
            child: Text(option.badge!, style: BubbaSettingsText.planBadge),
          ),
        ));
      }
      if (option.ruleY != null) {
        layers.add(at(
          30.75,
          option.ruleY! - 0.25,
          SizedBox(
            width: hd(328.50),
            height: d(0.5),
            child: const BubbaHairline(color: BubbaSettingsColors.cardBorder),
          ),
        ));
      }
    }

    return Row(
      children: [
        SizedBox(width: hd(18)),
        Container(
          width: hd(354),
          height: d(277),
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

class BubbaChangePlanScreen extends StatefulWidget {
  const BubbaChangePlanScreen({super.key});

  @override
  State<BubbaChangePlanScreen> createState() => _BubbaChangePlanScreenState();
}

class _BubbaChangePlanScreenState extends State<BubbaChangePlanScreen> {
  int? _selected;

  static const List<String> _planTypes = [
    'free',
    'standard',
    'premium',
    'premium',
  ];

  int _currentIndex(SubscriptionModel subscription) {
    if (!subscription.isPaid) return 0;
    return subscription.planLabel.toLowerCase().contains('3')
        ? 3
        : subscription.planLabel.toLowerCase().contains('week')
            ? 1
            : 2;
  }

  @override
  void initState() {
    super.initState();
    BubbaSettingsController.to
      ..loadSubscription()
      ..loadPlans();
  }

  List<SettingsPlanOption> _options(List<PlanCatalogEntry> catalog) {
    if (catalog.isEmpty) return settingsPlanOptions;
    return [
      for (var i = 0; i < settingsPlanOptions.length; i++)
        if (i < catalog.length)
          _withCatalog(settingsPlanOptions[i], catalog[i])
        else
          settingsPlanOptions[i],
    ];
  }

  SettingsPlanOption _withCatalog(
    SettingsPlanOption drawn,
    PlanCatalogEntry entry,
  ) =>
      SettingsPlanOption(
        name: entry.name.isEmpty ? drawn.name : entry.name,
        price: entry.priceLabel.isEmpty ? drawn.price : entry.priceLabel,
        nameX: drawn.nameX,
        nameBaseline: drawn.nameBaseline,
        priceBaseline: drawn.priceBaseline,
        radioX: drawn.radioX,
        radioY: drawn.radioY,
        ruleY: drawn.ruleY,
        badge: entry.badge ?? drawn.badge,
        badgeX: drawn.badgeX,
        badgeY: drawn.badgeY,
        badgeWidth: drawn.badgeWidth,
        badgeTextX: drawn.badgeTextX,
        badgeBaseline: drawn.badgeBaseline,
        badgeFill: drawn.badgeFill,
      );

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSettingsController.to;

    return Obx(() {
      final current = _currentIndex(controller.subscription.value);
      final selected = _selected ?? current;

      final sub = controller.subscription.value;
      final expires = sub.expiresAt;

      final options = _options(controller.plans);

      return SettingsChangePlanView(
        selected: selected,
        current: current,
        options: options,
        term: sub.isPaid ? sub.planLabel.toUpperCase() : 'FREE',
        plan: SettingsPlanCardData(
          badge: 'CURRENT PLAN',
          title: sub.isPaid ? 'Bea ${sub.planLabel}' : 'Bea Free',
          status: sub.isPaid
              ? (sub.cancelAtPeriodEnd ? 'Cancelled' : 'Active')
              : 'Free',
          renews: expires == null
              ? ''
              : sub.cancelAtPeriodEnd
                  ? '• Access until ${settingsLongDate(expires)}'
                  : '• Renews ${settingsLongDate(expires)}',
          price: sub.amount == null
              ? (sub.isPaid ? '' : r'$0 / month')
              : '\$${(sub.amount! / 100).toStringAsFixed(2)} / month + tax',
        ),
        onSelect: (i) => setState(() => _selected = i),
        onBack: Get.back,
        onContinue: selected == current
            ? null
            : () {
                final catalog = controller.plans;
                final plan = selected < catalog.length &&
                        catalog[selected].id.isNotEmpty
                    ? catalog[selected].id
                    : _planTypes[selected];
                final option = options[selected];
                if (plan == 'free') {
                  Get.toNamed(
                    Routes.BUBBA_CANCEL_SUBSCRIPTION,
                    arguments: const {'cancelled': false},
                  );
                  return;
                }
                Get.toNamed(
                  Routes.BUBBA_PLAN_CONFIRM,
                  arguments: {
                    'planType': plan,
                    'planName': option.name,
                    'price': option.price,
                    'downgrade': selected < current,
                  },
                );
              },
      );
    });
  }
}
