import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'bubba_settings_controller.dart';
import 'widgets/settings_chrome.dart';

enum SettingsProductKind { membership, shine, time }

class SettingsPurchase {
  const SettingsPurchase({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.card,
    required this.amount,
    required this.kind,
  });

  final String date;
  final String title;
  final String subtitle;
  final String card;
  final String amount;
  final SettingsProductKind kind;
}

const List<SettingsPurchase> settingsSamplePurchases = [
  SettingsPurchase(
    date: 'APR 2, 2026',
    title: 'Premium Membership, monthly',
    subtitle: 'Recurring subscription',
    card: 'Visa **** 1523',
    amount: r'$24.00',
    kind: SettingsProductKind.membership,
  ),
  SettingsPurchase(
    date: 'APR 2, 2026',
    title: 'Shine Pack, single',
    subtitle: 'One-time purchase',
    card: 'Visa **** 1523',
    amount: r'$24.00',
    kind: SettingsProductKind.shine,
  ),
  SettingsPurchase(
    date: '',
    title: 'Time Pack, 3 pack',
    subtitle: 'One-time purchase',
    card: 'Visa **** 1523',
    amount: r'$24.00',
    kind: SettingsProductKind.time,
  ),
  SettingsPurchase(
    date: '',
    title: 'Premium Membership, monthly',
    subtitle: 'Recurring subscription',
    card: 'Visa **** 1523',
    amount: r'$24.00',
    kind: SettingsProductKind.membership,
  ),
];

const double _firstDateBaseline = 128.24;
const double _firstMarkY = 155.61;
const double _firstTitleBaseline = 164.75;
const double _firstSubtitleBaseline = 182.25;
const double _firstCardBaseline = 201.28;
const double _firstAmountBaseline = 181.36;
const double _firstChevronY = 173.99;
const double _firstDividerY = 220.61;
const double _rowPitch = 82.00;
const double _dateBand = 41.75;
const double _markX = 22.36;
const double _textX = 82.42;
const double _amountX = 312.53;
const double _chevronX = 367.03;
const double _dateX = 19.84;

double _rowTop(BuildContext context, SettingsPurchase purchase) {
  final dateMetrics =
      bubbaDesignTextMetrics(context, BubbaSettingsText.formSection);
  final titleMetrics =
      bubbaDesignTextMetrics(context, BubbaSettingsText.purchaseTitle);
  final titleTop = _firstTitleBaseline - titleMetrics.baseline;
  return purchase.date.isEmpty
      ? math.min(_firstMarkY, titleTop)
      : math.min(_firstDateBaseline - dateMetrics.baseline, titleTop);
}

class SettingsPurchaseHistoryView extends StatelessWidget {
  const SettingsPurchaseHistoryView({
    super.key,
    this.purchases = settingsSamplePurchases,
    this.onBack,
    this.onPurchase,
  });

  final List<SettingsPurchase> purchases;
  final VoidCallback? onBack;
  final ValueChanged<int>? onPurchase;

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
      SettingsNavBar(title: 'Purchase history', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    var offset = 0.0;
    for (var i = 0; i < purchases.length; i++) {
      if (i > 0) {
        offset += _rowPitch + (purchases[i].date.isEmpty ? 0 : _dateBand);
      }
      final top = _rowTop(context, purchases[i]) + offset;
      flow.block(
        _PurchaseRow(
          purchase: purchases[i],
          offset: offset,
          top: top,
          onTap: onPurchase == null ? null : () => onPurchase!(i),
        ),
        top: top,
        height: _firstDividerY + offset - top,
      );
    }
  }
}

class _PurchaseRow extends StatelessWidget {
  const _PurchaseRow({
    required this.purchase,
    required this.offset,
    required this.top,
    this.onTap,
  });

  final SettingsPurchase purchase;
  final double offset;
  final double top;
  final VoidCallback? onTap;

  Color get _fill => switch (purchase.kind) {
        SettingsProductKind.membership => BubbaSettingsColors.productGreen,
        SettingsProductKind.shine => BubbaSettingsColors.productCoral,
        SettingsProductKind.time => BubbaSettingsColors.productBlue,
      };

  BubbaGlyph get _glyph => switch (purchase.kind) {
        SettingsProductKind.membership => BubbaSettingsGlyphs.productMembership,
        SettingsProductKind.shine => BubbaSettingsGlyphs.productShine,
        SettingsProductKind.time => BubbaSettingsGlyphs.productTime,
      };

  Size get _glyphSize => switch (purchase.kind) {
        SettingsProductKind.membership => const Size(13.65, 14.38),
        SettingsProductKind.shine => const Size(14.82, 14.65),
        SettingsProductKind.time => const Size(17.57, 17.95),
      };

  @override
  Widget build(BuildContext context) {
    final dateMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formSection);
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.purchaseTitle);
    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.purchaseSubtitle);
    final cardMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.purchaseCard);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: d(y + offset - top)),
            child: child,
          ),
        );

    final glyph = _glyphSize;
    final markCentreOffset = Offset(
      (44 - glyph.width) / 2,
      (44 - glyph.height) / 2,
    );

    return Semantics(
      button: true,
      label: '${purchase.title}, ${purchase.amount}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: d(_firstDividerY + offset - top),
          child: Stack(
            children: [
              if (purchase.date.isNotEmpty)
                at(
                  _dateX,
                  _firstDateBaseline - dateMetrics.baseline,
                  Text(purchase.date, style: BubbaSettingsText.formSection),
                ),
              at(
                _markX,
                _firstMarkY,
                SizedBox(
                  width: d(44),
                  height: d(44),
                  child: Stack(
                    children: [
                      Container(
                        width: d(44),
                        height: d(44),
                        decoration: BoxDecoration(
                          color: _fill,
                          shape: BoxShape.circle,
                          border: purchase.kind == SettingsProductKind.shine
                              ? Border.all(
                                  color: BubbaSettingsColors.productBorder,
                                  width: d(BubbaSettingsMetrics.dividerWeight),
                                )
                              : null,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: d(markCentreOffset.dx),
                            top: d(markCentreOffset.dy),
                          ),
                          child: BubbaGlyphIcon(
                            _glyph,
                            color: BubbaSettingsColors.onDark,
                            width: glyph.width,
                            height: glyph.height,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              at(
                _textX,
                _firstTitleBaseline - titleMetrics.baseline,
                Text(purchase.title, style: BubbaSettingsText.purchaseTitle),
              ),
              at(
                _textX,
                _firstSubtitleBaseline - subMetrics.baseline,
                Text(
                  purchase.subtitle,
                  style: BubbaSettingsText.purchaseSubtitle,
                ),
              ),
              at(
                _textX,
                _firstCardBaseline - cardMetrics.baseline,
                Text(purchase.card, style: BubbaSettingsText.purchaseCard),
              ),
              at(
                _amountX,
                _firstAmountBaseline - titleMetrics.baseline,
                Text(purchase.amount, style: BubbaSettingsText.purchaseTitle),
              ),
              at(
                _chevronX,
                _firstChevronY,
                const BubbaGlyphIcon(
                  BubbaSettingsGlyphs.smallChevron,
                  color: BubbaSettingsColors.rowLabel,
                  width: 3.94,
                  height: 6.96,
                ),
              ),
              at(
                _markX,
                _firstDividerY - BubbaSettingsMetrics.dividerWeight / 2,
                SizedBox(
                  width: hd(350),
                  height: d(BubbaSettingsMetrics.dividerWeight),
                  child: const BubbaHairline(
                    color: BubbaSettingsColors.divider,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> _historyMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String settingsPurchaseDate(DateTime? date) => date == null
    ? ''
    : '${_historyMonths[date.month - 1]} ${date.day}, ${date.year}';

class BubbaPurchaseHistoryScreen extends StatefulWidget {
  const BubbaPurchaseHistoryScreen({super.key});

  @override
  State<BubbaPurchaseHistoryScreen> createState() =>
      _BubbaPurchaseHistoryScreenState();
}

class _BubbaPurchaseHistoryScreenState
    extends State<BubbaPurchaseHistoryScreen> {
  BubbaSettingsController get _controller => BubbaSettingsController.to;

  @override
  void initState() {
    super.initState();
    _controller.loadPurchases(force: true);
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final items = _controller.purchases;
        String? previousDate;

        return SettingsPurchaseHistoryView(
          purchases: [
            for (final purchase in items)
              () {
                final date = settingsPurchaseDate(purchase.createdAt);
                final show = date == previousDate ? '' : date;
                previousDate = date;

                return SettingsPurchase(
                  date: show,
                  title: purchase.planLabel.isEmpty
                      ? 'Membership'
                      : purchase.planLabel,
                  subtitle: purchase.isRefunded
                      ? 'Refunded'
                      : purchase.description,
                  card: purchase.status,
                  amount: purchase.amountLabel,
                  kind: SettingsProductKind.membership,
                );
              }(),
          ],
          onBack: Get.back,
          onPurchase: (index) {
            if (index < items.length) {
              Get.toNamed(
                Routes.BUBBA_ORDER_DETAILS,
                arguments: {'id': items[index].id},
              );
            }
          },
        );
      });
}
