import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _goBackLeft = 34.37;
const double _footerRightInset = 390 - 354.67;
const double _skipToContinueGap = 11.01;
const double _dividerToButton =
    BubbaMetrics.footerButtonY - BubbaMetrics.footerDividerY;
const double _buttonToBottom = BubbaMetrics.designHeight -
    BubbaMetrics.footerButtonY -
    BubbaMetrics.footerButtonHeight;

class BubbaStepFooter extends StatelessWidget {
  const BubbaStepFooter({
    super.key,
    this.onBack,
    this.onSkip,
    required this.continueEnabled,
    this.onContinue,
    this.continueLabel = 'Continue',
    this.showDivider = true,
  });

  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final bool continueEnabled;
  final VoidCallback? onContinue;
  final String continueLabel;
  final bool showDivider;

  static double get height => d(BubbaMetrics.footerButtonHeight);

  @override
  Widget build(BuildContext context) {
    final continueWidth = onSkip == null
        ? BubbaMetrics.footerContinueWideWidth
        : BubbaMetrics.footerContinueWidth;
    final overhang =
        BubbaScale.tapOverhang(d(BubbaMetrics.footerButtonHeight));

    return ColoredBox(
      color: BubbaColors.screenBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDivider) Container(height: 1, color: BubbaColors.divider),
          SizedBox(height: math.max(0, d(_dividerToButton) - overhang)),
          Padding(
            padding: EdgeInsets.only(
              left: dx(_goBackLeft),
              right: BubbaScale.availableWidth - dxRight(_footerRightInset),
            ),
            child: Row(
              children: [
                if (onBack != null)
                  BubbaTapTarget(
                    onTap: onBack,
                    label: 'Go back',
                    designHeight: BubbaMetrics.footerButtonHeight,
                    enforceMinTarget: true,
                    child: Text('Go back', style: BubbaText.goBack),
                  ),
                const Spacer(),
                if (onSkip != null) ...[
                  _FooterPill(
                    label: 'Skip',
                    width: BubbaMetrics.footerSkipWidth,
                    enabled: true,
                    neutral: true,
                    onTap: onSkip,
                  ),
                  SizedBox(width: hd(_skipToContinueGap)),
                ],
                _FooterPill(
                  label: continueLabel,
                  width: continueWidth,
                  enabled: continueEnabled,
                  onTap: onContinue,
                ),
              ],
            ),
          ),
          SizedBox(height: math.max(0, d(_buttonToBottom) - overhang)),
        ],
      ),
    );
  }
}

class _FooterPill extends StatelessWidget {
  const _FooterPill({
    required this.label,
    required this.width,
    required this.enabled,
    this.neutral = false,
    this.onTap,
  });

  final String label;
  final double width;
  final bool enabled;
  final bool neutral;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color fill;
    final TextStyle style;
    if (neutral) {
      fill = BubbaColors.skipBg;
      style = BubbaText.skipLabel;
    } else if (enabled) {
      fill = BubbaColors.actionPrimary;
      style = BubbaText.ctaEnabled;
    } else {
      fill = BubbaColors.actionPrimaryDisabledBg;
      style = BubbaText.ctaDisabled;
    }
    return BubbaTapTarget(
      onTap: onTap,
      enabled: enabled,
      label: label,
      designHeight: BubbaMetrics.footerButtonHeight,
      enforceMinTarget: true,
      child: Container(
        width: hd(width),
        height: d(BubbaMetrics.footerButtonHeight),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius:
              BorderRadius.circular(d(BubbaMetrics.footerButtonRadius)),
          border: !neutral && !enabled
              ? Border.all(
                  color: BubbaColors.actionPrimaryDisabledBorder,
                  width: BubbaMetrics.borderWidth,
                )
              : null,
        ),
        child: Text(label, style: style),
      ),
    );
  }
}
