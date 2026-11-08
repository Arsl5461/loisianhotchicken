import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ProfileItem extends StatelessWidget {
  final String label;
  final String answer;
  final String privacy;
  final VoidCallback onTap;

  const ProfileItem({
    super.key,
    required this.label,
    required this.answer,
    required this.privacy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(16)),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      answer,
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.semiBold,
                        color: AppColors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                privacy,
                style: AppTextStyles.small(
                  color: AppColors.grey[600],
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(8)),
              Icon(
                LucideIcons.chevronRight,
                size: MediaQueryUtil.spacing(16),
                color: AppColors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
