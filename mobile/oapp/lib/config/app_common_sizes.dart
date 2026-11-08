import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final double appBorderRadius = 5;
double textFieldBorderRadius = 25.0;

enum DeviceState {
  tabletLandscape,
  tabletPortrait,
  phoneLandscape,
  phonePortrait,
}

class AppCommonSizes {
  static BuildContext? get _context => Get.context;
  static const double _androidFontScale = 0.9;

  static double? get chatCardWidth {
    final context = _context;
    if (context == null) return null;

    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 300.w;
      case DeviceState.phoneLandscape:
        return 400.w;
      case DeviceState.tabletPortrait:
        return 350.w;
      case DeviceState.tabletLandscape:
        return 450.w;
    }
  }

  static double get appLogoWidth {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 140.w;
      case DeviceState.phoneLandscape:
        return 80.w;
      case DeviceState.tabletPortrait:
        return 120.w;
      case DeviceState.tabletLandscape:
        return 100.w;
    }
  }

  static double get appLogoHeight {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 120.h;
      case DeviceState.phoneLandscape:
        return 80.h;
      case DeviceState.tabletPortrait:
        return 120.h;
      case DeviceState.tabletLandscape:
        return 100.h;
    }
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  static bool isLandScape() {
    final context = _context;
    if (context == null) return false;
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static DeviceState getDeviceState() {
    final context = _context;
    if (context == null) return DeviceState.phonePortrait;

    final bool tablet = isTablet(context);
    final bool landscape = isLandScape();

    if (tablet && landscape) return DeviceState.tabletLandscape;
    if (tablet && !landscape) return DeviceState.tabletPortrait;
    if (!tablet && landscape) return DeviceState.phoneLandscape;
    return DeviceState.phonePortrait;
  }

  static double appbarHeight() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 56.h;
      case DeviceState.phoneLandscape:
        return 45.h;
      case DeviceState.tabletPortrait:
        return 65.h;
      case DeviceState.tabletLandscape:
        return 55.h;
    }
  }

  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static double _fontSize(double baseSize) {
    final scaledSize = baseSize.sp;
    return _isAndroid ? scaledSize * _androidFontScale : scaledSize;
  }

  static double verySmallFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(12);
      case DeviceState.phoneLandscape:
        return _fontSize(12);
      case DeviceState.tabletPortrait:
        return 10.sp;
      case DeviceState.tabletLandscape:
        return 5.sp;
    }
  }

  static double extraSmallFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(10);
      case DeviceState.phoneLandscape:
        return _fontSize(10);
      case DeviceState.tabletPortrait:
        return 4.sp;
      case DeviceState.tabletLandscape:
        return 3.sp;
    }
  }

  static double smallFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(14);
      case DeviceState.phoneLandscape:
        return _fontSize(14);
      case DeviceState.tabletPortrait:
        return 11.sp;
      case DeviceState.tabletLandscape:
        return 6.sp;
    }
  }

  static double regularFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(17);
      case DeviceState.phoneLandscape:
        return _fontSize(17);
      case DeviceState.tabletPortrait:
        return 11.sp;
      case DeviceState.tabletLandscape:
        return 8.sp;
    }
  }

  static double mediumFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(21);
      case DeviceState.phoneLandscape:
        return _fontSize(21);
      case DeviceState.tabletPortrait:
        return 12.sp;
      case DeviceState.tabletLandscape:
        return 9.sp;
    }
  }

  static double largeFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(25);
      case DeviceState.phoneLandscape:
        return _fontSize(25);
      case DeviceState.tabletPortrait:
        return 13.sp;
      case DeviceState.tabletLandscape:
        return 12.sp;
    }
  }

  static double midlargeFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(30);
      case DeviceState.phoneLandscape:
        return _fontSize(28);
      case DeviceState.tabletPortrait:
        return 17.sp;
      case DeviceState.tabletLandscape:
        return 13.sp;
    }
  }

  static double headingFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return _fontSize(40);
      case DeviceState.phoneLandscape:
        return _fontSize(40);
      case DeviceState.tabletPortrait:
        return 18.sp;
      case DeviceState.tabletLandscape:
        return 14.sp;
    }
  }

  static double verySmall() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 12;
      case DeviceState.phoneLandscape:
        return 12;
      case DeviceState.tabletPortrait:
        return 8.sp;
      case DeviceState.tabletLandscape:
        return 6.sp;
    }
  }

  static double small() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 16;
      case DeviceState.phoneLandscape:
        return 16;
      case DeviceState.tabletPortrait:
        return 18;
      case DeviceState.tabletLandscape:
        return 18;
    }
  }

  static double medium() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 22;
      case DeviceState.phoneLandscape:
        return 20;
      case DeviceState.tabletPortrait:
        return 24;
      case DeviceState.tabletLandscape:
        return 22;
    }
  }

  static double large() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 28;
      case DeviceState.phoneLandscape:
        return 26;
      case DeviceState.tabletPortrait:
        return 32;
      case DeviceState.tabletLandscape:
        return 30;
    }
  }

  static double extraLarge() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 40;
      case DeviceState.phoneLandscape:
        return 36;
      case DeviceState.tabletPortrait:
        return 48;
      case DeviceState.tabletLandscape:
        return 44;
    }
  }

  static double commonSpacing() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 10.h;
      case DeviceState.phoneLandscape:
        return 5.h;
      case DeviceState.tabletPortrait:
        return 20.h;
      case DeviceState.tabletLandscape:
        return 20.h;
    }
  }

  static double cupertinoLoaderRadius() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 25.w;
      case DeviceState.phoneLandscape:
        return 15.w;
      case DeviceState.tabletPortrait:
        return 25.w;
      case DeviceState.tabletLandscape:
        return 15.w;
    }
  }

  static double infoPosition() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
      case DeviceState.phoneLandscape:
      case DeviceState.tabletPortrait:
        return 0.w;
      case DeviceState.tabletLandscape:
        return 35.w;
    }
  }

  static EdgeInsets commonButtonPadding() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w);
      case DeviceState.phoneLandscape:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.5.w);
      case DeviceState.tabletPortrait:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w);
      case DeviceState.tabletLandscape:
        return EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w);
    }
  }

  static double fieldFontSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
      case DeviceState.tabletPortrait:
        return 17.sp;
      case DeviceState.phoneLandscape:
      case DeviceState.tabletLandscape:
        return 10.sp;
    }
  }

  static double? getContactListHeaderHeight() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 114.h;
      case DeviceState.phoneLandscape:
        return 250.h;
      case DeviceState.tabletPortrait:
        return 120.h;
      case DeviceState.tabletLandscape:
        return 180.h;
    }
  }

  static double contactAvatarSize() {
    switch (getDeviceState()) {
      case DeviceState.phonePortrait:
        return 65.w;
      case DeviceState.phoneLandscape:
        return 72.w;
      case DeviceState.tabletPortrait:
        return 72.w;
      case DeviceState.tabletLandscape:
        return 72.w;
    }
  }
}
