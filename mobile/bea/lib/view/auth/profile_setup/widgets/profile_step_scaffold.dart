import 'package:flutter/material.dart';

import '../../../../core/design/bubba_icons.dart';
import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _eyebrowBaseline = 61.62;
const double _eyebrowDiamondY = 53.64;
const double _eyebrowDiamond = 8.64;
const double _eyebrowDiamondHeight = 8.75;
const double _eyebrowGap = 132.44 - 118.12 - _eyebrowDiamond;
const double _headingBaseline = 112.33;
const double _bodyBaseline = 145.22;

const double _ctaY = 757.5;
const double _ctaWidth = 183.3;
const double _ctaHeight = 58.0;
const double _ctaRightInset = 390 - 365.5;
const double _goBackBaseline = 792.83;
const double _goBackX = 25.88;
const double _chevronX = BubbaMetrics.backChevronX;
const double _chevronY = 52.60;

const double _stackedGoBackBaseline = 723.41;
const double _wideCtaX = 24.06;
const double _wideCtaRightInset = 390 - 24.06 - 339.70;
const double _wideCtaY = 737.0;

const double _bandTop = 740.0;
const double _footerRuleY = 735.04;

class BubbaProfileStepScaffold extends StatelessWidget {
  const BubbaProfileStepScaffold({
    super.key,
    required this.heading,
    this.headingSpan,
    this.body,
    this.bodyBaseline,
    required this.content,
    this.onBack,
    this.ctaLabel = 'Continue to photos',
    this.ctaEnabled = true,
    this.onCta,
    this.background,
    this.showFooter = true,
    this.backChevron = false,
    this.stackedFooter = false,
    this.footerRule = false,
    this.goBackBaseline,
    this.overlay,
    this.bleed,
  });

  final String heading;
  final InlineSpan? headingSpan;
  final String? body;
  final double? bodyBaseline;
  final BubbaContentBuilder content;
  final VoidCallback? onBack;
  final String ctaLabel;
  final bool ctaEnabled;
  final VoidCallback? onCta;
  final Color? background;
  final bool showFooter;
  final bool backChevron;
  final bool stackedFooter;

  /// p001, p042 and p048-p053 draw a full-bleed `#DCE2EA` rule just above the
  /// footer band; p002, p004 and p039 do not.
  final bool footerRule;
  final double? goBackBaseline;
  final List<Widget> Function(BuildContext context)? overlay;
  final WidgetBuilder? bleed;

  @override
  Widget build(BuildContext context) {
    return BubbaPage(
      background: background,
      bleed: bleed,
      overlay: (context) => [
        ...?overlay?.call(context),
        if (backChevron) _BackChevron(onTap: onBack),
      ],
      content: (context, flow) {
        final eyebrow = bubbaDesignTextMetrics(context, BubbaText.eyebrow);
        final rowTop = _eyebrowBaseline - eyebrow.baseline;
        flow.skipTo(rowTop);
        flow.raw(_Eyebrow(rowTop: rowTop), advance: eyebrow.lineHeight);
        flow.copy(
          heading,
          baseline: _headingBaseline,
          style: BubbaText.stepHeading,
          align: TextAlign.center,
          lines: '\n'.allMatches(
            headingSpan?.toPlainText() ?? heading,
          ).length + 1,
          header: true,
          span: headingSpan,
        );
        if (body != null) {
          flow.copy(
            body!,
            baseline: bodyBaseline ?? _bodyBaseline,
            style: BubbaText.body,
            align: TextAlign.center,
            lines: body!.contains('\n') ? 2 : 1,
          );
        }
        content(context, flow);
      },
      footer: !showFooter
          ? null
          : (context) => stackedFooter
              ? _StackedFooter(
                  onBack: onBack,
                  goBackBaseline: goBackBaseline ?? _stackedGoBackBaseline,
                  ctaLabel: ctaLabel,
                  ctaEnabled: ctaEnabled,
                  onCta: onCta,
                )
              : _SplitFooter(
                  onBack: onBack,
                  ctaLabel: ctaLabel,
                  ctaEnabled: ctaEnabled,
                  onCta: onCta,
                  rule: footerRule,
                ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.rowTop});

  final double rowTop;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: d(_eyebrowDiamondY - rowTop)),
          child: SizedBox(
            width: hd(_eyebrowDiamond),
            height: d(_eyebrowDiamondHeight),
            child: const Center(
              child: BubbaStar4(size: _eyebrowDiamond, strokeWidth: 0.9),
            ),
          ),
        ),
        SizedBox(width: hd(_eyebrowGap)),
        Text('BUILDING YOUR PROFILE', style: BubbaText.eyebrow),
      ],
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BubbaOverlay(
      x: _chevronX,
      y: _chevronY,
      hitPadding: 12,
      topShift: true,
      onTap: onTap,
      label: 'Back',
      child: const BubbaChevronLeft(
        width: BubbaMetrics.backChevronWidth,
        height: BubbaMetrics.backChevronHeight,
      ),
    );
  }
}

class _DarkCta extends StatelessWidget {
  const _DarkCta({
    required this.label,
    required this.enabled,
    this.onTap,
    this.width,
    this.radius = 10,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return BubbaMinTapBox(
      painted: d(_ctaHeight),
      width: width == null ? null : d(width!),
      child: BubbaTapTarget(
        onTap: onTap,
        enabled: enabled,
        label: label,
        designHeight: _ctaHeight,
        enforceMinTarget: true,
        child: Container(
          width: width == null ? null : d(width!),
          height: d(_ctaHeight),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? BubbaColors.actionDark
                : BubbaColors.actionPrimaryDisabledBg,
            borderRadius: BorderRadius.circular(d(radius)),
          ),
          child: Text(
            label,
            style: enabled ? BubbaText.buttonDark : BubbaText.ctaDisabled,
          ),
        ),
      ),
    );
  }
}

class _SplitFooter extends StatelessWidget {
  const _SplitFooter({
    this.onBack,
    required this.ctaLabel,
    required this.ctaEnabled,
    this.onCta,
    this.rule = false,
  });

  final VoidCallback? onBack;
  final String ctaLabel;
  final bool ctaEnabled;
  final VoidCallback? onCta;
  final bool rule;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BubbaColors.screenBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rule) ...[
            BubbaHairline(
              color: BubbaColors.border,
              width: double.infinity,
            ),
            SizedBox(height: d(_ctaY - _footerRuleY)),
          ] else
            SizedBox(height: d(_ctaY - _bandTop)),
          Padding(
            padding: EdgeInsets.only(
              left: dx(_goBackX),
              right: BubbaScale.availableWidth - dxRight(_ctaRightInset),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onBack != null)
                  Baseline(
                    baseline: d(_goBackBaseline - _ctaY),
                    baselineType: TextBaseline.alphabetic,
                    child: BubbaTapTarget(
                      onTap: onBack,
                      label: 'Go back',
                      child: SizedBox(
                        height: BubbaMetrics.minTapTarget,
                        child: Center(
                          child: Text('Go back', style: BubbaText.goBack),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                _DarkCta(
                  label: ctaLabel,
                  enabled: ctaEnabled,
                  onTap: onCta,
                  width: _ctaWidth,
                ),
              ],
            ),
          ),
          SizedBox(height: d(BubbaMetrics.designHeight - _ctaY - _ctaHeight)),
        ],
      ),
    );
  }
}

class _StackedFooter extends StatelessWidget {
  const _StackedFooter({
    this.onBack,
    required this.goBackBaseline,
    required this.ctaLabel,
    required this.ctaEnabled,
    this.onCta,
  });

  final VoidCallback? onBack;
  final double goBackBaseline;
  final String ctaLabel;
  final bool ctaEnabled;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BubbaColors.screenBg,
      child: Padding(
        padding: EdgeInsets.only(
          left: dx(_wideCtaX),
          right: BubbaScale.availableWidth - dxRight(_wideCtaRightInset),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onBack != null)
              BubbaFooterLink(
                'Go back',
                baseline: goBackBaseline,
                ctaY: _wideCtaY,
                style: BubbaText.goBackCentred,
                onTap: onBack,
              ),
            _DarkCta(
              label: ctaLabel,
              enabled: ctaEnabled,
              onTap: onCta,
              radius: 11.39,
            ),
            SizedBox(
              height: d(BubbaMetrics.designHeight - _wideCtaY - _ctaHeight),
            ),
          ],
        ),
      ),
    );
  }
}
