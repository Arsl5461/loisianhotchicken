import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_icons.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../core/design/bubba_text_styles.dart';
import '../../core/design/bubba_tokens.dart';
import '../auth/create_account/widgets/bubba_otp_field.dart';
import 'widgets/security_chrome.dart';

/// The vertical rhythm of one verify screen. p020 (phone) and p024 (email)
/// differ only in these five baselines and the box row's own y - the email
/// heading is one line where the phone heading is two, so everything above the
/// resend block sits 50.70 higher.
class SecurityVerifyLayout {
  const SecurityVerifyLayout({
    required this.headingBaseline,
    required this.leadBaseline,
    required this.destinationBaseline,
    required this.changeBaseline,
    required this.enterCodeBaseline,
    required this.boxY,
  });

  final double headingBaseline;
  final double leadBaseline;
  final double destinationBaseline;
  final double changeBaseline;
  final double enterCodeBaseline;
  final double boxY;

  static const SecurityVerifyLayout phone = SecurityVerifyLayout(
    headingBaseline: 115.61,
    leadBaseline: 163.63,
    destinationBaseline: 188.68,
    changeBaseline: 189.25,
    enterCodeBaseline: 291.57,
    boxY: 310.03,
  );

  static const SecurityVerifyLayout email = SecurityVerifyLayout(
    headingBaseline: 122.90,
    leadBaseline: 161.82,
    destinationBaseline: 186.87,
    changeBaseline: 187.44,
    enterCodeBaseline: 240.87,
    boxY: 259.34,
  );
}

class BubbaVerifyPhoneScreen extends StatelessWidget {
  const BubbaVerifyPhoneScreen({
    super.key,
    required this.destination,
    this.onVerified,
    this.onResend,
  });

  final String destination;
  final Future<bool> Function(String code)? onVerified;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) => SecurityVerifyCodeView(
        heading: 'Verify your phone number',
        destination: destination,
        layout: SecurityVerifyLayout.phone,
        onBack: Get.back,
        onChange: Get.back,
        onVerified: onVerified ??
            (_) async {
              Get.back(result: true);
              return true;
            },
        onResend: onResend,
      );
}

class BubbaVerifyEmailScreen extends StatelessWidget {
  const BubbaVerifyEmailScreen({
    super.key,
    required this.destination,
    this.onVerified,
    this.onResend,
  });

  final String destination;
  final Future<bool> Function(String code)? onVerified;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) => SecurityVerifyCodeView(
        heading: 'Verify your email',
        destination: destination,
        layout: SecurityVerifyLayout.email,
        onBack: Get.back,
        onChange: Get.back,
        onVerified: onVerified ??
            (_) async {
              Get.back(result: true);
              return true;
            },
        onResend: onResend,
      );
}

class SecurityVerifyCodeView extends StatefulWidget {
  const SecurityVerifyCodeView({
    super.key,
    required this.heading,
    required this.destination,
    required this.layout,
    this.initialCode = '',
    this.resendSeconds = 29,
    this.focused = false,
    this.onBack,
    this.onChange,
    this.onVerified,
    this.onResend,
  });

  final String heading;
  final String destination;
  final SecurityVerifyLayout layout;
  final String initialCode;
  final int resendSeconds;
  final bool focused;
  final VoidCallback? onBack;
  final VoidCallback? onChange;
  final Future<bool> Function(String code)? onVerified;
  final VoidCallback? onResend;

  @override
  State<SecurityVerifyCodeView> createState() => _SecurityVerifyCodeViewState();
}

class _SecurityVerifyCodeViewState extends State<SecurityVerifyCodeView> {
  late final TextEditingController _code =
      TextEditingController(text: widget.initialCode);
  Timer? _timer;
  late int _secondsLeft = widget.resendSeconds;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    if (_secondsLeft <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  bool _verifying = false;

  /// The field fills itself as the last digit lands, so this is where the
  /// double submit would happen; `_verifying` refuses it. A rejected code
  /// clears the field rather than leaving a dead six digits on screen.
  Future<void> _submit(String code) async {
    final verify = widget.onVerified;
    if (verify == null || _verifying) return;

    setState(() => _verifying = true);
    final ok = await verify(code);
    if (!mounted) return;

    setState(() {
      _verifying = false;
      if (!ok) _code.clear();
    });
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    setState(() {
      _secondsLeft = widget.resendSeconds;
      _code.clear();
    });
    _start();
    widget.onResend?.call();
  }

  @override
  Widget build(BuildContext context) {
    final layout = widget.layout;
    return SecurityScaffold(
      showNav: false,
      resizeToAvoidBottomInset: false,
      content: (context, flow) {
        flow.block(
          BubbaTapTarget(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
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

        final headingMetrics =
            bubbaDesignTextMetrics(context, BubbaSecurityText.verifyHeading);
        flow.block(
          Row(
            children: [
              SizedBox(width: hd(15.42)),
              Expanded(
                child: Text(
                  widget.heading,
                  style: BubbaSecurityText.verifyHeading,
                ),
              ),
            ],
          ),
          top: layout.headingBaseline - headingMetrics.baseline,
          height: headingMetrics.lineHeight,
        );

        flow.copy(
          'Enter the six-digit code sent to',
          baseline: layout.leadBaseline,
          style: BubbaText.bodyLarge,
          left: 19.6,
        );

        final destMetrics =
            bubbaDesignTextMetrics(context, BubbaText.buttonLight);
        final changeMetrics = bubbaDesignTextMetrics(context, BubbaText.link);
        flow.block(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.destination, style: BubbaText.buttonLight),
              SizedBox(width: hd(8)),
              Column(
                children: [
                  SizedBox(
                    height: d(
                      (layout.changeBaseline - changeMetrics.baseline) -
                          (layout.destinationBaseline - destMetrics.baseline),
                    ),
                  ),
                  BubbaTapTarget(
                    onTap: widget.onChange,
                    label: 'Change',
                    child: Text(
                      'Change',
                      style: BubbaText.link
                          .copyWith(color: BubbaColors.textLinkStrong),
                    ),
                  ),
                ],
              ),
            ],
          ),
          top: layout.destinationBaseline - destMetrics.baseline,
          height: destMetrics.lineHeight,
          left: 19.6,
        );

        flow.copy(
          'Enter code',
          baseline: layout.enterCodeBaseline,
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
              y: layout.boxY,
              digitBaselineOverride: layout.boxY + 34.97,
              focused: widget.focused,
              onCompleted: _submit,
            ),
          ),
          top: layout.boxY,
          height: BubbaOtpField.boxHeight,
        );

        flow.copy(
          'Didn’t get a code?',
          baseline: 465.73,
          style: BubbaText.noticeTitle,
          left: 19.5,
        );

        flow.block(
          BubbaTapTarget(
            onTap: _resend,
            enabled: _secondsLeft <= 0,
            label: 'Resend code',
            child: Baseline(
              baseline: d(487.91 - 470),
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
          height: 487.91 -
              470 +
              bubbaDesignTextMetrics(context, BubbaText.link).descent,
          left: 20.1,
        );
      },
    );
  }
}
