import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:get/get.dart';
import 'package:OApp/widgets/custom_svg_icons.dart';

import '../../core/routing/app_routes.dart';
import 'choose_location_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

import 'models/travel_city_model.dart';

class NewTravelScreen extends GetView<ChooseLocationController> {
  const NewTravelScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.only(
                left: MediaQueryUtil.spacing(8),
                right: MediaQueryUtil.spacing(8),
                top: MediaQueryUtil.spacing(12),
                bottom: MediaQueryUtil.spacing(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack ?? () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
                      child: CustomSvgIcons.backArrow(
                        color: AppColors.black,
                        size: MediaQueryUtil.iconSize(14),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQueryUtil.spacing(4)),

                  // Obx(() {
                  //   final cities =
                  //       controller.travelCities; // assuming this is RxList

                  //   return buildHeaderAvatar(context, cities);
                  // }),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Explore Cities',
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: MediaQueryUtil.spacing(2)),
                        Text(
                          controller.selectedTravelCity.value.name ??
                              "Select a city",
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(12),
                            color: AppColors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Filter icon
                  InkWell(
                    onTap: () {
                      controller.homeController.isTraveliingPreference.value =
                          true;
                      Get.toNamed(Routes.PREFERENCE_MAIN);
                    },
                    child: Container(
                      padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
                      child: CustomSvgIcons.filter(
                        color: AppColors.black,
                        size: MediaQueryUtil.iconSize(14),
                      ),
                    ),
                    // Icon(
                    //   Icons.tune,
                    //   size: MediaQueryUtil.iconSize(20),
                    //   color: AppColors.black,
                    // ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(height: 1, color: AppColors.grey),

            SizedBox(height: MediaQueryUtil.spacing(14)),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getPostsByCityId(
                    controller.selectedTravelCity.value.cityId ?? "",
                  ); // refresh API
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final spacing = MediaQueryUtil.spacing(12);
                      final aspect = 0.65;

                      return Obx(
                        () => GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                                childAspectRatio: aspect,
                              ),
                          itemCount: controller.getCityPosts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.showTravelPostsViewer([
                                  controller.getCityPosts[index]
                                      .toTravelPostModel(),
                                ], isOwner: false);
                              },
                              child: _TravelCard(
                                imageUrl:
                                    controller
                                        .getCityPosts[index]
                                        .imageUrls
                                        ?.first ??
                                    '',
                                title:
                                    controller
                                        .getCityPosts[index]
                                        .user
                                        ?.fullName ??
                                    "",
                                subtitle: "24",
                                avatarUrl:
                                    controller
                                        .getCityPosts[index]
                                        .user
                                        ?.photos
                                        ?.first ??
                                    "",
                                showTravelTag: true,
                                showQuestion: false,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildHeaderAvatar(BuildContext context, List<TravelCity> cities) {
    final posts = controller.travelPosts;
    final avatarUrl = controller.headerAvatarUrl(cities, posts);
    return Obx(
      () => controller.isPostLoading.value
          ? SizedBox(
              width: MediaQueryUtil.spacing(32),
              height: MediaQueryUtil.spacing(32),
              child: BlurShimmerPlaceholder(),
            )
          : InkWell(
              onTap: () async {
                final hasPosts = posts.isNotEmpty;

                await controller.showStoryActionSheet();
              },
              child: Stack(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: posts.isNotEmpty
                          ? Border.all(color: AppColors.cFF006A68, width: 2)
                          : null,
                      shape: BoxShape.circle,
                      // gradient: LinearGradient(
                      //   colors: [
                      //     AppColors.cFF006A68,
                      //     AppColors.cFFDFF3F1,
                      //   ],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                    ),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.grey[200],
                            backgroundImage: avatarUrl != null
                                ? Base64OrNetworkImage.getImageProvider(
                                    avatarUrl,
                                  )
                                : null,
                            child: avatarUrl == null
                                ? Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 16,
                                    color: AppColors.grey[600],
                                  )
                                : null,
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
            ),
    );
  }
}

class _TravelCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final bool showTravelTag;
  final String avatarUrl;
  final bool showQuestion;

  const _TravelCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
    this.showTravelTag = false,
    this.showQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // Main content - either image or question
          if (showQuestion)
            // Question card with grey background
            Positioned.fill(
              child: Container(
                color: AppColors.grey[200],
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
                    child: Text(
                      'Does anyone know a good place for drinks?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            // Regular image card
            Positioned.fill(
              child: Base64OrNetworkImage(
                imageData: imageUrl,
                fit: BoxFit.cover,
              ),
            ),

          // Top-left avatar
          Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),

          // Travel tag (top-right)
          if (showTravelTag)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(8),
                  vertical: MediaQueryUtil.spacing(4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Travel',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(10),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey[700],
                  ),
                ),
              ),
            ),

          // Bottom text overlay
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Text(
              '$title, $subtitle',
              style: TextStyle(
                color: showQuestion ? AppColors.black : AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: MediaQueryUtil.fontSize(12),
                shadows: showQuestion
                    ? null
                    : [
                        Shadow(
                          blurRadius: 2,
                          color: AppColors.black.withValues(alpha: 0.7),
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
