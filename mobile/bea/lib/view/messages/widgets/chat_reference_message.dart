import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/chat_message_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/HomeScreen/widgets/ice_breaker_card.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';

import '../controller/chat_controller.dart';
import 'stacked_message_bubble.dart';

class ChatReferenceMessage extends StatelessWidget {
  const ChatReferenceMessage({
    super.key,
    required this.controller,
    required this.message,
  });

  final ChatController controller;
  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final like = message.initiatedFromLike;
    if (like == null) return const SizedBox.shrink();

    final bool isMe = message.senderId == controller.currentUserId;
    final double cardWidth = MediaQueryUtil.width * 0.72;
    final double bubbleWidth = cardWidth * 0.35;

    final String imageUrl = isMe
        ? (controller.profileImageUrl.value ??
              'https://images.unsplash.com/photo-1586907835000-f692bbd4c9e0?q=80&w=1922&auto=format&fit=crop')
        : controller.profileController.user.value?.photos?.first ??
              'https://images.unsplash.com/photo-1586907835000-f692bbd4c9e0?q=80&w=1922&auto=format&fit=crop';
    final String overlayLikeText = isMe
        ? "You Liked ${controller.name.value}'s Photo"
        : "${controller.name.value} Liked your Photo";

    late final Widget referenceCard;
    late final String overlayText;

    if (like.isReply == true && like.icebreaker != null) {
      referenceCard = ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IceBreakerCard(
          paddingCard: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(8),
            vertical: MediaQueryUtil.spacing(16),
          ),
          promptTextStyle: AppTextStyles.text(
            customSize: 9,
            color: AppColors.grey[700],
            fontWeight: AppFontWeight.regular,
          ),
          answerTextStyle: AppTextStyles.verySmall(
            fontWeight: AppFontWeight.semi,
            color: AppColors.black,
          ),
          dividerColor: AppColors.grey[350],
          borderColor: AppColors.grey[350],
          backgroundColor: AppColors.white,
          paddingEnabled: false,
          prompt: '  ${like.icebreaker?.prompt}',
          answer: like.toUserIcebreakerAnswer ?? '',
        ),
      );
      overlayText = like.reply ?? '';
    } else if (like.isComment == true || like.comment != null) {
      referenceCard = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        child: Base64OrNetworkImage(
          imageData: imageUrl,
          width: cardWidth,
          height: MediaQueryUtil.height * 0.24,
          fit: BoxFit.cover,
        ),
      );
      overlayText = like.comment ?? message.message;
    } else {
      referenceCard = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        child: Base64OrNetworkImage(
          imageData: imageUrl,
          width: cardWidth,
          height: MediaQueryUtil.height * 0.24,
          fit: BoxFit.cover,
        ),
      );
      overlayText = overlayLikeText;
    }

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQueryUtil.spacing(8),
        bottom: MediaQueryUtil.spacing(54),
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: SizedBox(
          width: cardWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: isMe ? 0 : MediaQueryUtil.spacing(16),
                  right: isMe ? MediaQueryUtil.spacing(16) : 0,
                ),
                child: referenceCard,
              ),
              Positioned(
                bottom: -MediaQueryUtil.spacing(75),
                left: isMe ? null : 0,
                right: isMe ? 0 : null,
                child: SizedBox(
                  height: MediaQueryUtil.spacing(100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StackedMessageBubble(
                        text: overlayText,
                        isMe: isMe,
                        maxWidth: bubbleWidth,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
