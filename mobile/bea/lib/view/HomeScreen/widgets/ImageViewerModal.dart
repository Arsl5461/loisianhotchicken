import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'ImagePreviewSlider.dart';
import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ImageViewerModal extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageViewerModal({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ImageViewerModal> createState() => _ImageViewerModalState();
}

class _ImageViewerModalState extends State<ImageViewerModal> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onImageSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(2),
          vertical: MediaQueryUtil.spacing(50),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                /// Main Image Viewer
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            MediaQueryUtil.spacing(30),
                          ),
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 3.0,
                            child: Base64OrNetworkImage(
                              imageData: widget.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ),
                              ),
                              errorWidget: const Center(
                                child: Icon(
                                  LucideIcons.imageOff,
                                  color: AppColors.white54,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// Bottom Preview Slider
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.transparent,
                        AppColors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: ImagePreviewSlider(
                      images: widget.images,
                      selectedIndex: _currentIndex,
                      onImageSelected: _onImageSelected,
                      onDarkBackground: true,
                    ),
                  ),
                ),
              ],
            ),

            /// Back Button
            Positioned(
              top: MediaQueryUtil.spacing(16),
              left: MediaQueryUtil.spacing(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.opaque,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.iconSize(22),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: MediaQueryUtil.iconSize(44),
                      height: MediaQueryUtil.iconSize(44),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        // border: Border.all(
                        //   color: AppColors.white.withValues(alpha: 0.3),
                        //   width: 1,
                        // ),
                      ),
                      child: Icon(
                        LucideIcons.arrowLeft,
                        color: AppColors.white,
                        size: MediaQueryUtil.iconSize(20),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Three Dot Menu
            Positioned(
              top: MediaQueryUtil.spacing(16),
              right: MediaQueryUtil.spacing(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  MediaQueryUtil.iconSize(22),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MediaQueryUtil.iconSize(44),
                    height: MediaQueryUtil.iconSize(44),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: AppColors.white.withValues(alpha: 0.3),
                      //   width: 1,
                      // ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Base64OrNetworkImage(
                        svgColor: Colors.white,
                        imageData: 'assets/svg/dots_horizontal_more.svg',

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
