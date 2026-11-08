import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widget_helper/loading_helper.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import 'chat_message_item.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: BlurShimmerPlaceholder());
      }

      return Container(
        color: Colors.white,
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.only(
            left: MediaQueryUtil.spacing(16),
            right: MediaQueryUtil.spacing(16),
            top: MediaQueryUtil.spacing(8),
            bottom: MediaQueryUtil.spacing(120),
          ),
          itemCount: controller.messages.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (controller.isLoadingMore.value && index == 0) {
              return _ChatLoadingMoreIndicator();
            }

            final msgIndex =
                controller.isLoadingMore.value ? index - 1 : index;
            final message = controller.messages[msgIndex];
            final previousMessage =
                msgIndex > 0 ? controller.messages[msgIndex - 1] : null;
            final nextMessage = msgIndex < controller.messages.length - 1
                ? controller.messages[msgIndex + 1]
                : null;

            return ChatMessageItem(
              controller: controller,
              message: message,
              previousMessage: previousMessage,
              nextMessage: nextMessage,
            );
          },
        ),
      );
    });
  }
}

class _ChatLoadingMoreIndicator extends StatelessWidget {
  const _ChatLoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: SizedBox(
          height: 4,
          child: GradientIndeterminateProgressBar(height: 4),
        ),
      ),
    );
  }
}
