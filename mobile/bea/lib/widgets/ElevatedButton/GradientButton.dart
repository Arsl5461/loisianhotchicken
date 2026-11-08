import 'package:flutter/material.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? textSize;
  final double? width;
  final double? height;
  final double? elevation;
  final EdgeInsets? padding;
  final bool isLoading;
  final Widget? child;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.textSize,
    this.width,
    this.height,
    this.elevation,
    this.padding,
    this.isLoading = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);
    final defaultBackgroundColor = backgroundColor ?? AppColors.cFF006C6A;
    final defaultTextColor = textColor ?? AppColors.white;
    final defaultBorderRadius = borderRadius ?? 12.0;
    final defaultTextSize = textSize ?? 16.0;
    final defaultWidth = width ?? double.infinity;
    final defaultHeight = height ?? MediaQueryUtil.spacing(50);

    return SizedBox(
      width: defaultWidth,
      height: defaultHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBackgroundColor,
          foregroundColor: defaultTextColor,
          elevation: elevation ?? 0.0,
          shadowColor: elevation != null
              ? AppColors.black.withValues(alpha: 0.2)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQueryUtil.spacing(defaultBorderRadius),
            ),
          ),
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(20),
                vertical: MediaQueryUtil.spacing(12),
              ),
        ),
        child: isLoading
            ? SizedBox(
                width: MediaQueryUtil.spacing(20),
                height: MediaQueryUtil.spacing(20),
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                ),
              )
            : child ??
                  Text(
                    text,
                    style: AppTextStyles.regular(
                      // fontSize: MediaQueryUtil.fontSize(defaultTextSize),
                      fontWeight: AppFontWeight.semiBold,
                      color: defaultTextColor,
                    ),
                  ),
      ),
    );
  }
}
