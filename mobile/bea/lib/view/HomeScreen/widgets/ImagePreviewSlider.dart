import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:flutter/material.dart';

class ImagePreviewSlider extends StatefulWidget {
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onImageSelected;

  /// Use when rendered over a dark gradient (e.g. image viewer modal).
  final bool onDarkBackground;

  const ImagePreviewSlider({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onImageSelected,
    this.onDarkBackground = false,
  });

  @override
  State<ImagePreviewSlider> createState() => _ImagePreviewSliderState();
}

class _ImagePreviewSliderState extends State<ImagePreviewSlider> {
  static const double _portraitAspectRatio = 4 / 3; // height = width * 1.33

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected(animate: false);
    });
  }

  @override
  void didUpdateWidget(ImagePreviewSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToSelected();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected({bool animate = true}) {
    if (!_scrollController.hasClients || widget.images.isEmpty) return;

    final metrics = _thumbnailMetrics(context);
    final targetOffset =
        (widget.selectedIndex * metrics.stride) -
        (metrics.viewportWidth - metrics.itemWidth) / 2;
    final maxOffset = _scrollController.position.maxScrollExtent;
    final clamped = targetOffset.clamp(0.0, maxOffset);

    if (animate) {
      _scrollController.animateTo(
        clamped,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(clamped);
    }
  }

  _ThumbnailMetrics _thumbnailMetrics(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = MediaQueryUtil.spacing(16);
    final itemSpacing = MediaQueryUtil.spacing(10);
    final imageCount = widget.images.length;

    final double itemWidth;
    if (imageCount <= 4) {
      final availableWidth =
          screenWidth -
          (horizontalPadding * 2) -
          (itemSpacing * (imageCount - 1));
      itemWidth = availableWidth / imageCount;
    } else {
      itemWidth = screenWidth * 0.21;
    }

    return _ThumbnailMetrics(
      itemWidth: itemWidth,
      itemHeight: itemWidth * _portraitAspectRatio,
      itemSpacing: itemSpacing,
      horizontalPadding: horizontalPadding,
      viewportWidth: screenWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    final metrics = _thumbnailMetrics(context);
    final selectedColor = widget.onDarkBackground
        ? AppColors.white
        : AppColors.cFF51B4AC;

    return SizedBox(
      height: metrics.itemHeight + MediaQueryUtil.spacing(20),
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
        itemCount: widget.images.length,
        separatorBuilder: (_, __) => SizedBox(width: metrics.itemSpacing),
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;

          return GestureDetector(
            onTap: () => widget.onImageSelected(index),
            child: AnimatedScale(
              scale: isSelected ? 1.0 : 0.94,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.72,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: metrics.itemWidth,
                  height: metrics.itemHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(10),
                    ),
                    border: Border.all(
                      color: isSelected ? selectedColor : AppColors.transparent,
                      width: isSelected ? 2.5 : 0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: selectedColor.withValues(alpha: 0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(8),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Base64OrNetworkImage(
                          imageData: widget.images[index],
                          width: metrics.itemWidth,
                          height: metrics.itemHeight,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                          fadeInDuration: const Duration(milliseconds: 180),
                        ),
                        if (widget.onDarkBackground && !isSelected)
                          Container(
                            color: AppColors.black.withValues(alpha: 0.18),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThumbnailMetrics {
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;
  final double horizontalPadding;
  final double viewportWidth;

  const _ThumbnailMetrics({
    required this.itemWidth,
    required this.itemHeight,
    required this.itemSpacing,
    required this.horizontalPadding,
    required this.viewportWidth,
  });

  double get stride => itemWidth + itemSpacing;
}
