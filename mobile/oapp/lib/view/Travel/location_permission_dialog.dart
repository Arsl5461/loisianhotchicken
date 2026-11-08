import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

/// Location Permission Dialog - Shows permission request for location access
/// - Dialog overlay with teal background
/// - "Share your location" title
/// - Description text
/// - "Share location" button
/// - Close button
class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Dialog(
      backgroundColor: AppColors.transparent,
      child: Container(
        margin: EdgeInsets.all(MediaQueryUtil.spacing(16)),
        padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
        decoration: BoxDecoration(
          color: AppColors.cFFDFF3F1, // Teal background
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close icon (top-right)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    size: MediaQueryUtil.iconSize(18),
                    color: AppColors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            // Title
            Text(
              'Share your location',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(18),
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            // Description
            Text(
              'Provide location in phone settings to access Travel mode.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(14),
                color: AppColors.grey[600],
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(16)),
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle share location action
                  Get.back(); // Close dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cFF006A68, // Dark teal
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQueryUtil.spacing(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(8),
                    ),
                  ),
                ),
                child: Text(
                  'Share location',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
