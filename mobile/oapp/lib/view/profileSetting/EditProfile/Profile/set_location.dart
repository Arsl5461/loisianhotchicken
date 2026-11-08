import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../ProfileMaking/profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SetLocationScreen extends GetView<ProfileController> {
  const SetLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFF7FBFA,
      body: SafeArea(
        child: Center(
          child: Obx(
            () => Column(
              spacing: 30,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(24),
                  ),
                  child: SizedBox(
                    height: MediaQueryUtil.spacing(330),
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        MediaQueryUtil.spacing(16),
                      ),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            controller.latitude.value,
                            controller.longitude.value,
                          ),
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("current_location"),
                            position: LatLng(
                              controller.latitude.value,
                              controller.longitude.value,
                            ),
                          ),
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cFFDFF3F1,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                          color: AppColors.black.withValues(alpha: 0.06),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Close
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.close,
                                color: AppColors.grey[700],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Icon bubble
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            size: 28,
                            color: AppColors.cFF006A68,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Share your location',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enable location to show travel mode and nearby matches.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.verySmall(
                            height: 1.3,
                            color: AppColors.grey[700],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Preview
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _row(
                                "Latitude",
                                controller.latitude.value == 0.0
                                    ? "—"
                                    : controller.latitude.value.toStringAsFixed(
                                        6,
                                      ),
                              ),
                              const SizedBox(height: 6),
                              _row(
                                "Longitude",
                                controller.longitude.value == 0.0
                                    ? "—"
                                    : controller.longitude.value
                                          .toStringAsFixed(6),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.setLiveLocation(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cFF006A68,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  )
                                : Text(
                                    'Share location',
                                    style: AppTextStyles.small(
                                      fontWeight: AppFontWeight.semiBold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'We only use it to improve your experience.',
                          style: AppTextStyles.extraSmall(
                            color: AppColors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.verySmall(color: AppColors.grey[800]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.verySmall(
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
