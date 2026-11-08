import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;
  final double? borderWidth;
  final int? maxLength;
  final bool enabled;
  final Color? focusColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const CustomTextField({
    super.key,
    this.borderWidth,
    required this.controller,
    required this.hintText,
    this.isRequired = false,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusColor,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    // For multi-line text fields, don't use fixed height
    final bool isMultiLine = (widget.maxLines ?? 1) > 1;

    return Container(
      width: double.infinity,
      height: isMultiLine
          ? null
          : MediaQueryUtil.dynamicSize(
              small: 60,
              medium: 65,
              large: 70,
              extraSmall: 58,
              extraLarge: 75,
            ),
      constraints: isMultiLine
          ? BoxConstraints(
              minHeight: MediaQueryUtil.dynamicSize(
                small: 60,
                medium: 65,
                large: 70,
                extraSmall: 58,
                extraLarge: 75,
              ),
            )
          : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? MediaQueryUtil.spacing(12),
        ),
        border: Border.all(
          color: _isFocused
              ? (widget.focusColor ?? AppColors.cFF006C6A)
              : (widget.borderColor ?? AppColors.grey[300]!),
          width: widget.borderWidth ?? (_isFocused ? 2 : 1),
        ),
      ),
      alignment: isMultiLine ? Alignment.topLeft : Alignment.center,
      child: TextField(
        controller: widget.controller,
        onTap: () {
          setState(() {
            _isFocused = true;
          });
          widget.onTap?.call();
        },
        onSubmitted: (value) {
          setState(() {
            _isFocused = false;
          });
          widget.onSubmitted?.call(value);
        },
        onChanged: widget.onChanged,
        textAlignVertical: isMultiLine
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle:
              widget.hintStyle ??
              TextStyle(
                fontSize: MediaQueryUtil.fontSize(16),
                color: AppColors.grey[400],
              ),
          border: InputBorder.none,
          isDense: true,
          contentPadding:
              widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(16),
                vertical: MediaQueryUtil.spacing(2),
              ),
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          counterText: widget.maxLength != null ? null : '',
        ),
        style:
            widget.textStyle ??
            TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              color: AppColors.black,
            ),
      ),
    );
  }
}
