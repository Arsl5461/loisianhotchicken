import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

class BubbaProviderRow extends StatelessWidget {
  const BubbaProviderRow({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    this.filled = false,
    this.tintIcon = true,
    this.onPressed,
  });

  final String label;
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final bool filled;
  final bool tintIcon;
  final VoidCallback? onPressed;

  static const double height = 57.0;
  static const double radius = 12.4;
  static const double iconInset = 20.6;
  static const double labelInset = 46.3;
  static const double chevronInset = 23.5;
  static const double chevronWidth = 6.2;
  static const double chevronHeight = 10.5;

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? BubbaColors.textOnDark : BubbaColors.actionDark;
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: d(height),
          decoration: BoxDecoration(
            color: filled ? BubbaColors.actionPrimary : BubbaColors.surface,
            borderRadius: BorderRadius.circular(d(radius)),
            border: filled
                ? null
                : Border.all(
                    color: BubbaColors.borderSubtle,
                    width: BubbaMetrics.borderWidth,
                  ),
          ),
          child: Row(
            children: [
              SizedBox(width: hd(iconInset)),
              SvgPicture.asset(
                iconAsset,
                width: hd(iconWidth),
                height: d(iconHeight),
                colorFilter: tintIcon
                    ? ColorFilter.mode(foreground, BlendMode.srcIn)
                    : null,
              ),
              SizedBox(width: hd(labelInset - iconInset - iconWidth)),
              Expanded(
                child: Text(
                  label,
                  style: BubbaText.rowLabel.copyWith(color: foreground),
                ),
              ),
              SvgPicture.asset(
                'assets/svg/bubba_chevron_right.svg',
                width: hd(chevronWidth),
                height: d(chevronHeight),
                colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
              ),
              SizedBox(width: hd(chevronInset)),
            ],
          ),
        ),
      ),
    );
  }
}
