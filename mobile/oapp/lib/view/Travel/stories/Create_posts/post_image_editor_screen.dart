import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../controller/create_post_controller.dart';

class PostImageEditorScreen extends StatefulWidget {
  const PostImageEditorScreen({super.key});

  @override
  State<PostImageEditorScreen> createState() => _PostImageEditorScreenState();
}

class _PostImageEditorScreenState extends State<PostImageEditorScreen> {
  final CreatePostController controller = Get.find<CreatePostController>();

  @override
  void initState() {
    super.initState();
    _configureEditorTheme();
    controller.showEditOptions.value = true;
  }

  @override
  void dispose() {
    controller.showEditOptions.value = false;
    super.dispose();
  }

  void _configureEditorTheme() {
    ImageEditor.theme = ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.white,
        secondary: AppColors.white,
      ),
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.cFF35BCB8,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.white)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white,
      ),
    );
  }

  Future<Widget> _buildImageWithFilter(String path) async {
    final Uint8List data = await File(path).readAsBytes();

    return Obx(
      () => ImageEditor(
        image: data,
        showEditOptions: controller.showEditOptions.value,
        showTextEditor: false,
        onImageGenerated: (editedData) async {
          await controller.saveEditedImageAndReplace(
            editedData,
            index: controller.currentIndex.value,
          );

          controller.showEditOptions.value = false;

          if (mounted) {
            Get.back();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        controller.showEditOptions.value = false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Obx(() {
            if (controller.selectedImages.isEmpty) {
              return const Center(child: Text('No image selected'));
            }

            final String path =
                controller.selectedImages[controller.currentIndex.value];

            return FutureBuilder<Widget>(
              key: ValueKey(path),
              future: _buildImageWithFilter(path),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('Unable to load image editor'),
                  );
                }

                return snapshot.data!;
              },
            );
          }),
        ),
      ),
    );
  }
}
