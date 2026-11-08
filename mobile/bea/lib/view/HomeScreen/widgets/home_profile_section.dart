import 'package:OApp/controller/home_controller.dart';
import 'package:OApp/view/HomeScreen/widgets/AboutCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Images/Base64OrNetworkImage.dart';
import '../../profileSetting/models/ice_breaker_model.dart';
import 'ImagePreviewSlider.dart';
import 'datingHeartButton.dart';
import 'home_profile_sheets.dart';
import 'ice_breaker_card.dart';

class HomeProfileSection extends GetView<HomeController> {
  final UserModel currentProfile;
  final BuildContext parentContext;
  final bool showUserView;

  const HomeProfileSection({
    super.key,
    required this.currentProfile,
    required this.parentContext,
    this.showUserView = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQueryUtil.spacing(8)),

        Obx(
          () => ImagePreviewSlider(
            images: currentProfile.photos ?? [],
            selectedIndex: controller.selectedImageIndex.value,
            onImageSelected: (index) {
              controller.selectedImageIndex.value = index;
              final photo = currentProfile.photos?.elementAtOrNull(index);
              if (photo != null) {
                Base64OrNetworkImage.prefetchUrls(
                  context,
                  [photo],
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.82,
                );
              }
              HomeProfileSheets.showImageViewerModal(
                context: context,
                currentProfile: currentProfile,
                controller: controller,
              );
            },
          ),
        ),

        /// ABOUT CARD
        AboutCard(
          age: currentProfile.ages ?? 0,
          location: currentProfile.hometown ?? "",
          user: currentProfile,
        ),

        SizedBox(height: MediaQueryUtil.spacing(3)),

        /// IMAGE + ICEBREAKER LIST
        _buildImageIceBreakerList(context),

        SizedBox(height: MediaQueryUtil.spacing(20)),

        /// RETURN TO TOP
        InkWell(
          onTap: controller.scrollToTop,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward, size: MediaQueryUtil.fontSize(20)),
              SizedBox(width: 5),
              Text(
                'RETURN TO TOP',
                style: AppTextStyles.small(fontWeight: AppFontWeight.semiBold),
              ),
            ],
          ),
        ),

        SizedBox(height: MediaQueryUtil.spacing(20)),
      ],
    );
  }

  /// ================= IMAGE + ICEBREAKER =================
  Widget _buildImageIceBreakerList(BuildContext context) {
    final images = currentProfile.photos ?? [];
    final iceBreakers = controller.getIceBreakers(
      currentProfile.id ?? '',
      currentProfile.iceBreakers ?? [],
    );

    if (images.isEmpty) return const SizedBox();

    final mediaQuery = MediaQuery.of(context);
    final safeHeight =
        mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;

    final cardHeight = safeHeight * 0.83;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        final image = images[index];

        IceBreakerModel? breaker;
        if (iceBreakers.isNotEmpty) {
          breaker = iceBreakers[index % iceBreakers.length];
        }

        return RepaintBoundary(
          child: Column(
            children: [
              Container(
                height: cardHeight,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(4),
                  vertical: MediaQueryUtil.spacing(10),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        MediaQueryUtil.spacing(24),
                      ),
                      child: Base64OrNetworkImage(
                        imageData: image,
                        width: double.infinity,
                        height: cardHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: cardHeight * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(MediaQueryUtil.spacing(24)),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.transparent,
                              AppColors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(visible: showUserView, child: _heartWidget()),
                  ],
                ),
              ),
              if (breaker != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(5),
                  ),
                  child: IceBreakerCard(
                    paddingEnabled: false,
                    showReply: showUserView,
                    prompt: breaker.prompt ?? '',
                    answer: breaker.answer ?? '',
                    onReply: () {
                      HomeProfileSheets.openReplyBottomSheet(
                        item: breaker!,
                        currentProfile: currentProfile,
                        controller: controller,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// ================= HEART =================
  Widget _heartWidget() {
    return Positioned(
      bottom: MediaQueryUtil.spacing(16),
      right: MediaQueryUtil.spacing(16),
      child: HeartWidget(
        heartBorderWidth: 2,
        size: 60,
        width: 60,
        innerCircleScale: 0.98,
        circleBorderWidth: 2,
        circleBorderColor: Colors.white,
        backgroundColor: const Color(0xFFE2E2E2).withValues(alpha: 0.88),

        onTap: () => HomeProfileSheets.openLikeSheet(
          currentProfile: currentProfile,
          controller: controller,
        ),
      ),
    );
  }
}
