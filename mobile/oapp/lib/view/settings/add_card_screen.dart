import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'bubba_settings_controller.dart';
import 'settings_feedback.dart';
import 'widgets/settings_chrome.dart';
import 'billing_address_screen.dart';
import 'widgets/settings_confirm_scaffold.dart';

class SettingsCardDraft {
  const SettingsCardDraft({
    this.number = '',
    this.expiry = '',
    this.cvc = '',
    this.name = '',
    this.address,
  });

  final String number;
  final String expiry;
  final String cvc;
  final String name;
  final SettingsBillingAddress? address;

  bool get isEmpty =>
      number.isEmpty && expiry.isEmpty && cvc.isEmpty && name.isEmpty;
}

const double _cardX = 26.72;
const double _cardY = 162.81;
const double _cardW = 336;
const double _cardH = 234.50;
const double _cardRadius = 15.47;
const double _noticeX = 25.72;
const double _noticeY = 415.92;
const double _billingY = 541.31;

class SettingsAddCardView extends StatelessWidget {
  const SettingsAddCardView({
    super.key,
    this.draft = const SettingsCardDraft(),
    this.onBack,
    this.onSave,
    this.onBilling,
    this.onChanged,
    this.saving = false,
  });

  final SettingsCardDraft draft;
  final VoidCallback? onBack;
  final VoidCallback? onSave;
  final bool saving;
  final VoidCallback? onBilling;
  final ValueChanged<SettingsCardDraft>? onChanged;

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
      SettingsNavBar(title: 'Add Card', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    final sectionMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formSection);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(27.76)),
          Text('CARD INFORMATION', style: BubbaSettingsText.formSection),
        ],
      ),
      top: 147.46 - sectionMetrics.baseline,
      height: sectionMetrics.lineHeight,
    );

    flow.block(
      _CardBox(draft: draft, onChanged: onChanged),
      top: _cardY,
      height: _cardH,
    );
    flow.block(const _EncryptedNotice(), top: _noticeY, height: 59);

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(26.20)),
          Text('BILLING ADDRESS', style: BubbaSettingsText.formSection),
        ],
      ),
      top: 517.96 - sectionMetrics.baseline,
      height: sectionMetrics.lineHeight,
    );

    final address = draft.address;
    flow.block(
      address == null
          ? _BillingRow(onTap: onBilling)
          : _BillingCard(address: address, onTap: onBilling),
      top: _billingY,
      height: address == null ? 59 : 134.81,
    );

    flow.block(
      SettingsCtaButton(
        label: 'Save card',
        fill: BubbaSettingsColors.rowLabel,
        busy: saving,
        onTap: onSave,
      ),
      top: 742.81,
      height: 58,
    );
  }
}

class _CardBox extends StatefulWidget {
  const _CardBox({required this.draft, this.onChanged});

  final SettingsCardDraft draft;
  final ValueChanged<SettingsCardDraft>? onChanged;

  @override
  State<_CardBox> createState() => _CardBoxState();
}

class _CardBoxState extends State<_CardBox> {
  late final TextEditingController _number =
      TextEditingController(text: widget.draft.number);
  late final TextEditingController _expiry =
      TextEditingController(text: widget.draft.expiry);
  late final TextEditingController _cvc =
      TextEditingController(text: widget.draft.cvc);
  late final TextEditingController _name =
      TextEditingController(text: widget.draft.name);
  final Map<TextEditingController, FocusNode> _nodes = {};

  FocusNode _nodeFor(TextEditingController controller) =>
      _nodes.putIfAbsent(controller, FocusNode.new);

  @override
  void dispose() {
    _number.dispose();
    _expiry.dispose();
    _cvc.dispose();
    _name.dispose();
    for (final node in _nodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _report() {
    setState(() {});
    widget.onChanged?.call(
      SettingsCardDraft(
        number: _number.text,
        expiry: _expiry.text,
        cvc: _cvc.text,
        name: _name.text,
        address: widget.draft.address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formLabel);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.formValue);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(math.max(0, left - _cardX)),
              top: d(math.max(0, top - _cardY)),
            ),
            child: child,
          ),
        );

    Widget label(String text, double x, double baseline) =>
        at(x, baseline - labelMetrics.baseline,
            Text(text, style: BubbaSettingsText.formLabel));

    Widget value(
      String text,
      String hint,
      double x,
      double baseline, {
      TextEditingController? controller,
      double width = 260,
      TextInputType keyboard = TextInputType.number,
      int? maxLength,
    }) =>
        at(
          x,
          baseline - valueMetrics.baseline,
          controller == null
              ? Text(
                  text.isEmpty ? hint : text,
                  style: text.isEmpty
                      ? BubbaSettingsText.formPlaceholder
                      : BubbaSettingsText.formValue,
                )
              : SizedBox(
                  width: hd(width),
                  child: Stack(
                    children: [
                      if (controller.text.isEmpty)
                        Text(hint, style: BubbaSettingsText.formPlaceholder),
                      EditableText(
                        controller: controller,
                        focusNode: _nodeFor(controller),
                        style: BubbaSettingsText.formValue,
                        cursorColor: BubbaSettingsColors.rowLabel,
                        backgroundCursorColor:
                            BubbaSettingsColors.cardBorder,
                        keyboardType: keyboard,
                        maxLines: 1,
                        onChanged: (_) => _report(),
                      ),
                    ],
                  ),
                ),
        );

    Widget rule(double x, double y, double w) => at(
          x,
          y - 0.25,
          SizedBox(
            width: hd(w),
            height: d(0.5),
            child: const BubbaHairline(color: BubbaSettingsColors.cardBorder),
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(_cardX)),
        Container(
          width: hd(_cardW),
          height: d(_cardH),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(BubbaSettingsMetrics.dividerWeight),
            ),
            borderRadius: BorderRadius.circular(d(_cardRadius)),
          ),
          child: Stack(
            children: [
              rule(_cardX, 241.31, _cardW),
              rule(24.72, 316.31, _cardW),
              at(
                188.72,
                240.81,
                SizedBox(
                  width: d(0.5),
                  height: d(75),
                  child: const BubbaHairline(
                    color: BubbaSettingsColors.cardBorder,
                  ),
                ),
              ),
              label('Card number', 46.43, 188.03),
              value(draft.number, '2424 2424 2424 2424', 45.99, 216.88,
                  controller: _number, width: 280),
              label('Expiration date', 48.25, 267.80),
              value(draft.expiry, 'MM / YY', 48.19, 293.88,
                  controller: _expiry, width: 120),
              label('Security code', 223.25, 267.80),
              value(draft.cvc, 'CVC', 222.21, 291.85,
                  controller: _cvc, width: 100),
              label('Name on card', 50.25, 341.80),
              value(draft.name, 'Full name', 50.99, 368.85,
                  controller: _name,
                  width: 280,
                  keyboard: TextInputType.name),
            ],
          ),
        ),
      ],
    );
  }
}

class _EncryptedNotice extends StatelessWidget {
  const _EncryptedNotice();

  @override
  Widget build(BuildContext context) {
    final metrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.noticeBody);
    return Row(
      children: [
        SizedBox(width: hd(_noticeX)),
        Container(
          width: hd(335),
          height: d(59),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.noticeBg,
            borderRadius: BorderRadius.circular(d(9.38)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(47.37 - _noticeX),
                    top: d(439.36 - _noticeY),
                  ),
                  child: const BubbaGlyphIcon(
                    BubbaSettingsGlyphs.lockMark,
                    color: BubbaSettingsColors.noticeText,
                    width: 10.10,
                    height: 12.12,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: hd(70.39 - _noticeX),
                    top: d(438.32 - _noticeY - metrics.baseline),
                  ),
                  child: Opacity(
                    opacity: 0.92,
                    child: Text(
                      'Your payment information is encrypted\nand secure.',
                      style: BubbaSettingsText.noticeBody,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BillingRow extends StatelessWidget {
  const _BillingRow({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.billingValue);
    return Row(
      children: [
        SizedBox(width: hd(25.22)),
        Semantics(
          button: true,
          label: 'Add billing address',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: hd(335),
              height: d(59),
              decoration: BoxDecoration(
                border: Border.all(
                  color: BubbaSettingsColors.billingBorder,
                  width: d(BubbaSettingsMetrics.dividerWeight),
                ),
                borderRadius: BorderRadius.circular(d(9.38)),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(37.95 - 25.22),
                        top: d(560.90 - _billingY),
                      ),
                      child: const BubbaGlyphIcon(
                        BubbaSettingsGlyphs.pinMark,
                        color: BubbaSettingsColors.rowLabel,
                        width: 16.81,
                        height: 20.07,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(66.36 - 25.22),
                        top: d(574.69 - _billingY - metrics.baseline),
                      ),
                      child: Text(
                        'Add billing address',
                        style: BubbaSettingsText.billingValue,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(337.26 - 25.22),
                        top: d(566.22 - _billingY),
                      ),
                      child: const SettingsChevron(
                        color: BubbaSettingsColors.mutedChevron,
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

class _BillingCard extends StatelessWidget {
  const _BillingCard({required this.address, this.onTap});

  final SettingsBillingAddress address;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.uiMedium);
    final lineMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.billingValue);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(math.max(0, left - 25.22)),
              top: d(math.max(0, top - _billingY)),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(25.22)),
        Semantics(
          button: true,
          label: 'Billing address',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: hd(335),
              height: d(134.81),
              decoration: BoxDecoration(
                color: BubbaSettingsColors.pageBg,
                border: Border.all(
                  color: BubbaSettingsColors.cardBorder,
                  width: d(BubbaSettingsMetrics.dividerWeight),
                ),
                borderRadius: BorderRadius.circular(d(9.38)),
              ),
              child: Stack(
                children: [
                  at(
                    37.95,
                    560.90,
                    const BubbaGlyphIcon(
                      BubbaSettingsGlyphs.pinMark,
                      color: BubbaSettingsColors.rowLabel,
                      width: 16.81,
                      height: 20.07,
                    ),
                  ),
                  at(
                    66.36,
                    574.69 - nameMetrics.baseline,
                    Text(
                      address.name,
                      style: BubbaSettingsText.uiMedium
                          .copyWith(color: BubbaSettingsColors.billingLabel),
                    ),
                  ),
                  at(
                    65.96,
                    601.10 - lineMetrics.baseline,
                    Text(address.line1, style: BubbaSettingsText.billingValue),
                  ),
                  at(
                    65.96,
                    629.10 - lineMetrics.baseline,
                    Text(address.line2, style: BubbaSettingsText.billingValue),
                  ),
                  at(
                    65.96,
                    657.10 - lineMetrics.baseline,
                    Text(address.country, style: BubbaSettingsText.billingValue),
                  ),
                  at(
                    336.26,
                    600.22,
                    const SettingsChevron(
                      color: BubbaSettingsColors.mutedChevron,
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

class BubbaAddCardScreen extends StatefulWidget {
  const BubbaAddCardScreen({super.key});

  @override
  State<BubbaAddCardScreen> createState() => _BubbaAddCardScreenState();
}

class _BubbaAddCardScreenState extends State<BubbaAddCardScreen> {
  SettingsCardDraft _draft = const SettingsCardDraft();
  bool _busy = false;

  /// The card never reaches our own API: the details go to Stripe, and only
  /// the PaymentMethod id it returns is posted to `payment/methods`.
  ///
  /// The design draws its own card fields rather than Stripe's `CardField`,
  /// so this hands them over with `dangerouslyUpdateCardDetails`. That call is
  /// only permitted for a PCI SAQ D merchant; see
  /// `docs/backend/BACKEND_REQUIRED_CHANGES.md` B12.
  Future<void> _save() async {
    if (_busy || _draft.isEmpty) return;
    setState(() => _busy = true);

    final expiry = _draft.expiry.split(RegExp(r'[/\s]+'));
    final month = int.tryParse(expiry.isNotEmpty ? expiry.first : '');
    final year = int.tryParse(expiry.length > 1 ? expiry[1] : '');

    if (month == null || year == null) {
      showSettingsError('Check the expiry date.');
      setState(() => _busy = false);
      return;
    }

    try {
      await Stripe.instance.dangerouslyUpdateCardDetails(
        CardDetails(
          number: _draft.number.replaceAll(RegExp(r'\s'), ''),
          expirationMonth: month,
          expirationYear: year < 100 ? 2000 + year : year,
          cvc: _draft.cvc,
        ),
      );

      final address = _draft.address;
      final method = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: _draft.name.isEmpty ? null : _draft.name,
              address: address == null
                  ? null
                  : Address(
                      line1: address.street.isEmpty
                          ? address.line1
                          : address.street,
                      line2: address.apt.isEmpty ? null : address.apt,
                      city: address.city.isEmpty ? null : address.city,
                      state: address.state.isEmpty ? null : address.state,
                      postalCode: address.zip.isEmpty ? null : address.zip,
                      country: address.countryCode.isEmpty
                          ? address.country
                          : address.countryCode,
                    ),
              phone: address == null || address.phone.isEmpty
                  ? null
                  : address.phone,
            ),
          ),
        ),
      );

      final controller = BubbaSettingsController.to;
      final ok = await controller.addCard(method.id);

      if (!mounted) return;
      if (!ok) {
        showSettingsError(controller.paymentError.value);
        setState(() => _busy = false);
        return;
      }

      Get.back();
    } catch (error) {
      if (!mounted) return;
      showSettingsError('Could not add that card. Check the details.');
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => SettingsAddCardView(
        draft: _draft,
        onBack: Get.back,
        onBilling: () async {
          final address = await Get.to<SettingsBillingAddress>(
            () => BubbaBillingAddressScreen(
              cardholder: _draft.name,
              initial: _draft.address,
            ),
          );
          if (address != null) {
            setState(() => _draft = SettingsCardDraft(
                  number: _draft.number,
                  expiry: _draft.expiry,
                  cvc: _draft.cvc,
                  name: _draft.name,
                  address: address,
                ));
          }
        },
        onChanged: (draft) => setState(() => _draft = draft),
        saving: _busy,
        onSave: _draft.isEmpty || _busy ? null : _save,
      );
}

class BubbaBillingAddressScreen extends StatelessWidget {
  const BubbaBillingAddressScreen({super.key, this.cardholder = '', this.initial});

  final String cardholder;
  final SettingsBillingAddress? initial;

  @override
  Widget build(BuildContext context) => SettingsBillingAddressView(
        initial: initial?.toForm() ?? const SettingsBillingAddressForm(),
        onBack: Get.back,
        onSaveAddress: (form) => Get.back(
          result: SettingsBillingAddress.fromForm(form, name: cardholder),
        ),
      );
}
