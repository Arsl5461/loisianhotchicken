import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/global_service.dart';

/// One failure surface for parts 3 and 5. A settings write that fails has to
/// say so, and stacking bars on a dead connection helps nobody.
void showSettingsError(String? message) {
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

String? settingsProfilePhotoUrl() {
  if (!Get.isRegistered<GlobalService>()) return null;
  final photos = Get.find<GlobalService>().getUserModel()?.photos;
  if (photos == null || photos.isEmpty) return null;
  final first = photos.first.trim();
  return first.isEmpty ? null : first;
}
