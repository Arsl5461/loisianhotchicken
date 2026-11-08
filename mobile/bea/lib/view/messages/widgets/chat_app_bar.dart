import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/extenshions/duration_extenshion.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, required this.controller});

  final ChatController controller;

  @override
  Size get preferredSize => Size.fromHeight(MediaQueryUtil.spacing(100));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      toolbarHeight: MediaQueryUtil.spacing(100),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.black,
          size: MediaQueryUtil.spacing(19),
          fontWeight: FontWeight.w700,
        ),
        onPressed: Get.back,
      ),
      title: Column(
        spacing: 2,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: controller.heroTag,
            child: Container(
              width: MediaQueryUtil.spacing(50),
              height: MediaQueryUtil.spacing(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: Obx(
                () =>
                    (controller.profileImageUrl.value != null &&
                        (controller.profileImageUrl.value?.isNotEmpty ?? false))
                    ? ClipOval(
                        child: Base64OrNetworkImage(
                          imageData:
                              controller.profileImageUrl.value ??
                              'https://images.unsplash.com/photo-1586907835000-f692bbd4c9e0?q=80&w=1922&auto=format&fit=crop',
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          Obx(
            () => Text(
              controller.name.value,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular(
                color: AppColors.black,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
          Obx(() {
            if (controller.isOtherUserTyping.value) {
              return Text(
                '${controller.name.value} is typing...',
                style: AppTextStyles.verySmall(
                  color: AppColors.cFF006A68,
                  fontWeight: AppFontWeight.semiBold,
                ),
              );
            }

            final id = controller.targetUserId.value;
            final contact = id.isEmpty
                ? null
                : controller.chatlistController.contacts.firstWhereOrNull(
                    (c) => c.id == id,
                  );
            final remaining = contact?.timeRemainingMatch;

            if (remaining == null || remaining >= const Duration(hours: 24)) {
              return const SizedBox.shrink();
            }

            if (remaining <= Duration.zero) {
              return Text(
                'Match Expired',
                style: AppTextStyles.verySmall(
                  color: AppColors.redAccent,
                  fontWeight: AppFontWeight.semi,
                ),
              );
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: MediaQueryUtil.fontSize(18),
                  color: AppColors.grey[600],
                ),
                SizedBox(width: MediaQueryUtil.spacing(6)),
                Text(
                  remaining.toHoursMinutesColon(),
                  style: AppTextStyles.verySmall(
                    color: AppColors.grey[700],
                    fontWeight: AppFontWeight.regular,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      actions: [
        InkWell(
          onTap: controller.showCupertinoDialog,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Base64OrNetworkImage(
              imageData: 'assets/svg/dots_horizontal_more.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
