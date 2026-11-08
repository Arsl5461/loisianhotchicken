import 'package:OApp/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import 'chat_reference_message.dart';
import 'swipeable_message_bubble.dart';

class ChatMessageItem extends StatelessWidget {
  const ChatMessageItem({
    super.key,
    required this.controller,
    required this.message,
    this.previousMessage,
    this.nextMessage,
  });

  final ChatController controller;
  final ChatMessageModel message;
  final ChatMessageModel? previousMessage;
  final ChatMessageModel? nextMessage;

  @override
  Widget build(BuildContext context) {
    if (message.chatType == MessageType.initiatedChat) {
      return ChatReferenceMessage(controller: controller, message: message);
    }

    return Obx(
      () => SwipeableMessageBubble(
        message: message,
        prevMessage: previousMessage,
        nextMessage: nextMessage,
        currentUserId: controller.currentUserId,
        profileImageUrl: controller.profileImageUrl.value,
        onReply: controller.setReply,
      ),
    );
  }
}
