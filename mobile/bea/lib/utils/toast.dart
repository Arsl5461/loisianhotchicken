import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ToastDuration { short, long }

enum ToastGravity { top, bottom }

class Toast {
  static Duration _getDuration(ToastDuration duration) {
    switch (duration) {
      case ToastDuration.long:
        return const Duration(seconds: 5);
      case ToastDuration.short:
        return const Duration(seconds: 3);
    }
  }

  static SnackPosition _getPosition(ToastGravity gravity) {
    switch (gravity) {
      case ToastGravity.top:
        return SnackPosition.TOP;
      case ToastGravity.bottom:
        return SnackPosition.BOTTOM;
    }
  }

  static void _show({
    required String title,
    required String message,
    required Color titleColor,
    required IconData icon,
    Gradient? gradient,
    ToastDuration duration = ToastDuration.short,
    ToastGravity gravity = ToastGravity.top,
  }) {
    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: AppTextStyles.regular(
          fontFamily: AppFontFamily.playfair,
          fontWeight: AppFontWeight.bold,
          color: titleColor,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.small(
          fontFamily: AppFontFamily.playfair,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
      snackPosition: _getPosition(gravity),
      duration: _getDuration(duration),
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colors.transparent,
      colorText: AppColors.black,
      icon: Icon(icon, color: titleColor),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      /// Gradient background
      backgroundGradient: gradient,

      /// Shadow
      boxShadows: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// SUCCESS
  static void success(
    String message, {
    ToastDuration duration = ToastDuration.short,
    ToastGravity gravity = ToastGravity.top,
  }) {
    _show(
      title: "Success",
      message: message,
      titleColor: AppColors.cFF006A69,
      icon: Icons.check_circle,
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 74, 152, 236),
          Color.fromARGB(255, 29, 45, 221),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      duration: duration,
      gravity: gravity,
    );
  }

  /// ERROR
  static void error(
    String message, {
    ToastDuration duration = ToastDuration.short,
    ToastGravity gravity = ToastGravity.top,
  }) {
    _show(
      title: "Information",
      message: message,
      titleColor: AppColors.cFF006A69,
      icon: Icons.info_outline,
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 74, 152, 236),
          Color.fromARGB(255, 29, 45, 221),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      duration: duration,
      gravity: gravity,
    );
  }

  /// WARNING
  static void warning(
    String message, {
    ToastDuration duration = ToastDuration.short,
    ToastGravity gravity = ToastGravity.top,
  }) {
    _show(
      title: "Warning",
      message: message,
      titleColor: Colors.orange,
      icon: Icons.warning_amber,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      duration: duration,
      gravity: gravity,
    );
  }

  /// INFO
  static void info(
    String message, {
    ToastDuration duration = ToastDuration.short,
    ToastGravity gravity = ToastGravity.top,
  }) {
    _show(
      title: "Information",
      message: message,
      titleColor: AppColors.cFF006A69,
      icon: Icons.info_outline,
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 74, 152, 236),
          Color.fromARGB(255, 29, 45, 221),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      duration: duration,
      gravity: gravity,
    );
  }
}
