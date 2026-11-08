import 'package:flutter/cupertino.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class DisplayToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final TextStyle? labelStyle;

  const DisplayToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              AppTextStyles.regular(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.darkGrey,
              ),
        ),
        CupertinoSwitch(
          value: value,
          onChanged: (bool newValue) {
            onChanged(newValue);
          },
          activeTrackColor: activeColor ?? AppColors.cFF006C6A,
          inactiveTrackColor: inactiveColor ?? AppColors.cFFE5E5E5,
        ),
      ],
    );
  }
}
