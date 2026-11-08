import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_loading.dart';
import 'widgets/bubba_otp_field.dart';

enum VerifyCodeError { none, expired, incorrect }

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    super.key,
    required this.destination,
    this.headingFirstLine = 'Verify your',
    this.headingSecondLine = 'phone number',
    this.onVerified,
    this.onChangeDestination,
    this.onResend,
    this.initialCode = '',
    this.initialError = VerifyCodeError.none,
    this.resendSeconds = 29,
    this.focused = false,
    this.busy = false,
  });

  final String destination;
  final String headingFirstLine;
  final String headingSecondLine;
  final void Function(String code)? onVerified;
  final VoidCallback? onChangeDestination;
  final VoidCallback? onResend;
  final String initialCode;
  final VerifyCodeError initialError;
  final int resendSeconds;

  final bool focused;

  /// The code is checked as soon as the sixth digit lands, so this is the only
  /// thing on the screen that says the check is running.
  final bool busy;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late final TextEditingController _code;
  Timer? _resendTimer;
  late int _secondsLeft;
  late VerifyCodeError _error;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.initialCode);
    _error = widget.initialError;
    _secondsLeft = widget.resendSeconds;
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    if (_secondsLeft <= 0) return;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    setState(() {
      _secondsLeft = widget.resendSeconds;
      _error = VerifyCodeError.none;
      _code.clear();
    });
    _startResendTimer();
    widget.onResend?.call();
  }

  String? get _errorText {
    switch (_error) {
      case VerifyCodeError.expired:
        return 'This code has expired.';
      case VerifyCodeError.incorrect:
        return 'This code isn’t right. Try again.';
      case VerifyCodeError.none:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: BubbaTheme.light,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: BubbaColors.screenBg,
          resizeToAvoidBottomInset: false,
          body: BubbaPage(
            content: (context, flow) {
              flow.block(
                BubbaTapTarget(
                  onTap: () => Navigator.of(context).maybePop(),
                  label: 'Back',
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: hd(16),
                      right: hd(20),
                      top: d(18),
                      bottom: d(18),
                    ),
                    child: const BubbaChevronLeft(),
                  ),
                ),
                top: 44.92 - 18,
                height: BubbaMetrics.backIconHeight + 36,
                left: BubbaMetrics.backChevronX - 16,
              );
              flow.copy(
                '${widget.headingFirstLine}\n${widget.headingSecondLine}',
                baseline: 127.7,
                style: BubbaText.displayLargeAlt,
                left: 15.4,
                lines: 2,
              );
              flow.copy(
                'Enter the six-digit code sent to',
                baseline: 212.5,
                style: BubbaText.bodyLarge,
                left: 19.6,
              );
              flow.block(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.destination, style: BubbaText.buttonLight),
                    SizedBox(width: hd(8)),
                    Baseline(
                      baseline: d(238.1 - 237.6) +
                          d(bubbaDesignTextMetrics(
                            context,
                            BubbaText.buttonLight,
                          ).baseline),
                      baselineType: TextBaseline.alphabetic,
                      child: BubbaTapTarget(
                        onTap: widget.onChangeDestination,
                        label: 'Change number',
                        child: Text(
                          'Change',
                          style: BubbaText.link.copyWith(
                            color: BubbaColors.textLinkStrong,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                top: 237.6 -
                    bubbaDesignTextMetrics(context, BubbaText.buttonLight)
                        .baseline,
                height: bubbaDesignTextMetrics(context, BubbaText.buttonLight)
                    .lineHeight,
                left: 19.6,
              );
              flow.copy(
                'Enter code',
                baseline: 291.6,
                style: BubbaText.fieldHeading,
                left: 15.5,
              );
              flow.bleed(
                Padding(
                  padding: EdgeInsets.only(
                    left: dx(BubbaOtpField.firstBoxX),
                    right: BubbaScale.availableWidth -
                        dxRight(BubbaOtpField.rowInsetRight),
                  ),
                  child: BubbaOtpField(
                    controller: _code,
                    focused: widget.focused,
                    hasError: _error != VerifyCodeError.none,
                    onCompleted: (code) => widget.onVerified?.call(code),
                  ),
                ),
                top: BubbaOtpField.boxY,
                height: BubbaOtpField.boxHeight,
              );
              if (_errorText != null) {
                flow.copy(
                  _errorText!,
                  baseline: 390.6,
                  style: BubbaText.error,
                  left: 16.2,
                  liveRegion: true,
                );
              }
              if (widget.busy) {
                flow.block(
                  const BubbaSpinner(size: 24),
                  top: 400,
                  height: 24,
                  align: Alignment.center,
                );
              }
              flow.copy(
                'Didn\u2019t get a code?',
                baseline: 465.7,
                style: BubbaText.noticeTitle,
                left: 19.5,
              );
              flow.block(
                BubbaTapTarget(
                  onTap: _resend,
                  enabled: _secondsLeft <= 0,
                  label: 'Resend code',
                  child: Baseline(
                    baseline: d(487.9 - 470),
                    baselineType: TextBaseline.alphabetic,
                    child: _secondsLeft > 0
                        ? Text.rich(
                            TextSpan(
                              style: BubbaText.timer,
                              children: [
                                const TextSpan(text: 'Resend available in '),
                                TextSpan(
                                  text: '${_secondsLeft}s',
                                  style: BubbaText.timer.copyWith(
                                    color: BubbaColors.textLinkStrong,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text('Resend code', style: BubbaText.link),
                  ),
                ),
                top: 470,
                height: 487.9 -
                    470 +
                    bubbaDesignTextMetrics(context, BubbaText.link).descent,
                left: 20.1,
              );
            },
          ),
        ),
      ),
    );
  }
}
