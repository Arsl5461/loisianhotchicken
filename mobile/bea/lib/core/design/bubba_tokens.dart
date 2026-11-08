import 'package:flutter/material.dart';

class BubbaFonts {
  BubbaFonts._();

  static const String display = 'Canela';
  static const String body = 'Lato';
  static const String ui = 'PublicSans';
  static const String system = 'PublicSans';
  static const String serif = 'PlayfairDisplay';
}

class BubbaColors {
  BubbaColors._();

  static const Color screenBg = Color(0xFFFAF9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceField = Color(0xFFFFFEFF);

  static const Color textHeading = Color(0xFF212121);
  static const Color textHeadingAlt = Color(0xFF444444);
  static const Color textBody = Color(0xFF373D3E);
  static const Color textBodyMuted = Color(0xFF4A4A4D);
  static const Color textLabel = Color(0xFF444444);
  static const Color textFieldValue = Color(0xFF2E2E2E);
  static const Color textPlaceholder = Color(0xFF8A929E);
  static const Color textPlaceholderAccessible = Color(0xFF6B7280);
  static const Color textLegal = Color(0xFFA2A09D);
  static const Color textLink = Color(0xFF536C94);
  static const Color textLinkStrong = Color(0xFF394E83);
  static const Color textTimer = Color(0xFF4D4D4F);
  static const Color textNoticeMuted = Color(0xFF939393);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFF879C90);
  static const Color textError = Color(0xFFF60047);

  static const Color border = Color(0xFFDCE2EA);
  static const Color borderSubtle = Color(0xFFEDEEEF);
  static const Color borderDisabled = Color(0xFFD9E0EB);
  static const Color borderError = Color(0xFFE2174C);
  static const Color noticeBg = Color(0xFFFFF1F4);
  static const Color noticeBorder = Color(0xFFF7CDD8);

  static const Color actionPrimary = Color(0xFF2D4B39);
  static const Color actionPrimaryDisabledBg = Color(0xFFE8EEE9);
  static const Color actionPrimaryDisabledBorder = Color(0xFFD7E2DA);

  /// Part 1's disabled CTA is a neutral blue-grey, not part 2's green-grey.
  /// Traced off artboards 8, 22 and 28.
  static const Color ctaDisabledBgPart1 = Color(0xFFF2F4F7);
  static const Color ctaDisabledBorderPart1 = Color(0xFFD9E0EB);
  static const Color textDisabledPart1 = Color(0xFF8797B6);
  static const Color actionDark = Color(0xFF000000);

  static const Color brandGreen = Color(0xFF194336);
  static const Color brandGreenDark = Color(0xFF254237);

  static const Color progressTrack = Color(0xFFE6E6E6);
  static const Color chipBg = Color(0xFFF2F3F2);
  static const Color chipText = Color(0xFF271C14);
  static const Color rowBg = Color(0xFFF6F6F6);
  static const Color skipBg = Color(0xFFF2F4F4);
  static const Color divider = Color(0xFFEAEAEA);

  static const Color textGoBack = Color(0xFF3F3128);
  static const Color textStepCounter = Color(0xFF494949);
  static const Color actionDarkDisabled = Color(0xFF4E535A);
  static const Color photoTile = Color(0xFFF7F5F4);
  static const Color photoTileBorder = Color(0xFFE7E4E0);
  static const Color photoAddCircle = Color(0xFFEEECE9);
  static const Color photoAddGlyph = Color(0xFF807E7D);
  static const Color tipsBg = Color(0xFFF7F4F2);
  static const Color errorRed = Color(0xFFFC0028);
  static const Color textHeadingPart2 = Color(0xFF1A1A1A);
  static const Color textQuestion = Color(0xFF0F0F0F);
  static const Color textSubtle = Color(0xFF686868);

  static const Color homeIndicator = Color(0xFFBFC5CF);

  static const Color scrim = Color(0x54000000);
  static const Color scrimLight = Color(0x2B000000);
  static const Color popoverShadow = Color(0x26000000);
}

class BubbaMetrics {
  BubbaMetrics._();

  static const double designWidth = 390;
  static const double designHeight = 843;

  /// The smallest comfortable tap target. Design points shrink with the scale
  /// factor, so on a 320-wide phone a 50.56 pill is only 37.9 tall; controls
  /// grow their hit box to this without moving what is painted.
  static const double minTapTarget = 44;

  /// The status-bar band the artboards budget for. Every design is drawn on a
  /// 390x843 iPhone 14, whose safe-area top is 47, and the chrome is placed
  /// just under it. A device with a deeper notch needs the canvas pushed down
  /// by the difference or that chrome lands inside the cutout.
  static const double designStatusBar = 47;

  static const double copyMeasure = 221;

  static const double contentTrailingGap = 24;
  static const double backChevronX = 19.11;
  static const double backChevronWidth = 10.22;
  static const double backChevronHeight = 18.05;
  static const double backChevronXContent = 25.28;
  static const double pagePadding = 26;
  static const double pageInsetRight = 27.9;
  static const double designContentWidth = 335.9;
  static const double tabletMinSideMargin = 48;
  static const double noticeInsetRight = 30.5;
  static const double borderWidth = 1;

  static const double fieldHeight = 57.5;
  static const double fieldRadius = 10;
  static const double countryFieldWidth = 83.5;
  static const double fieldGap = 19.3;

  static const double buttonHeight = 60.4;
  static const double buttonRadius = 10;
  static const double buttonBottomOffset = 39.6;

  static const double rowHeight = 57;
  static const double rowRadius = 12.4;
  static const double minTouchTarget = 44;

  static const double otpBoxWidth = 50.8;
  static const double otpBoxHeight = 55.7;
  static const double otpBoxRadius = 7.7;

  static const double backIconWidth = 6.96;
  static const double backIconHeight = 13.92;
  static const double caretWidth = 6.6;
  static const double caretHeight = 3.3;

  static const double progressBarY = 69.83;
  static const double progressBarWidth = 286.18;
  static const double progressBarStroke = 3;
  static const double sheetRadius = 25.37;

  static const double footerDividerY = 747.36;
  static const double footerButtonY = 765.07;
  static const double footerButtonHeight = 50.56;
  static const double footerButtonRadius = 4.43;
  static const double footerContinueWidth = 107.83;
  static const double footerContinueWideWidth = 157.33;
  static const double footerSkipWidth = 75.91;
  static const double goBackBaseline = 790.81;

  static const double chipHeight = 60.4;
  static const double chipRadius = 4.97;
  static const double chipGap2Up = 12.1;
  static const double chipGap3Up = 9.98;

  static const double toggleWidth = 54.19;
  static const double toggleHeight = 23.87;
  static const double toggleKnob = 20.57;
  static const double rowHeightPart2 = 57.46;
}
