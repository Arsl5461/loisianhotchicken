import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

class TravelStoryPickerScreen extends StatefulWidget {
  const TravelStoryPickerScreen({super.key});

  @override
  State<TravelStoryPickerScreen> createState() =>
      _TravelStoryPickerScreenState();
}

class _TravelStoryPickerScreenState extends State<TravelStoryPickerScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];
  int _mainIndex = 0; // index into _photos

  bool get _hasMain => _photos.isNotEmpty;
  XFile? get _mainPhoto => _hasMain ? _photos[_mainIndex] : null;

  Future<void> _pickFrom(ImageSource source) async {
    if (_photos.length >= 5) return;
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );
      if (file == null) return;
      setState(() {
        _photos.add(file);
        if (_photos.length == 1) _mainIndex = 0;
      });
    } catch (_) {}
  }

  void _showPickSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickAction(Icons.photo_camera, 'Camera', () {
                  Get.back();
                  _pickFrom(ImageSource.camera);
                }),
                _buildPickAction(Icons.photo, 'Gallery', () {
                  Get.back();
                  _pickFrom(ImageSource.gallery);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickAction(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: MediaQueryUtil.spacing(80),
            height: MediaQueryUtil.spacing(80),
            decoration: BoxDecoration(
              color: AppColors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: MediaQueryUtil.iconSize(28),
              color: AppColors.black87,
            ),
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(8)),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.cFFF1DFD5,
            AppColors.cFFEADFDB,
            AppColors.cFFDDE4EC,
            AppColors.cFFDDE4EC,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.black87),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Create post',
            style: TextStyle(
              color: AppColors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _showPickSheet,
              icon: const Icon(
                Icons.center_focus_weak,
                color: AppColors.black87,
              ),
              tooltip: 'Pick',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Main photo preview area
              AspectRatio(
                aspectRatio: 9 / 12,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(12),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _mainPhoto == null
                      ? _buildEmptyMain()
                      : Image.file(File(_mainPhoto!.path), fit: BoxFit.cover),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Previews row (up to 4)
              SizedBox(
                height: MediaQueryUtil.dynamicSize(
                  small: 86,
                  medium: 96,
                  large: 110,
                ),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(12),
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length.clamp(0, 5),
                  separatorBuilder: (_, __) =>
                      SizedBox(width: MediaQueryUtil.spacing(10)),
                  itemBuilder: (context, index) {
                    return _buildThumb(index);
                  },
                ),
              ),

              // Add button and count
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                  vertical: MediaQueryUtil.spacing(12),
                ),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _photos.length >= 5 ? null : _showPickSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cFF2FB9B6,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_a_photo),
                      label: Text('Add photo (${_photos.length}/5)'),
                    ),
                    const Spacer(),
                    Text(
                      _hasMain
                          ? 'Tap a thumbnail to set as main'
                          : 'Add a main photo',
                      style: const TextStyle(color: AppColors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMain() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQueryUtil.spacing(80),
            height: MediaQueryUtil.spacing(80),
            decoration: BoxDecoration(
              color: AppColors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt,
              size: MediaQueryUtil.iconSize(32),
              color: AppColors.black54,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(10)),
          const Text(
            'Tap the icon above to add photos',
            style: TextStyle(color: AppColors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildThumb(int index) {
    final XFile file = _photos[index];
    final bool isMain = index == _mainIndex;
    return GestureDetector(
      onTap: () => setState(() => _mainIndex = index),
      child: Stack(
        children: [
          Container(
            width: MediaQueryUtil.spacing(86),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.file(File(file.path), fit: BoxFit.cover),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: () => setState(() {
                final removed = _photos.removeAt(index);
                if (_photos.isEmpty) {
                  _mainIndex = 0;
                } else if (index == _mainIndex) {
                  _mainIndex = 0;
                } else if (index < _mainIndex) {
                  _mainIndex -= 1;
                }
                removed;
              }),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.black87,
                ),
              ),
            ),
          ),
          if (isMain)
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Main',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
