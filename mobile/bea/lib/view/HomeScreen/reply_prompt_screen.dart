import 'package:OApp/widgets/ElevatedButton/customElevatedButtom.dart';
import 'package:OApp/widgets/Input/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ReplyPromptScreen extends StatefulWidget {
  final String profileName;
  final String promptLabel;
  final String promptText;

  const ReplyPromptScreen({
    super.key,
    required this.profileName,
    required this.promptLabel,
    required this.promptText,
  });

  @override
  _ReplyPromptScreenState createState() => _ReplyPromptScreenState();
}

class _ReplyPromptScreenState extends State<ReplyPromptScreen> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SizedBox(height: MediaQueryUtil.spacing(160)),

              // Profile name at top
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                  vertical: MediaQueryUtil.spacing(8),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.profileName,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(24),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Prompt card
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
                decoration: BoxDecoration(
                  color: AppColors.cFFECEBEB,
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.15),
                      offset: Offset(-3, 3),
                      blurRadius: 4,
                      spreadRadius: -1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Prompt label
                    Text(
                      widget.promptLabel,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(14),
                        color: AppColors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(12)),
                    // Prompt text
                    Text(
                      widget.promptText,
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(16),
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(60)),

              // Reply input field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                child: CustomTextField(
                  controller: _replyController,
                  hintText: 'Reply to prompt',
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.cFF01696A, // Teal color
                  borderRadius: 12,
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Send like button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                child: SizedBox(
                  height: MediaQueryUtil.spacing(55),
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Send like',
                    onPressed: () {
                      // Handle send like action
                      Get.back();
                    },
                    backgroundColor: AppColors.cFF01696A, // Teal color
                    textColor: AppColors.white,
                    borderRadius: 30,
                    textSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Cancel button
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
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
