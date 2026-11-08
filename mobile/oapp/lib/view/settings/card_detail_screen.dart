import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import 'add_card_screen.dart';
import 'billing_address_screen.dart';
import 'bubba_settings_controller.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';

class SettingsCardDetailView extends StatelessWidget {
  const SettingsCardDetailView({
    super.key,
    this.expiry = '05/28',
    this.addressName = 'Ron Sasonov',
    this.addressLine1 = '1 Peaslee Hill',
    this.addressLine2 = 'West Hartford, CT 06117',
    this.addressCountry = 'USA',
    this.primary = true,
    this.onBack,
    this.onEdit,
    this.onRemove,
    this.onAddress,
  });

  final String expiry;
  final String addressName;
  final String addressLine1;
  final String addressLine2;
  final String addressCountry;
  final bool primary;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final VoidCallback? onAddress;

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
    final uiMetrics = bubbaDesignTextMetrics(context, BubbaSettingsText.uiMedium);
    final chipMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.uiMedium);
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.orderLabel);
    final lineMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.billingValue);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: d(top)),
            child: child,
          ),
        );

    Widget rule(double x, double y, Color colour) => at(
          x,
          y - 0.25,
          SizedBox(
            width: hd(350),
            height: d(0.5),
            child: BubbaHairline(color: colour),
          ),
        );

    flow.block(
      SizedBox(
        height: d(760),
        child: Stack(
          children: [
            SettingsNavBar(title: '', onBack: onBack),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: hd(347.92),
                  top: d(65.32 - uiMetrics.baseline),
                ),
                child: Semantics(
                  button: true,
                  label: 'Edit card',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onEdit,
                    child: Text(
                      'Edit',
                      style: BubbaSettingsText.uiMedium
                          .copyWith(color: BubbaSettingsColors.editAction),
                    ),
                  ),
                ),
              ),
            ),
            at(
              160.85,
              124.65,
              SizedBox(
                width: d(68.31),
                height: d(43.07),
                child: Stack(
                  children: [
                    Container(
                      width: d(68.31),
                      height: d(43.07),
                      decoration: BoxDecoration(
                        color: BubbaSettingsColors.visaNavy,
                        borderRadius: BorderRadius.circular(d(2.53)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: d(164.76 - 160.85),
                          top: d(136.79 - 124.65),
                        ),
                        child: const BubbaGlyphIcon(
                          BubbaSettingsGlyphs.visaWordmark,
                          color: BubbaSettingsColors.onDark,
                          width: 58.06,
                          height: 18.75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            at(
              128.78,
              197.69,
              const BubbaGlyphIcon(
                BubbaSettingsGlyphs.cardDisplayName,
                color: BubbaSettingsColors.rowLabel,
                width: 116.75,
                height: 20.14,
              ),
            ),
            if (primary)
              at(
                106.72,
                243.61,
                Container(
                  width: hd(186),
                  height: d(28),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: BubbaSettingsColors.primaryChipBg,
                    borderRadius: BorderRadius.circular(d(14)),
                  ),
                  child: Text(
                    'Primary payment method',
                    style: BubbaSettingsText.uiMedium
                        .copyWith(color: BubbaSettingsColors.primaryChipText),
                  ),
                ),
              ),
            rule(21.91, 322.09, BubbaSettingsColors.cardBorder),
            at(
              27.49,
              361.97,
              const BubbaGlyphIcon(
                BubbaSettingsGlyphs.expiresMark,
                color: BubbaSettingsColors.rowLabel,
                width: 17.68,
                height: 17.68,
              ),
            ),
            at(
              62.86,
              375.06 - uiMetrics.baseline,
              Text('Expires', style: BubbaSettingsText.uiMedium),
            ),
            at(
              288.43,
              374.22 - uiMetrics.baseline,
              Text(expiry, style: BubbaSettingsText.uiMedium),
            ),
            at(
              27.95,
              402.93,
              const BubbaGlyphIcon(
                BubbaSettingsGlyphs.securityMark,
                color: BubbaSettingsColors.rowLabel,
                width: 15.07,
                height: 18.08,
              ),
            ),
            at(
              63.23,
              415.51 - uiMetrics.baseline,
              Text('Security code', style: BubbaSettingsText.uiMedium),
            ),
            for (var i = 0; i < 3; i++)
              at(
                296.72 + i * 9,
                402.61,
                Container(
                  width: d(5),
                  height: d(5),
                  decoration: const BoxDecoration(
                    color: BubbaSettingsColors.rowLabel,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            rule(23.72, 461.11, BubbaSettingsColors.cardBorder),
            at(
              31.69,
              501.40 - labelMetrics.baseline,
              Text('Billing address', style: BubbaSettingsText.orderLabel
                  .copyWith(color: BubbaSettingsColors.cardMetaLabel)),
            ),
            at(
              31.08,
              535.56 - uiMetrics.baseline,
              Text(addressName, style: BubbaSettingsText.uiMedium),
            ),
            at(
              31.08,
              563.56 - lineMetrics.baseline,
              Text(addressLine1, style: BubbaSettingsText.billingValue
                  .copyWith(color: BubbaSettingsColors.rowLabel)),
            ),
            at(
              31.08,
              591.56 - lineMetrics.baseline,
              Text(addressLine2, style: BubbaSettingsText.billingValue
                  .copyWith(color: BubbaSettingsColors.rowLabel)),
            ),
            at(
              31.08,
              619.56 - lineMetrics.baseline,
              Text(addressCountry, style: BubbaSettingsText.billingValue
                  .copyWith(color: BubbaSettingsColors.rowLabel)),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: hd(325.40),
                  top: d(549.28),
                ),
                child: Semantics(
                  button: true,
                  label: 'Billing address',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onAddress,
                    child: const SettingsChevron(
                      color: BubbaSettingsColors.mutedChevron,
                    ),
                  ),
                ),
              ),
            ),
            rule(18.72, 648.11, const Color(0xFFEAE7E5)),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: hd(31.15),
                  top: d(683.85 - uiMetrics.baseline),
                ),
                child: Semantics(
                  button: true,
                  label: 'Remove card',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onRemove,
                    child: Text(
                      'Remove card',
                      style: BubbaSettingsText.uiMedium
                          .copyWith(color: BubbaSettingsColors.removeAction),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: d(chipMetrics.lineHeight * 0)),
          ],
        ),
      ),
      top: 0,
      height: 760,
    );
  }
}

class BubbaCardDetailScreen extends StatefulWidget {
  const BubbaCardDetailScreen({super.key});

  @override
  State<BubbaCardDetailScreen> createState() => _BubbaCardDetailScreenState();
}

class _BubbaCardDetailScreenState extends State<BubbaCardDetailScreen> {
  String? get _id => Get.arguments is Map<String, dynamic>
      ? (Get.arguments as Map<String, dynamic>)['id'] as String?
      : null;

  @override
  void initState() {
    super.initState();
    BubbaSettingsController.to.loadCards();
  }

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSettingsController.to;

    return Obx(() {
      final id = _id;
      final card = id == null
          ? null
          : controller.cards.firstWhereOrNull((item) => item.id == id);

      return SettingsCardDetailView(
        expiry: card?.expiryLabel ?? '',
        addressName: card?.billingName ?? '',
        addressLine1: card?.billingLine1 ?? '',
        addressLine2: card?.billingLocality ?? '',
        addressCountry: card?.billingCountry ?? '',
        primary: card?.isDefault ?? true,
        onBack: Get.back,
        onAddress: () async {
          if (card == null) return;
          final next = await Get.to<SettingsBillingAddress>(
            () => BubbaBillingAddressScreen(
              cardholder: card.billingName,
              initial: SettingsBillingAddress(
                name: card.billingName,
                line1: card.billingLine1,
                line2: card.billingLocality,
                country: card.billingCountry,
                street: card.billingLine1,
                apt: card.billingLine2,
                city: card.billingCity,
                state: card.billingState,
                zip: card.billingPostalCode,
              ),
            ),
          );
          if (next == null) return;
          final ok = await controller.updateCardBillingAddress(card.id, next);
          if (!ok) showSettingsError(controller.paymentError.value);
        },
        onEdit: () async {
          if (id == null || id.isEmpty) return;
          if (controller.saving.value) return;

          final ok = await controller.makeCardDefault(id);
          if (!ok) showSettingsError(controller.paymentError.value);
        },
        onRemove: () async {
          if (id == null || id.isEmpty) {
            showSettingsError('That card is no longer on your account.');
            return;
          }
          if (controller.saving.value) return;

          final ok = await controller.removeCard(id);
          if (ok) {
            Get.back();
          } else {
            showSettingsError(controller.paymentError.value);
          }
        },
      );
    });
  }
}
