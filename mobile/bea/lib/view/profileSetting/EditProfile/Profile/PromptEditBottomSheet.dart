import 'package:OApp/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PromptEditBottomSheet extends StatelessWidget {
  final String question;
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final VoidCallback onSave;

  const PromptEditBottomSheet({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQueryUtil.spacing(40),
                height: MediaQueryUtil.spacing(4),
                margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(20)),
                decoration: BoxDecoration(
                  color: AppColors.grey[300],
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Answer',
                    style: AppTextStyles.large(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      LucideIcons.x,
                      size: MediaQueryUtil.spacing(24),
                      color: AppColors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQueryUtil.spacing(24)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
                decoration: BoxDecoration(
                  color: AppColors.grey[50],
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(12),
                  ),
                  border: Border.all(
                    color: AppColors.grey[300]!,
                    width: MediaQueryUtil.spacing(1),
                  ),
                ),
                child: Text(
                  question.isNotEmpty ? question : 'No question selected',
                  style: AppTextStyles.regular(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.black87,
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(20)),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your Answer',
                  hintText: 'Enter your answer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(12),
                    ),
                  ),
                ),
                controller: TextEditingController(text: answer),
                onChanged: onAnswerChanged,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: MediaQueryUtil.spacing(30)),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.regular(
                          color: AppColors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQueryUtil.spacing(16)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onSave();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cFF006C6A,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQueryUtil.spacing(12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            MediaQueryUtil.spacing(12),
                          ),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQueryUtil.spacing(20)),
            ],
          ),
        ),
      ),
    );
  }
}
