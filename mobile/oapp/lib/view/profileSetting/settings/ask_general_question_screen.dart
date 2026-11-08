import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:OApp/widgets/Buttons/customContinueButton.dart';
import 'package:OApp/widgets/Input/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class AskGeneralQuestionScreen extends StatefulWidget {
  const AskGeneralQuestionScreen({super.key});

  @override
  State<AskGeneralQuestionScreen> createState() =>
      _AskGeneralQuestionScreenState();
}

class _AskGeneralQuestionScreenState extends State<AskGeneralQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _questionFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isQuestionFocused = false;

  @override
  void initState() {
    super.initState();
    _questionFocusNode.addListener(() {
      setState(() {
        _isQuestionFocused = _questionFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _emailController.dispose();
    _questionFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              // Header
              EditProfileHeader(
                title: 'Ask a general question',
                onBack: () => Get.back(),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Question Field
                      Text(
                        'Ask us anything',
                        style: AppTextStyles.verySmall(
                          color: AppColors.grey[600],
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(8)),
                      _buildQuestionTextField(),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Email Field
                      Text(
                        'Preferred email',
                        style: AppTextStyles.verySmall(
                          color: AppColors.grey[600],
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(8)),
                      _buildEmailTextField(),

                      SizedBox(height: MediaQueryUtil.spacing(80)),

                      // Photo Upload Section
                      Text(
                        'Add supporting photos',
                        style: AppTextStyles.verySmall(
                          color: AppColors.grey[600],
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(8)),
                      _buildPhotoUploadSection(),

                      SizedBox(height: MediaQueryUtil.spacing(20)),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              _buildActionButtons(),
              SizedBox(height: MediaQueryUtil.spacing(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTextField() {
    return Container(
      height: MediaQueryUtil.spacing(150),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isQuestionFocused
              ? AppColors.cFF006C6A
              : AppColors.grey[300]!,
          width: _isQuestionFocused ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _questionController,
        focusNode: _questionFocusNode,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
          border: InputBorder.none,
        ),
        style: AppTextStyles.small(color: AppColors.black),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return CustomTextField(
      controller: _emailController,
      hintText: '',
      keyboardType: TextInputType.emailAddress,
      borderRadius: 8,
      borderColor: AppColors.grey[300],
      focusColor: AppColors.cFF006C6A,
    );
  }

  Widget _buildPhotoUploadSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            // Placeholder for photo selection logic
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Add photo ${index + 1}')));
          },
          child: Container(
            width: MediaQueryUtil.spacing(70),
            height: MediaQueryUtil.spacing(65),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey[300]!),
            ),
            child: Icon(
              Icons.add,
              size: MediaQueryUtil.spacing(24),
              color: AppColors.grey[600],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
      child: Column(
        children: [
          // Submit button
          SizedBox(
            height: MediaQueryUtil.spacing(50),
            child: CustomContinueButton(
              text: 'Submit',
              backgroundColor: AppColors.cFF30AEAE,
              onPressed: _submitQuestion,
              borderRadius: 8,
              textStyle: AppTextStyles.small(
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),

          SizedBox(height: MediaQueryUtil.spacing(6)),

          // Cancel button
          SizedBox(
            width: double.infinity,
            height: MediaQueryUtil.spacing(50),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cFFDDDCDB,
                foregroundColor: AppColors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.small(
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitQuestion() {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your question before submitting.'),
          backgroundColor: AppColors.red[600],
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email address before submitting.'),
          backgroundColor: AppColors.red[600],
        ),
      );
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: MediaQueryUtil.iconSize(32),
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(16)),
            Text(
              'Question Submitted!',
              style: AppTextStyles.medium(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              'We\'ve received your question and will get back to you at ${_emailController.text} within 24 hours.',
              textAlign: TextAlign.center,
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.regular,
                color: AppColors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(24)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  _questionController.clear();
                  _emailController.clear();
                  Get.offNamed(Routes.CONTACT_US);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cFF4A90E2,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(8),
                    ),
                  ),
                ),
                child: Text(
                  'Done',
                  style: AppTextStyles.regular(
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
