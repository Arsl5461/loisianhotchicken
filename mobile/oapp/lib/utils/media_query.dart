import 'package:flutter/material.dart';

/// Enhanced MediaQuery utility class for comprehensive responsive design
class MediaQueryUtil {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late Orientation orientation;
  static late bool isTablet;
  static late bool isLandscape;
  static late bool isPortrait;
  static late double statusBarHeight;
  static late double bottomBarHeight;
  static late double textScaleFactor;
  static late double devicePixelRatio;
  static late double logicalPixelRatio;
  static late Brightness platformBrightness;
  static late bool accessibleNavigation;
  static late bool disableAnimations;

  /// Initialize the utility class with BuildContext
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;

    orientation = _mediaQueryData.orientation;
    isTablet = screenWidth >= 768;
    isLandscape = orientation == Orientation.landscape;
    isPortrait = orientation == Orientation.portrait;

    statusBarHeight = _mediaQueryData.padding.top;
    bottomBarHeight = _mediaQueryData.padding.bottom;
    textScaleFactor = _mediaQueryData.textScaleFactor;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    logicalPixelRatio = _mediaQueryData.devicePixelRatio;
    platformBrightness = _mediaQueryData.platformBrightness;
    accessibleNavigation = _mediaQueryData.accessibleNavigation;
    disableAnimations = _mediaQueryData.disableAnimations;
  }

  // Screen dimensions
  static double get width => screenWidth;
  static double get height => screenHeight;

  // Percentage-based dimensions
  static double widthPercentage(double percentage) =>
      screenWidth * (percentage / 100);
  static double heightPercentage(double percentage) =>
      screenHeight * (percentage / 100);

  // Safe area dimensions
  static double safeWidthPercentage(double percentage) =>
      (screenWidth - safeAreaHorizontal) * (percentage / 100);
  static double safeHeightPercentage(double percentage) =>
      (screenHeight - safeAreaVertical) * (percentage / 100);

  // Enhanced responsive font sizes
  static double fontSize(double size) {
    double scaleFactor = 1.0;

    // Device type scaling
    if (isExtraSmallScreen) {
      scaleFactor = 0.85;
    } else if (isSmallScreen) {
      scaleFactor = 0.9;
    } else if (isMediumScreen) {
      scaleFactor = 1.0;
    } else if (isLargeScreen) {
      scaleFactor = 1.1;
    } else if (isTablet) {
      scaleFactor = 1.2;
    }

    // Accessibility scaling with limits
    double accessibilityScale = textScaleFactor.clamp(0.8, 1.3);

    return (size * scaleFactor * accessibilityScale).clamp(
      size * 0.7,
      size * 1.5,
    );
  }

  // Enhanced responsive spacing
  static double spacing(double space) {
    double scaleFactor = 1.0;

    if (isExtraSmallScreen) {
      scaleFactor = 0.75;
    } else if (isSmallScreen) {
      scaleFactor = 0.85;
    } else if (isMediumScreen) {
      scaleFactor = 1.0;
    } else if (isLargeScreen) {
      scaleFactor = 1.1;
    } else if (isTablet) {
      scaleFactor = 1.3;
    }

    return space * scaleFactor;
  }

  // Responsive padding
  static EdgeInsets padding({
    double all = 0,
    double horizontal = 0,
    double vertical = 0,
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
  }) {
    return EdgeInsets.only(
      top: spacing(
        top != 0
            ? top
            : vertical != 0
            ? vertical
            : all,
      ),
      bottom: spacing(
        bottom != 0
            ? bottom
            : vertical != 0
            ? vertical
            : all,
      ),
      left: spacing(
        left != 0
            ? left
            : horizontal != 0
            ? horizontal
            : all,
      ),
      right: spacing(
        right != 0
            ? right
            : horizontal != 0
            ? horizontal
            : all,
      ),
    );
  }

  // Responsive margin
  static EdgeInsets margin({
    double all = 0,
    double horizontal = 0,
    double vertical = 0,
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
  }) {
    return EdgeInsets.only(
      top: spacing(
        top != 0
            ? top
            : vertical != 0
            ? vertical
            : all,
      ),
      bottom: spacing(
        bottom != 0
            ? bottom
            : vertical != 0
            ? vertical
            : all,
      ),
      left: spacing(
        left != 0
            ? left
            : horizontal != 0
            ? horizontal
            : all,
      ),
      right: spacing(
        right != 0
            ? right
            : horizontal != 0
            ? horizontal
            : all,
      ),
    );
  }

  // Responsive border radius
  static BorderRadius borderRadius(double radius) {
    return BorderRadius.circular(spacing(radius));
  }

  // Icon sizes
  static double iconSize(double size) {
    if (isTablet) {
      return size * 1.3;
    }
    return spacing(size);
  }

  // Button dimensions
  static Size buttonSize({double width = 200, double height = 50}) {
    return Size(widthPercentage(width > 100 ? 100 : width), spacing(height));
  }

  // Enhanced device type checks with iOS-specific breakpoints
  static bool get isExtraSmallScreen =>
      screenWidth < 375; // iPhone SE (375px), small Android
  static bool get isSmallScreen =>
      screenWidth < 390; // iPhone 12 mini (390px), small phones
  static bool get isMediumScreen =>
      screenWidth < 430; // iPhone 15 Pro Max (430px), most phones
  static bool get isLargeScreen =>
      screenWidth < 768; // Large phones, small tablets
  static bool get isExtraLargeScreen =>
      screenWidth >= 768; // Tablets, foldables

  // Device category checks
  static bool get isPhone => screenWidth < 768;
  static bool get isFoldable => screenWidth >= 768 && screenWidth < 1024;
  static bool get isDesktop => screenWidth >= 1024;

  // Aspect ratio checks
  static bool get isUltraWide => screenWidth / screenHeight > 2.1;
  static bool get isSquare => (screenWidth / screenHeight).abs() < 0.1;

  // Typography helpers
  static TextStyle headlineStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: MediaQueryUtil.fontSize(fontSize),
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: MediaQueryUtil.fontSize(fontSize),
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle captionStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: MediaQueryUtil.fontSize(fontSize),
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Layout helpers
  static Widget verticalSpace(double height) {
    return SizedBox(height: spacing(height));
  }

  static Widget horizontalSpace(double width) {
    return SizedBox(width: spacing(width));
  }

  // Responsive container
  static Container responsiveContainer({
    Widget? child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? color,
    double borderRadius = 0,
    BoxBorder? border,
  }) {
    return Container(
      width: width != null ? widthPercentage(width) : null,
      height: height != null ? spacing(height) : null,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: MediaQueryUtil.borderRadius(borderRadius),
        border: border,
      ),
      child: child,
    );
  }

  // App bar height
  static double get appBarHeight => kToolbarHeight;

  // Bottom navigation bar height
  static double get bottomNavBarHeight => kBottomNavigationBarHeight;

  // Density-aware scaling
  static double densityAwareSize(double size) {
    return size * devicePixelRatio;
  }

  // Safe area aware dimensions
  static double get safeWidth => screenWidth - safeAreaHorizontal;
  static double get safeHeight => screenHeight - safeAreaVertical;

  // Dynamic sizing based on screen size
  static double dynamicSize({
    required double small,
    required double medium,
    required double large,
    double? extraSmall,
    double? extraLarge,
  }) {
    if (isExtraSmallScreen) return extraSmall ?? small;
    if (isSmallScreen) return small;
    if (isMediumScreen) return medium;
    if (isLargeScreen) return large;
    if (isExtraLargeScreen) return extraLarge ?? large;
    return medium;
  }

  // Responsive grid columns
  static int getGridColumns({int? maxColumns}) {
    int columns = 1;
    if (isExtraSmallScreen) {
      columns = 1;
    } else if (isSmallScreen)
      columns = 2;
    else if (isMediumScreen)
      columns = 2;
    else if (isLargeScreen)
      columns = 3;
    else if (isTablet)
      columns = 4;
    else if (isDesktop)
      columns = 5;

    return maxColumns != null ? columns.clamp(1, maxColumns) : columns;
  }

  // Responsive breakpoint values
  static double getBreakpointValue({
    required double mobile,
    required double tablet,
    required double desktop,
    double? smallMobile,
  }) {
    if (isPhone) {
      return isExtraSmallScreen ? (smallMobile ?? mobile) : mobile;
    } else if (isTablet) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // Accessibility helpers
  static bool get isHighContrast => platformBrightness == Brightness.dark;
  static bool get isReducedMotion => disableAnimations;
  static bool get isAccessibilityMode => accessibleNavigation;

  // iOS-specific helpers
  static bool get hasNotch =>
      statusBarHeight > 20; // iOS devices with notch/Dynamic Island
  static bool get hasHomeIndicator =>
      bottomBarHeight > 0; // iOS devices with home indicator
  static bool get isIPhone =>
      screenWidth < 768 && screenHeight < 1200; // iPhone detection
  static bool get isIPad => screenWidth >= 768; // iPad detection

  // iOS safe area helpers
  static EdgeInsets get iosSafeArea => EdgeInsets.only(
    top: statusBarHeight,
    bottom: bottomBarHeight,
    left: _mediaQueryData.padding.left,
    right: _mediaQueryData.padding.right,
  );

  // iOS-specific spacing for notch/Dynamic Island
  static double get iosTopPadding => hasNotch ? statusBarHeight : 0;
  static double get iosBottomPadding => hasHomeIndicator ? bottomBarHeight : 0;

  // Layout helpers for different screen types
  static EdgeInsets getScreenPadding() {
    return EdgeInsets.symmetric(
      horizontal: spacing(isPhone ? 16 : 24),
      vertical: spacing(isPhone ? 8 : 16),
    );
  }

  // iOS-optimized padding that respects safe areas
  static EdgeInsets getIOSOptimizedPadding({
    double horizontal = 16,
    double vertical = 8,
    bool respectSafeArea = true,
  }) {
    return EdgeInsets.only(
      left: spacing(horizontal),
      right: spacing(horizontal),
      top: respectSafeArea
          ? iosTopPadding + spacing(vertical)
          : spacing(vertical),
      bottom: respectSafeArea
          ? iosBottomPadding + spacing(vertical)
          : spacing(vertical),
    );
  }

  static double getScreenMargin() {
    return spacing(isPhone ? 16 : 32);
  }

  // Responsive image sizing
  static Size getImageSize({
    required double width,
    required double height,
    double? maxWidth,
    double? maxHeight,
  }) {
    double scaleFactor = 1.0;
    if (isExtraSmallScreen) {
      scaleFactor = 0.8;
    } else if (isSmallScreen)
      scaleFactor = 0.9;
    else if (isTablet)
      scaleFactor = 1.2;

    double scaledWidth = width * scaleFactor;
    double scaledHeight = height * scaleFactor;

    if (maxWidth != null && scaledWidth > maxWidth) {
      scaledWidth = maxWidth;
      scaledHeight = (height * maxWidth) / width;
    }

    if (maxHeight != null && scaledHeight > maxHeight) {
      scaledHeight = maxHeight;
      scaledWidth = (width * maxHeight) / height;
    }

    return Size(scaledWidth, scaledHeight);
  }
}
