import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileAccountItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileAccountItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
          splashColor: AppColors.grey.withValues(alpha: 0.1),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: MediaQueryUtil.spacing(4),
              horizontal: MediaQueryUtil.spacing(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQueryUtil.spacing(5),
                  ),
                  child: icon,
                ),
                SizedBox(width: MediaQueryUtil.spacing(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTextStyles.regular(
                                fontWeight: AppFontWeight.semi,
                              ),
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            size: MediaQueryUtil.spacing(20),
                            color: AppColors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(2)),
                      Text(
                        subtitle,
                        style: AppTextStyles.verySmall(
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
