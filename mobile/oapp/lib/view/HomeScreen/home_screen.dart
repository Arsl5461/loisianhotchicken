import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/HomeScreen/widgets/home_profile_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../widgets/Images/Base64OrNetworkImage.dart';
import '../profileSetting/DatingPrefernecs/datingprefererncemain.dart';
import 'widgets/DatingProfileHeader.dart';

import 'package:OApp/core/constants/app_colors.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  Future<void> _openPreferences() async {
    await Get.to(() => DatingPreferencesMain());
    await controller.loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final mediaQuery = MediaQuery.of(context);
    final safeHeight =
        mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final cardHeight = safeHeight * 0.82;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(2)),
        child: Column(
          children: [
            DatingProfileHeader(
              onBackTap: controller.showReferralRewardIfApplicable,
              onFilterTap: _openPreferences,
            ),
            Expanded(
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                final hasProfiles = controller.data.isNotEmpty;
                final profile = controller.currentProfile;

                if (!hasProfiles && !isLoading) {
                  return RefreshIndicator(
                    onRefresh: controller.loadPosts,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: mediaQuery.size.height,
                        child: Column(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQueryUtil.spacing(24),
                              ),
                              child: Text(
                                controller.emptyFeedMessage.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.grey[700],
                                  fontSize: MediaQueryUtil.fontSize(15),
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(20)),
                            TextButton(
                              onPressed: _openPreferences,
                              child: const Text('Adjust dating preferences'),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (isLoading || profile == null) {
                  return Center(child: BlurShimmerPlaceholder());
                }

                return HomeProfileContent(
                  key: ValueKey(profile.id),
                  controller: controller,
                  profile: profile,
                  cardHeight: cardHeight,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
