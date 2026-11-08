import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/chat_controller.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_bottom_input_section.dart';
import 'widgets/chat_match_header.dart';
import 'widgets/chat_messages_list.dart';

class ChatScreen extends GetWidget<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ChatAppBar(controller: controller),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ChatMatchHeader(controller: controller),
          ),
          Positioned(
            top: MediaQueryUtil.spacing(35),
            left: 0,
            right: 0,
            bottom: 0,
            child: ChatMessagesList(controller: controller),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ChatBottomInputSection(),
          ),
        ],
      ),
    );
  }
}
