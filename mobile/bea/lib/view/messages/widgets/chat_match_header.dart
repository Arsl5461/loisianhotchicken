import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/chat_controller.dart';
import 'chat_disconnected_banner.dart';

class ChatMatchHeader extends StatelessWidget {
  const ChatMatchHeader({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: MediaQueryUtil.spacing(4)),
          Divider(height: 2, color: AppColors.grey[300]),
          SizedBox(height: MediaQueryUtil.spacing(14)),
          Obx(() {
            final id = controller.targetUserId.value;
            if (id.isEmpty) return const SizedBox();

            final match = controller.chatlistController.matches
                .firstWhereOrNull((m) => m.userId == id);

            if (match == null) return const SizedBox();

            String formatted = '';
            String time = '';
            try {
              final date = DateTime.parse(match.matchedAt);
              formatted = DateFormat('MM/dd/yy').format(date);
              time = DateFormat('h:mm a').format(date);
            } catch (_) {
              formatted = match.matchedAt;
            }

            return Container(
              color: AppColors.transparent,
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Matched $formatted',
                    style: AppTextStyles.extraSmall(
                      color: AppColors.grey[600],
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                  Text(
                    time,
                    style: AppTextStyles.extraSmall(
                      color: AppColors.grey[600],
                      fontWeight: AppFontWeight.regular,
                    ),
                  ),
                ],
              ),
            );
          }),
          const ChatDisconnectedBanner(showBanner: false),
        ],
      ),
    );
  }
}
