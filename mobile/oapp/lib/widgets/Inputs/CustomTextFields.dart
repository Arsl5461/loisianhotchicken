import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? suffixicon;
  final IconData? prefeixicons;
  final TextInputType keyboradtype;
  final bool obsecure;
  final String? Function(String?)? validator;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixicon,
    this.prefeixicons,
    required this.keyboradtype,
    required this.obsecure,
    this.validator,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboradtype,
      obscureText: obsecure,
      textInputAction: TextInputAction.next, // Better keyboard navigation
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.grey[600],
          fontSize: MediaQueryUtil.fontSize(16),
          fontStyle: FontStyle.italic,
        ),
        prefixIcon: prefeixicons != null
            ? Icon(prefeixicons, color: AppColors.grey[600])
            : null,
        suffixIcon: suffixicon != null
            ? Icon(suffixicon, color: AppColors.grey[600])
            : null,
        // Add background
        filled: true,
        fillColor: AppColors.grey[100],
        // Add padding
        contentPadding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(16),
        ),
        isDense: false,
        // Border styling - no borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQueryUtil.spacing(borderRadius ?? 8.0),
          ),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQueryUtil.spacing(borderRadius ?? 8.0),
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQueryUtil.spacing(borderRadius ?? 8.0),
          ),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQueryUtil.spacing(borderRadius ?? 8.0),
          ),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            MediaQueryUtil.spacing(borderRadius ?? 8.0),
          ),
          borderSide: BorderSide.none,
        ),
        // Error text styling
        errorStyle: TextStyle(
          color: AppColors.red,
          fontSize: MediaQueryUtil.fontSize(12),
        ),
      ),
    );
  }
}
