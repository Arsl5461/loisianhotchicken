import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/typography/app_text_styles.dart';

class IceBreakerCard extends StatelessWidget {
  final String prompt;
  final String answer;
  final String? reply;
  final String? otherUserName;
  final VoidCallback? onReply;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? dividerColor;
  final bool showReply;
  final bool paddingEnabled;
  final TextStyle? promptTextStyle;
  final TextStyle? answerTextStyle;
  final TextStyle? replyTextStyle;
  final EdgeInsetsGeometry? paddingCard;

  const IceBreakerCard({
    this.paddingCard,
    this.dividerColor,
    this.promptTextStyle,
    this.answerTextStyle,
    this.replyTextStyle,

    this.borderColor,
    this.backgroundColor,
    this.paddingEnabled = true,
    super.key,
    this.otherUserName,
    required this.prompt,
    required this.answer,
    this.reply,
    this.onReply,
    this.showReply = false,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: paddingEnabled
            ? MediaQueryUtil.spacing(16)
            : MediaQueryUtil.spacing(0),
        vertical: MediaQueryUtil.spacing(12),
      ),
      padding: paddingCard ?? EdgeInsets.all(MediaQueryUtil.spacing(16)),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.ce9e9e4,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        border: showReply
            ? null
            : Border.all(color: borderColor ?? AppColors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top row (Question + Reply)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  prompt,
                  style:
                      promptTextStyle ??
                      AppTextStyles.small(
                        color: AppColors.grey[700],
                        fontWeight: AppFontWeight.semi,
                      ),
                ),
              ),
              if (showReply) ...[
                GestureDetector(
                  onTap: onReply,
                  child: Text(
                    "REPLY",
                    style:
                        replyTextStyle ??
                        AppTextStyles.small(
                          //  fontSize: MediaQueryUtil.fontSize(12),
                          fontWeight: AppFontWeight.semiBold,
                          //  color: Color(0xFF302F2F),
                        ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: MediaQueryUtil.spacing(10)),

          /// Divider
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor ?? AppColors.grey[300],
          ),

          SizedBox(height: MediaQueryUtil.spacing(12)),

          /// Answer
          Text(
            answer,
            style:
                answerTextStyle ??
                AppTextStyles.text(
                  customSize: 16.sp,
                  fontWeight: AppFontWeight.semi,
                  color: AppColors.grey[900],
                ),
          ),

          if (reply != null) ...[
            SizedBox(height: MediaQueryUtil.spacing(12)),
            Divider(
              height: 1,
              thickness: 1,
              color: dividerColor ?? AppColors.grey[300],
            ),

            SizedBox(height: MediaQueryUtil.spacing(12)),

            /// Answer
            Text(
              "${otherUserName ?? "They"}: $reply",
              style: AppTextStyles.verySmall(color: AppColors.grey[700]),
            ),
          ],
        ],
      ),
    );
  }
}
