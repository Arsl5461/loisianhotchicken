import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/messages/controller/chat_controller.dart';
import 'package:OApp/widget_helper/loading_helper.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBottomInputSection extends GetView<ChatController> {
  const ChatBottomInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isValid = controller.isValidTimeRx.value;
      final isLoading = controller.isLoading.value;

      return Column(
        children: [
          if (isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GradientIndeterminateProgressBar(height: 4),
            ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(20),
              child: BlurShimmerPlaceholder(
                height: MediaQueryUtil.spacing(55),
              ),
            )
          else if (isValid)
            const _ChatMessageInputField()
          else
            const _ChatPremiumUpgradeBanner(),
        ],
      );
    });
  }
}

class _ChatPremiumUpgradeBanner extends StatelessWidget {
  const _ChatPremiumUpgradeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQueryUtil.spacing(100),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.c185755,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(25)),
        border: Border.all(color: AppColors.grey[350]!, width: 1),
      ),
      child: Center(
        child: Text(
          'Upgrade To Premium To Extend Match Time And Keep Chatting',
          textAlign: TextAlign.center,
          style: AppTextStyles.small(
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _ChatMessageInputField extends GetView<ChatController> {
  const _ChatMessageInputField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(10)),
      color: Colors.white,
      child: Column(
        children: [
          Obx(() {
            final reply = controller.replyingTo.value;
            if (reply == null) return const SizedBox.shrink();

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(16),
              ),
              padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
              decoration: BoxDecoration(
                color: AppColors.grey[200],
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(8)),
              ),
              child: Row(
                children: [
                  Container(
                    width: MediaQueryUtil.spacing(3),
                    height: MediaQueryUtil.spacing(30),
                    color: AppColors.cFF006C6A,
                  ),
                  SizedBox(width: MediaQueryUtil.spacing(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Replying to',
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(12),
                            fontWeight: FontWeight.w600,
                            color: AppColors.cFF006C6A,
                          ),
                        ),
                        Text(
                          reply.message,
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(13),
                            color: AppColors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: MediaQueryUtil.spacing(18)),
                    onPressed: controller.cancelReply,
                  ),
                ],
              ),
            );
          }),
          Container(
            color: AppColors.transparent,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQueryUtil.spacing(16),
                  MediaQueryUtil.spacing(0),
                  MediaQueryUtil.spacing(16),
                  MediaQueryUtil.spacing(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQueryUtil.spacing(55),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            MediaQueryUtil.spacing(25),
                          ),
                          border: Border.all(
                            color: AppColors.grey[350]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller.messageController,
                          decoration: InputDecoration(
                            fillColor: AppColors.white,
                            hintText: 'Send a message',
                            hintStyle: AppTextStyles.verySmall(
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.grey[500],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(16),
                            color: AppColors.black87,
                          ),
                          onSubmitted: (_) => controller.sendFromInput(),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQueryUtil.spacing(8)),
                    GestureDetector(
                      onTap: controller.sendFromInput,
                      child: Text(
                        'Send',
                        style: AppTextStyles.small(
                          color: AppColors.grey[700],
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
