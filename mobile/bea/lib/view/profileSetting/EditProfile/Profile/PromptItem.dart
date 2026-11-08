import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PromptItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool hasContent;
  final bool hasAnswer;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const PromptItem({
    this.backgroundColor,
    super.key,
    required this.question,
    required this.answer,
    required this.hasContent,
    required this.hasAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Container(
      color: backgroundColor,
      margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(16)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
            border: Border.all(color: AppColors.grey[300]!, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasContent) ...[
                      Text(
                        question,
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(8)),
                      Text(
                        hasAnswer ? answer : 'Enter answer here',
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.regular,
                          color: hasAnswer
                              ? AppColors.black
                              : AppColors.grey[700],
                        ),
                      ),
                    ] else
                      Text(
                        'Add Prompt',
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(8)),
              Icon(
                LucideIcons.chevronRight,
                size: MediaQueryUtil.spacing(16),
                color: AppColors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
