import 'package:flutter/material.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomContinueButton extends StatelessWidget {
  final String text;
  final bool? loader;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final TextStyle? textStyle;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomContinueButton({
    super.key,
    this.text = 'Continue',
    this.onPressed,
    this.loader,
    this.isEnabled = true,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.textStyle,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return SizedBox(
      width: double.infinity,
      height: MediaQueryUtil.dynamicSize(
        small: 50,
        medium: 55,
        large: 60,
        extraSmall: 48,
        extraLarge: 65,
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? (backgroundColor ?? AppColors.cFF4E535A)
              : (disabledBackgroundColor ?? AppColors.grey[300]),
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? MediaQueryUtil.spacing(12),
            ),
          ),
          elevation: 0,
          padding: padding,
        ),
        child: loader == true
            ? CircularProgressIndicator()
            : Text(
                text,
                style:
                    textStyle ??
                    AppTextStyles.small(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.white,
                    ),
              ),
      ),
    );
  }
}
