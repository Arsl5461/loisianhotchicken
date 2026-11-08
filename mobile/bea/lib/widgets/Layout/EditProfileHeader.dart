import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/typography/app_text_styles.dart';
import '../../utils/media_query.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditProfileHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;
  final VoidCallback? onBack;
  final bool showCloseButton;
  final Widget? trailing;

  const EditProfileHeader({
    this.trailing,
    super.key,
    required this.title,
    this.onClose,
    this.onBack,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(16),
            vertical: MediaQueryUtil.spacing(4),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // LEFT (Back)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onBack ?? () => Get.back(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
                    child: Icon(
                      LucideIcons.chevronLeft,
                      size: MediaQueryUtil.spacing(24),
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              // CENTER (Title)
              Center(
                child: Text(
                  title,
                  style: AppTextStyles.regular(
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.black,
                  ),
                ),
              ),

              // RIGHT (Close / Trailing)
              Align(
                alignment: Alignment.centerRight,
                child:
                    trailing ??
                    Visibility(
                      visible: showCloseButton,
                      child: GestureDetector(
                        onTap: onClose ?? () => Get.back(),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
                          child: Icon(
                            LucideIcons.x,
                            size: MediaQueryUtil.spacing(24),
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),

        // Divider
        Divider(height: 1, thickness: 1, color: AppColors.grey[300]),
      ],
    );
  }
}
