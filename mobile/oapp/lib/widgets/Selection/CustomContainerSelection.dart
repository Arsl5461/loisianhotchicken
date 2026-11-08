import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomContainerSelection extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? width;
  final double? height;
  final double? textSize;
  final FontWeight? fontWeight;

  const CustomContainerSelection({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.borderRadius,
    this.borderWidth,
    this.width,
    this.height,
    this.textSize,
    this.fontWeight,
  });

  @override
  State<CustomContainerSelection> createState() =>
      _CustomContainerSelectionState();
}

class _CustomContainerSelectionState extends State<CustomContainerSelection> {
  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    // Default colors
    final selectedBgColor =
        widget.selectedBackgroundColor ?? AppColors.cFFE3F2FD;
    final unselectedBgColor =
        widget.unselectedBackgroundColor ?? AppColors.white;
    final selectedTextColor = widget.selectedTextColor ?? AppColors.black87;
    final unselectedTextColor = widget.unselectedTextColor ?? AppColors.black87;
    final selectedBorderColor =
        widget.selectedBorderColor ?? AppColors.cFF1E88E5;
    final unselectedBorderColor =
        widget.unselectedBorderColor ?? AppColors.transparent;

    // Default dimensions
    final borderRadius = MediaQueryUtil.spacing(widget.borderRadius ?? 12);
    final borderWidth = MediaQueryUtil.spacing(widget.borderWidth ?? 2);
    final width = MediaQueryUtil.spacing(widget.width ?? 140);
    final height = MediaQueryUtil.spacing(widget.height ?? 50);
    final textSize = MediaQueryUtil.fontSize(widget.textSize ?? 16);
    final fontWeight = widget.fontWeight ?? FontWeight.w500;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: widget.isSelected ? selectedBgColor : unselectedBgColor,
          border: Border.all(
            color: widget.isSelected
                ? selectedBorderColor
                : unselectedBorderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: fontWeight,
              color: widget.isSelected
                  ? selectedTextColor
                  : unselectedTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
