import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final String title;
  final VoidCallback onUploadPhotos;
  final VoidCallback onTakePhoto;

  const ImageSourceBottomSheet({
    super.key,
    required this.title,
    required this.onUploadPhotos,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQueryUtil.spacing(40),
            height: MediaQueryUtil.spacing(4),
            margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(20)),
            decoration: BoxDecoration(
              color: AppColors.grey[300],
              borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(2)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.medium(
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  LucideIcons.x,
                  size: MediaQueryUtil.spacing(24),
                  color: AppColors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQueryUtil.spacing(24)),
          _buildSourceOption(
            icon: LucideIcons.image,
            title: 'Upload photos',
            onTap: () {
              Get.back();
              onUploadPhotos();
            },
          ),
          _buildSourceOption(
            icon: LucideIcons.camera,
            title: 'Take photo',
            onTap: () {
              Get.back();
              onTakePhoto();
            },
          ),
          SizedBox(height: MediaQueryUtil.spacing(20)),
        ],
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(8)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQueryUtil.spacing(16),
          horizontal: MediaQueryUtil.spacing(4),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.black,
              size: MediaQueryUtil.spacing(24),
            ),
            SizedBox(width: MediaQueryUtil.spacing(16)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.small(
                  fontWeight: AppFontWeight.regular,
                  color: AppColors.black,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.grey[400],
              size: MediaQueryUtil.spacing(20),
            ),
          ],
        ),
      ),
    );
  }
}
