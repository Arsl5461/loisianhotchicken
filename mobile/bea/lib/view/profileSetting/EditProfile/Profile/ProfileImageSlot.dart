import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ProfileImageSlot extends StatelessWidget {
  final bool isMainPhoto;
  final bool hasImage;
  final bool isDefaultImage;
  final String? defaultImageUrl;
  final File? selectedImage;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final double? borderRadius;

  const ProfileImageSlot({
    super.key,
    this.borderRadius,
    required this.isMainPhoto,
    required this.hasImage,
    required this.isDefaultImage,
    this.defaultImageUrl,
    this.selectedImage,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isMainPhoto
            ? MediaQueryUtil.dynamicSize(
                small: 364,
                medium: 420,
                large: 496,
                extraSmall: 338,
                extraLarge: 455,
              )
            : MediaQueryUtil.dynamicSize(
                small: 110,
                medium: 140,
                large: 130,
                extraSmall: 100,
                extraLarge: 140,
              ),
        width: isMainPhoto ? double.infinity : null,
        margin: EdgeInsets.all(MediaQueryUtil.spacing(2)),

        decoration: BoxDecoration(
          color: hasImage ? AppColors.transparent : AppColors.white,
          borderRadius: BorderRadius.circular(
            borderRadius ?? MediaQueryUtil.spacing(12),
          ),
          border: isMainPhoto
              ? null
              : Border.all(
                  color: AppColors.grey[300] ?? AppColors.grey,
                  width: 1.35,
                ),
        ),
        child: hasImage
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        borderRadius ?? MediaQueryUtil.spacing(12),
                      ),
                      child: _buildImageWidget(),
                    ),
                  ),
                  if (isMainPhoto)
                    Positioned(
                      top: MediaQueryUtil.spacing(16),
                      left: MediaQueryUtil.spacing(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(15),
                          vertical: MediaQueryUtil.spacing(6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey[700]!.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(
                            MediaQueryUtil.spacing(8),
                          ),
                        ),
                        child: Text(
                          'Main',
                          style: AppTextStyles.verySmall(
                            color: AppColors.white,
                            fontWeight: AppFontWeight.semi,
                          ),
                        ),
                      ),
                    ),
                  if (!isMainPhoto)
                    Positioned(
                      top: -10,
                      right: -10,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            MediaQueryUtil.spacing(12),
                          ),
                          child: Container(
                            width: MediaQueryUtil.spacing(24),
                            height: MediaQueryUtil.spacing(24),
                            decoration: BoxDecoration(
                              // color: AppColors.white,
                              color: AppColors.white.withValues(alpha: 0.80),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: AppColors.black,
                              size: MediaQueryUtil.fontSize(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isMainPhoto) ...[
                    Icon(
                      Icons.add_a_photo,
                      size: MediaQueryUtil.fontSize(48),
                      color: AppColors.grey[400],
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(16)),
                    Text(
                      'Add your best photo here',
                      style: AppTextStyles.medium(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.grey[700],
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(8)),
                    Text(
                      'Tap to add photo',
                      style: AppTextStyles.small(color: AppColors.grey[500]),
                    ),
                  ] else
                    Base64OrNetworkImage(
                      imageData: 'assets/svg/plus.svg',
                      width: MediaQueryUtil.spacing(14),
                      height: MediaQueryUtil.spacing(14),
                    ),

                  // Icon(
                  //   Icons.add,
                  //   size: MediaQueryUtil.fontSize(32),
                  //   color: AppColors.grey[400],
                  // ),
                ],
              ),
      ),
    );
  }

  Widget _buildImageWidget() {
    // Local picked image
    if (selectedImage != null) {
      return Image.file(selectedImage!, fit: BoxFit.cover);
    }

    // Network or base64 image
    if (defaultImageUrl != null && defaultImageUrl!.isNotEmpty) {
      return Base64OrNetworkImage(
        imageData: defaultImageUrl!,
        fit: BoxFit.cover,
      );
    }

    return Container();
  }
}
