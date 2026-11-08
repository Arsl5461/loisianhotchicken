import 'package:OApp/widgets/custom_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'dart:ui';

import 'package:OApp/core/constants/app_colors.dart';

class SwipeFeedbackIcon extends StatelessWidget {
  final bool
  isLike; // true for thumbs up (like), false for thumbs down (dislike)
  final double opacity;

  const SwipeFeedbackIcon({
    super.key,
    required this.isLike,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Opacity(
      opacity: opacity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          MediaQueryUtil.dynamicSize(small: 63, medium: 71, large: 82),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQueryUtil.dynamicSize(
              small: 85,
              medium: 95,
              large: 110,
            ),
            height: MediaQueryUtil.dynamicSize(
              small: 85,
              medium: 95,
              large: 110,
            ),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: isLike
                  ? CustomSvgIcons.thumbsUp(
                      color: AppColors.cFF51B4AC,
                      size: MediaQueryUtil.iconSize(35),
                    )
                  : CustomSvgIcons.thumbsDown(
                      color: AppColors.red,
                      size: MediaQueryUtil.iconSize(35),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
