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

class SettingsPaymentCard {
  const SettingsPaymentCard({
    required this.label,
    required this.expiry,
    this.primary = false,
  });

  final String label;
  final String expiry;
  final bool primary;
}

const double _rowPitch = 100.75;
const double _markX = 24.77;
const double _markY = 224.89;
const double _labelX = 84.78;
const double _labelBaseline = 229.40;
const double _expiryX = 81.78;
const double _expiryBaseline = 257.40;
const double _chevronX = 360.10;
const double _chevronY = 235.88;
const double _dividerY = 291.90;
const double _chipX = 259.60;
const double _chipY = 226.40;

class SettingsPaymentMethodsView extends StatelessWidget {
  const SettingsPaymentMethodsView({
    super.key,
    this.cards = const [],
    this.onBack,
    this.onCard,
    this.onAdd,
  });

  final List<SettingsPaymentCard> cards;
  final VoidCallback? onBack;
  final ValueChanged<int>? onCard;
  final VoidCallback? onAdd;

  bool get _empty => cards.isEmpty;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          content: _empty ? _emptyContent : _listContent,
        ),
      );

  void _nav(BubbaFlow flow) => flow.block(
        SettingsNavBar(title: 'Payment Methods', onBack: onBack),
        top: 0,
        height: BubbaSettingsMetrics.navHeight,
      );

  void _listContent(BuildContext context, BubbaFlow flow) {
    _nav(flow);

    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.pageSubtitle);
    flow.block(
      Text(
        'Your payment methods are used for\nmembership and purchases',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.pageSubtitle,
      ),
      top: 105.21 - subMetrics.baseline,
      height: subMetrics.lineHeight * 2,
    );

    for (var i = 0; i < cards.length; i++) {
      final offset = _rowPitch * i;
      flow.block(
        _CardRow(
          card: cards[i],
          offset: offset,
          onTap: onCard == null ? null : () => onCard!(i),
        ),
        top: _markY + offset - 12,
        height: _dividerY + offset - (_markY + offset - 12),
      );
    }

    final addTop = _markY + _rowPitch * cards.length + 12.5;
    flow.block(
      _AddButton(onTap: onAdd, top: addTop),
      top: addTop,
      height: 58,
    );
  }

  void _emptyContent(BuildContext context, BubbaFlow flow) {
    _nav(flow);

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(144.60)),
          SizedBox(
            width: d(91),
            height: d(91),
            child: Stack(
              children: [
                Container(
                  width: d(91),
                  height: d(91),
                  decoration: const BoxDecoration(
                    color: BubbaSettingsColors.pauseCircle,
                    shape: BoxShape.circle,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: hd(168.14 - 144.60),
                      top: d(241.78 - 212.81),
                    ),
                    child: const BubbaGlyphIcon(
                      BubbaSettingsGlyphs.cardMark,
                      color: BubbaSettingsColors.rowLabel,
                      width: 43.88,
                      height: 31.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      top: 212.81,
      height: 91,
    );

    final headingMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.displayHeading);
    flow.block(
      Text(
        'No payment methods yet',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.displayHeading,
      ),
      top: 398.65 - headingMetrics.baseline,
      height: headingMetrics.lineHeight,
    );

    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.emptyBody);
    flow.block(
      Text(
        'Add a payment method to securely pay\nfor your membership and purchases',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.emptyBody,
      ),
      top: 434.81 - bodyMetrics.baseline,
      height: bodyMetrics.lineHeight * 2,
    );

    flow.block(
      _AddButton(onTap: onAdd, top: 489.30, x: 26.14, labelX: 81.66),
      top: 489.30,
      height: 58,
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({required this.card, required this.offset, this.onTap});

  final SettingsPaymentCard card;
  final double offset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final top = _markY + offset - 12;
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.uiMedium);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: d(y - top)),
            child: child,
          ),
        );

    return Semantics(
      button: true,
      label: '${card.label}, expires ${card.expiry}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: d(_dividerY + offset - top),
          child: Stack(
            children: [
              at(
                _markX,
                _markY + offset,
                const BubbaGlyphIcon(
                  BubbaSettingsGlyphs.visaMark,
                  color: BubbaSettingsColors.cardMark,
                  width: 37.06,
                  height: 25.95,
                ),
              ),
              at(
                _labelX,
                _labelBaseline + offset - labelMetrics.baseline,
                Text(card.label, style: BubbaSettingsText.uiMedium),
              ),
              at(
                _expiryX,
                _expiryBaseline + offset - labelMetrics.baseline,
                Text(
                  'Expires ${card.expiry}',
                  style: BubbaSettingsText.uiMedium
                      .copyWith(color: BubbaSettingsColors.cardExpiry),
                ),
              ),
              if (card.primary)
                at(
                  _chipX,
                  _chipY + offset,
                  Container(
                    width: hd(76),
                    height: d(28),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: BubbaSettingsColors.primaryChipBg,
                      borderRadius: BorderRadius.circular(d(14)),
                    ),
                    child: Text(
                      'Primary',
                      style: BubbaSettingsText.uiMedium
                          .copyWith(color: BubbaSettingsColors.primaryChipText),
                    ),
                  ),
                ),
              at(_chevronX, _chevronY + offset, const SettingsChevron()),
              at(
                22.60,
                _dividerY + offset - 0.25,
                SizedBox(
                  width: hd(350),
                  height: d(0.5),
                  child: const BubbaHairline(
                    color: BubbaSettingsColors.cardBorder,
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

class _AddButton extends StatelessWidget {
  const _AddButton({
    this.onTap,
    required this.top,
    this.x = 21.60,
    this.labelX = 77.12,
  });

  final VoidCallback? onTap;
  final double top;
  final double x;
  final double labelX;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaSettingsText.uiMedium);
    return Row(
      children: [
        SizedBox(width: hd(x)),
        Semantics(
          button: true,
          label: 'Add payment method',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: hd(345),
              height: d(58),
              decoration: BoxDecoration(
                color: BubbaSettingsColors.addButtonBg,
                borderRadius: BorderRadius.circular(d(9.52)),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(38.04 - x),
                        top: d(456.56 - 437.40),
                      ),
                      child: SizedBox(
                        width: d(19.32),
                        height: d(19.32),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: d(1.89),
                              height: d(19.32),
                              color: BubbaSettingsColors.rowLabel,
                            ),
                            Container(
                              width: d(19.32),
                              height: d(1.89),
                              color: BubbaSettingsColors.rowLabel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(labelX - x),
                        top: d(471.94 - 437.40 - metrics.baseline),
                      ),
                      child: Text(
                        'Add payment method',
                        style: BubbaSettingsText.uiMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// p007 / p013. The empty state is the real one for an account with no Stripe
/// customer yet, which is every new account.
class BubbaPaymentMethodsScreen extends StatefulWidget {
  const BubbaPaymentMethodsScreen({super.key, this.cards});

  /// Only the golden fixtures pass this.
  final List<SettingsPaymentCard>? cards;

  @override
  State<BubbaPaymentMethodsScreen> createState() =>
      _BubbaPaymentMethodsScreenState();
}

class _BubbaPaymentMethodsScreenState extends State<BubbaPaymentMethodsScreen> {
  BubbaSettingsController get _controller => BubbaSettingsController.to;

  @override
  void initState() {
    super.initState();
    if (widget.cards == null) _controller.loadCards(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final fixture = widget.cards;
    if (fixture != null) {
      return SettingsPaymentMethodsView(cards: fixture, onBack: Get.back);
    }

    return Obx(() {
      final error = _controller.paymentError.value;
      if (error != null && _controller.cards.isEmpty) showSettingsError(error);

      return SettingsPaymentMethodsView(
        cards: [
          for (final card in _controller.cards)
            SettingsPaymentCard(
              label: '${card.brandLabel} ${card.maskedNumber}'.trim(),
              expiry: card.expiryLabel,
              primary: card.isDefault,
            ),
        ],
        onBack: Get.back,
        onCard: (index) {
          if (index < _controller.cards.length) {
            Get.toNamed(
              Routes.BUBBA_CARD_DETAIL,
              arguments: {'id': _controller.cards[index].id},
            );
          }
        },
        onAdd: () => Get.toNamed(Routes.BUBBA_ADD_CARD),
      );
    });
  }
}
