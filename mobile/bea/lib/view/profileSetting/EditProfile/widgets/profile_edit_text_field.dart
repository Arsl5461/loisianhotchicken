import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../widgets/Input/CustomTextField.dart';

class ProfileEditTextField extends StatelessWidget {
  const ProfileEditTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.keyboardType,
    this.focusColor,
    this.borderColor,
    this.hintStyle,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding,
    this.textStyle,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final Color? focusColor;
  final Color? borderColor;
  final TextStyle? hintStyle;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      onSubmitted: onSubmitted,
      hintText: hintText,
      keyboardType: keyboardType,
      focusColor: focusColor,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      contentPadding: contentPadding,

      borderRadius: 18.0,
      borderWidth: 1.4,
      borderColor: borderColor ?? AppColors.grey[400]!,
      hintStyle:
          hintStyle ??
          AppTextStyles.regular(
            fontWeight: AppFontWeight.semi,
            color: AppColors.grey[700],
          ),

      textStyle:
          textStyle ?? AppTextStyles.regular(fontWeight: AppFontWeight.semi),
    );
  }
}
