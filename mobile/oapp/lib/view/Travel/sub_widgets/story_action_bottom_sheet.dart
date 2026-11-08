import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryActionBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required bool hasStory,
    required int storyCount,
    String? avatarUrl,
    required VoidCallback onCreateStory,
    required VoidCallback onViewStory,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        MediaQueryUtil.init(ctx);

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQueryUtil.spacing(12),
              0,
              MediaQueryUtil.spacing(12),
              MediaQueryUtil.spacing(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MainCard(
                  hasStory: hasStory,
                  storyCount: storyCount,
                  avatarUrl: avatarUrl,
                  onCreateStory: () {
                    Get.back();
                    onCreateStory();
                  },
                  onViewStory: () {
                    Get.back();
                    onViewStory();
                  },
                ),
                SizedBox(height: MediaQueryUtil.spacing(10)),
                _CancelCard(onTap: () => Get.back()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MainCard extends StatelessWidget {
  const _MainCard({
    required this.hasStory,
    required this.storyCount,
    required this.avatarUrl,
    required this.onCreateStory,
    required this.onViewStory,
  });

  final bool hasStory;
  final int storyCount;
  final String? avatarUrl;
  final VoidCallback onCreateStory;
  final VoidCallback onViewStory;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        MediaQueryUtil.spacing(20),
        MediaQueryUtil.spacing(16),
        MediaQueryUtil.spacing(20),
        MediaQueryUtil.spacing(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQueryUtil.spacing(40),
            height: MediaQueryUtil.spacing(4),
            decoration: BoxDecoration(
              color: AppColors.grey[300],
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),
          _StoryAvatar(hasStory: hasStory, avatarUrl: avatarUrl),
          SizedBox(height: MediaQueryUtil.spacing(14)),
          Text(
            hasStory ? 'Your travel story' : 'Share your travel story',
            style: AppTextStyles.regular(
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(6)),
          Text(
            hasStory
                ? 'You have $storyCount active ${storyCount == 1 ? 'story' : 'stories'}'
                : 'Post photos and moments from cities you visit',
            textAlign: TextAlign.center,
            style: AppTextStyles.verySmall(color: AppColors.grey[600]),
          ),
          SizedBox(height: MediaQueryUtil.spacing(20)),
          _PrimaryActionButton(
            label: 'Create new story',
            icon: Icons.add_circle_outline,
            onTap: onCreateStory,
          ),
          if (hasStory) ...[
            SizedBox(height: MediaQueryUtil.spacing(10)),
            _SecondaryActionButton(
              label: 'View your $storyCount ${storyCount == 1 ? 'story' : 'stories'}',
              icon: Icons.play_circle_outline,
              onTap: onViewStory,
            ),
          ],
        ],
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.hasStory, required this.avatarUrl});

  final bool hasStory;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasStory
            ? Border.all(color: AppColors.cFF006A68, width: 2.5)
            : Border.all(color: AppColors.grey[300]!, width: 1.5),
      ),
      padding: const EdgeInsets.all(3),
      child: ClipOval(
        child: hasImage
            ? Base64OrNetworkImage(
                imageData: avatarUrl!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              )
            : ColoredBox(
                color: AppColors.cFFDFF3F1,
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: AppColors.cFF006A68,
                  size: MediaQueryUtil.iconSize(28),
                ),
              ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cFF006A68,
      borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(14)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(14)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              SizedBox(width: MediaQueryUtil.spacing(8)),
              Text(
                label,
                style: AppTextStyles.small(
                  color: AppColors.white,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cFFDFF3F1,
      borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(14)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(14)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.cFF006A68, size: 20),
              SizedBox(width: MediaQueryUtil.spacing(8)),
              Text(
                label,
                style: AppTextStyles.small(
                  color: AppColors.cFF006A68,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancelCard extends StatelessWidget {
  const _CancelCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(16)),
          child: Text(
            'Cancel',
            textAlign: TextAlign.center,
            style: AppTextStyles.small(
              color: AppColors.grey[700],
              fontWeight: AppFontWeight.semiBold,
            ),
          ),
        ),
      ),
    );
  }
}
