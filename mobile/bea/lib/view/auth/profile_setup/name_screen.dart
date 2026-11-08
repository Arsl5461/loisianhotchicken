import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_field.dart';
import 'widgets/step_scaffold.dart';

/// Step 1 of 12 - artboards p015 (empty) and p016 (filled, field focused).
///
/// p016 draws the heading 31pt lower and its body one size larger than every
/// other artboard in the flow; that is state-to-state drift in the design, so
/// both states use p015's rhythm, which is the one all 22 other steps share.
class ProfileNameScreen extends StatefulWidget {
  const ProfileNameScreen({
    super.key,
    this.initialValue = '',
    this.focused = false,
    this.onContinue,
  });

  final String initialValue;

  final bool focused;
  final ValueChanged<String>? onContinue;

  static const double questionBaseline = 336.10;
  static const double fieldY = 356.94;

  @override
  State<ProfileNameScreen> createState() => _ProfileNameScreenState();
}

class _ProfileNameScreenState extends State<ProfileNameScreen> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initialValue);
  final FocusNode _focus = FocusNode();

  bool _isValid = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _isValid = _name.text.trim().isNotEmpty;
    _focus.addListener(_onFocusChanged);
    _name.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChanged);
    _name.removeListener(_onTextChanged);
    _focus.dispose();
    _name.dispose();
    super.dispose();
  }

  // A TextEditingController notifies on selection changes too, so rebuilding on
  // every notification makes the field's own layout re-trigger the listener and
  // the tree never settles. Only rebuild when something we render actually flips.
  void _onTextChanged() {
    final valid = _name.text.trim().isNotEmpty;
    if (valid != _isValid) setState(() => _isValid = valid);
  }

  void _onFocusChanged() {
    if (_focus.hasFocus != _focused) setState(() => _focused = _focus.hasFocus);
  }

  void _submit() {
    if (!_isValid) return;
    widget.onContinue?.call(_name.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.screenBg,
        resizeToAvoidBottomInset: false,
        body: BubbaStepScaffold(
          step: 1,
          heading: 'Let’s start with the basics.',
          body: 'We’ll ask a few quick questions to\npersonalize your experience.',
          fullWidthCta: true,
          continueEnabled: _isValid,
          onContinue: _submit,
          content: (context, flow) {
            flow.copy(
              'What should we call you?',
              baseline: ProfileNameScreen.questionBaseline,
              style: BubbaText.question,
            );
            flow.block(
              BubbaField(
                controller: _name,
                focusNode: _focus,
                focused: widget.focused,
                hintText: 'First name',
                hintStyle: BubbaText.stepFieldPlaceholder,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.givenName],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              top: ProfileNameScreen.fieldY,
              height: BubbaMetrics.fieldHeight,
            );
          },
        ),
      ),
    );
  }
}
