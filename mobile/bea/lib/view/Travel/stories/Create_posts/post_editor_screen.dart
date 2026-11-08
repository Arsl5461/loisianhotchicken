import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../widget_helper/widget_helpers.dart';
import '../../controller/create_post_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PostEditorScreen extends GetView<CreatePostController> {
  const PostEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image section with rounded corners
            Expanded(
              child: Obx(() {
                if (controller.selectedImages.isEmpty) {
                  return const Center(child: Text('No image selected'));
                }

                final currentPath =
                    controller.selectedImages[controller.currentIndex.value];

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                        vertical: 5,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.expand(
                          child: Image.file(
                            File(currentPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 5,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: controller.captionController,
                          onChanged: (val) {
                            controller.captionController.text = val;
                            controller
                                .captionController
                                .selection = TextSelection.fromPosition(
                              TextPosition(
                                offset:
                                    controller.captionController.text.length,
                              ),
                            );
                          },
                          style: AppTextStyles.regular(
                            color: Colors.white,
                            fontWeight: AppFontWeight.semiBold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add caption',
                            hintStyle: AppTextStyles.regular(
                              color: Colors.white,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false, // ensures no background
                            isDense: true,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            _buildThumbnails(),
            // Very small gap

            // Bottom action bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnails() {
    return Obx(() {
      if (controller.selectedImages.isEmpty) {
        return SizedBox(
          height: 78,
          child: Row(
            children: [
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.addMoreImages,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.cFFE6E6E6,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.add, size: 28),
                ),
              ),
            ],
          ),
        );
      }

      final totalItems = controller.selectedImages.length + 1;

      return SizedBox(
        height: 66,
        child: ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          itemCount: totalItems,
          proxyDecorator: (child, index, animation) {
            return Material(
              color: Colors.transparent,
              child: Transform.scale(scale: 1.05, child: child),
            );
          },
          onReorder: (oldIndex, newIndex) {
            final imagesCount = controller.selectedImages.length;

            // Prevent dragging/reordering the add button
            if (oldIndex >= imagesCount || newIndex > imagesCount) return;

            controller.reorderImages(oldIndex, newIndex);
          },
          itemBuilder: (context, index) {
            final isAddButton = index == controller.selectedImages.length;

            if (isAddButton) {
              return Container(
                key: const ValueKey('add_more_images'),

                child: Align(
                  alignment: Alignment.topCenter,
                  // 👈 important
                  child: GestureDetector(
                    onTap: controller.addMoreImages,
                    child: Container(
                      width: 60,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.cFFE6E6E6,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.add, size: 28),
                    ),
                  ),
                ),
              );
            }

            final path = controller.selectedImages[index];
            final isSelected = controller.currentIndex.value == index;

            return ReorderableDelayedDragStartListener(
              key: ValueKey(path),
              index: index,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => controller.setCurrentIndex(index),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.cFF35BCB8
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.file(File(path), fit: BoxFit.cover),
                      ),
                    ),

                    // Positioned(
                    //   top: 2,
                    //   left: 2,
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       // Example:
                    //       // final editedPath = await Get.toNamed(
                    //       //   Routes.IMAGE_EDITOR,
                    //       //   arguments: {'imagePath': path},
                    //       // );
                    //       // if (editedPath != null && editedPath is String) {
                    //       //   controller.replaceEditedImage(index, editedPath);
                    //       //   controller.setCurrentIndex(index);
                    //       // }

                    //       controller.setCurrentIndex(index);
                    //     },
                    //     child: Container(
                    //       padding: const EdgeInsets.all(4),
                    //       decoration: BoxDecoration(
                    //         color: Colors.black.withValues( alpha:0.6),
                    //         shape: BoxShape.circle,
                    //       ),
                    //       child: const Icon(
                    //         Icons.edit,
                    //         size: 14,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => controller.removeImageAt(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        children: [
          Obx(() {
            if (controller.uploadedSongUrl.value.isEmpty) {
              return const SizedBox();
            }

            return WidgetHelpers.musicPreviewWidget(
              songUrl: controller.uploadedSongUrl.value,
              songFileName: controller.songFileName,
              audioStatus: controller.audioStatus.value,
              onToggle: controller.toggleState,
              onRemove: controller.removeMusic,
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              //  Container(width: 250, child: _buildCaptionInput()),
              Obx(
                () => _buildActionButton(
                  icon: Icons.location_on_outlined,
                  color: controller.isLocLoaded.value
                      ? AppColors.cFF006A68
                      : null,
                  iconColor: controller.isLocLoaded.value
                      ? AppColors.white
                      : null,
                  onTap: () {
                    controller.requestPermissionAndSetLocation();

                    // Handle location
                  },
                ),
              ),

              // Text button

              // Music button
              Obx(
                () => _buildActionButton(
                  color: controller.uploadedSongUrl.value.isNotEmpty
                      ? AppColors.cFF006A68
                      : null,
                  iconColor: controller.uploadedSongUrl.value.isNotEmpty
                      ? AppColors.white
                      : null,
                  icon: controller.isSongUploading.value
                      ? Icons.pending_sharp
                      : Icons.music_note_outlined,
                  onTap: () {
                    controller.addMusic();
                  },
                ),
              ),

              // Filter button
              _buildActionButton(
                icon: Icons.edit,
                onTap: controller.openSelectedImageEditor,
              ),

              // const SizedBox(width: 8),

              // Share buttoncreate
              GestureDetector(
                onTap: () => controller.sharePost(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cFF35BCB8,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color ?? AppColors.cFFE6E6E6,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: iconColor ?? AppColors.black87),
      ),
    );
  }
}
