import 'package:flutter/material.dart';
import 'bubba_scale.dart';
import 'bubba_tokens.dart';

class BubbaText {
  BubbaText._();

  static double _size(double phone, double tablet) => dsp(phone, tablet);

  static TextStyle get displayLarge => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(36, 42),
    height: 43.2 / 36,
    color: BubbaColors.textHeading,
  );

  static TextStyle get displayLargeAlt =>
      displayLarge.copyWith(color: BubbaColors.textHeadingAlt);

  static TextStyle get displayMedium => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(24, 28),
    height: 1.2,
    color: BubbaColors.actionDark,
  );

  static TextStyle get displaySmall => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(18, 21),
    height: 21.6 / 18,
    color: BubbaColors.actionDark,
  );

  static TextStyle get body => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    height: 21 / 12,
    color: BubbaColors.textBody,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: BubbaColors.textBodyMuted,
  );

  static TextStyle get error => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    height: 21 / 12,
    color: BubbaColors.textError,
  );

  static TextStyle get legal => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(10, 12),
    color: BubbaColors.textLegal,
  );

  static TextStyle get link => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: BubbaColors.textLink,
  );

  static TextStyle get timer => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: BubbaColors.textTimer,
  );

  static TextStyle get buttonDark => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: BubbaColors.textOnDark,
  );

  static TextStyle get buttonLight => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: BubbaColors.actionDark,
  );

  static TextStyle get rowLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: BubbaColors.actionDark,
  );

  static TextStyle get noticeTitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    color: BubbaColors.actionDark,
  );

  static TextStyle get noticeMessage => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: BubbaColors.textNoticeMuted,
  );

  static TextStyle get countryName => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: BubbaColors.actionDark,
  );

  static TextStyle get searchHint => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    letterSpacing: 0,
    color: const Color(0xFF7C7C80),
  );

  static TextStyle get fieldLabel => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w700,
    fontSize: _size(8, 11),
    color: BubbaColors.textLabel,
  );

  static TextStyle get fieldValue => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    letterSpacing: 0,
    color: BubbaColors.textFieldValue,
  );

  static TextStyle get fieldPlaceholder => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    letterSpacing: 0,
    color: BubbaColors.textPlaceholder,
  );

  static TextStyle get fieldHeading => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: BubbaColors.actionDark,
  );

  static TextStyle get otpDigit => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(24, 28),
    color: BubbaColors.actionDark,
  );

  static TextStyle get ctaDisabled => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: BubbaColors.textDisabled,
  );

  static TextStyle get ctaDisabledPart1 =>
      ctaDisabled.copyWith(color: BubbaColors.textDisabledPart1);

  static TextStyle get ctaEnabled => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: BubbaColors.textOnDark,
  );

  static TextStyle get stepHeading => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(24, 28),
    height: 28.8 / 24,
    color: BubbaColors.textHeadingPart2,
  );

  static TextStyle get stepCounter => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: BubbaColors.textStepCounter,
  );

  static TextStyle get question => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w500,
    fontSize: _size(18, 21),
    height: 1.2,
    color: BubbaColors.textQuestion,
  );

  static TextStyle get chipLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    height: 16.8 / 14,
    color: BubbaColors.chipText,
  );

  static TextStyle get chipLabelSelected => chipLabel.copyWith(
    fontWeight: FontWeight.w700,
    color: BubbaColors.textOnDark,
  );

  static TextStyle get goBack => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: BubbaColors.textGoBack,
  );

  static TextStyle get skipLabel => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: BubbaColors.actionDark,
  );

  /// Wheel rows fade with distance from the selected one: black at the centre,
  /// `#C3C9CF` one row out, `#D9DDE0` beyond that.
  static TextStyle wheelItem(int distanceFromSelected) => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(18, 21),
    color: switch (distanceFromSelected) {
      0 => BubbaColors.actionDark,
      1 => const Color(0xFFC3C9CF),
      _ => const Color(0xFFD9DDE0),
    },
  );

  static TextStyle get navTitle => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: BubbaColors.actionDark,
  );

  static TextStyle get tabSelected => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: const Color(0xFF242725),
  );

  static TextStyle get tabUnselected =>
      tabSelected.copyWith(fontWeight: FontWeight.w400);

  static TextStyle get listRow => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: BubbaColors.actionDark,
  );

  static TextStyle get answerPrompt => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: BubbaColors.actionDark,
  );

  static TextStyle get answerValue => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    letterSpacing: 0,
    color: BubbaColors.actionDark,
  );

  static TextStyle get answerHint =>
      answerValue.copyWith(color: const Color(0xFF8C939D));

  static TextStyle get answerCounter => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    color: BubbaColors.actionDark,
  );

  static TextStyle get changeLink => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(10, 12),
    letterSpacing: d(0.4),
    color: const Color(0xFF224C38),
  );

  static TextStyle get formatTitle => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w700,
    fontSize: _size(18, 21),
    color: const Color(0xFF050505),
  );

  static TextStyle get formatBody => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: const Color(0xFF4C453C),
  );

  static TextStyle get eyebrow => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(10, 12),
    letterSpacing: d(0.5),
    color: const Color(0xFF224C38),
  );

  static TextStyle get slotTitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w800,
    fontSize: _size(14, 17),
    color: const Color(0xFF050505),
  );

  static TextStyle get slotSubtitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: const Color(0xFF050505),
  );

  static TextStyle get selectedPill => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF164E38),
  );

  static TextStyle get segmentSelected => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: const Color(0xFF0C4333),
  );

  static TextStyle get segmentUnselected =>
      segmentSelected.copyWith(color: const Color(0xFF4A4D4F));

  static TextStyle get youAreLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    letterSpacing: d(0.6),
    color: const Color(0xFF1E4732),
  );

  static TextStyle get ageValue => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(24, 28),
    color: const Color(0xFF0A0A0A),
  );

  static TextStyle get inspirationLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF222222),
  );

  static TextStyle get promptChip => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(11, 13),
    color: const Color(0xFF0C0C0C),
  );

  static TextStyle get helper => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: const Color(0xFF63706B),
  );

  static TextStyle get fieldLabelPart2 => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    color: const Color(0xFF222222),
  );

  static TextStyle get fieldLabelOptional =>
      fieldLabelPart2.copyWith(fontWeight: FontWeight.w500);

  static TextStyle get fieldValuePart2 => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(13.59, 16),
    letterSpacing: 0,
    color: BubbaColors.actionDark,
  );

  static TextStyle get fieldPlaceholderPart2 =>
      fieldValuePart2.copyWith(color: BubbaColors.textPlaceholder);

  static TextStyle get stepFieldPlaceholder => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    letterSpacing: 0,
    color: BubbaColors.textPlaceholder,
  );

  static TextStyle get previewLabel => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(10, 12),
    color: const Color(0xFF63706B),
  );

  static TextStyle get previewTitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w800,
    fontSize: _size(14, 17),
    color: const Color(0xFF110D0F),
  );

  static TextStyle get previewSubtitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: const Color(0xFFA0A0A0),
  );

  static TextStyle get sectionLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w600,
    fontSize: _size(12, 14),
    color: const Color(0xFF161A18),
  );

  static TextStyle get searchSectionLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF727272),
  );

  static TextStyle get reassurance => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    height: 18 / 12,
    color: const Color(0xFF4C453C),
  );

  static TextStyle get toggleTitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    color: BubbaColors.actionDark,
  );

  static TextStyle get toggleSubtitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: BubbaColors.textSubtle,
  );

  static TextStyle get goBackCentred => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    color: BubbaColors.textStepCounter,
  );

  static TextStyle get tipsTitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    color: const Color(0xFF224C38),
  );

  static TextStyle get tipsBody => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(10, 12),
    height: 18 / 10,
    color: const Color(0xFF4C453C),
  );

  static TextStyle get reorderHint => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: const Color(0xFF706A64),
  );

  static TextStyle get photoError => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w400,
    fontSize: _size(10, 12),
    color: BubbaColors.errorRed,
  );

  static TextStyle get uploadLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF7F7F7F),
  );

  static TextStyle get uploadCount => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(8, 11),
    color: const Color(0xFF7F7F7F),
  );

  static TextStyle get pickerCancel => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: const Color(0xFF000000),
  );

  static TextStyle get pickerAlbum =>
      pickerCancel.copyWith(fontWeight: FontWeight.w500);

  static TextStyle get pickerNextEnabled => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: BubbaColors.textOnDark,
  );

  static TextStyle get pickerNextDisabled => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: BubbaColors.textDisabled,
  );

  static TextStyle get pickerBadge => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(10, 12),
    color: BubbaColors.textOnDark,
  );

  static TextStyle get previewRetake => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    color: BubbaColors.textOnDark,
  );

  static TextStyle get previewAdd => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: const Color(0xFF000000),
  );

  static TextStyle get albumName => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF000000),
  );

  static TextStyle get albumCount =>
      albumName.copyWith(color: const Color(0xFF78716A));

  static TextStyle get sheetTitle => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(16, 19),
    color: const Color(0xFF000000),
  );

  /// p054 - the edit-profile screen.
  static TextStyle get editSection => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w700,
    fontSize: _size(16, 19),
    color: const Color(0xFF111111),
  );

  static TextStyle get editSectionHint => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: const Color(0xFF111111),
  );

  static TextStyle get editAdded => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(10, 12),
    color: const Color(0xFF000000),
  );

  static TextStyle get editCardEyebrow => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w800,
    fontSize: _size(10, 12),
    letterSpacing: d(0.4),
    color: const Color(0xFF6D6D6D),
  );

  static TextStyle get editCardTitle => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    letterSpacing: d(0.3),
    color: const Color(0xFF224C38),
  );

  static TextStyle get editCardBody => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: const Color(0xFF333333),
  );

  static TextStyle get editRowLabel => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(10, 12),
    letterSpacing: d(0.3),
    color: const Color(0xFF6F6F6F),
  );

  static TextStyle get editRowValue => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: const Color(0xFF111111),
  );

  static TextStyle get editRowVisibility => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF6F6F6F),
  );

  /// p014 / p045 - the edit-photo screen.
  static TextStyle get editDone => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: const Color(0xFF224C38),
  );

  static TextStyle get editMainBadge => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w700,
    fontSize: _size(10, 12),
    letterSpacing: d(0.4),
    color: const Color(0xFF221F20),
  );

  static TextStyle get editOrderBadge => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF000000),
  );

  static TextStyle get editHint => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: const Color(0xFF7A746D),
  );

  static TextStyle get editCaption => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: BubbaColors.textOnDark,
  );

  static TextStyle get editCrop => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF111111),
  );

  /// p027 - a search result row.
  static TextStyle get resultRow => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: const Color(0xFF271C14),
  );

  /// p022 - the birthday confirmation card.
  static TextStyle get confirmTitle => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(18, 21),
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get confirmDate => confirmTitle.copyWith(
    fontWeight: FontWeight.w300,
  );

  static TextStyle get confirmAge => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFFA3A3A3),
  );

  static TextStyle get confirmEdit => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: const Color(0xFF332A20),
  );

  /// p047 - the completion screen.
  static TextStyle get readyEyebrow => TextStyle(
    fontFamily: BubbaFonts.system,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    letterSpacing: d(0.6),
    color: const Color(0xFF224C38),
  );

  static TextStyle get readyHeading => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(36, 42),
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle get readyBody => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: const Color(0xFF4F5857),
  );

  static TextStyle get enterBubba => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: BubbaColors.textOnDark,
  );

  /// p033's "Select education level" heading and its level chips.
  static TextStyle get levelSheetTitle => TextStyle(
    fontFamily: BubbaFonts.display,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: const Color(0xFF000000),
  );

  static TextStyle get levelChip => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: const Color(0xFF000000),
  );

  static TextStyle get levelChipSelected =>
      levelChip.copyWith(fontWeight: FontWeight.w700, color: BubbaColors.textOnDark);

  static TextStyle get sheetRowTitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: _size(14, 17),
    color: const Color(0xFF000000),
  );

  static TextStyle get sheetRowSubtitle => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    color: const Color(0xFF333333),
  );

  static TextStyle get cardKind => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w800,
    fontSize: _size(10, 12),
    letterSpacing: d(0.4),
    color: const Color(0xFF6D6D6D),
  );

  static TextStyle get cardTitle => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w700,
    fontSize: _size(12, 14),
    letterSpacing: d(0.2),
    color: const Color(0xFF224C38),
  );

  static TextStyle get cardBody => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(14, 17),
    height: 16.8 / 14,
    color: const Color(0xFF333333),
  );

  static TextStyle get cardOption => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    height: 18 / 12,
    color: const Color(0xFF333333),
  );

  static TextStyle get cardOptionMarker => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF241F20),
  );

  static TextStyle get cardRankValue => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: _size(12, 14),
    color: const Color(0xFF000000),
  );

  static TextStyle get cardRankMarker => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF221F20),
  );

  static TextStyle get cardOrBadge => TextStyle(
    fontFamily: BubbaFonts.ui,
    fontWeight: FontWeight.w500,
    fontSize: _size(10, 12),
    color: const Color(0xFF241F20),
  );

  static TextStyle get cardOrInline => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(12, 14),
    color: const Color(0xFF74767E),
  );

  static TextStyle get cardFlagLabel => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w800,
    fontSize: _size(11, 13),
    color: const Color(0xFF221F20),
  );

  static TextStyle get cardRateValue => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(18, 21),
    color: const Color(0xFF2A6DB4),
  );

  static TextStyle get cardRateEdge => TextStyle(
    fontFamily: BubbaFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: _size(14, 17),
    color: const Color(0xFF020202),
  );
}
