import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

class BubbaPillButton extends StatelessWidget {
  const BubbaPillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width = designWidth,
    this.height = designHeight,
    this.fill = BubbaColors.actionPrimary,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color fill;
  final TextStyle? textStyle;

  static const double designWidth = 238.9;
  static const double designHeight = 58.0;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: BubbaTapTarget(
        onTap: onPressed,
        label: label,
        designHeight: height,
        child: Container(
          width: hd(width),
          height: d(height),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(d(height / 2)),
          ),
          child: Text(label, style: textStyle ?? BubbaText.buttonDark),
        ),
      ),
    );
  }
}

class BubbaTextButton extends StatelessWidget {
  const BubbaTextButton({
    super.key,
    required this.label,
    required this.gapAbove,
    this.onPressed,
    this.style,
  });

  final String label;
  final double gapAbove;
  final VoidCallback? onPressed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return BubbaLink(
      label,
      gapAbove: gapAbove,
      style: style ?? BubbaText.buttonLight,
      onTap: onPressed,
    );
  }
}
