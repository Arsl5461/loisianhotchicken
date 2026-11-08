import 'package:OApp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static bool isDarkMode = false;

  // Primary Colors
  static const Color primaryColor = AppColors.cFF006C6A;
  static const Color accentColor = AppColors.cFF4A90E2;

  // Backgrounds
  static const Color scaffoldBg = AppColors.white;
  static const Color secondaryBg = AppColors.cFFF8F8F8;

  // Text
  static const Color textPrimary = AppColors.black;

  // Borders / Dividers
  static const Color borderColor = AppColors.cFFE5E7E6;

  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: scaffoldBg,

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surfaceTint: Colors.transparent, // 🔥 ADD THIS
      onPrimary: AppColors.white,
      onSurface: textPrimary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: scaffoldBg,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: scaffoldBg,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),

    iconTheme: const IconThemeData(color: textPrimary),

    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),

    dividerColor: borderColor,

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    cardTheme: CardThemeData(
      color: secondaryBg,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  /// Helper Colors

  static Color loadingColor(BuildContext context) {
    return primaryColor;
  }

  static Color border(BuildContext context) {
    return borderColor;
  }

  static Color secondaryBackground(BuildContext context) {
    return secondaryBg;
  }

  static Color accent(BuildContext context) {
    return accentColor;
  }

  static Brightness getIconBrightness(BuildContext context) {
    return Brightness.dark;
  }
}
