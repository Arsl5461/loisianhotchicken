import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../controller/create_post_controller.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CreatePostScreen extends GetView<CreatePostController> {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildCameraButton(),
                      const SizedBox(height: 32),
                      const Text(
                        'Recents',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(child: _buildRecentImagesGrid()),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Create post',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: controller.showCameraOptions,
      child: Center(
        child: Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.cFFE8E8E8,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey[400]!, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  size: const Size(28, 28),
                  painter: FocusIconPainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentImagesGrid() {
    return Obx(() {
      switch (controller.galleryState.value) {
        case GalleryState.loading:
          return _buildLoadingState();

        case GalleryState.permissionDenied:
          return _buildPermissionDenied();

        case GalleryState.error:
          return _buildErrorState();

        case GalleryState.empty:
          return _buildEmptyGallery();

        case GalleryState.loaded:
          return _buildGrid();
      }
    });
  }

  /// ---------------- LOADING UI ----------------

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("Loading your gallery..."),
        ],
      ),
    );
  }

  /// ---------------- PERMISSION DENIED UI ----------------

  Widget _buildPermissionDenied() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 60, color: AppColors.grey),
          const SizedBox(height: 10),
          const Text(
            "Gallery permission denied",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text("Please allow gallery access in settings"),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () => PhotoManager.openSetting(),
            icon: const Icon(Icons.settings),
            label: const Text("Open Settings"),
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: controller.loadGalleryImages,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  /// ---------------- ERROR UI ----------------

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 60, color: AppColors.red),
          const SizedBox(height: 10),
          const Text(
            "Failed to load gallery",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: controller.loadGalleryImages,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  /// ---------------- EMPTY GALLERY ----------------

  Widget _buildEmptyGallery() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.photo_library_outlined, size: 60, color: AppColors.grey),
          SizedBox(height: 10),
          Text("No images found in your gallery"),
        ],
      ),
    );
  }

  /// ---------------- IMAGE GRID ----------------

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.6,
      ),
      itemCount: controller.galleryImages.length,
      itemBuilder: (context, index) {
        final asset = controller.galleryImages[index];

        return GestureDetector(
          onTap: () async {
            final file = await asset.file;
            if (file != null) {
              controller.navigateToPostEditor([file.path]);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AssetEntityImage(
              asset,
              fit: BoxFit.cover,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize(300, 300),
            ),
          ),
        );
      },
    );
  }
}

class FocusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.125;
    canvas.drawCircle(center, radius, paint);

    final bracketLength = size.width * 0.25;

    // Draw brackets (simplified)
    final offsets = [
      // Top-left
      [
        Offset(-bracketLength, -bracketLength),
        Offset(-bracketLength + bracketLength * 0.5, -bracketLength),
      ],
      [
        Offset(-bracketLength, -bracketLength),
        Offset(-bracketLength, -bracketLength + bracketLength * 0.5),
      ],
      // Top-right
      [
        Offset(bracketLength, -bracketLength),
        Offset(bracketLength - bracketLength * 0.5, -bracketLength),
      ],
      [
        Offset(bracketLength, -bracketLength),
        Offset(bracketLength, -bracketLength + bracketLength * 0.5),
      ],
      // Bottom-right
      [
        Offset(bracketLength, bracketLength),
        Offset(bracketLength - bracketLength * 0.5, bracketLength),
      ],
      [
        Offset(bracketLength, bracketLength),
        Offset(bracketLength, bracketLength - bracketLength * 0.5),
      ],
      // Bottom-left
      [
        Offset(-bracketLength, bracketLength),
        Offset(-bracketLength + bracketLength * 0.5, bracketLength),
      ],
      [
        Offset(-bracketLength, bracketLength),
        Offset(-bracketLength, bracketLength - bracketLength * 0.5),
      ],
    ];

    for (var pair in offsets) {
      canvas.drawLine(center + pair[0], center + pair[1], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
