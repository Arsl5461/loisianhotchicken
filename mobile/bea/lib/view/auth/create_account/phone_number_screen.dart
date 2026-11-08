import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';
import 'data/bubba_countries.dart';
import 'models/bubba_country.dart';
import 'widgets/bubba_cta_button.dart';
import 'widgets/bubba_notice_card.dart';
import 'widgets/country_picker_popover.dart';
import 'widgets/get_started_sheet.dart';

enum PhoneNumberError { none, invalid, tooManyAttempts }

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({
    super.key,
    this.onContinue,
    this.onNeedHelp,
    this.initialError = PhoneNumberError.none,
    this.initialNumber = '',
    this.lockoutDuration = const Duration(minutes: 15),
    this.heading = 'What’s your\nphone number?',
    this.body = 'We use your number for login and\n'
        'security verification. It won’t show\n'
        'up anywhere.',
    this.bodyLines = 3,
    this.headingLines = 2,
    this.fieldShift = 0,
    this.secondaryLabel,
    this.onSecondary,
    this.pickerOpen = false,
    this.pickerSearching = false,
    this.fieldFocused = false,
    this.signInSheet = false,
    this.busy = false,
  });

  const PhoneNumberScreen.signIn({
    super.key,
    this.onContinue,
    this.onNeedHelp,
    this.initialError = PhoneNumberError.none,
    this.initialNumber = '',
    this.lockoutDuration = const Duration(minutes: 15),
    this.onSecondary,
    this.pickerOpen = false,
    this.pickerSearching = false,
    this.fieldFocused = false,
    this.signInSheet = false,
    this.busy = false,
  })  : heading = 'Enter your phone\nnumber',
        body = 'We’ll text you a code to verify it’s you.',
        bodyLines = 1,
        headingLines = 2,
        fieldShift = -53.4,
        secondaryLabel = 'Use another sign-in method';

  final void Function(BubbaCountry country, String number)? onContinue;

  /// Drawn as a spinner inside "Continue" while the code request is in flight.
  final bool busy;
  final VoidCallback? onNeedHelp;
  final PhoneNumberError initialError;
  final String initialNumber;
  final Duration lockoutDuration;
  final String heading;
  final String body;
  final int bodyLines;
  final int headingLines;
  final double fieldShift;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  final bool pickerOpen;
  final bool pickerSearching;
  final bool fieldFocused;
  final bool signInSheet;

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  late final TextEditingController _phone;
  final FocusNode _phoneFocus = FocusNode();

  BubbaCountry _country = bubbaCountries.first;
  bool _pickerOpen = false;
  bool _pickerAsSheet = false;
  PhoneNumberError _error = PhoneNumberError.none;
  Timer? _lockoutTimer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _phone = TextEditingController(
      text: BubbaUsPhoneFormatter.format(widget.initialNumber),
    );
    _pickerOpen = widget.pickerOpen || widget.pickerSearching;
    _pickerAsSheet = widget.pickerSearching;
    _error = widget.initialError;
    _phone.addListener(_onNumberChanged);
    _phoneFocus.addListener(() => setState(() {}));
    if (_error == PhoneNumberError.tooManyAttempts) {
      _startLockout();
    }
  }

  void _startLockout() {
    _lockoutTimer?.cancel();
    _remaining = widget.lockoutDuration;
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      final next = _remaining - const Duration(seconds: 1);
      setState(() => _remaining = next);
      if (next <= Duration.zero) {
        timer.cancel();
        setState(() => _error = PhoneNumberError.none);
      }
    });
  }

  String get _lockoutMessage =>
      'Please wait 15 minutes before trying again.';

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    _phone.removeListener(_onNumberChanged);
    _phone.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _onNumberChanged() {
    setState(() {
      if (_error == PhoneNumberError.invalid) {
        _error = PhoneNumberError.none;
      }
    });
  }

  String get _digits => _phone.text.replaceAll(RegExp(r'\D'), '');

  static const int _minDigits = 10;

  bool get _canContinue =>
      _digits.length >= _minDigits && _error != PhoneNumberError.tooManyAttempts;

  void _openPicker() {
    _phoneFocus.unfocus();
    setState(() => _pickerOpen = true);
  }

  void _closePicker() {
    FocusScope.of(context).unfocus();
    setState(() {
      _pickerOpen = false;
      _pickerAsSheet = false;
    });
  }

  void _pickCountry(BubbaCountry country) {
    FocusScope.of(context).unfocus();
    setState(() {
      _country = country;
      _pickerOpen = false;
      _pickerAsSheet = false;
    });
  }

  void _onPickerSheetChanged(bool asSheet) {
    if (_pickerAsSheet == asSheet) return;
    setState(() => _pickerAsSheet = asSheet);
  }

  void _submit() {
    if (_digits.length < _minDigits) {
      setState(() => _error = PhoneNumberError.invalid);
      return;
    }
    widget.onContinue?.call(_country, _digits);
  }

  Color get _phoneBorderColor {
    if (_error == PhoneNumberError.invalid) return BubbaColors.borderError;
    if (widget.fieldFocused || _phoneFocus.hasFocus) {
      return BubbaColors.actionPrimary;
    }
    return BubbaColors.border;
  }




  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Theme(
      data: BubbaTheme.light,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: PopScope(
          canPop: !_pickerOpen,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _pickerOpen) _closePicker();
          },
          child: Scaffold(
          backgroundColor: BubbaColors.screenBg,
          resizeToAvoidBottomInset: false,
          body: BubbaPage(
            footerBand: BubbaMetrics.buttonBottomOffset,
            overlay: (_pickerOpen || widget.signInSheet)
                ? (context) => [
                      if (_pickerOpen)
                        CountryPickerPopover(
                          selected: _country,
                          searching: widget.pickerSearching,
                          shiftY: widget.fieldShift,
                          onSelected: _pickCountry,
                          onDismiss: _closePicker,
                          onSheetChanged: _onPickerSheetChanged,
                        ),
                      if (widget.signInSheet)
                        BubbaSheetOverlay(
                          sheet: GetStartedSheet(
                            title: 'Sign in another way',
                            subtitle:
                                'Choose a method connected to your account.',
                            exclude: const {BubbaAuthProvider.phone},
                            footerLabel: 'Recover your account',
                            footerCaption:
                                'Use this if you can’t access any linked method',
                            onPicked: (_) {},
                          ),
                        ),
                    ]
                : null,
            footer: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.secondaryLabel != null)
                  BubbaFooterLink(
                    widget.secondaryLabel!,
                    baseline: 718.9,
                    ctaY: BubbaMetrics.designHeight -
                        BubbaMetrics.buttonBottomOffset -
                        BubbaMetrics.buttonHeight,
                    style: BubbaText.link,
                    onTap: widget.onSecondary,
                  ),
                if (!_pickerAsSheet)
                  BubbaCtaButton(
                    label: 'Continue',
                    enabled: _canContinue,
                    busy: widget.busy,
                    onPressed: _pickerOpen ? _closePicker : _submit,
                    bottomInset: bottomInset,
                  ),
              ],
            ),
            content: (context, flow) {
              final fy = widget.fieldShift;
              flow.block(
                BubbaTapTarget(
                  onTap: () => Navigator.of(context).maybePop(),
                  label: 'Back',
                  child: Padding(
                    padding: EdgeInsets.all(d(18)),
                    child: const BubbaChevronLeft(),
                  ),
                ),
                top: 53.5 - 18,
                height: BubbaMetrics.backIconHeight + 36,
                left: BubbaMetrics.backChevronXContent - 18,
              );
              flow.copy(
                widget.heading,
                baseline: 138.9,
                style: BubbaText.displayLarge,
                left: 21.6,
                lines: widget.headingLines,
              );
              flow.copy(
                widget.body,
                baseline: 232.3,
                style: BubbaText.body,
                left: 23.4,
                lines: widget.bodyLines,
              );
              flow.block(
                Row(
                  children: [
                    SizedBox(
                      width: hd(BubbaMetrics.countryFieldWidth),
                      child: Text('COUNTRY', style: BubbaText.fieldLabel),
                    ),
                    SizedBox(width: hd(131.1 - 28.3 - BubbaMetrics.countryFieldWidth)),
                    Text('PHONE', style: BubbaText.fieldLabel),
                  ],
                ),
                top: 339.1 +
                    fy -
                    bubbaDesignTextMetrics(context, BubbaText.fieldLabel)
                        .baseline,
                height: bubbaDesignTextMetrics(context, BubbaText.fieldLabel)
                    .lineHeight,
                left: 28.3,
              );
              flow.block(
                Row(
                  children: [
                    Semantics(
                      button: true,
                      label: 'Country code',
                      value: _country.shortLabel,
                      hint: 'Opens the country list',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _openPicker,
                        child: ExcludeSemantics(
                          child: Container(
                            width: hd(BubbaMetrics.countryFieldWidth),
                            height: d(57.8),
                            decoration: BoxDecoration(
                              color: BubbaColors.surface,
                              borderRadius: BorderRadius.circular(
                                d(BubbaMetrics.fieldRadius),
                              ),
                            ),
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                d(BubbaMetrics.fieldRadius),
                              ),
                              border: Border.all(
                                color: _pickerOpen
                                    ? BubbaColors.actionPrimary
                                    : BubbaColors.border,
                                width: BubbaMetrics.borderWidth,
                              ),
                            ),
                            padding: EdgeInsets.only(
                              left: hd(14.5),
                              right: hd(15.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _country.shortLabel,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: BubbaText.fieldValue,
                                    ),
                                  ),
                                ),
                                SizedBox(width: hd(5)),
                                const BubbaChevronDown(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: hd(128.8 - 26.0 - BubbaMetrics.countryFieldWidth)),
                    Expanded(
                      child: Container(
                        height: d(BubbaMetrics.fieldHeight),
                        decoration: BoxDecoration(
                          color: _error == PhoneNumberError.invalid
                              ? BubbaColors.surfaceField
                              : BubbaColors.surface,
                          borderRadius: BorderRadius.circular(
                            d(BubbaMetrics.fieldRadius),
                          ),
                        ),
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            d(BubbaMetrics.fieldRadius),
                          ),
                          border: Border.all(
                            color: _phoneBorderColor,
                            width: BubbaMetrics.borderWidth,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: d(11.9)),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _phone,
                          focusNode: _phoneFocus,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [
                            AutofillHints.telephoneNumber,
                          ],
                          inputFormatters: [BubbaUsPhoneFormatter()],
                          style: BubbaText.fieldValue.copyWith(
                            color: BubbaColors.actionDark,
                          ),
                          cursorColor: BubbaColors.actionDark,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Phone number',
                            hintStyle: BubbaText.fieldPlaceholder,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                top: 348.4 + fy,
                height: 57.8,
              );
              if (_error == PhoneNumberError.invalid) {
                flow.copy(
                  'Enter a $_minDigits digit phone number.',
                  baseline: 430.3 + fy,
                  style: BubbaText.error,
                  left: 128.0,
                  liveRegion: true,
                );
              }
              if (_error == PhoneNumberError.tooManyAttempts) {
                flow.block(
                  BubbaNoticeCard(
                    title: 'Too many attempts.',
                    message: _lockoutMessage,
                  ),
                  top: 424.8 + fy,
                  height: BubbaNoticeCard.designHeight,
                );
                flow.link(
                  'Need help?',
                  baseline: 507.0 + fy,
                  style: BubbaText.link,
                  onTap: widget.onNeedHelp,
                  align: Alignment.centerLeft,
                );
              }
            },
          ),
          ),
        ),
      ),
    );
  }
}


class BubbaUsPhoneFormatter extends TextInputFormatter {
  static String format(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      buffer.write(capped[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = format(newValue.text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
