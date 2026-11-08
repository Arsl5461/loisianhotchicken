import 'package:OApp/widgets/ElevatedButton/customElevatedButtom.dart';
import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:OApp/widgets/Input/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SendLikeScreen extends StatefulWidget {
  final String profileName;
  final String imageUrl;

  const SendLikeScreen({
    super.key,
    required this.profileName,
    required this.imageUrl,
  });

  @override
  State<SendLikeScreen> createState() => _SendLikeScreenState();
}

class _SendLikeScreenState extends State<SendLikeScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SizedBox(height: MediaQueryUtil.spacing(50)),
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
                      fontSize: MediaQueryUtil.fontSize(28),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              // Image card - same size as in profile cards (45% screen height)
              Container(
                height: screenHeight * 0.45,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(24),
                  ),
                  child: Base64OrNetworkImage(
                    imageData: widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              // Comment text field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                child: CustomTextField(
                  controller: _commentController,
                  hintText: 'Add a comment',
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.grey[300],
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

              SizedBox(height: MediaQueryUtil.spacing(6)),

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
