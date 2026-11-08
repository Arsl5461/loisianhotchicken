import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../services/global_service.dart';
import 'bubba_settings_controller.dart';
import 'purchase_history_screen.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';

class SettingsOrder {
  const SettingsOrder({
    required this.title,
    required this.placedAt,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.card,
    required this.cardAmount,
    required this.orderDate,
    required this.orderId,
    required this.email,
    required this.addressName,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressCountry,
  });

  final String title;
  final String placedAt;
  final String subtotal;
  final String tax;
  final String total;
  final String card;
  final String cardAmount;
  final String orderDate;
  final String orderId;
  final String email;
  final String addressName;
  final String addressLine1;
  final String addressLine2;
  final String addressCountry;
}

const SettingsOrder settingsEmptyOrder = SettingsOrder(
  title: '',
  placedAt: '',
  subtotal: '',
  tax: '',
  total: '',
  card: '',
  cardAmount: '',
  orderDate: '',
  orderId: '',
  email: '',
  addressName: '',
  addressLine1: '',
  addressLine2: '',
  addressCountry: '',
);

const SettingsOrder settingsSampleOrder = SettingsOrder(
  title: 'Premium Membership, monthly',
  placedAt: 'Apr 2, 2026 - 4:53 AM',
  subtotal: r'$24.00',
  tax: r'$0.12',
  total: r'$24.12',
  card: 'Visa 1523',
  cardAmount: r'$24.00',
  orderDate: 'Apr 2, 2026',
  orderId: 'BE-2482-1035',
  email: 'ronssnv@gmail.com',
  addressName: 'Ron Sasonov',
  addressLine1: '1 Peaslee Hill',
  addressLine2: 'West Hartford, CT 06117',
  addressCountry: 'USA',
);

class SettingsOrderDetailsView extends StatelessWidget {
  const SettingsOrderDetailsView({
    super.key,
    this.order = settingsSampleOrder,
    this.onBack,
    this.onCopyId,
  });

  final SettingsOrder order;
  final VoidCallback? onBack;
  final VoidCallback? onCopyId;

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
    final headingMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.orderHeading);
    final metaMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.orderMeta);
    final rowMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.orderRow);
    final totalMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.orderTotal);
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.orderLabel);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: d(top)),
            child: child,
          ),
        );

    Widget rule(double x, double y) => at(
          x,
          y - BubbaSettingsMetrics.dividerWeight / 2,
          SizedBox(
            width: hd(350),
            height: d(BubbaSettingsMetrics.dividerWeight),
            child: const BubbaHairline(color: BubbaSettingsColors.divider),
          ),
        );

    Widget circleIcon(
      double x,
      double y,
      BubbaGlyph glyph,
      double gx,
      double gy,
      double gw,
      double gh,
    ) =>
        at(
          x,
          y,
          SizedBox(
            width: d(31.04),
            height: d(31.04),
            child: Stack(
              children: [
                Container(
                  width: d(31.04),
                  height: d(31.04),
                  decoration: const BoxDecoration(
                    color: BubbaSettingsColors.orderIconBg,
                    shape: BoxShape.circle,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: d(gx - x), top: d(gy - y)),
                    child: BubbaGlyphIcon(
                      glyph,
                      color: BubbaSettingsColors.rowLabel,
                      width: gw,
                      height: gh,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

    flow.block(
      SizedBox(
        height: d(760),
        child: Stack(
          children: [
            SettingsNavBar(title: 'Order details', onBack: onBack),
            at(
              22.36,
              155.61,
              SizedBox(
                width: d(44),
                height: d(44),
                child: Stack(
                  children: [
                    Container(
                      width: d(44),
                      height: d(44),
                      decoration: const BoxDecoration(
                        color: BubbaSettingsColors.productGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: d(37.71 - 22.36),
                          top: d(169.82 - 155.61),
                        ),
                        child: const BubbaGlyphIcon(
                          BubbaSettingsGlyphs.productMembership,
                          color: BubbaSettingsColors.onDark,
                          width: 13.65,
                          height: 14.38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            at(
              82.42,
              172.75 - headingMetrics.baseline,
              Text(order.title, style: BubbaSettingsText.orderHeading),
            ),
            at(
              82.73,
              193.25 - metaMetrics.baseline,
              Text(order.placedAt, style: BubbaSettingsText.orderMeta),
            ),
            rule(22.36, 220.61),
            at(
              20.70,
              264.44 - rowMetrics.baseline,
              Text('Subtotal', style: BubbaSettingsText.orderRow),
            ),
            at(
              326.67,
              263.34 - rowMetrics.baseline,
              Text(order.subtotal, style: BubbaSettingsText.orderRow),
            ),
            at(
              20.70,
              297.03 - rowMetrics.baseline,
              Text('Tax', style: BubbaSettingsText.orderRow),
            ),
            at(
              332.49,
              295.93 - rowMetrics.baseline,
              Text(order.tax, style: BubbaSettingsText.orderRow),
            ),
            at(
              20.70,
              337.22 - totalMetrics.baseline,
              Text('Total', style: BubbaSettingsText.orderTotal),
            ),
            at(
              319.43,
              336.12 - totalMetrics.baseline,
              Text(order.total, style: BubbaSettingsText.orderTotal),
            ),
            rule(18.48, 368.31),
            at(
              21.57,
              402.56,
              const BubbaGlyphIcon(
                BubbaSettingsGlyphs.visaMark,
                color: BubbaSettingsColors.cardMark,
                width: 27.86,
                height: 19.50,
              ),
            ),
            at(
              62.71,
              414.60 - rowMetrics.baseline,
              Text(order.card, style: BubbaSettingsText.orderRow),
            ),
            at(
              325.31,
              414.60 - rowMetrics.baseline,
              Text(order.cardAmount, style: BubbaSettingsText.orderRow),
            ),
            rule(18.48, 448.31),
            circleIcon(
              20.32,
              480.13,
              BubbaSettingsGlyphs.orderDate,
              29.32,
              488.42,
              12.94,
              14.01,
            ),
            at(
              67.47,
              489.75 - labelMetrics.baseline,
              Text('Order date', style: BubbaSettingsText.orderLabel),
            ),
            at(
              67.86,
              509.90 - rowMetrics.baseline,
              Text(order.orderDate, style: BubbaSettingsText.orderRow),
            ),
            circleIcon(
              192.83,
              480.99,
              BubbaSettingsGlyphs.orderId,
              201.03,
              489.97,
              14.01,
              12.97,
            ),
            at(
              239.97,
              490.61 - labelMetrics.baseline,
              Text('Order ID', style: BubbaSettingsText.orderLabel),
            ),
            at(
              240.36,
              510.76 - rowMetrics.baseline,
              Text(order.orderId, style: BubbaSettingsText.orderRow),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: hd(338.64),
                  top: d(509.79 - labelMetrics.baseline),
                ),
                child: Semantics(
                  button: true,
                  label: 'Copy order ID',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onCopyId,
                    child: Text(
                      'Copy',
                      style: BubbaSettingsText.orderLabel
                          .copyWith(color: BubbaSettingsColors.orderCopy),
                    ),
                  ),
                ),
              ),
            ),
            rule(17.48, 543.31),
            circleIcon(
              21.32,
              571.13,
              BubbaSettingsGlyphs.orderEmail,
              30.70,
              581.52,
              14.02,
              10.78,
            ),
            at(
              68.51,
              582.60 - labelMetrics.baseline,
              Text('Email', style: BubbaSettingsText.orderLabel),
            ),
            at(
              68.90,
              602.75 - rowMetrics.baseline,
              Text(order.email, style: BubbaSettingsText.orderRow),
            ),
            rule(23.48, 624.31),
            circleIcon(
              21.32,
              657.13,
              BubbaSettingsGlyphs.orderPin,
              30.43,
              665.03,
              11.86,
              15.12,
            ),
            at(
              66.10,
              666.60 - labelMetrics.baseline,
              Text('Billing address', style: BubbaSettingsText.orderLabel),
            ),
            at(
              66.49,
              686.75 - rowMetrics.baseline,
              Text(order.addressName, style: BubbaSettingsText.orderRow),
            ),
            at(
              66.49,
              707.75 - rowMetrics.baseline,
              Text(order.addressLine1, style: BubbaSettingsText.orderRow),
            ),
            at(
              66.49,
              728.75 - rowMetrics.baseline,
              Text(order.addressLine2, style: BubbaSettingsText.orderRow),
            ),
            at(
              66.49,
              749.75 - rowMetrics.baseline,
              Text(order.addressCountry, style: BubbaSettingsText.orderRow),
            ),
          ],
        ),
      ),
      top: 0,
      height: 760,
    );
  }
}

/// The order the transaction id in the route arguments names. Without an id it
/// draws the fixture, which is what the goldens assert.
class BubbaOrderDetailsScreen extends StatefulWidget {
  const BubbaOrderDetailsScreen({super.key, this.order});

  final SettingsOrder? order;

  @override
  State<BubbaOrderDetailsScreen> createState() =>
      _BubbaOrderDetailsScreenState();
}

class _BubbaOrderDetailsScreenState extends State<BubbaOrderDetailsScreen> {
  SettingsOrder? _order;

  String? get _id => Get.arguments is Map<String, dynamic>
      ? (Get.arguments as Map<String, dynamic>)['id'] as String?
      : null;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    if (_order == null) _load();
  }

  Future<void> _load() async {
    final id = _id;
    if (id == null || id.isEmpty) return;

    final controller = BubbaSettingsController.to;
    final purchase = await controller.loadPurchase(id);

    if (!mounted) return;
    if (purchase == null) {
      showSettingsError(controller.paymentError.value);
      return;
    }

    final user = Get.find<GlobalService>().getUserModel();
    setState(() {
      _order = SettingsOrder(
        title: purchase.planLabel.isEmpty
            ? 'Membership'
            : '${purchase.planLabel} Membership, monthly',
        placedAt: settingsPurchaseDate(purchase.createdAt),
        subtotal: purchase.amountLabel,
        tax: r'$0.00',
        total: purchase.amountLabel,
        card: purchase.isRefunded ? 'Refunded' : purchase.status,
        cardAmount: purchase.amountLabel,
        orderDate: settingsPurchaseDate(purchase.createdAt),
        orderId: purchase.id,
        email: user?.email ?? '',
        addressName: user?.fullName ?? '',
        addressLine1: '',
        addressLine2: '',
        addressCountry: '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = _order ?? settingsEmptyOrder;

    return SettingsOrderDetailsView(
      order: order,
      onBack: Get.back,
      onCopyId: order.orderId.isEmpty
          ? null
          : () => Clipboard.setData(ClipboardData(text: order.orderId)),
    );
  }
}
