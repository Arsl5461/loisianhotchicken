import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class GradientTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final List<Color>? gradientColors;
  final double? gradientOpacity;

  const GradientTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.gradientColors,
    this.gradientOpacity,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    // Default gradient colors (same as signup screen)
    final defaultGradientColors =
        gradientColors ??
        [
          AppColors.cFFF1DFD5.withValues(alpha: gradientOpacity ?? 0.3),
          AppColors.cFFEADFDB.withValues(alpha: gradientOpacity ?? 0.3),
          AppColors.cFFDDE4EC.withValues(alpha: gradientOpacity ?? 0.3),
        ];

    // Default border color (same as signup screen)
    final defaultBorderColor = borderColor ?? AppColors.cFFD3D3D5;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: defaultGradientColors,
        ),
        borderRadius: BorderRadius.circular(
          MediaQueryUtil.spacing(borderRadius ?? 12),
        ),
        border: Border.all(
          color: defaultBorderColor,
          width: MediaQueryUtil.spacing(borderWidth ?? 2),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        readOnly: readOnly,
        style:
            textStyle ??
            TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              color: AppColors.black87,
              fontWeight: FontWeight.w400,
            ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              hintStyle ??
              TextStyle(
                fontSize: MediaQueryUtil.fontSize(16),
                color: AppColors.grey[400],
                fontWeight: FontWeight.w400,
              ),
          contentPadding:
              contentPadding ??
              EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(20),
                vertical: MediaQueryUtil.spacing(12),
              ),
          border: InputBorder.none,
          filled: true,
          fillColor: fillColor ?? AppColors.transparent,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
