import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_field.dart';
import 'widgets/bubba_cta_button.dart';

final RegExp _emailPattern = RegExp(r'^[\w.!#$%&*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$');

class EmailEntryScreen extends StatefulWidget {
  const EmailEntryScreen({
    super.key,
    this.body = 'Your email can be used for sign-in and\naccount recovery.',
    this.secondaryLabel,
    this.onContinue,
    this.onSecondary,
    this.initialEmail = '',
  });

  const EmailEntryScreen.signIn({
    super.key,
    this.onContinue,
    this.onSecondary,
    this.initialEmail = '',
  })  : body = 'We’ll email you a code to verify it’s\nyou.',
        secondaryLabel = 'Use another sign-in method';

  final String body;
  final String? secondaryLabel;
  final void Function(String email)? onContinue;
  final VoidCallback? onSecondary;
  final String initialEmail;

  static const double fieldX = 29.0;
  static const double fieldY = 273.6;
  static const double fieldHeight = BubbaMetrics.fieldHeight;
  static const double textInset = 15.5;

  @override
  State<EmailEntryScreen> createState() => _EmailEntryScreenState();
}

class _EmailEntryScreenState extends State<EmailEntryScreen> {
  late final TextEditingController _email;
  final FocusNode _focus = FocusNode();
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail);
    _email.addListener(_onChanged);
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _email.removeListener(_onChanged);
    _email.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {
      if (_showError) _showError = false;
    });
  }

  bool get _isValid => _emailPattern.hasMatch(_email.text.trim());

  void _submit() {
    if (!_isValid) {
      setState(() => _showError = true);
      return;
    }
    widget.onContinue?.call(_email.text.trim());
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
        child: Scaffold(
          backgroundColor: BubbaColors.screenBg,
          resizeToAvoidBottomInset: false,
          body: BubbaPage(
            footerBand: BubbaMetrics.buttonBottomOffset,
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
                BubbaCtaButton(
                  label: 'Continue',
                  enabled: _isValid,
                  onPressed: _submit,
                  bottomInset: bottomInset,
                ),
              ],
            ),
            content: (context, flow) {
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
                'Enter your email',
                baseline: 138.9,
                style: BubbaText.displayLarge,
                left: 21.5,
              );
              flow.copy(
                widget.body,
                baseline: 187.8,
                style: BubbaText.body,
                left: 23.3,
                lines: 2,
              );
              flow.copy(
                'EMAIL',
                baseline: 264.0,
                style: BubbaText.fieldLabel,
                left: 28.3,
              );
              flow.block(
                BubbaField(
                  controller: _email,
                  focusNode: _focus,
                  hintText: 'Email address',
                  height: EmailEntryScreen.fieldHeight,
                  textInset: EmailEntryScreen.textInset,
                  hasError: _showError,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
                top: EmailEntryScreen.fieldY,
                height: EmailEntryScreen.fieldHeight,
                left: EmailEntryScreen.fieldX,
              );
              if (_showError) {
                flow.copy(
                  'Enter a valid email address.',
                  baseline: 355.2,
                  style: BubbaText.error,
                  left: EmailEntryScreen.fieldX,
                  liveRegion: true,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
