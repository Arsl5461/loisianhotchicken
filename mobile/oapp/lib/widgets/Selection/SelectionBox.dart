import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SelectionBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? borderWidth;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const SelectionBox({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.backgroundColor,
    this.borderRadius,
    this.borderWidth,
    this.textStyle,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height:
            height ??
            MediaQueryUtil.dynamicSize(
              small: 45,
              medium: 50,
              large: 55,
              extraSmall: 42,
              extraLarge: 60,
            ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(
            borderRadius ?? MediaQueryUtil.spacing(12),
          ),
          border: Border.all(
            color: isSelected
                ? (selectedBorderColor ?? AppColors.cFF006C6A)
                : (unselectedBorderColor ?? AppColors.grey[300]!),
            width: isSelected ? 3.0 : borderWidth ?? 1.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style:
                textStyle ??
                TextStyle(
                  fontSize: MediaQueryUtil.fontSize(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
