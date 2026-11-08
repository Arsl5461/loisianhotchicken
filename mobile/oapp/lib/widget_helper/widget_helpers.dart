import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/constants/app_colors.dart' show AppColors;
import '../utils/toast.dart';

enum AudioStatus { idle, loading, playing, error }

class WidgetHelpers {
  static Future<PermissionStatus> requestPermission(
    Permission permission, {
    String? message,
    bool isContext = false,
  }) async {
    final permissionName = permission.toString().split('.').last;
    PermissionStatus status = PermissionStatus.denied;

    final serviceStatus = await permission.isGranted;
    if (!serviceStatus) {
      status = await permission.request();
    } else {
      status = PermissionStatus.granted;
    }

    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      // await openAppSettings();
      bool userConfirmed =
          await Get.dialog<bool>(
            AlertDialog(
              title: Text("$permissionName Permission is Required"),
              content: const Text("Permission is Required"),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          ) ??
          false;

      if (userConfirmed) {
        await openAppSettings();
      } else {
        Toast.error(message ?? "");
      }
    } else if (status == PermissionStatus.limited) {
      status = PermissionStatus.granted;
    }

    return status;
  }

  static Widget musicPreviewWidget({
    required String songUrl,
    required String? songFileName,
    required AudioStatus audioStatus,
    required VoidCallback onToggle,
    VoidCallback? onRemove,
    Color? activeColor,
    Color? inactiveColor,
    Color? textColor,
    Color? iconColor,
  }) {
    if (songUrl.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: audioStatus == AudioStatus.playing
            ? (activeColor ?? AppColors.cFF006A68).withValues(alpha: 0.3)
            : (inactiveColor ?? Colors.black).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.music_note, color: iconColor ?? Colors.black),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              songFileName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          IconButton(
            icon: audioStatus == AudioStatus.playing
                ? Icon(Icons.pause, color: iconColor)
                : Icon(Icons.play_arrow, color: iconColor),
            onPressed: onToggle,
          ),

          if (onRemove != null)
            IconButton(
              icon: Icon(Icons.close, color: iconColor),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
