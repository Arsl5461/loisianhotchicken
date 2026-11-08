import 'package:flutter/material.dart';
import '../../core/design/widgets/bubba_loading.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_icons.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../auth/create_account/data/bubba_countries.dart';
import '../auth/create_account/models/bubba_country.dart';
import '../auth/create_account/phone_number_screen.dart';
import '../../data/repositories/settings_repository.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'security_verify_code_screen.dart';
import 'widgets/security_chrome.dart';
import 'widgets/settings_picker_sheet.dart';

const String _defaultPhone = '1 (860) 977 - 4286';
const String _dialPrefix = '+';
const double _phoneValueX = 63.00;

const SecurityHeroCircle _phoneHero = SecurityHeroCircle(
  glyph: BubbaSecurityGlyphs.phone,
  glyphX: 181.64,
  glyphY: 137.54,
  glyphWidth: 26.80,
  glyphHeight: 26.93,
);

class BubbaPhoneNumberScreen extends StatefulWidget {
  const BubbaPhoneNumberScreen({super.key});

  @override
  State<BubbaPhoneNumberScreen> createState() => _BubbaPhoneNumberScreenState();
}

class _BubbaPhoneNumberScreenState extends State<BubbaPhoneNumberScreen> {
  BubbaSecurityController get _controller => BubbaSecurityController.to;

  @override
  void initState() {
    super.initState();
    _controller.loadAccount(force: true);
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final number = _controller.phoneNumber;

        return PhoneNumberDetailView(
          phoneNumber: number,
          onBack: Get.back,
          onChange: () async {
            await Get.toNamed(Routes.BUBBA_CHANGE_PHONE_NUMBER);
            await _controller.loadAccount(force: true);
          },
        );
      });
}

class PhoneNumberDetailView extends StatelessWidget {
  const PhoneNumberDetailView({
    super.key,
    this.phoneNumber = _defaultPhone,
    this.onBack,
    this.onChange,
  });

  final String phoneNumber;
  final VoidCallback? onBack;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Phone Number',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      _phoneHero,
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Phone number');
    securityLead(
      context,
      flow,
      const ['This is the number you use to sign in', 'to Bubba'],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityValueCard(
        top: 352.50,
        height: 94,
        cardX: 26.14,
        pairs: [
          SecurityValuePair(
            label: 'Your phone number',
            labelBaseline: 391.32,
            value: phoneNumber,
            valueBaseline: 417.68,
            x: 44.13,
            valuePrefix: _dialPrefix,
            valueX: _phoneValueX,
          ),
        ],
      ),
      top: 352.50,
      height: 94,
    );

    flow.block(
      SecurityNavCard(
        top: 547.90,
        height: 66.60,
        cardX: 20.74,
        onTap: onChange,
        spec: const SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.phone,
          iconX: 38.65,
          iconY: 573.49,
          iconWidth: 17.00,
          iconHeight: 17.08,
          title: 'Change phone number',
          titleX: 73.19,
          titleBaseline: 585.66,
          trailing: SecurityChevron(),
          trailingY: 576.60,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 547.90,
      height: 66.60,
    );
  }
}

class BubbaChangePhoneNumberScreen extends StatefulWidget {
  const BubbaChangePhoneNumberScreen({super.key});

  @override
  State<BubbaChangePhoneNumberScreen> createState() =>
      _BubbaChangePhoneNumberScreenState();
}

class _BubbaChangePhoneNumberScreenState
    extends State<BubbaChangePhoneNumberScreen> {
  final TextEditingController _phone = TextEditingController();
  BubbaCountry _country = bubbaCountries.first;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickCountry() async {
    final picked = await showSettingsPickerSheet(
      context,
      title: 'Country code',
      searchHint: 'Search countries',
      selected: _country.code,
      options: [
        for (final country in bubbaCountries)
          SettingsPickerOption(
            value: country.code,
            label: '${country.name} (${country.dialCode})',
          ),
      ],
    );
    if (picked == null || !mounted) return;
    setState(
      () => _country = bubbaCountries.firstWhere((c) => c.code == picked),
    );
  }

  BubbaSecurityController get _controller => BubbaSecurityController.to;
  final SettingsRepository _repository = Get.find<SettingsRepository>();

  /// Two steps: `request` sends the code to the **new** number and returns a
  /// short-lived token, `confirm` performs the swap. The old number stays live
  /// until the code is accepted.
  Future<void> _send() async {
    if (_busy || _phone.text.replaceAll(RegExp(r'\D'), '').length < 10) return;
    setState(() => _busy = true);

    final next =
        '${_country.dialCode}${_phone.text.replaceAll(RegExp(r'\D'), '')}';
    final old = _controller.phoneNumber;

    final requested = await _repository.requestPhoneChange(next);
    if (!mounted) return;

    if (!requested.isSuccess || requested.value == null) {
      showSettingsError(requested.errorMessage);
      setState(() => _busy = false);
      return;
    }

    final token = requested.value!;

    final verified = await Get.to<bool>(
      () => BubbaVerifyPhoneScreen(
        destination: next,
        onVerified: (code) async {
          final confirmed = await BubbaBusy.run(
            _repository.confirmPhoneChange(changeToken: token, otp: code),
          );
          if (!confirmed.isSuccess) {
            showSettingsError(confirmed.errorMessage);
            return false;
          }
          Get.back(result: true);
          return true;
        },
        onResend: () => _repository.requestPhoneChange(next),
      ),
    );

    if (!mounted) return;
    setState(() => _busy = false);
    if (verified != true) return;

    await _controller.loadAccount(force: true);
    if (!mounted) return;

    await Get.off(
      () => BubbaPhoneNumberUpdatedScreen(oldNumber: old, newNumber: next),
    );
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final number = _controller.phoneNumber;

        return ChangePhoneNumberView(
          controller: _phone,
          currentNumber: number,
          countryLabel: '${_country.code} ${_country.dialCode}',
          busy: _busy,
          onBack: Get.back,
          onCancel: Get.back,
          onCountry: _busy ? null : _pickCountry,
          onSend: _send,
        );
      });
}

class ChangePhoneNumberView extends StatelessWidget {
  const ChangePhoneNumberView({
    super.key,
    required this.controller,
    this.currentNumber = _defaultPhone,
    this.countryLabel = 'US +1',
    this.busy = false,
    this.onBack,
    this.onCancel,
    this.onSend,
    this.onCountry,
  });

  final TextEditingController controller;
  final String currentNumber;
  final String countryLabel;
  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onSend;
  final VoidCallback? onCountry;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Change Phone Number',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      _phoneHero,
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Change number');
    securityLead(
      context,
      flow,
      const ['Enter your new phone number.', 'We’ll send you a verification code.'],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityValueCard(
        top: 352.50,
        height: 94,
        cardX: 26.14,
        pairs: [
          SecurityValuePair(
            label: 'Current phone number',
            labelBaseline: 391.32,
            value: currentNumber,
            valueBaseline: 417.68,
            x: 44.13,
            valuePrefix: _dialPrefix,
            valueX: _phoneValueX,
          ),
        ],
      ),
      top: 352.50,
      height: 94,
    );

    final headerMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.countryHeader);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(29.48)),
          Text('New phone number', style: BubbaSecurityText.countryHeader),
        ],
      ),
      top: 490.59 - headerMetrics.baseline,
      height: headerMetrics.lineHeight,
    );

    flow.block(
      SecurityPhoneEntry(
        controller: controller,
        countryLabel: countryLabel,
        onCountry: onCountry,
        onSubmitted: (_) => onSend?.call(),
      ),
      top: 499.88,
      height: 57.80,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Send code',
        y: 699.70,
        labelBaseline: 734.62,
        enabled: !busy,
        busy: busy,
        onTap: onSend,
      ),
      top: 699.70,
      height: BubbaSecurityMetrics.ctaHeight,
    );

    securitySecondaryLink(
      context,
      flow,
      'Cancel',
      baseline: 786.92,
      onTap: busy ? null : onCancel,
    );
  }
}

/// p019's `New phone number` row: the country button and the masked number
/// field, both drawn the way part 1's sign-up screen draws them so the picker
/// and the mask behave identically in both places.
class SecurityPhoneEntry extends StatelessWidget {
  const SecurityPhoneEntry({
    super.key,
    required this.controller,
    this.countryLabel = 'US +1',
    this.onCountry,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String countryLabel;
  final VoidCallback? onCountry;
  final ValueChanged<String>? onSubmitted;

  static const double countryX = 27.17;
  static const double countryWidth = 83.45;
  static const double countryHeight = 57.80;
  static const double fieldX = 129.95;
  static const double fieldWidth = 233.16;
  static const double fieldHeight = 57.46;
  static const double radius = 10;
  static const double countryY = 499.88;
  static const double fieldY = 500.23;
  static const double caretX = 88.56;
  static const double caretY = 527.31;
  static const double caretWidth = 6.57;
  static const double caretHeight = 3.29;

  @override
  Widget build(BuildContext context) {
    final m = bubbaDesignTextMetrics(context, BubbaSecurityText.countryLabel);
    final labelTop = 533.09 - m.baseline;

    BoxDecoration box() => BoxDecoration(
          color: BubbaSecurityColors.inputBg,
          borderRadius: BorderRadius.circular(d(radius)),
          border: Border.all(
            color: BubbaSecurityColors.inputBorder,
            width: BubbaSecurityMetrics.cardBorderWidth,
          ),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: hd(countryX)),
        Semantics(
          button: true,
          label: 'Country code',
          value: countryLabel,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCountry,
            child: SizedBox(
              width: hd(countryWidth),
              height: d(countryHeight),
              child: DecoratedBox(
                decoration: box(),
                // The label and the caret each sit at their own design x; a
                // caret pushed along by the label's width lands 5pt left the
                // moment PublicSans stands in for SF Pro.
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: hdGap(41.65 - countryX),
                          top: dGap(labelTop - countryY),
                        ),
                        child: Text(
                          countryLabel,
                          style: BubbaSecurityText.countryLabel,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: hdGap(caretX - countryX),
                          top: dGap(caretY - countryY),
                        ),
                        child: const BubbaChevronDown(
                          width: caretWidth,
                          height: caretHeight,
                          color: BubbaSecurityColors.icon,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: hd(fieldX - countryX - countryWidth)),
        SizedBox(
          width: hd(fieldWidth),
          height: d(fieldHeight),
          child: DecoratedBox(
            decoration: box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: dGap(533.23 - m.baseline - fieldY)),
                Row(
                  children: [
                    SizedBox(width: hd(141.88 - fieldX)),
                    Expanded(
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (context, value, _) => Stack(
                          children: [
                            if (value.text.isEmpty)
                              Text(
                                'Phone number',
                                style: BubbaSecurityText.countryLabel.copyWith(
                                  color: BubbaSecurityColors.inputPlaceholder,
                                ),
                              ),
                            SizedBox(
                              height: d(m.lineHeight),
                              // P3-5: a Material decoration puts its text 2.5pt
                              // below where you place it even with the padding
                              // zeroed, so there is no InputDecorator at all
                              // and the placeholder is a sibling.
                              child: TextField(
                                controller: controller,
                                keyboardType: TextInputType.phone,
                                autofillHints: const [
                                  AutofillHints.telephoneNumber,
                                ],
                                inputFormatters: [BubbaUsPhoneFormatter()],
                                onSubmitted: onSubmitted,
                                decoration: null,
                                style: BubbaSecurityText.countryLabel,
                                cursorColor: BubbaSecurityColors.rowTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: hd(12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BubbaPhoneNumberUpdatedScreen extends StatelessWidget {
  const BubbaPhoneNumberUpdatedScreen({
    super.key,
    required this.oldNumber,
    required this.newNumber,
  });

  final String oldNumber;
  final String newNumber;

  @override
  Widget build(BuildContext context) => PhoneNumberUpdatedView(
        oldNumber: oldNumber,
        newNumber: newNumber,
        onBack: Get.back,
        onContinue: () => Get.until(
          (route) => Get.currentRoute == Routes.BUBBA_SECURITY_PRIVACY,
        ),
        onBackToSecurity: () => Get.until(
          (route) => Get.currentRoute == Routes.BUBBA_SECURITY_PRIVACY,
        ),
      );
}

class PhoneNumberUpdatedView extends StatelessWidget {
  const PhoneNumberUpdatedView({
    super.key,
    this.oldNumber = _defaultPhone,
    this.newNumber = _defaultPhone,
    this.onBack,
    this.onContinue,
    this.onBackToSecurity,
  });

  final String oldNumber;
  final String newNumber;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onBackToSecurity;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Change Phone Number',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      const SecurityHeroCircle(
        glyph: BubbaSecurityGlyphs.checkMark,
        fill: BubbaSecurityColors.heroSuccess,
        glyphColor: BubbaSecurityColors.successMark,
        glyphX: 179.65,
        glyphY: 139.92,
        glyphWidth: 30.69,
        glyphHeight: 22.17,
      ),
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Phone number updated');
    securityLead(
      context,
      flow,
      const ['Your phone number has been', 'successfully changed.'],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityValueCard(
        top: 352.50,
        height: 160.81,
        cardX: 26.14,
        ruleBaselines: const [434.99],
        ruleInset: (BubbaSecurityMetrics.cardWidth - 300.48) / 2,
        pairs: [
          SecurityValuePair(
            label: 'Old phone number',
            labelBaseline: 391.32,
            value: oldNumber,
            valueBaseline: 417.68,
            x: 44.13,
            valuePrefix: _dialPrefix,
            valueX: _phoneValueX,
          ),
          SecurityValuePair(
            label: 'New phone number',
            labelBaseline: 463.78,
            value: newNumber,
            valueBaseline: 490.15,
            x: 44.13,
            valuePrefix: _dialPrefix,
            valueX: _phoneValueX,
            labelStyle: BubbaSecurityText.fieldValueAccent,
            badge: 'Verified',
            badgeBaseline: 476.04,
            badgeRightGap: 26.14 + BubbaSecurityMetrics.cardWidth - 341.61,
          ),
        ],
      ),
      top: 352.50,
      height: 160.81,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Continue',
        y: 707.10,
        labelBaseline: 742.02,
        onTap: onContinue,
      ),
      top: 707.10,
      height: BubbaSecurityMetrics.ctaHeight,
    );

    securitySecondaryLink(
      context,
      flow,
      'Back to Security & Privacy',
      baseline: 794.33,
      onTap: onBackToSecurity,
    );
  }
}
