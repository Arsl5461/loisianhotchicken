import 'package:OApp/controller/your_likes_controller.dart';
import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/pending_likes_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/HomeScreen/widgets/ice_breaker_card.dart';
import 'package:OApp/widgets/ElevatedButton/customElevatedButtom.dart';
import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:OApp/widgets/Navigation/GoBackLink.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YourLikesScreen extends GetView<YourLikesController> {
  const YourLikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.cFFF8F8F8,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Your Likes',
                          style: AppTextStyles.regular(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh,
                            size: MediaQueryUtil.fontSize(25),
                          ),
                          color: AppColors.cFF006C6A,
                          onPressed: controller.onrefresh,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQueryUtil.spacing(20)),
                  _buildTabBar(),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.pendingLikes.isEmpty &&
                    controller.expiredLikes.isEmpty) {
                  return _buildLoadingGrid();
                }

                final isNewLikesTab = controller.selectedTabIndex.value == 0;
                final likes = isNewLikesTab
                    ? controller.pendingLikes
                    : controller.expiredLikes;

                if (likes.isEmpty) {
                  return _buildEmptyState(isNewLikesTab: isNewLikesTab);
                }

                return RefreshIndicator(
                  color: AppColors.cFF006C6A,
                  onRefresh: controller.onrefresh,
                  child: _buildLikesGrid(likes),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQueryUtil.dynamicSize(
          small: 180,
          medium: 200,
          large: 220,
          extraSmall: 160,
          extraLarge: 240,
        ),
        height: MediaQueryUtil.dynamicSize(
          small: 28,
          medium: 32,
          large: 36,
          extraSmall: 26,
          extraLarge: 40,
        ),
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTabItem(index: 0, label: 'New Likes')),
            Expanded(child: _buildTabItem(index: 1, label: 'Expired')),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required int index, required String label}) {
    return GestureDetector(
      onTap: () => controller.setTab(index),
      child: Obx(() {
        final selected = controller.selectedTabIndex.value == index;
        final count = index == 0
            ? controller.pendingLikes.length
            : controller.expiredLikes.length;

        return Container(
          padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(6)),
          decoration: BoxDecoration(
            color: selected ? AppColors.cFF006C6A : AppColors.transparent,
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
          ),
          child: Text(
            '$label ($count)',
            textAlign: TextAlign.center,
            style: AppTextStyles.verySmall(
              color: selected ? AppColors.white : AppColors.black87,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(20)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: MediaQueryUtil.spacing(10),
        mainAxisSpacing: MediaQueryUtil.spacing(12),
        childAspectRatio: 0.68,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => ClipRRect(
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        child: const BlurShimmerPlaceholder(),
      ),
    );
  }

  Widget _buildLikesGrid(List<LikeItemModel> likes) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        MediaQueryUtil.spacing(20),
        0,
        MediaQueryUtil.spacing(20),
        MediaQueryUtil.spacing(20),
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: MediaQueryUtil.spacing(10),
        mainAxisSpacing: MediaQueryUtil.spacing(12),
        childAspectRatio: 0.68,
      ),
      itemCount: likes.length,
      itemBuilder: (context, index) {
        final likeModel = likes[index];
        if (likeModel.user == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => _showLikeModal(likeModel),
          child: _buildProfileCard(likeModel),
        );
      },
    );
  }

  Widget _buildEmptyState({required bool isNewLikesTab}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQueryUtil.dynamicSize(
                small: 80,
                medium: 100,
                large: 120,
                extraSmall: 70,
                extraLarge: 140,
              ),
              height: MediaQueryUtil.dynamicSize(
                small: 80,
                medium: 100,
                large: 120,
                extraSmall: 70,
                extraLarge: 140,
              ),
              decoration: const BoxDecoration(
                color: AppColors.cFFF5E6D3,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNewLikesTab ? Icons.favorite_border : Icons.history,
                size: MediaQueryUtil.dynamicSize(
                  small: 40,
                  medium: 50,
                  large: 60,
                  extraSmall: 35,
                  extraLarge: 70,
                ),
                color: AppColors.cFF006C6A,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(20)),
            Text(
              isNewLikesTab ? 'No likes yet' : 'No expired likes',
              style: AppTextStyles.large(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              isNewLikesTab
                  ? "When someone likes you, they'll appear here"
                  : 'Likes that expired without a match will show up here',
              style: AppTextStyles.small(color: AppColors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (isNewLikesTab) ...[
              SizedBox(height: MediaQueryUtil.spacing(24)),
              SizedBox(
                width: MediaQueryUtil.dynamicSize(
                  small: 200,
                  medium: 220,
                  large: 240,
                  extraSmall: 180,
                  extraLarge: 260,
                ),
                height: MediaQueryUtil.dynamicSize(
                  small: 40,
                  medium: 44,
                  large: 48,
                  extraSmall: 36,
                  extraLarge: 52,
                ),
                child: CustomButton(
                  text: 'Keep Swiping',
                  onPressed: controller.goToHomeTab,
                  backgroundColor: AppColors.cFF006C6A,
                  textColor: AppColors.white,
                  borderRadius: MediaQueryUtil.spacing(12),
                  textSize: MediaQueryUtil.fontSize(14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(LikeItemModel likeModel) {
    final imageUrl = likeModel.user?.photos?.isNotEmpty == true
        ? likeModel.user!.photos!.first
        : '';
    final like = likeModel.initiatedFromLike;
    final name = likeModel.user?.fullName ?? 'Unknown';
    final age = controller.calculateAge(likeModel.user?.dateOfBirth);
    final message = _likeMessage(like);

    return ClipRRect(
      borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.12),
              blurRadius: MediaQueryUtil.spacing(10),
              offset: Offset(0, MediaQueryUtil.spacing(4)),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Base64OrNetworkImage(
              imageData: imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              fadeInDuration: const Duration(milliseconds: 200),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.transparent,
                      AppColors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQueryUtil.spacing(10),
                    MediaQueryUtil.spacing(28),
                    MediaQueryUtil.spacing(10),
                    MediaQueryUtil.spacing(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$name, $age',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.small(
                          color: AppColors.white,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(6)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(8),
                          vertical: MediaQueryUtil.spacing(4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cFFF5E6D3.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(
                            MediaQueryUtil.spacing(8),
                          ),
                        ),
                        child: Text(
                          message,
                          style: AppTextStyles.extraSmall(
                            color: AppColors.black87,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _likeMessage(SendLikeModel? like) {
    if (like?.isReply ?? false) return 'Replied Ice Breaker';
    if (like?.isComment ?? false) return 'Commented on your profile';
    return 'Liked you';
  }

  void _showLikeModal(LikeItemModel like) {
    controller.messageController.clear();
    Get.dialog(_buildLikeModal(like), barrierDismissible: true);
  }

  Widget _buildLikeModal(LikeItemModel likeModel) {
    final like = likeModel.initiatedFromLike;
    final imageUrl = likeModel.user?.photos?.isNotEmpty == true
        ? likeModel.user!.photos!.first
        : '';
    final message = _likeMessage(like);

    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(20),
        vertical: MediaQueryUtil.spacing(40),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: MediaQueryUtil.dynamicSize(
            small: 380,
            medium: 450,
            large: 520,
            extraSmall: 360,
            extraLarge: 580,
          ),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              blurRadius: MediaQueryUtil.spacing(20),
              spreadRadius: MediaQueryUtil.spacing(2),
              offset: Offset(0, MediaQueryUtil.spacing(10)),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (like?.isReply ?? false) ...[
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQueryUtil.spacing(20),
                    left: MediaQueryUtil.spacing(20),
                    right: MediaQueryUtil.spacing(20),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(20),
                    vertical: MediaQueryUtil.spacing(10),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cFFE8F0F3,
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(15),
                    ),
                  ),
                  child: Text(
                    message,
                    style: AppTextStyles.small(
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              SizedBox(height: MediaQueryUtil.spacing(10)),
              SizedBox(
                width: MediaQueryUtil.dynamicSize(
                  small: 300,
                  medium: 360,
                  large: 420,
                  extraSmall: 280,
                  extraLarge: 480,
                ),
                height: MediaQueryUtil.dynamicSize(
                  small: 300,
                  medium: 360,
                  large: 420,
                  extraSmall: 280,
                  extraLarge: 480,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(15),
                  ),
                  child: Base64OrNetworkImage(
                    imageData: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(10)),
              if (like?.isReply ?? false) ...[
                IceBreakerCard(
                  backgroundColor: AppColors.white,
                  otherUserName: likeModel.user?.fullName,
                  reply: like?.reply ?? '',
                  prompt: like?.icebreaker?.prompt ?? '',
                  answer: like?.toUserIcebreakerAnswer ?? '',
                ),
              ],
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey[50],
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(12),
                  ),
                  border: Border.all(color: AppColors.grey[300]!),
                ),
                child: TextField(
                  controller: controller.messageController,
                  onChanged: (val) => controller.messageText.value = val,
                  decoration: InputDecoration(
                    hintText: 'Send a message',
                    hintStyle: TextStyle(
                      color: AppColors.grey[500],
                      fontSize: MediaQueryUtil.fontSize(14),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQueryUtil.spacing(12),
                    ),
                  ),
                  style: AppTextStyles.regular(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.black87,
                  ),
                  maxLines: 1,
                  onSubmitted: (_) {
                    if (controller.messageController.text.trim().isNotEmpty) {
                      controller.goToConversation(
                        profile: likeModel.user!,
                        message: controller.messageText.value,
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(20)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQueryUtil.dynamicSize(
                        small: 48,
                        medium: 52,
                        large: 56,
                        extraSmall: 44,
                        extraLarge: 60,
                      ),
                      child: Obx(
                        () => CustomButton(
                          isDisabled: controller.messageText.value
                              .trim()
                              .isEmpty,
                          text: 'Go to conversation',
                          onPressed: () => controller.goToConversation(
                            profile: likeModel.user!,
                            message: controller.messageText.value,
                          ),
                          backgroundColor: AppColors.cFF006C6A,
                          textColor: AppColors.white,
                          borderRadius: MediaQueryUtil.spacing(12),
                          textSize: MediaQueryUtil.fontSize(16),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(12)),
                    GoBackLink(onTap: controller.closeModal, text: 'Cancel'),
                  ],
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(20)),
            ],
          ),
        ),
      ),
    );
  }
}
