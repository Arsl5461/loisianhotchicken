import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One failure surface for every part 4 screen. A save that fails has to say
/// so, and it must not stack: a fast double tap on a dead connection would
/// otherwise queue two identical bars.
void showPrefsError(String? message) {
  if (message == null || message.isEmpty) return;
  if (Get.isSnackbarOpen) return;

  Get.rawSnackbar(
    message: message,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    borderRadius: 10,
    backgroundColor: const Color(0xFF2D2D2D),
  );
}
