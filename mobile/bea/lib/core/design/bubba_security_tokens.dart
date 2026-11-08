import 'package:flutter/material.dart';

import 'bubba_scale.dart';
import 'bubba_tokens.dart';

/// Part 5, Security and Privacy Settings. Raw trace values from
/// `05_security_and_privacy_settings.ai`, not colour-converted, same rule as
/// parts 3 and 4. The normalisations are recorded in
/// `docs/bubba_part5/00_OVERVIEW.md` §4.
class BubbaSecurityColors {
  BubbaSecurityColors._();

  static const Color pageBg = Color(0xFFFFFFFF);

  static const Color heroNeutral = Color(0xFFF5F1EF);
  static const Color heroSuccess = Color(0xFFF1F5F1);
  static const Color heroDanger = Color(0xFFF8F0F0);

  static const Color cardBg = Color(0xFFFCFBFB);
  static const Color cardBorder = Color(0xFFEEEDEC);
  static const Color cardRule = Color(0xFFEEEDEC);

  static const Color lead = Color(0xFF373D3E);
  static const Color heading = Color(0xFF000000);
  static const Color rowTitle = Color(0xFF000000);
  static const Color rowSubtitle = Color(0xFF6A6B6E);
  static const Color fieldLabel = Color(0xFF6B6B6B);
  static const Color chevron = Color(0xFF333333);
  static const Color icon = Color(0xFF000000);

  static const Color accent = Color(0xFF21452F);
  static const Color danger = Color(0xFFAC2221);
  static const Color dangerIcon = Color(0xFFAE241F);
  static const Color dangerCta = Color(0xFFB72221);
  static const Color dangerCardBg = Color(0xFFF8F0F0);
  static const Color successMark = Color(0xFF335A3E);
  static const Color successCardBg = Color(0xFFF1F5F1);

  static const Color ctaFill = Color(0xFF000000);
  static const Color onDark = Color(0xFFFFFFFF);

  static const Color inputBg = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFDAE1EA);
  static const Color inputPlaceholder = Color(0xFF8A919D);
  static const Color inputValue = Color(0xFF2E2E2E);

  static const Color radioIdle = Color(0xFFA0A0A0);
  static const Color radioOn = Color(0xFF21452F);
  static const Color radioDot = Color(0xFFFFFFFF);

  static const Color emptyTitle = Color(0xFF232222);
  static const Color unblockTitle = Color(0xFF232222);
  static const Color unblockBody = Color(0xFF7D797D);
  static const Color blockedMeta = Color(0xFF000000);
  static const Color appleMeta = Color(0xFF888888);
  static const Color statusOn = Color(0xFF429451);
}

class BubbaSecurityMetrics {
  BubbaSecurityMetrics._();

  static const double canvasHeight = 838;

  static const double heroX = 157;
  static const double heroY = 113;
  static const double heroSize = 76;

  static const double cardX = 22.34;
  static const double cardWidth = 338;
  static const double cardRadius = 11.16;
  static const double cardBorderWidth = 1;

  static const double rowChevronWidth = 6;
  static const double rowChevronHeight = 10.60;

  static const double ctaX = 31.50;
  static const double ctaWidth = 327;
  static const double ctaHeight = 58;
  static const double ctaRadius = 7.33;

  static const double inputWidth = 335.01;
  static const double inputHeight = 57.46;
  static const double inputRadius = 10;

  static const double radioSize = 18.94;
  static const double radioDotSize = 7.01;
  static const double radioBorderWidth = 1;

  static const double ruleWeight = 1;

  /// Every card chevron sits this far left of its card's right edge.
  static const double cardChevronRightGap = 17.66;

  static const double leadPitch = 21;
  static const double subtitlePitch = 18;
  static const double subtitlePitchTight = 14.40;

  /// Lead baselines. A screen with a heading uses [detailLeadBaseline]; a hub
  /// screen uses [hubLeadBaseline]; a screen with no hero uses [bareLeadBaseline].
  static const double hubLeadBaseline = 235.35;
  static const double detailHeadingBaseline = 240.35;
  static const double detailLeadBaseline = 272.35;
  static const double bareLeadBaseline = 124.24;
}

class BubbaSecurityText {
  BubbaSecurityText._();

  static TextStyle get lead => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.lead,
      );

  static TextStyle get heading => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(18, 21),
        letterSpacing: 0,
        color: BubbaSecurityColors.heading,
      );

  static TextStyle get rowTitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 17),
        letterSpacing: 0,
        color: BubbaSecurityColors.rowTitle,
      );

  static TextStyle get rowSubtitle => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.rowSubtitle,
      );

  static TextStyle get rowAction => rowTitle.copyWith(
        fontSize: dsp(12, 14),
        color: BubbaSecurityColors.accent,
      );

  static TextStyle get fieldLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.fieldLabel,
      );

  static TextStyle get fieldValue => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 17),
        letterSpacing: 0,
        color: BubbaSecurityColors.rowTitle,
      );

  static TextStyle get fieldValueAccent => fieldValue.copyWith(
        fontSize: dsp(12, 14),
        color: BubbaSecurityColors.accent,
      );

  static TextStyle get verified => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.accent,
      );

  static TextStyle get ctaLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 17),
        letterSpacing: 0,
        color: BubbaSecurityColors.onDark,
      );

  static TextStyle get secondaryLabel => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w700,
        fontSize: dsp(14, 17),
        letterSpacing: 0,
        color: BubbaSecurityColors.heading,
      );

  static TextStyle get inputPlaceholder => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(14, 17),
        letterSpacing: 0,
        color: BubbaSecurityColors.inputPlaceholder,
      );

  static TextStyle get inputValue => inputPlaceholder.copyWith(
        color: BubbaSecurityColors.rowTitle,
      );

  static TextStyle get countryLabel => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(14, 17),
        letterSpacing: 0,
        color: BubbaSecurityColors.inputValue,
      );

  static TextStyle get countryHeader => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 15),
        letterSpacing: 0,
        color: Color(0xFF444444),
      );

  /// p020 / p024 set the verify heading at 21pt Canela, not part 1's 36pt.
  static TextStyle get verifyHeading => TextStyle(
        fontFamily: BubbaFonts.display,
        fontWeight: FontWeight.w400,
        fontSize: dsp(21, 25),
        height: 1.2,
        letterSpacing: 0,
        color: const Color(0xFF444444),
      );

  static TextStyle get emptyTitle => TextStyle(
        fontFamily: BubbaFonts.display,
        fontWeight: FontWeight.w400,
        fontSize: dsp(18, 21),
        letterSpacing: 0,
        color: BubbaSecurityColors.emptyTitle,
      );

  static TextStyle get unblockTitle => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w700,
        fontSize: dsp(18, 21),
        letterSpacing: 0,
        color: BubbaSecurityColors.unblockTitle,
      );

  static TextStyle get unblockBody => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w400,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.unblockBody,
      );

  static TextStyle get blockedName => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.blockedMeta,
      );

  static TextStyle get blockedDate => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w500,
        fontSize: dsp(10, 12),
        letterSpacing: 0,
        color: BubbaSecurityColors.blockedMeta,
      );

  static TextStyle get unblockAction => TextStyle(
        fontFamily: BubbaFonts.ui,
        fontWeight: FontWeight.w700,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.accent,
      );

  static TextStyle get appleMeta => TextStyle(
        fontFamily: BubbaFonts.body,
        fontWeight: FontWeight.w400,
        fontSize: dsp(12, 14),
        letterSpacing: 0,
        color: BubbaSecurityColors.appleMeta,
      );
}
