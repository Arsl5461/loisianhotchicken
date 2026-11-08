import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? height;
  final TextAlign? textAlign;
  final EdgeInsets? padding;

  const PageTitle({
    super.key,
    required this.title,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.textAlign,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        title,
        style: TextStyle(
          fontSize: MediaQueryUtil.fontSize(fontSize ?? 28),
          fontWeight: fontWeight ?? FontWeight.w600,
          color: textColor ?? AppColors.black87,
          height: height ?? 1.2,
        ),
        textAlign: textAlign ?? TextAlign.center,
      ),
    );
  }
}
