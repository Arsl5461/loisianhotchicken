import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../utils/media_query.dart';
import 'package:OApp/core/constants/app_colors.dart';

/// A customizable selectable box widget that can be used across multiple screens.
/// This widget provides a box-style selection option with customizable colors, text, and dimensions.
class SelectableBox extends StatelessWidget {
  /// The text to display in the box
  final String text;

  /// Whether this box is currently selected
  final bool isSelected;

  /// Callback function to execute when the box is tapped
  final VoidCallback onTap;

  /// Background color when selected
  final Color? selectedBackgroundColor;

  /// Background color when not selected
  final Color? unselectedBackgroundColor;

  /// Text color when selected
  final Color? selectedTextColor;

  /// Text color when not selected
  final Color? unselectedTextColor;

  /// Border radius of the box
  final double? borderRadius;

  /// Height of the box
  final double? height;

  /// Text size
  final double? textSize;

  /// Font weight of the text
  final FontWeight? fontWeight;

  /// Horizontal padding
  final double? horizontalPadding;

  /// Vertical padding
  final double? verticalPadding;

  const SelectableBox({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.borderRadius,
    this.height,
    this.textSize,
    this.fontWeight,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final selectedBgColor = selectedBackgroundColor ?? AppColors.cFF006C6A;
    final unselectedBgColor = unselectedBackgroundColor ?? AppColors.cFFF2F2F2;

    final selectedTextClr = selectedTextColor ?? AppColors.white;
    final unselectedTextClr = unselectedTextColor ?? AppColors.darkGrey;

    final radius = borderRadius ?? 8;
    final boxHeight = MediaQueryUtil.spacing(height ?? 60);
    final txtSize = MediaQueryUtil.fontSize(textSize ?? 14);
    final weight = fontWeight ?? FontWeight.w500;

    final hPadding = MediaQueryUtil.spacing(horizontalPadding ?? 8);
    final vPadding = MediaQueryUtil.spacing(verticalPadding ?? 8);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: boxHeight,
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : unselectedBgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hPadding,
            vertical: vPadding,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              text,
              style: AppTextStyles.small(
                fontWeight: isSelected
                    ? AppFontWeight.semiBold
                    : AppFontWeight.semi,
                color: isSelected ? selectedTextClr : unselectedTextClr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
