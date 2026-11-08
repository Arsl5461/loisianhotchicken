import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/step_scaffold.dart';

const double _inspirationBaseline = 280.54;
const double _chipsY = 293.50;
const double _chipHeight = 29.86;
const double _chipRadius = 6.18;
const double _boxY = 338.65;
const double _boxHeight = 239.84;
const double _boxTextTop = 16;
const double _counterBaseline = 555.29;
const double _bodyBaseline = 207.39;
const double _skipBaseline = 701.96;
const double _ctaHeight = 60.37;
const double _ctaY = 720.71;
const double _goBackBaseline = 806.27;

TextStyle get _goBackStyle => BubbaText.goBack.copyWith(
  fontWeight: FontWeight.w500,
  color: BubbaColors.actionDark,
);

/// Step 13 of 13 - artboard p038. The last questionnaire step, and the first
/// screen that uses the black CTA that the Icebreakers and Photos flows keep.
class ProfileBioScreen extends StatefulWidget {
  const ProfileBioScreen({
    super.key,
    this.initialValue = '',
    this.onBack,
    this.onSkip,
    this.onContinue,
  });

  final String initialValue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final ValueChanged<String>? onContinue;

  static const int maxLength = 300;

  static const List<String> prompts = [
    'A perfect Sunday...',
    'I’m always up for...',
    'You should know...',
  ];

  @override
  State<ProfileBioScreen> createState() => _ProfileBioScreenState();
}

class _ProfileBioScreenState extends State<ProfileBioScreen> {
  late final _bio = TextEditingController(text: widget.initialValue);
  final _focus = FocusNode();
  late int _length = _bio.text.characters.length;

  @override
  void initState() {
    super.initState();
    _bio.addListener(_sync);
  }

  @override
  void dispose() {
    _bio.removeListener(_sync);
    _bio.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _sync() {
    final n = _bio.text.characters.length;
    if (n != _length) setState(() => _length = n);
  }

  void _usePrompt(String prompt) {
    _bio.text = prompt;
    _bio.selection = TextSelection.collapsed(offset: _bio.text.length);
    _focus.requestFocus();
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
          step: 13,
          totalSteps: 13,
          heading: 'Tell people a little\nabout yourself',
          body: 'Share what you enjoy, care about, or\nwant someone to know',
          bodyBaseline: _bodyBaseline,
          continueEnabled: true,
          continueLabel: 'Continue to icebreakers',
          onBack: widget.onBack,
          onContinue: () => widget.onContinue?.call(_bio.text.trim()),
          footer: (context) => _BioFooter(
            onSkip: widget.onSkip,
            onBack: widget.onBack,
            onContinue: () => widget.onContinue?.call(_bio.text.trim()),
          ),
          content: (context, flow) {
            flow.copy(
              'Need inspiration?',
              baseline: _inspirationBaseline,
              style: BubbaText.inspirationLabel,
            );
            flow.block(
              Row(
                children: [
                  for (var i = 0; i < ProfileBioScreen.prompts.length; i++) ...[
                    if (i > 0) SizedBox(width: hd(5.34)),
                    Expanded(
                      child: _PromptChip(
                        label: ProfileBioScreen.prompts[i],
                        onTap: () => _usePrompt(ProfileBioScreen.prompts[i]),
                      ),
                    ),
                  ],
                ],
              ),
              top: _chipsY,
              height: _chipHeight,
            );
            flow.block(
              Container(
                height: d(_boxHeight),
                decoration: BoxDecoration(
                  color: BubbaColors.surface,
                  borderRadius: BorderRadius.circular(d(10.34)),
                  border: Border.all(
                    color: BubbaColors.border,
                    width: BubbaMetrics.borderWidth,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  d(13),
                  d(_boxTextTop),
                  d(13),
                  d(30),
                ),
                child: TextField(
                  controller: _bio,
                  focusNode: _focus,
                  maxLines: null,
                  expands: true,
                  maxLength: ProfileBioScreen.maxLength,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: BubbaText.fieldValuePart2,
                  cursorColor: BubbaColors.actionDark,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'I’ll never say no to a long walk with a coffee.',
                    hintStyle: BubbaText.fieldPlaceholderPart2,
                  ),
                ),
              ),
              top: _boxY,
              height: _boxHeight,
            );
            flow.copy(
              '$_length / ${ProfileBioScreen.maxLength}',
              baseline: _counterBaseline,
              style: BubbaText.helper,
              align: TextAlign.right,
              right: BubbaMetrics.pageInsetRight + 14,
            );
          },
        ),
      ),
    );
  }
}

class _BioFooter extends StatelessWidget {
  const _BioFooter({this.onSkip, this.onBack, this.onContinue});

  final VoidCallback? onSkip;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  static const double _ctaBottom = _ctaY + _ctaHeight;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BubbaColors.screenBg,
      child: Padding(
        padding: EdgeInsets.only(
          left: BubbaScale.contentLeft,
          right: BubbaScale.availableWidth - BubbaScale.contentRight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BubbaFooterLink(
              'Skip for now',
              baseline: _skipBaseline,
              ctaY: _ctaY,
              style: BubbaText.goBack.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0C0C0C),
              ),
              onTap: onSkip,
            ),
            BubbaTapTarget(
              onTap: onContinue,
              label: 'Continue to icebreakers',
              designHeight: _ctaHeight,
              child: Container(
                height: d(_ctaHeight),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BubbaColors.actionDark,
                  borderRadius: BorderRadius.circular(
                    d(BubbaMetrics.buttonRadius),
                  ),
                ),
                child: Text(
                  'Continue to icebreakers',
                  style: BubbaText.buttonDark,
                ),
              ),
            ),
            SizedBox(
              height: d(BubbaMetrics.designHeight - _ctaBottom),
              child: Align(
                alignment: Alignment.topCenter,
                child: Baseline(
                  baseline: d(_goBackBaseline - _ctaBottom),
                  baselineType: TextBaseline.alphabetic,
                  child: BubbaMinTapBox(
                    painted: bubbaTextMetrics(context, _goBackStyle).lineHeight,
                    child: BubbaTapTarget(
                      onTap: onBack,
                      label: 'Go back',
                      child: SizedBox(
                        height: BubbaMetrics.minTapTarget,
                        child: Center(
                          widthFactor: 1,
                          child: Text('Go back', style: _goBackStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: d(_chipHeight),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F4),
          borderRadius: BorderRadius.circular(d(_chipRadius)),
        ),
        child: Text(label, style: BubbaText.promptChip),
      ),
    ),
  );
}
