import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_field.dart';
import 'widgets/display_toggle_row.dart';
import 'widgets/step_scaffold.dart';

/// Step 4 of 12 - artboard p023.
class ProfileHometownScreen extends StatefulWidget {
  const ProfileHometownScreen({
    super.key,
    this.initialValue = '',
    this.onBack,
    this.onSkip,
    this.onContinue,
  });

  final String initialValue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(String hometown, bool display)? onContinue;

  static const double fieldY = 257.00;
  static const double helperBaseline = 332.27;
  static const double toggleY = 360.71;

  @override
  State<ProfileHometownScreen> createState() => _ProfileHometownScreenState();
}

class _ProfileHometownScreenState extends State<ProfileHometownScreen> {
  late final _town = TextEditingController(text: widget.initialValue);
  final _focus = FocusNode();
  bool _display = true;
  late bool _isValid = _town.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _town.addListener(_sync);
    _focus.addListener(_syncFocus);
  }

  @override
  void dispose() {
    _town.removeListener(_sync);
    _focus.removeListener(_syncFocus);
    _town.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _sync() {
    final valid = _town.text.trim().isNotEmpty;
    if (valid != _isValid) setState(() => _isValid = valid);
  }

  void _syncFocus() => setState(() {});

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
          step: 4,
          heading: 'Where are you from?',
          body: 'Your hometown can be a great\nconversation starter.',
          continueEnabled: _isValid,
          onBack: widget.onBack,
          onSkip: widget.onSkip,
          onContinue: () =>
              widget.onContinue?.call(_town.text.trim(), _display),
          content: (context, flow) {
            flow.block(
              BubbaField(
                controller: _town,
                focusNode: _focus,
                hintText: 'City, state, or country',
                hintStyle: BubbaText.stepFieldPlaceholder,
                textInset: 13.66,
                textCapitalization: TextCapitalization.words,
                leading: const BubbaLocationPin(),
              ),
              top: ProfileHometownScreen.fieldY,
              height: BubbaMetrics.fieldHeight,
            );
            flow.copy(
              'Start typing to search',
              baseline: ProfileHometownScreen.helperBaseline,
              style: BubbaText.helper,
            );
            flow.block(
              BubbaDisplayToggleRow(
                subtitle: 'Let other see your hometown',
                value: _display,
                onChanged: (v) => setState(() => _display = v),
              ),
              top: ProfileHometownScreen.toggleY,
              height: BubbaMetrics.rowHeightPart2,
            );
          },
        ),
      ),
    );
  }
}
