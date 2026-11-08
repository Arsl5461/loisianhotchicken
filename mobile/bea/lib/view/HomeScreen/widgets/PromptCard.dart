import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PromptCard extends StatelessWidget {
  final String promptText;
  final VoidCallback? onReplyTap;

  const PromptCard({super.key, required this.promptText, this.onReplyTap});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(10),
        vertical: MediaQueryUtil.spacing(12),
      ),
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.cFFECEBEB,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            offset: Offset(-3, 3), // Shadow to bottom and left
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // First line: "A non-negotiable for me is" on left, "REPLY" on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'A non-negotiable for me is',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    color: AppColors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onReplyTap,
                child: Text(
                  'REPLY',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    color: AppColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQueryUtil.spacing(20)),

          // Second line: Main prompt text
          Text(
            promptText,
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(17),
              color: AppColors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
