import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bubba_text_styles.dart';
import 'bubba_tokens.dart';

class BubbaTheme {
  BubbaTheme._();

  static OutlineInputBorder _fieldBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(BubbaMetrics.fieldRadius),
    borderSide: BorderSide(color: color, width: BubbaMetrics.borderWidth),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: false,
    fontFamily: BubbaFonts.body,
    scaffoldBackgroundColor: BubbaColors.screenBg,
    canvasColor: BubbaColors.screenBg,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
      primary: BubbaColors.actionPrimary,
      onPrimary: BubbaColors.textOnDark,
      surface: BubbaColors.surface,
      onSurface: BubbaColors.textBody,
      error: BubbaColors.textError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: BubbaColors.screenBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: BubbaColors.actionDark),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BubbaColors.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      hintStyle: BubbaText.fieldPlaceholder,
      enabledBorder: _fieldBorder(BubbaColors.border),
      focusedBorder: _fieldBorder(BubbaColors.actionPrimary),
      errorBorder: _fieldBorder(BubbaColors.borderError),
      focusedErrorBorder: _fieldBorder(BubbaColors.borderError),
      disabledBorder: _fieldBorder(BubbaColors.border),
      errorStyle: BubbaText.error,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: BubbaColors.actionDark,
      selectionColor: BubbaColors.actionPrimary.withValues(alpha: 0.2),
      selectionHandleColor: BubbaColors.actionPrimary,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: BubbaColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      // The add-photos sheet measures 17% black behind it, not Material's 54%.
      modalBarrierColor: const Color(0x2B000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(BubbaMetrics.sheetRadius),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: BubbaColors.actionPrimary,
      linearTrackColor: BubbaColors.progressTrack,
      linearMinHeight: BubbaMetrics.progressBarStroke,
    ),
    dividerColor: BubbaColors.borderSubtle,
    iconTheme: const IconThemeData(color: BubbaColors.actionDark),
  );
}
