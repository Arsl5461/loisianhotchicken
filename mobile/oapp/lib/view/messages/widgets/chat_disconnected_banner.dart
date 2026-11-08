import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/messages/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDisconnectedBanner extends GetView<ChatController> {
  final bool showBanner;

  const ChatDisconnectedBanner({
    super.key,
    required this.showBanner,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showBanner,
      child: Obx(() {
        if (!controller.isConnected.value && !controller.isLoading.value) {
          return Container(
            width: double.infinity,
            color: AppColors.cFF006A68,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(16),
              vertical: MediaQueryUtil.spacing(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: AppColors.white,
                  size: MediaQueryUtil.spacing(16),
                ),
                SizedBox(width: MediaQueryUtil.spacing(8)),
                Text(
                  'Disconnected',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: MediaQueryUtil.fontSize(12),
                  ),
                ),
                SizedBox(width: MediaQueryUtil.spacing(8)),
                TextButton(
                  onPressed: controller.connect,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'RETRY',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQueryUtil.fontSize(12),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
