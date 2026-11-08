import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;
  final String text;
  final Color? checkedColor;
  final Color? uncheckedColor;
  final Color? textColor;
  final double? textSize;
  final FontWeight? fontWeight;
  final double? spacing;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onTap,
    required this.text,
    this.checkedColor,
    this.uncheckedColor,
    this.textColor,
    this.textSize,
    this.fontWeight,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Container(
            width: MediaQueryUtil.spacing(20),
            height: MediaQueryUtil.spacing(20),
            decoration: BoxDecoration(
              color: isChecked
                  ? (checkedColor ?? AppColors.cFF1E88E5)
                  : AppColors.transparent,
              borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(4)),
              border: Border.all(
                color: isChecked
                    ? (checkedColor ?? AppColors.cFF1E88E5)
                    : (uncheckedColor ?? AppColors.grey[400]!),
                width: MediaQueryUtil.spacing(2),
              ),
            ),
            child: isChecked
                ? Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: MediaQueryUtil.iconSize(14),
                  )
                : null,
          ),
        ),
        SizedBox(width: MediaQueryUtil.spacing(spacing ?? 12)),
        Text(
          text,
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(textSize ?? 16),
            fontWeight: fontWeight ?? FontWeight.w400,
            color: textColor ?? AppColors.black87,
          ),
        ),
      ],
    );
  }
}
