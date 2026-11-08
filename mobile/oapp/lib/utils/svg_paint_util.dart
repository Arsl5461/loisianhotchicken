import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:OApp/core/constants/app_colors.dart';

/// Utility class for painting and rendering SVG icons from assets using flutter_svg package
class SvgPaintUtil {
  /// Paints an SVG icon from assets with custom color and size
  ///
  /// [assetPath] - Path to the SVG file in assets (e.g., 'assets/icons/home.svg')
  /// [color] - Color to apply to the SVG icon (uses BlendMode.srcIn to tint)
  /// [size] - Size of the icon (width and height)
  /// [width] - Optional width override (overrides size if provided)
  /// [height] - Optional height override (overrides size if provided)
  /// [fit] - How to fit the icon in the bounds
  /// [alignment] - Alignment of the SVG within its bounds
  /// [allowDrawingOutsideViewBox] - Whether to allow drawing outside viewBox
  /// [placeholderBuilder] - Widget to show while SVG is loading
  /// [semanticsLabel] - Label for accessibility
  static Widget paintSvg({
    required String assetPath,
    Color? color,
    double? size,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
  }) {
    final double iconWidth = width ?? size ?? 24.0;
    final double iconHeight = height ?? size ?? 24.0;

    return SvgPicture.asset(
      assetPath,
      width: iconWidth,
      height: iconHeight,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder:
          placeholderBuilder ??
          (BuildContext context) => SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: Center(
              child: SizedBox(
                width: iconWidth * 0.5,
                height: iconHeight * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.grey[400],
                ),
              ),
            ),
          ),
      semanticsLabel: semanticsLabel,
    );
  }

  /// Paints an SVG icon with default fallback values
  static Widget paintSvgWithDefaults({
    required String assetPath,
    Color? color,
    double? size,
    Color defaultColor = AppColors.black,
    double defaultSize = 24.0,
  }) {
    return paintSvg(
      assetPath: assetPath,
      color: color ?? defaultColor,
      size: size ?? defaultSize,
    );
  }

  /// Paints multiple SVG icons in a row with spacing
  static Widget paintSvgRow({
    required List<String> assetPaths,
    Color? color,
    double? size,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    double spacing = 8.0,
  }) {
    return Row(
      mainAxisAlignment: alignment,
      children: assetPaths.asMap().entries.map((entry) {
        final int index = entry.key;
        final String path = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            right: index < assetPaths.length - 1 ? spacing : 0,
          ),
          child: paintSvg(assetPath: path, color: color, size: size),
        );
      }).toList(),
    );
  }

  /// Paints multiple SVG icons in a column with spacing
  static Widget paintSvgColumn({
    required List<String> assetPaths,
    Color? color,
    double? size,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    double spacing = 8.0,
  }) {
    return Column(
      mainAxisAlignment: alignment,
      children: assetPaths.asMap().entries.map((entry) {
        final int index = entry.key;
        final String path = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < assetPaths.length - 1 ? spacing : 0,
          ),
          child: paintSvg(assetPath: path, color: color, size: size),
        );
      }).toList(),
    );
  }
}
