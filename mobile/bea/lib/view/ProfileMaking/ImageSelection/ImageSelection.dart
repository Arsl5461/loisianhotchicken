import 'package:OApp/view/ProfileMaking/profile_making_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:io';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Images/Base64OrNetworkImage.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../../widgets/Buttons/customContinueButton.dart';
import '../../../widgets/Progress/ProgressTracker.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PhotoSelectionScreen extends GetView<ProfileController> {
  const PhotoSelectionScreen({super.key});

  Future<void> _showImageSourceDialog(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQueryUtil.spacing(20)),
        ),
      ),
      builder: (BuildContext context) {
        final currentItem = controller.selectedImages[index];

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
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(2),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add photos',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(22),
                      fontWeight: FontWeight.bold,
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
                  _pickImage(ImageSource.gallery, index);
                },
              ),

              _buildSourceOption(
                icon: LucideIcons.camera,
                title: 'Take photo',
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.camera, index);
                },
              ),

              if (currentItem != null) ...[
                SizedBox(height: MediaQueryUtil.spacing(6)),
                _buildSourceOption(
                  icon: LucideIcons.trash2,
                  title: 'Remove photo',
                  onTap: () async {
                    Get.back();
                    await controller.removeImageAt(index);
                  },
                ),
              ],

              SizedBox(height: MediaQueryUtil.spacing(20)),
            ],
          ),
        );
      },
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
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(18),
                  fontWeight: FontWeight.w400,
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

  Future<void> _pickImage(ImageSource source, int index) async {
    try {
      final XFile? pickedFile = await controller.picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        controller.setImageAt(index, File(pickedFile.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error picking image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildPhotoSlot(int index) {
    final item = controller.selectedImages[index];
    final bool hasImage = item != null;

    return GestureDetector(
      onTap: () => _showImageSourceDialog(Get.context!, index),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
          border: Border.all(color: AppColors.grey, width: 2),
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(12),
                    ),
                    child: _buildPhotoWidget(item),
                  ),
                  Positioned(
                    top: MediaQueryUtil.spacing(8),
                    right: MediaQueryUtil.spacing(8),
                    child: Container(
                      padding: EdgeInsets.all(MediaQueryUtil.spacing(4)),
                      decoration: BoxDecoration(
                        color: AppColors.black54,
                        borderRadius: BorderRadius.circular(
                          MediaQueryUtil.spacing(20),
                        ),
                      ),
                      child: Icon(
                        LucideIcons.edit,
                        color: AppColors.white,
                        size: MediaQueryUtil.spacing(12),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Icon(
                  LucideIcons.plus,
                  size: MediaQueryUtil.spacing(24),
                  color: AppColors.black,
                ),
              ),
      ),
    );
  }

  Widget _buildPhotoWidget(dynamic item) {
    if (item is File) {
      return Image.file(item, fit: BoxFit.cover);
    }

    if (item is String) {
      return Base64OrNetworkImage(
        imageData: item,
        fit: BoxFit.cover,
        placeholder: Container(
          color: AppColors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Container(color: AppColors.grey[200]);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Obx(() {
      final int totalPhotos = controller.selectedImages
          .where((image) => image != null)
          .length;
      final bool hasMinimumPhotos = totalPhotos >= 4;

      return Scaffold(
        backgroundColor: AppColors.cFFF8F8F8,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(20),
              vertical: MediaQueryUtil.spacing(16),
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQueryUtil.spacing(16)),

                ProgressTracker(progress: 15 / 16),

                SizedBox(height: MediaQueryUtil.spacing(24)),

                Text(
                  "Choose Photos",
                  style: AppTextStyles.large(
                    fontFamily: AppFontFamily.playfair,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: MediaQueryUtil.spacing(16)),

                Text(
                  "No catfishing. Add at least 4 photos to enter the dating pool. You can change these whenever.",
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: MediaQueryUtil.spacing(60)),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: MediaQueryUtil.spacing(18),
                    mainAxisSpacing: MediaQueryUtil.spacing(18),
                    children: List.generate(6, (index) {
                      return _buildPhotoSlot(index);
                    }),
                  ),
                ),

                SizedBox(height: MediaQueryUtil.spacing(24)),

                Center(
                  child: GoBackLink(
                    onTap: () {
                      Get.toNamed(Routes.POLITICS);
                    },
                  ),
                ),

                SizedBox(height: MediaQueryUtil.spacing(16)),

                controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomContinueButton(
                        loader: controller.isLoading.value,
                        onPressed: hasMinimumPhotos
                            ? () async {
                                controller.addUserByIndex(index: 4);
                              }
                            : null,
                        isEnabled: hasMinimumPhotos,
                        backgroundColor: AppColors.cFF4E535A,
                      ),

                SizedBox(height: MediaQueryUtil.spacing(30)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
