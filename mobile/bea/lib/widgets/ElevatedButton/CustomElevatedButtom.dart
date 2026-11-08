import 'package:flutter/material.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double? textSize;
  final double? elevation;
  final FontWeight? fontWeight;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.cFF01696A,
    this.textColor = AppColors.white,
    this.borderRadius = 8.0,
    this.textSize,
    this.elevation,
    this.fontWeight,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.grey.shade400 : backgroundColor,
        foregroundColor: isDisabled ? AppColors.grey.shade700 : textColor,
        minimumSize: Size(double.infinity, MediaQueryUtil.spacing(50)),
        elevation: elevation ?? 0.0,
        shadowColor: elevation != null
            ? AppColors.black.withValues(alpha: 0.2)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            MediaQueryUtil.spacing(borderRadius),
          ),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.small(
          fontWeight: AppFontWeight.semi,
          // fontSize: textSize != null
          //     ? MediaQueryUtil.fontSize(textSize!)
          //     : MediaQueryUtil.fontSize(20),
        ),
      ),
    );
  }
}
