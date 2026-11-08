import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../utils/toast.dart';
import '../../../widgets/ElevatedButton/customElevatedButtom.dart';
import '../../ProfileMaking/profile_making_controller/profile_controller.dart';

class LocationSetupPage extends GetView<ProfileController> {
  const LocationSetupPage({super.key});

  Future<void> _handlePermission() async {
    final ok = await controller.requestPermissionAndSetLocation();

    if (!ok) {
      if (controller.locError.value != null) {
        Toast.warning(controller.locError.value!);
      }
      return;
    }

    if (!await controller.saveLocationToAccount()) {
      Toast.error(controller.locError.value ?? 'Could not save your location');
      return;
    }
    Get.toNamed(Routes.NOTIFICATION_SETUP);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          final isLoading = controller.isLocLoading.value;
          final error = controller.locError.value;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    MediaQueryUtil.spacing(24),
                    MediaQueryUtil.spacing(20),
                    MediaQueryUtil.spacing(24),
                    MediaQueryUtil.spacing(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Great, now we'll need your location",
                        style: AppTextStyles.large(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      Text(
                        "Your location is required to find people nearby",
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.grey[600],
                        ),
                      ),

                      /// ERROR
                      if (error != null) ...[
                        SizedBox(height: MediaQueryUtil.spacing(16)),
                        Container(
                          padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
                          decoration: BoxDecoration(
                            color: AppColors.red[50],
                            borderRadius: BorderRadius.circular(
                              MediaQueryUtil.spacing(8),
                            ),
                            border: Border.all(color: AppColors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.red[700],
                              ),
                              SizedBox(width: MediaQueryUtil.spacing(8)),
                              Expanded(
                                child: Text(
                                  error,
                                  style: AppTextStyles.small(
                                    fontWeight: AppFontWeight.regular,
                                    color: AppColors.red[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      /// DEBUG LAT LNG
                      Row(
                        spacing: 10,
                        children: [
                          Text(
                            "Lat: ${controller.latitude.value}",
                            style: AppTextStyles.verySmall(
                              fontWeight: AppFontWeight.regular,
                              color: AppColors.grey[600],
                            ),
                          ),
                          Text(
                            "Lng: ${controller.longitude.value}",
                            style: AppTextStyles.verySmall(
                              fontWeight: AppFontWeight.regular,
                              color: AppColors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      SizedBox(
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

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      Text(
                        "We use this only to show relevant people and places nearby.",
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: MediaQueryUtil.spacing(24),
                  right: MediaQueryUtil.spacing(24),
                  top: MediaQueryUtil.spacing(16),
                  bottom: keyboardHeight > 0
                      ? keyboardHeight + MediaQueryUtil.spacing(12)
                      : MediaQueryUtil.spacing(24),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: MediaQueryUtil.spacing(58),
                    width: double.infinity,
                    child: isLoading
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColors.cFF006C6A,
                              borderRadius: BorderRadius.circular(
                                MediaQueryUtil.spacing(12),
                              ),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            ),
                          )
                        : CustomButton(
                            text: 'Set location permissions',
                            onPressed: _handlePermission,
                            backgroundColor: AppColors.cFF006C6A,
                            textColor: AppColors.white,
                            borderRadius: MediaQueryUtil.spacing(12),
                            textSize: MediaQueryUtil.fontSize(16),
                          ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
