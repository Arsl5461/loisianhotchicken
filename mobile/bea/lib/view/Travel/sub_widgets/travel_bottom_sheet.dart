import 'package:OApp/widget_helper/widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Images/base64OrNetworkImage.dart';
import '../controller/travel_posts_viewer_controller.dart';
import '../models/travel_city_model.dart';
import '../models/travel_post_model.dart';

import 'package:OApp/core/constants/app_colors.dart';

class TravelPostsViewer extends GetView<TravelPostsViewerController> {
  final bool isFullScreen;

  const TravelPostsViewer({super.key, this.isFullScreen = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isReady.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: isFullScreen
              ? BorderRadius.zero
              : const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: !isFullScreen,
          child: Column(
            children: [
              SizedBox(height: MediaQueryUtil.spacing(isFullScreen ? 12 : 8)),
              SizedBox(height: MediaQueryUtil.spacing(isFullScreen ? 12 : 40)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(12),
                  ),
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.posts.length,
                    onPageChanged: controller.onPostChanged,
                    itemBuilder: (context, index) {
                      final post = controller.posts[index];

                      return Column(
                        children: [
                          Expanded(child: _buildImageCard(post, index)),
                          SizedBox(height: MediaQueryUtil.spacing(12)),
                          _buildBottomMeta(post, index),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildImageCard(TravelPostModel post, int postIndex) {
    final List<String> images =
        (post.imageUrls != null && post.imageUrls!.isNotEmpty)
        ? post.imageUrls!
        : ((post.imageUrl != null && post.imageUrl!.isNotEmpty)
              ? [post.imageUrl!]
              : []);

    final imageController = controller.getImageController(postIndex);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: imageController,
              physics: const BouncingScrollPhysics(),
              itemCount: images.isEmpty ? 1 : images.length,
              onPageChanged: (imageIndex) {
                controller.onImageChanged(postIndex, imageIndex);
              },
              itemBuilder: (context, imageIndex) {
                if (images.isEmpty) {
                  return Container(
                    color: AppColors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.grey[500],
                    ),
                  );
                }

                return Base64OrNetworkImage(
                  imageData: images[imageIndex],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          // Gradient overlay should not block swipe gestures
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.black.withValues(alpha: 0.22),
                      AppColors.transparent,
                      AppColors.black.withValues(alpha: 0.18),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQueryUtil.spacing(14),
            left: MediaQueryUtil.spacing(14),
            right: MediaQueryUtil.spacing(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: (post.user?.photos?.isNotEmpty ?? false)
                      ? Base64OrNetworkImage.getImageProvider(
                          post.user!.photos!.first,
                        )
                      : null,
                  backgroundColor: AppColors.white.withValues(alpha: 0.75),
                  child: (post.user?.photos?.isNotEmpty ?? false)
                      ? null
                      : Icon(
                          Icons.person,
                          color: AppColors.grey[700],
                          size: 18,
                        ),
                ),
                SizedBox(width: MediaQueryUtil.spacing(8)),
                Expanded(
                  child: Text(
                    post.user?.fullName ?? 'Story',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.small(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.stopAudio();
                    Get.back();
                  },
                  icon: const Icon(Icons.close, color: AppColors.white),
                ),
              ],
            ),
          ),

          if (images.length > 1)
            Positioned(
              bottom: MediaQueryUtil.spacing(12),
              left: 0,
              right: 0,
              child: Obx(() {
                final currentImageIndex = controller
                    .getImageIndex(postIndex)
                    .value;

                return IgnorePointer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(3),
                        ),
                        width: currentImageIndex == index ? 9 : 7,
                        height: currentImageIndex == index ? 9 : 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentImageIndex == index
                              ? AppColors.white
                              : AppColors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: (post.songUrl != null && post.songUrl!.isNotEmpty)
                ? Obx(
                    () => WidgetHelpers.musicPreviewWidget(
                      textColor: AppColors.white,
                      iconColor: AppColors.white,
                      songUrl: post.songUrl ?? "",
                      songFileName: controller.extractSongName(
                        post.songUrl ?? "",
                      ),
                      audioStatus: controller.audioStatus.value,
                      onToggle: () {
                        controller.toggleState(post.songUrl ?? "");
                      },
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMeta(TravelPostModel post, int index) {
    final replies = post.comments?.length ?? 0;
    final views = (post.views != null && post.views!.isNotEmpty)
        ? post.views!.length
        : post.viewsCount;

    final location = [
      if ((post.city ?? '').isNotEmpty) post.city!,
      if ((post.country ?? '').isNotEmpty) post.country!,
    ].join(', ');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(4)),
      child: Obx(() {
        final isLiked = controller.likedPosts[index];
        final likeCount = controller.likesCount[index];
        final isReplying = controller.replyingPostIndex.value == index;

        return Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.cFF2A8281,
                ),
                SizedBox(width: MediaQueryUtil.spacing(4)),
                Expanded(
                  child: Text(
                    location.isNotEmpty ? location : 'Unknown location',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.small(
                      fontWeight: AppFontWeight.semi,
                      color: AppColors.cFF2A8281,
                    ),
                  ),
                ),
                Text(
                  _timeLabel(post.createdAt),
                  style: AppTextStyles.verySmall(color: AppColors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: MediaQueryUtil.spacing(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _metric(
                  onIconTap: () => controller.onViewsView(post),
                  onTextTap: () => controller.onViewsView(post),
                  icon: Icons.remove_red_eye_outlined,
                  count: views,
                  label: 'views',
                ),
                _metric(
                  icon: Icons.send_outlined,
                  count: replies,
                  onIconTap: () => controller.toggleReplyField(index),
                  onTextTap: () => controller.onRepliesView(post),
                  label: 'replies',
                  color: isReplying ? AppColors.cFF2A8281 : AppColors.black87,
                ),
                _metric(
                  onIconTap: () => controller.toggleLike(index),
                  onTextTap: () => controller.onLikeView(post),
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  count: likeCount,
                  label: 'likes',
                  color: isLiked ? AppColors.red : AppColors.black87,
                ),
              ],
            ),
            if (isReplying) ...[
              SizedBox(height: MediaQueryUtil.spacing(12)),
              _buildReplyField(),
            ],
            SizedBox(height: MediaQueryUtil.spacing(8)),
          ],
        );
      }),
    );
  }

  Widget _buildReplyField() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(10),
        vertical: MediaQueryUtil.spacing(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.replyController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendReply(),
              decoration: const InputDecoration(
                hintText: 'Send message',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            onPressed: controller.sendReply,
            icon: const Icon(Icons.send, color: AppColors.cFF2A8281),
          ),
        ],
      ),
    );
  }

  Widget _metric({
    required IconData icon,
    required int count,
    required String label,
    Color color = AppColors.black87,
    VoidCallback? onTextTap,
    VoidCallback? onIconTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTextTap,
          child: Row(
            children: [
              Text(
                "$count $label",
                style: AppTextStyles.small(
                  fontWeight: AppFontWeight.semiBold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(10)),
        InkWell(
          onTap: onIconTap,
          child: Icon(icon, size: 25, color: color),
        ),
        SizedBox(height: MediaQueryUtil.spacing(4)),
      ],
    );
  }

  String _timeLabel(DateTime? date) {
    if (date == null) return '';

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class CityCard extends StatelessWidget {
  final TravelCity city;

  const CityCard({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Base64OrNetworkImage(
                imageData: city.image ?? '',
                width: width,
                height: height,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                fadeInDuration: const Duration(milliseconds: 200),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.transparent,
                      AppColors.black.withValues(alpha: 0.15),
                      AppColors.black.withValues(alpha: 0.55),
                    ],
                    stops: const [0.45, 0.7, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: MediaQueryUtil.spacing(10),
                right: MediaQueryUtil.spacing(10),
                bottom: MediaQueryUtil.spacing(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      city.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.small(
                        color: AppColors.white,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                    if ((city.postsCount ?? 0) > 0) ...[
                      SizedBox(height: MediaQueryUtil.spacing(2)),
                      Text(
                        '${city.postsCount} ${city.postsCount == 1 ? 'story' : 'stories'}',
                        style: AppTextStyles.extraSmall(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
