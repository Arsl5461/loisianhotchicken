import 'package:flutter/material.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class GoBackLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const GoBackLink({
    super.key,
    this.text = 'Go back',
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style:
            textStyle ??
            AppTextStyles.small(fontWeight: AppFontWeight.semiBold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
