import 'package:flutter/material.dart';

import 'bubba_scale.dart';
import 'bubba_tokens.dart';

/// Part 4, Dating Preferences. Raw trace values from
/// `04_dating_preferences.ai`, not colour-converted, same rule as part 3.
class BubbaPrefsColors {
  BubbaPrefsColors._();

  static const Color pageBg = Color(0xFFFFFFFF);
  static const Color listBg = Color(0xFFFCFBFA);
  static const Color navIcon = Color(0xFF333333);
  static const Color navTitle = Color(0xFF111111);
  static const Color title = Color(0xFF000000);
  static const Color rowLabel = Color(0xFF212121);
  static const Color rowValue = Color(0xFF898989);
  static const Color sectionHeader = Color(0xFF7F7F7F);
  static const Color divider = Color(0xFFF9F9F9);
  static const Color navDivider = Color(0xFFEAEAEA);
  static const Color hairline = Color(0xFFCBCBCB);
  static const Color chevron = Color(0xFF383838);
  static const Color optionLabel = Color(0xFF000000);
  static const Color controlBorder = Color(0xFFC3C5C5);
  static const Color radioOn = Color(0xFF050505);
  static const Color checkOn = Color(0xFF1E4740);
  static const Color onDark = Color(0xFFFFFFFF);
  static const Color toggleOn = Color(0xFF285466);
  static const Color toggleOnTeal = Color(0xFF1F4941);
  static const Color toggleOnRose = Color(0xFFA51D42);
  static const Color toggleOff = Color(0xFFD6D6D6);
  static const Color introCopy = Color(0xFF373D3E);
  static const Color eyebrow = Color(0xFF676669);
  static const Color impactBg = Color(0xFFF7F4F1);
  static const Color impactTitle = Color(0xFF0C0C0C);
  static const Color impactUnit = Color(0xFF5F5F61);
  static const Color impactNote = Color(0xFF50514E);
  static const Color ctaDark = Color(0xFF000000);
  static const Color cardBorder = Color(0xFFEFEDED);
  static const Color cardIconBg = Color(0xFFF4EFE9);
  static const Color optionTitle = Color(0xFF070707);
  static const Color optionSub = Color(0xFF656A6F);
  static const Color sliderTrack = Color(0xFFD7D6D5);
  static const Color sliderActive = Color(0xFF494949);
  static const Color sliderScale = Color(0xFF7F8488);
  static const Color sliderCaption = Color(0xFF535357);
  static const Color pillBg = Color(0xFFF6F2ED);
  static const Color sliderCardBorder = Color(0xFFEFEFEF);
  static const Color sliderCardFill = Color(0xFFFFFEFD);
  static const Color v2Bg = Color(0xFFFCFBFA);
  static const Color v2Rule = Color(0xFFEBEAE9);
  static const Color v2IconBg = Color(0xFFF4EFE9);
  static const Color v2IconBgMuted = Color(0xFFF1F1EC);
  static const Color v2PillOn = Color(0xFFF6F5F0);
  static const Color v2PillOff = Color(0xFFEAEAEA);
  static const Color v2PillLabelOff = Color(0xFF767475);
  static const Color v2Value = Color(0xFF020202);
  static const Color travelCardBg = Color(0xFFECF0F7);
  static const Color travelIconBg = Color(0xFFAAB9DE);
  static const Color meterFilled = Color(0xFF052520);
  static const Color meterMid = Color(0xFFBDCA90);
  static const Color meterEmpty = Color(0xFFE4E3E3);
  static const Color meterVerdict = Color(0xFF053A35);
  static const Color searchIdleBorder = Color(0xFFEEECEA);
  static const Color searchIdleIcon = Color(0xFF7E7D7E);
  static const Color searchActiveBorder = Color(0xFF070707);
  static const Color placeCountry = Color(0xFF919190);
  static const Color ctaTeal = Color(0xFF1F4941);
}

class BubbaPrefsMetrics {
  BubbaPrefsMetrics._();

  static const double navBackX = 16.91;
  static const double navBackY = 49.21;
  static const double navBackWidth = 8.32;
  static const double navBackHeight = 14.70;
  static const double navTitleBaseline = 63.23;
  static const double navDividerY = 76.50;

  static const double headingX = 15.00;
  static const double contentX = 13.47;

  static const double rowPitch = 53.78;
  static const double rowValueGap = 17.76;
  static const double rowRuleGap = 30.75;
  static const double rowChevronGap = 1.78;
  static const double rowChevronX = 368.25;
  static const double ruleX = 14.88;
  static const double ruleWidth = 374.46;

  static const double optionPitch = 51.98;
  static const double optionLabelX = 25.46;
  static const double optionRuleX = 26.49;
  static const double optionRuleWidth = 365.58;

  static const double radioX = 350.71;
  static const double radioSize = 21.89;
  static const double radioDot = 6.00;

  static const double checkboxX = 345.73;
  static const double checkboxSize = 21.00;
  static const double checkboxRadius = 3.71;

  static const double toggleWidth = 54.19;
  static const double toggleHeight = 23.87;
  static const double toggleRadius = 11.94;
  static const double knobWidth = 31.65;
  static const double knobHeight = 20.57;
  static const double knobRadius = 10.29;
  static const double knobInsetLeft = 2.03;
  static const double knobInsetRight = 1.51;

  static const double impactX = 15.28;
  static const double impactWidth = 359;
  static const double impactHeight = 132;
  static const double impactRadius = 15.20;
  static const double impactUnitGap = 7.27;
}

class BubbaPrefsText {
  BubbaPrefsText._();

  static TextStyle get navTitle => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.navTitle,
      );

  static TextStyle get navTitleBold => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get heading => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(18, 21),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get sectionHeader => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.sectionHeader,
      );

  static TextStyle get rowLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.rowLabel,
      );

  static TextStyle get rowValue => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.rowValue,
      );

  static TextStyle get optionLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.optionLabel,
      );

  static TextStyle get optionMedium => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.optionLabel,
      );

  static TextStyle get introCopy => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(12, 14),
        height: 18 / 12,
        letterSpacing: 0,
        color: BubbaPrefsColors.introCopy,
      );

  static TextStyle get eyebrow => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaPrefsColors.eyebrow,
      );

  static TextStyle get impactTitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaPrefsColors.impactTitle,
      );

  static TextStyle get impactNumber => TextStyle(
        fontFamily: BubbaFonts.serif,
        fontWeight: FontWeight.w400,
        fontSize: dsp(30, 34),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get impactUnit => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.impactUnit,
      );

  static TextStyle get impactNote => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.impactNote,
      );

  static TextStyle get welcomeChipTitle => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(18, 21),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get welcomeChipDate => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w400,
        fontSize: dsp(16, 18),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get welcomeHeading => TextStyle(
        fontFamily: BubbaFonts.display,
        fontWeight: FontWeight.w400,
        fontSize: dsp(48, 54),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get welcomeCopy => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: const Color(0xFF0A090B),
      );

  static TextStyle get welcomeCta => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(18, 21),
        letterSpacing: 0,
        color: BubbaPrefsColors.onDark,
      );

  static TextStyle get destinationName => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get destinationCountry => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.placeCountry,
      );

  static TextStyle get destinationSearch => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.searchIdleIcon,
      );

  static TextStyle get destinationQuery => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get destinationEyebrow => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.v2Value,
      );

  static TextStyle get v2Title => TextStyle(
        fontFamily: BubbaFonts.display,
        fontWeight: FontWeight.w400,
        fontSize: dsp(24, 28),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get v2Value => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.v2Value,
      );

  static TextStyle get v2Pill => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.v2Value,
      );

  static TextStyle get travelRow => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get tripRowTitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get tripRowValue => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get tripRowHint => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaPrefsColors.eyebrow,
      );

  static TextStyle get tripSummaryName => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get tripSummaryMeta => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF939191),
      );

  static TextStyle get tripAction => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF3F577D),
      );

  static TextStyle get tripActionSmall => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: const Color(0xFF3F577D),
      );

  static TextStyle get tripCta => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.onDark,
      );

  static TextStyle get travelNote => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(10, 12),
        height: 18 / 10,
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get meterVerdict => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.meterVerdict,
      );

  static TextStyle get sheetTitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: const Color(0xFF040505),
      );

  static TextStyle get sheetSubtitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF505151),
      );

  static TextStyle get searchPlaceholder => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF333333),
      );

  static TextStyle get placeName => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get placeDistance => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w400,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: const Color(0xFFB9B9B9),
      );

  static TextStyle get clearLink => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF0D3E71),
      );

  static TextStyle get locationLink => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w400,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF226F96),
      );

  static TextStyle get optionTitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.optionTitle,
      );

  static TextStyle get optionSub => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaPrefsColors.optionSub,
      );

  static TextStyle get currentValue => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.optionTitle,
      );

  static TextStyle get sliderValue => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(18, 21),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get sliderCaption => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaPrefsColors.sliderCaption,
      );

  static TextStyle get sliderScale => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaPrefsColors.sliderScale,
      );

  static TextStyle get pillLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get ctaBold => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.onDark,
      );

  static TextStyle get reset => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF003626),
      );

  /// p013's origin row. The trace sets all three at 12pt, not the 10pt
  /// `optionSub` they were built with, and the label and link are Lato-Bold.
  static TextStyle get originNote => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.impactNote,
      );

  static TextStyle get originLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get originChange => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: const Color(0xFF003626),
      );

  /// p027 / p028's map chrome. These controls exist only as pixels inside the
  /// placed raster, so there is no trace to read: the type is matched to the
  /// part 4 ramp above rather than sampled off the render, and the colours are
  /// the tokens the rest of part 4 already uses.
  static TextStyle get locationTitle => TextStyle(
        fontFamily: BubbaFonts.display,
        fontWeight: FontWeight.w400,
        fontSize: dsp(21, 25),
        letterSpacing: 0,
        color: BubbaPrefsColors.v2Value,
      );

  static TextStyle get locationMeta => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(13, 15),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get locationRadiusLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(11, 13),
        letterSpacing: 0,
        color: BubbaPrefsColors.v2Value,
      );

  static TextStyle get locationRadiusValue => TextStyle(
        fontFamily: BubbaFonts.display,
        fontWeight: FontWeight.w400,
        fontSize: dsp(20, 24),
        letterSpacing: 0,
        color: BubbaPrefsColors.v2Value,
      );

  static TextStyle get exploreTitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(15, 17),
        letterSpacing: 0,
        color: BubbaPrefsColors.title,
      );

  static TextStyle get exploreBody => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(14, 16),
        height: 22 / 14,
        letterSpacing: 0,
        color: BubbaPrefsColors.rowValue,
      );

  static TextStyle get ctaLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 16),
        letterSpacing: 0,
        color: BubbaPrefsColors.onDark,
      );
}
