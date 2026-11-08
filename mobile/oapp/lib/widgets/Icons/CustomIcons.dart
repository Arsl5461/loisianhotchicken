import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomIcon({
    super.key,
    required this.icon,
    this.color,
    this.size,
    this.width,
    this.height,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    Widget iconWidget = Icon(
      icon,
      color: color ?? AppColors.grey[600],
      size: size ?? MediaQueryUtil.iconSize(24),
    );

    // If width and height are specified, wrap in SizedBox
    if (width != null || height != null) {
      iconWidget = SizedBox(width: width, height: height, child: iconWidget);
    }

    // If padding is specified, wrap in Padding
    if (padding != null) {
      iconWidget = Padding(padding: padding!, child: iconWidget);
    }

    // If margin is specified, wrap in Container
    if (margin != null) {
      iconWidget = Container(margin: margin!, child: iconWidget);
    }

    // If onTap is specified, wrap in GestureDetector
    if (onTap != null) {
      iconWidget = GestureDetector(onTap: onTap, child: iconWidget);
    }

    return iconWidget;
  }
}

// Predefined icon styles for common use cases
class IconStyles {
  static const Color primary = AppColors.cFF1A1A1A;
  static const Color secondary = AppColors.cFF6B7280;
  static const Color accent = AppColors.cFF196585;
  static const Color success = AppColors.cFF10B981;
  static const Color warning = AppColors.cFFF59E0B;
  static const Color error = AppColors.cFFEF4444;
  static const Color white = AppColors.white;
  static const Color grey = AppColors.cFF9CA3AF;
}

// Common icon sizes
class IconSizes {
  static double get small => MediaQueryUtil.iconSize(16);
  static double get medium => MediaQueryUtil.iconSize(24);
  static double get large => MediaQueryUtil.iconSize(32);
  static double get extraLarge => MediaQueryUtil.iconSize(48);
}

// Common icon dimensions
class IconDimensions {
  static double get small => MediaQueryUtil.spacing(24);
  static double get medium => MediaQueryUtil.spacing(32);
  static double get large => MediaQueryUtil.spacing(48);
  static double get extraLarge => MediaQueryUtil.spacing(64);
}
