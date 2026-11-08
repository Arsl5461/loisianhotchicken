import 'package:flutter/material.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class BottomNavigationWithSkip extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onContinue;
  final bool isEnabled;
  final String skipText;
  final Color? enabledColor;
  final Color? disabledColor;

  const BottomNavigationWithSkip({
    super.key,
    required this.onSkip,
    required this.onContinue,
    this.isEnabled = true,
    this.skipText = 'Skip',
    this.enabledColor,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip button
        GestureDetector(
          onTap: onSkip,
          child: Text(
            skipText,
            style: AppTextStyles.small(fontWeight: AppFontWeight.semiBold),
          ),
        ),

        // Continue button with chevron
        GestureDetector(
          onTap: isEnabled ? onContinue : null,
          child: Container(
            width: MediaQueryUtil.dynamicSize(
              small: 40,
              medium: 42,
              large: 45,
              extraSmall: 38,
              extraLarge: 48,
            ),
            height: MediaQueryUtil.dynamicSize(
              small: 40,
              medium: 42,
              large: 45,
              extraSmall: 38,
              extraLarge: 48,
            ),
            decoration: BoxDecoration(
              color: isEnabled
                  ? (enabledColor ?? AppColors.greys)
                  : (disabledColor ?? AppColors.grey[300]),
              borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
            ),
            child: Icon(
              Icons.chevron_right,
              color: AppColors.white,
              size: MediaQueryUtil.iconSize(30),
            ),
          ),
        ),
      ],
    );
  }
}
