import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../../../core/typography/app_text_styles.dart';

class ProfileSectionHeader extends StatelessWidget {
  final String title;
  final bool showExpansion;
  final bool isExpanded;
  final Function()? onTap;

  const ProfileSectionHeader({
    super.key,
    required this.title,
    this.showExpansion = false,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.regular(
                //   fontSize: MediaQueryUtil.fontSize(20),
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.black87,
              ),
            ),
            if (showExpansion) ...[
              InkWell(
                onTap: onTap,
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: MediaQueryUtil.fontSize(30),
                  color: AppColors.grey[600],
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: MediaQueryUtil.spacing(4)),
        Container(height: 1, color: AppColors.grey[300]),
        SizedBox(height: MediaQueryUtil.spacing(20)),
      ],
    );
  }
}
