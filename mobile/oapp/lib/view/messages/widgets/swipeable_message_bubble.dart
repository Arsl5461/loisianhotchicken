import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/chat_message_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SwipeableMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final ChatMessageModel? prevMessage;
  final ChatMessageModel? nextMessage;
  final String? currentUserId;
  final void Function(ChatMessageModel) onReply;
  final String? profileImageUrl;

  const SwipeableMessageBubble({
    super.key,
    required this.message,
    required this.prevMessage,
    required this.nextMessage,
    required this.currentUserId,
    required this.onReply,
    this.profileImageUrl,
  });

  bool _isSameSender(ChatMessageModel? a, ChatMessageModel b) {
    if (a == null) return false;
    return a.senderId == b.senderId;
  }

  bool _shouldShowTime() {
    if (prevMessage == null) return true;
    final diff = message.timestamp.difference(prevMessage!.timestamp).inMinutes;
    return diff >= 5;
  }

  bool _isLastInGroup() {
    if (nextMessage == null) return true;
    return nextMessage!.senderId != message.senderId;
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == currentUserId;
    final isSamePrev = _isSameSender(prevMessage, message);
    final isLast = _isLastInGroup();
    final showTime = _shouldShowTime();
    final timeStr = DateFormat('h:mm a').format(message.timestamp);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (isMe && details.primaryVelocity! > 0) {
            onReply(message);
          } else if (!isMe && details.primaryVelocity! < 0) {
            onReply(message);
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTime)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  timeStr,
                  style: AppTextStyles.extraSmall(color: AppColors.grey[700]),
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: isSamePrev ? 2 : 10, bottom: 2),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe && !isSamePrev)
                  Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(right: 6),
                    child: ClipOval(
                      child: Base64OrNetworkImage(
                        imageData: profileImageUrl ??
                            'https://images.unsplash.com/photo-1586907835000-f692bbd4c9e0',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else if (!isMe)
                  const SizedBox(width: 34),
                Flexible(
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(14),
                          vertical: MediaQueryUtil.spacing(10),
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.blueColor
                              : AppColors.grey[350],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomLeft: Radius.circular(isMe ? 14 : 1),
                            bottomRight: Radius.circular(isMe ? 1 : 14),
                          ),
                        ),
                        child: Text(
                          message.message,
                          style: AppTextStyles.verySmall(
                            fontWeight: AppFontWeight.semiBold,
                            fontFamily: AppFontFamily.urbanist,
                            color: isMe ? Colors.white : Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ),
                      if (isMe && isLast)
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 4),
                          child: Text(
                            'Sent',
                            style: AppTextStyles.extraSmall(
                              color: AppColors.grey[500],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
