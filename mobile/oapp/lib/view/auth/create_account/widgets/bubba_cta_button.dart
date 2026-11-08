import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';
import '../../../../core/design/widgets/bubba_loading.dart';

class BubbaCtaButton extends StatelessWidget {
  const BubbaCtaButton({
    super.key,
    required this.label,
    required this.enabled,
    this.onPressed,
    this.bottomInset = 0,
    this.designY,
    this.fill,
    this.busy = false,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onPressed;
  final double bottomInset;
  final double? designY;
  final Color? fill;
  final bool busy;

  static const double designX = BubbaMetrics.pagePadding + 0.2;

  @override
  Widget build(BuildContext context) {
    final overhang = BubbaScale.tapOverhang(d(BubbaMetrics.buttonHeight));
    final button = BubbaTapTarget(
      onTap: onPressed,
      enabled: enabled && !busy,
      label: label,
      designHeight: BubbaMetrics.buttonHeight,
      enforceMinTarget: true,
      child: Container(
          height: d(BubbaMetrics.buttonHeight),
          decoration: BoxDecoration(
            color: enabled
                ? (fill ?? BubbaColors.actionPrimary)
                : BubbaColors.ctaDisabledBgPart1,
            borderRadius: BorderRadius.circular(d(BubbaMetrics.buttonRadius)),
            border: enabled
                ? null
                : Border.all(
                    color: BubbaColors.ctaDisabledBorderPart1,
                    width: BubbaMetrics.borderWidth,
                  ),
          ),
          alignment: Alignment.center,
          child: busy
              ? const BubbaSpinner(size: 22, color: Colors.white)
              : Text(
                  label,
                  style:
                      enabled ? BubbaText.ctaEnabled : BubbaText.ctaDisabledPart1,
                ),
        ),
    );

    // Both branches measure from the bottom of the viewport. A design y is
    // 843-relative, and on a 568-tall phone that puts the CTA off the screen -
    // "Begin profile setup" landed at y 570 on an iPhone SE.
    //
    // The inset is the larger of the keyboard the caller passed and the home
    // indicator / Android navigation bar, or the CTA sits under the latter -
    // it overlapped Android's 3-button bar by 11.4pt.
    final extra = math.max(0.0, bottomInset - bubbaBottomInset(context));
    return Padding(
      padding: EdgeInsets.only(
        left: dx(designX),
        right: BubbaScale.availableWidth - dxRight(BubbaMetrics.pageInsetRight),
        bottom: (designY != null
                ? d(BubbaMetrics.designHeight -
                    designY! -
                    BubbaMetrics.buttonHeight)
                : d(BubbaMetrics.buttonBottomOffset)) +
            extra -
            overhang,
      ),
      child: button,
    );
  }
}
