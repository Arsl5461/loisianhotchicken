import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/bubba_nav_bar.dart';

const double _promptBaseline = 128.21;
const double _changeBaseline = 130.99;
const double _changeColumnWidth = 50.0;
const double _boxY = 164.25;
const double _boxHeight = 397.20;
const double _boxRadius = 12.41;
const double _boxTextInset = 12.35;
const double _boxTextTop = 17.5;
const double _counterBaseline = 544.11;
const double _ctaY = 749.46;
const double _ctaHeight = 58.0;
const double _ctaRadius = 11.39;

/// Artboards p007 (empty, "Done" disabled), p051 ("Done" live) and p052
/// ("Save changes" when editing an existing answer).
///
/// This screen keeps the **green** CTA even though the icebreaker screens around
/// it use black - see `01_TOKENS.md`.
class IcebreakerAnswerScreen extends StatefulWidget {
  const IcebreakerAnswerScreen({
    super.key,
    required this.prompt,
    this.initialValue = '',
    this.editing = false,
    this.onBack,
    this.onChangePrompt,
    this.onSubmit,
  });

  final String prompt;
  final String initialValue;

  /// p052 - an answer that already exists, so the CTA reads "Save changes".
  final bool editing;
  final VoidCallback? onBack;

  final ValueChanged<String>? onChangePrompt;
  final ValueChanged<String>? onSubmit;

  static const int maxLength = 300;

  @override
  State<IcebreakerAnswerScreen> createState() => _IcebreakerAnswerScreenState();
}

class _IcebreakerAnswerScreenState extends State<IcebreakerAnswerScreen> {
  late final _answer = TextEditingController(text: widget.initialValue);
  final _focus = FocusNode();
  late int _length = _answer.text.characters.length;

  @override
  void initState() {
    super.initState();
    _answer.addListener(_sync);
  }

  @override
  void dispose() {
    _answer.removeListener(_sync);
    _answer.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _sync() {
    final n = _answer.text.characters.length;
    if (n != _length) setState(() => _length = n);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _answer.text.trim().isNotEmpty;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.screenBg,
        resizeToAvoidBottomInset: false,
        body: BubbaPage(
          contentStartY: navHairlineY,
          header: (context) =>
              BubbaNavBar(title: 'Your answer', onBack: widget.onBack),
          content: (context, flow) {
            // CHANGE sits on the prompt's first line, so the two are one row.
            // Laid out in sequence the link's design baseline lands above the
            // flow cursor, and the negative gap that produced collapsed its hit
            // box - it drew in roughly the right place but never fired.
            final promptMetrics =
                bubbaDesignTextMetrics(context, BubbaText.answerPrompt);
            final changeMetrics =
                bubbaDesignTextMetrics(context, BubbaText.changeLink);
            final promptTop = _promptBaseline - promptMetrics.baseline;
            final changeTop = _changeBaseline - changeMetrics.baseline;
            flow.block(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(widget.prompt, style: BubbaText.answerPrompt),
                  ),
                  SizedBox(
                    width: hd(_changeColumnWidth),
                    child: BubbaLink(
                      'CHANGE',
                      gapAbove: _changeBaseline - promptTop,
                      style: BubbaText.changeLink,
                      onTap: widget.onChangePrompt == null
                          ? null
                          : () => widget.onChangePrompt!(_answer.text),
                      align: Alignment.centerRight,
                      semanticsLabel: 'Change prompt',
                    ),
                  ),
                ],
              ),
              top: promptTop,
              // CHANGE's line box ends below the prompt's, so the row is as
              // tall as the lower of the two - declare anything shorter and
              // the answer box below drifts down by the difference.
              height: math.max(
                    promptTop + promptMetrics.lineHeight,
                    changeTop + changeMetrics.lineHeight,
                  ) -
                  promptTop,
            );
            flow.block(
              Container(
                height: d(_boxHeight),
                decoration: BoxDecoration(
                  color: BubbaColors.surface,
                  borderRadius: BorderRadius.circular(d(_boxRadius)),
                  border: Border.all(
                    color: BubbaColors.border,
                    width: BubbaMetrics.borderWidth,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  d(_boxTextInset),
                  d(_boxTextTop),
                  d(_boxTextInset),
                  d(30),
                ),
                child: TextField(
                  controller: _answer,
                  focusNode: _focus,
                  maxLines: null,
                  expands: true,
                  maxLength: IcebreakerAnswerScreen.maxLength,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: BubbaText.answerValue,
                  cursorColor: BubbaColors.actionDark,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText:
                        'I\u2019ll never say no to a long walk with a coffee.',
                    hintStyle: BubbaText.answerHint,
                  ),
                ),
              ),
              top: _boxY,
              height: _boxHeight,
            );
            flow.copy(
              '$_length / ${IcebreakerAnswerScreen.maxLength}',
              baseline: _counterBaseline,
              style: BubbaText.answerCounter,
              align: TextAlign.right,
              right: BubbaMetrics.pageInsetRight + 14,
            );
          },
          footer: (context) => Padding(
            padding: EdgeInsets.only(
              left: BubbaScale.contentLeft,
              right: BubbaScale.availableWidth - BubbaScale.contentRight,
              bottom: d(BubbaMetrics.designHeight - _ctaY - _ctaHeight),
            ),
            child: BubbaTapTarget(
              onTap: enabled
                  ? () => widget.onSubmit?.call(_answer.text.trim())
                  : null,
              enabled: enabled,
              label: widget.editing ? 'Save changes' : 'Done',
              designHeight: _ctaHeight,
              child: Container(
                height: d(_ctaHeight),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: enabled
                      ? BubbaColors.actionPrimary
                      : BubbaColors.actionPrimaryDisabledBg,
                  borderRadius: BorderRadius.circular(d(_ctaRadius)),
                  border: enabled
                      ? null
                      : Border.all(
                          color: BubbaColors.actionPrimaryDisabledBorder,
                          width: BubbaMetrics.borderWidth,
                        ),
                ),
                child: Text(
                  widget.editing ? 'Save changes' : 'Done',
                  style:
                      enabled ? BubbaText.ctaEnabled : BubbaText.ctaDisabled,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
