import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';
import 'step_footer.dart';

const double _barToCounterGap = 18.72;
const double _counterBaseline = 73.39;
const double _headingBaseline = 143.04;
const double _headingLineHeight = 28.8;
const double _bodyBaselineOneLine = 181.42;
const double _bodyBaselineTwoLine = 201.71;
const double _bodyLineHeight = 21;

typedef BubbaFlowBuilder = void Function(BuildContext context, BubbaFlow flow);

class BubbaStepScaffold extends StatelessWidget {
  const BubbaStepScaffold({
    super.key,
    required this.step,
    this.totalSteps = 12,
    required this.heading,
    this.headingBaseline,
    this.body,
    this.bodyBaseline,
    required this.content,
    this.onBack,
    this.onSkip,
    required this.continueEnabled,
    this.onContinue,
    this.continueLabel = 'Continue',
    this.fullWidthCta = false,
    this.ctaFill,
    this.bleed,
    this.showFooter = true,
    this.footer,
    this.overlay,
    this.background,
  });

  final int step;
  final int totalSteps;
  final String heading;
  final double? headingBaseline;
  final String? body;
  final double? bodyBaseline;
  final BubbaFlowBuilder content;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final bool continueEnabled;
  final VoidCallback? onContinue;
  final String continueLabel;
  final bool fullWidthCta;
  final Color? ctaFill;
  final WidgetBuilder? bleed;
  final bool showFooter;
  final WidgetBuilder? footer;
  final List<Widget> Function(BuildContext context)? overlay;
  final Color? background;

  double get _resolvedHeadingBaseline => headingBaseline ?? _headingBaseline;

  double get _resolvedBodyBaseline =>
      bodyBaseline ??
      (_headingLines == 1 ? _bodyBaselineOneLine : _bodyBaselineTwoLine);

  int get _headingLines => heading.contains('\n') ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    return BubbaPage(
      background: background,
      bleed: bleed,
      overlay: overlay,
      content: (context, flow) {
        final counterMetrics = bubbaDesignTextMetrics(context, BubbaText.stepCounter);
        flow.skipTo(_counterBaseline - counterMetrics.baseline);
        flow.raw(
          _ProgressRow(step: step, totalSteps: totalSteps),
          advance: counterMetrics.lineHeight,
        );
        flow.copy(
          heading,
          baseline: _resolvedHeadingBaseline,
          style: BubbaText.stepHeading,
          align: TextAlign.center,
          lines: _headingLines,
          header: true,
        );
        if (body != null) {
          flow.copy(
            body!,
            baseline: _resolvedBodyBaseline,
            style: BubbaText.body,
            align: TextAlign.center,
            lines: body!.contains('\n') ? 2 : 1,
          );
        }
        content(context, flow);
        flow.gap(BubbaMetrics.contentTrailingGap);
      },
      footer: footer ??
          (!showFooter
              ? null
              :
              (context) => fullWidthCta
                  ? _FullWidthCta(
                      label: continueLabel,
                      enabled: continueEnabled,
                      onTap: onContinue,
                      fill: ctaFill,
                    )
                  : BubbaStepFooter(
                      onBack: onBack,
                      onSkip: onSkip,
                      continueEnabled: continueEnabled,
                      onContinue: onContinue,
                      continueLabel: continueLabel,
                    )),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.step, required this.totalSteps});

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaText.stepCounter);
    final rowTop = _counterBaseline - metrics.baseline;
    final barTop =
        BubbaMetrics.progressBarY - BubbaMetrics.progressBarStroke / 2 - rowTop;
    final fraction = (step / totalSteps).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: d(barTop)),
            child: SizedBox(
              height: d(BubbaMetrics.progressBarStroke),
              child: Stack(
                children: [
                  const SizedBox.expand(
                    child: ColoredBox(color: BubbaColors.progressTrack),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: fraction,
                    heightFactor: 1,
                    child: const ColoredBox(color: BubbaColors.actionPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: hd(_barToCounterGap)),
        Text('$step of $totalSteps', style: BubbaText.stepCounter),
      ],
    );
  }
}

class _FullWidthCta extends StatelessWidget {
  const _FullWidthCta({
    required this.label,
    required this.enabled,
    this.onTap,
    this.fill,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final Color? fill;
  static const double designY = 734.07;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: BubbaScale.contentLeft,
        right: BubbaScale.availableWidth - BubbaScale.contentRight,
        bottom: d(
          BubbaMetrics.designHeight - designY - BubbaMetrics.buttonHeight,
        ),
      ),
      child: BubbaMinTapBox(
        painted: d(BubbaMetrics.buttonHeight),
        child: BubbaTapTarget(
          onTap: onTap,
          enabled: enabled,
          label: label,
          designHeight: BubbaMetrics.buttonHeight,
          enforceMinTarget: true,
          child: Container(
            height: d(BubbaMetrics.buttonHeight),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: enabled
                  ? (fill ?? BubbaColors.actionPrimary)
                  : BubbaColors.actionPrimaryDisabledBg,
              borderRadius: BorderRadius.circular(d(BubbaMetrics.buttonRadius)),
              border: enabled
                  ? null
                  : Border.all(
                      color: BubbaColors.actionPrimaryDisabledBorder,
                      width: BubbaMetrics.borderWidth,
                    ),
            ),
            child: Text(
              label,
              style: enabled ? BubbaText.ctaEnabled : BubbaText.ctaDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

double get stepHeadingLineHeight => _headingLineHeight;
double get stepBodyLineHeight => _bodyLineHeight;
