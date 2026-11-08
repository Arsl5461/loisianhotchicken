import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';

class StackedMessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final double maxWidth;

  const StackedMessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth * 2.5),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(14),
          vertical: MediaQueryUtil.spacing(10),
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.lightblueColor : const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 1),
            bottomRight: Radius.circular(isMe ? 1 : 16),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.start,
          softWrap: true,
          maxLines: 5,
          overflow: TextOverflow.clip,
          style: AppTextStyles.small(
            fontWeight: AppFontWeight.semi,
            fontFamily: AppFontFamily.urbanist,
            color: Colors.black87,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
