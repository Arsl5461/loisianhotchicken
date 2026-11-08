import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';

class CommonButtons {
  static Widget commonButton({
    required String text,
    double? borderRadius,
    double? height,
    EdgeInsetsGeometry? marginButton,
    required VoidCallback onPressed,
    bool isEnabled = true,
    Color backgroundColor = AppColors.cFF006C6A,
    Color disabledColor = AppColors.grey,
    TextStyle? textStyle,
  }) {
    return Container(
      margin:
          marginButton ??
          EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(16),
            vertical: MediaQueryUtil.spacing(10),
          ),
      child: SizedBox(
        width: double.infinity,
        height: height ?? MediaQueryUtil.spacing(50),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? backgroundColor : disabledColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? MediaQueryUtil.spacing(25),
              ),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style:
                textStyle ??
                AppTextStyles.small(
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.white,
                ),
          ),
        ),
      ),
    );
  }
}
