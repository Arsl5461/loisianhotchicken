import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:OApp/widgets/custom_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'choose_location_controller.dart';
import 'sub_widgets/travel_bottom_sheet.dart';

class ChooseLocationScreen extends GetView<ChooseLocationController> {
  const ChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    final gridSpacing = MediaQueryUtil.spacing(14);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.cFF006A68,
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            controller: controller.scrollcontroller,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeader(context),
                    SizedBox(height: MediaQueryUtil.spacing(8)),
                    Container(height: 1, color: AppColors.black12),
                    SizedBox(height: MediaQueryUtil.spacing(8)),
                    Obx(
                      () => _buildCurrentLocationOption(
                        controller.selectedCity.value,
                        !controller.isLocationNeeded(),
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(16)),
                    Obx(
                      () => controller.isLocationNeeded()
                          ? Column(
                              children: [
                                _buildShareLocationBox(),
                                SizedBox(height: MediaQueryUtil.spacing(16)),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    _buildPopularCitiesHeading(),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isLoading.value &&
                    controller.travelCities.isEmpty) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: gridSpacing),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: gridSpacing,
                        mainAxisSpacing: gridSpacing,
                        childAspectRatio: 0.92,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, __) => ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: const BlurShimmerPlaceholder(),
                        ),
                        childCount: 6,
                      ),
                    ),
                  );
                }

                final cities = controller.travelCities;
                if (cities.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(MediaQueryUtil.spacing(24)),
                        child: Text(
                          'No cities with stories yet.\nPull down to refresh.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.small(
                            color: AppColors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    gridSpacing,
                    0,
                    gridSpacing,
                    MediaQueryUtil.spacing(24),
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: gridSpacing,
                      mainAxisSpacing: gridSpacing,
                      childAspectRatio: 0.92,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final city = cities[index];
                      return RepaintBoundary(
                        child: GestureDetector(
                          onTap: () => controller.updateLocation(city),
                          child: CityCard(city: city),
                        ),
                      );
                    }, childCount: cities.length),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(12),
      ),
      child: Row(
        children: [
          Obx(() {
            final posts = controller.travelPosts;
            final avatarUrl = controller.headerAvatarUrl(
              controller.travelCities,
              posts,
            );

            if (controller.isPostLoading.value) {
              return SizedBox(
                width: MediaQueryUtil.spacing(40),
                height: MediaQueryUtil.spacing(40),
                child: const BlurShimmerPlaceholder(borderRadius: 20),
              );
            }

            return InkWell(
              onTap: controller.showStoryActionSheet,
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: posts.isNotEmpty
                          ? Border.all(color: AppColors.cFF006A68, width: 2)
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: avatarUrl != null && avatarUrl.isNotEmpty
                              ? Base64OrNetworkImage(
                                  imageData: avatarUrl,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                )
                              : ColoredBox(
                                  color: AppColors.grey[200]!,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 16,
                                    color: AppColors.grey[600],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 10,
                        color: AppColors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(width: MediaQueryUtil.spacing(8)),
          Expanded(
            child: Center(
              child: Text(
                'Explore Cities',
                style: AppTextStyles.regular(
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              controller.homeController.isTraveliingPreference.value = true;
              Get.toNamed(Routes.PREFERENCE_MAIN);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
              child: CustomSvgIcons.filter(
                color: AppColors.black,
                size: MediaQueryUtil.iconSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationOption(
    String? selectedCity,
    bool isLocationGranted,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(8)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.searchPostedCities,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Icon(
                    !controller.isNearbyFilter.value
                        ? Icons.my_location
                        : Icons.location_on,
                    color: AppColors.cFF619295,
                    size: MediaQueryUtil.iconSize(12),
                  ),
                  SizedBox(width: MediaQueryUtil.spacing(4)),
                  Expanded(
                    child: Text(
                      !controller.isNearbyFilter.value
                          ? 'Use current location'
                          : controller.country.value.isNotEmpty
                          ? 'Current location: ${controller.country.value}'
                          : 'Latitude: ${controller.latitude.value.toStringAsFixed(2)}, '
                                'Longitude: ${controller.longitude.value.toStringAsFixed(2)}',
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.cFF2A8281,
                      ).copyWith(letterSpacing: -0.5),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.LOCATIONS_MODAL),
            child: Text(
              selectedCity != null && selectedCity.isNotEmpty
                  ? 'Change city'
                  : 'Search city',
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semi,
                color: AppColors.cFF2A8281,
              ).copyWith(letterSpacing: -0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareLocationBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(16)),
      child: Container(
        padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
        decoration: BoxDecoration(
          color: AppColors.cFFDFF3F1,
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  controller.latitude.value =
                      ChooseLocationController.fallbackLat;
                  controller.longitude.value =
                      ChooseLocationController.fallbackLng;
                },
                child: Icon(
                  Icons.close,
                  size: MediaQueryUtil.iconSize(18),
                  color: AppColors.grey[600],
                ),
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(4)),
            Text(
              'Share your location',
              textAlign: TextAlign.center,
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(4)),
            Text(
              'Provide location in phone settings to access Travel mode.',
              textAlign: TextAlign.center,
              style: AppTextStyles.verySmall(
                fontWeight: AppFontWeight.regular,
                color: AppColors.grey[600],
              ).copyWith(letterSpacing: 0.9),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.requestPermissionAndSetLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cFF006A68,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQueryUtil.spacing(4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(30),
                    ),
                  ),
                ),
                child: Text(
                  'Share location',
                  style: AppTextStyles.small(
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularCitiesHeading() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQueryUtil.spacing(16),
        MediaQueryUtil.spacing(8),
        MediaQueryUtil.spacing(16),
        MediaQueryUtil.spacing(12),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Popular cities',
          style: AppTextStyles.regular(
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
