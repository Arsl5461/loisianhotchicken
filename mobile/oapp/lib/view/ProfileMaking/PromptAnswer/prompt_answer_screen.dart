import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/routing/app_routes.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PromptAnswerScreen extends StatefulWidget {
  final String prompt;

  const PromptAnswerScreen({super.key, required this.prompt});

  @override
  _PromptAnswerScreenState createState() => _PromptAnswerScreenState();
}

class _PromptAnswerScreenState extends State<PromptAnswerScreen> {
  late TextEditingController _answerController;
  final int maxCharacters = 180;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    _answerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    int currentLength = _answerController.text.length;
    bool canSubmit = currentLength > 0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(20),
            vertical: MediaQueryUtil.spacing(16),
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQueryUtil.spacing(24),
                  ), // Spacer for centering
                  // Title
                  Text(
                    "Answer",
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),

                  // Close button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      LucideIcons.x,
                      size: MediaQueryUtil.spacing(24),
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQueryUtil.spacing(40)),

              // Prompt and input area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prompt text
                    Text(
                      widget.prompt,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(18),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(8)),

                    // Input field
                    Expanded(
                      child: TextField(
                        controller: _answerController,
                        maxLines: null,
                        maxLength: maxCharacters,
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(16),
                          color: AppColors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "As you type your answer",
                          hintStyle: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(16),
                            color: AppColors.grey[500],
                          ),
                          border: InputBorder.none,
                          counterText: '', // Hide default counter
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(16)),

                    // Character counter
                    Text(
                      "$currentLength/$maxCharacters",
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(14),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(20)),

                    // Change prompt button
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          var newPrompt = await Get.toNamed(
                            Routes.PROMPT_SELECTION,
                          );

                          // Navigate to prompt selection and get new prompt
                          // final newPrompt = await Get.push<String>(
                          //   '/prompt-selection',
                          // );
                          if (newPrompt != null) {
                            setState(() {
                              // Update the prompt (this would require rebuilding the widget)
                            });
                          }
                        },
                        child: Text(
                          "CHANGE",
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(12),
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey[500],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(30)),

              // Done button
              SizedBox(
                width: double.infinity,
                height: MediaQueryUtil.spacing(50),
                child: ElevatedButton(
                  onPressed: canSubmit
                      ? () {
                          debugPrint('Answer: ${_answerController.text}');
                          Get.back(result: _answerController.text);
                        }
                      : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSubmit
                        ? AppColors.cFF1A7575
                        : AppColors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQueryUtil.spacing(12),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(16),
                      fontWeight: FontWeight.w600,
                      color: canSubmit ? AppColors.white : AppColors.grey[500],
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(20)),
            ],
          ),
        ),
      ),
    );
  }
}
