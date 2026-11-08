import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../../../widgets/Images/base64OrNetworkImage.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onActionTap;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PageView for carousel
        PageView.builder(
          onPageChanged: onPageChanged,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Base64OrNetworkImage(
                imageData: images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        ),
        // Profile picture with name on top left side
        Positioned(
          top: MediaQueryUtil.spacing(
            24,
          ), // Increased from 16 to 24 to match dots
          left: MediaQueryUtil.spacing(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile picture
              Container(
                width: MediaQueryUtil.spacing(40),
                height: MediaQueryUtil.spacing(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1527736947477-2790e28f3443?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=762',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(8)),

              // User name
              Text(
                'Kendall Jenner',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: AppColors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Three dots on top right of picture with optimized touch area
        Positioned(
          top: MediaQueryUtil.spacing(24),
          right: MediaQueryUtil.spacing(16),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {
                debugPrint('Three dots tapped!'); // Debug print
                onActionTap();
              },
              borderRadius: BorderRadius.circular(20), // Rounded touch area
              splashColor: AppColors.white.withValues(
                alpha: 0.2,
              ), // Visual feedback
              highlightColor: AppColors.white.withValues(
                alpha: 0.1,
              ), // Visual feedback
              child: Container(
                // Optimized touch area - smaller but still responsive
                padding: EdgeInsets.all(
                  MediaQueryUtil.spacing(8),
                ), // Reduced from 12 to 8
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: MediaQueryUtil.spacing(3)),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: MediaQueryUtil.spacing(3)),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Carousel dots at bottom center
        Positioned(
          bottom: MediaQueryUtil.spacing(20),
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(2),
                ),
                width: currentIndex == index ? 8 : 6,
                height: currentIndex == index ? 8 : 6,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.white
                      : AppColors.white.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
