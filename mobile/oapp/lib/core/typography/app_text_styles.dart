import 'package:flutter/material.dart';

import '../../config/app_common_sizes.dart';

enum AppTextSize {
  verySmall,
  small,
  medium,
  large,
  midlarge,
  heading,
  regular,
  extraSmall,
}

enum AppFontWeight { light, regular, semi, semiBold, bold }

enum AppFontFamily { publicSans, urbanist, playfair }

class AppTextStyles {
  static TextStyle text({
    AppTextSize? size,
    AppFontWeight fontWeight = AppFontWeight.regular,
    AppFontFamily fontFamily = AppFontFamily.publicSans,
    Color? color,
    double? height,
    double? customSize,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: customSize ?? _getSize(size ?? AppTextSize.medium),
      fontWeight: fontWeight.weight,
      fontFamily: fontFamily.name,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  /// Quick access styles (METHODS)

  static TextStyle verySmall({
    Color? color,
    AppFontWeight fontWeight = AppFontWeight.regular,
    AppFontFamily fontFamily = AppFontFamily.publicSans,
    double? height,
    TextDecoration? decoration,
  }) {
    return text(
      fontFamily: fontFamily,
      size: AppTextSize.verySmall,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle extraSmall({
    Color? color,
    AppFontWeight fontWeight = AppFontWeight.regular,
    AppFontFamily fontFamily = AppFontFamily.publicSans,
    double? height,
    TextDecoration? decoration,
  }) {
    return text(
      fontFamily: fontFamily,
      size: AppTextSize.extraSmall,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle small({
    Color? color,
    AppFontWeight fontWeight = AppFontWeight.regular,
    AppFontFamily fontFamily = AppFontFamily.publicSans,
    double? height,
    TextDecoration? decoration,
  }) {
    return text(
      fontFamily: fontFamily,
      size: AppTextSize.small,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle medium({
    AppFontFamily fontFamily = AppFontFamily.publicSans,
    Color? color,
    AppFontWeight fontWeight = AppFontWeight.regular,
    double? height,
    TextDecoration? decoration,
  }) {
    return text(
      fontFamily: fontFamily,
      size: AppTextSize.medium,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle regular({
    Color? color,
    AppFontFamily fontFamily = AppFontFamily.publicSans,
    AppFontWeight fontWeight = AppFontWeight.regular,
    double? height,
    TextDecoration? decoration,
  }) {
    return text(
      fontFamily: fontFamily,
      size: AppTextSize.regular,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle large({
    Color? color,
    AppFontWeight fontWeight = AppFontWeight.regular,
    double? height,
    TextDecoration? decoration,
    AppFontFamily fontFamily = AppFontFamily.playfair,
  }) {
    return text(
      fontFamily: fontFamily,
      size: AppTextSize.large,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle midLarge({
    Color? color,
    AppFontWeight fontWeight = AppFontWeight.regular,
    double? height,
    TextDecoration? decoration,
    AppFontFamily fontFamily = AppFontFamily.playfair,
  }) {
    return text(
      fontFamily: fontFamily,
      size: AppTextSize.large,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle heading({
    Color? color,
    AppFontWeight fontWeight = AppFontWeight.semiBold,
    double? height,
    TextDecoration? decoration,
    AppFontFamily fontFamily = AppFontFamily.playfair,
  }) {
    return text(
      fontFamily: fontFamily,

      size: AppTextSize.heading,
      color: color,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  static double _getSize(AppTextSize size) {
    switch (size) {
      case AppTextSize.verySmall:
        return AppCommonSizes.verySmallFontSize();
      case AppTextSize.extraSmall:
        return AppCommonSizes.extraSmallFontSize();
      case AppTextSize.small:
        return AppCommonSizes.smallFontSize();
      case AppTextSize.medium:
        return AppCommonSizes.mediumFontSize();
      case AppTextSize.large:
        return AppCommonSizes.largeFontSize();
      case AppTextSize.heading:
        return AppCommonSizes.headingFontSize();
      case AppTextSize.regular:
        return AppCommonSizes.regularFontSize();
      case AppTextSize.midlarge:
        return AppCommonSizes.midlargeFontSize();
    }
  }
}

extension AppFontWeightExtension on AppFontWeight {
  FontWeight get weight {
    switch (this) {
      case AppFontWeight.light:
        return FontWeight.w300;
      case AppFontWeight.regular:
        return FontWeight.w400;
      case AppFontWeight.semi:
        return FontWeight.w500;
      case AppFontWeight.semiBold:
        return FontWeight.w700;
      case AppFontWeight.bold:
        return FontWeight.w900;
    }
  }
}

extension AppFontFamilyExtension on AppFontFamily {
  String get name {
    switch (this) {
      case AppFontFamily.publicSans:
        return "PublicSans";
      case AppFontFamily.urbanist:
        return "Urbanist";

      case AppFontFamily.playfair:
        return "PlayfairDisplay";
    }
  }
}

enum AppIconSize { verySmall, small, medium, large, extraLarge }

class AppIcons {
  static double size(AppIconSize size) {
    switch (size) {
      case AppIconSize.verySmall:
        return AppCommonSizes.verySmall();
      case AppIconSize.small:
        return AppCommonSizes.small();
      case AppIconSize.medium:
        return AppCommonSizes.medium();
      case AppIconSize.large:
        return AppCommonSizes.large();
      case AppIconSize.extraLarge:
        return AppCommonSizes.extraLarge();
    }
  }
}
