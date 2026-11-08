import 'package:OApp/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final TextEditingController _suggestionController = TextEditingController();
  String selectedCategory = 'General';
  bool isSubmitting = false;

  final List<String> categories = [
    'General',
    'Bug Report',
    'Feature Request',
    'UI/UX Feedback',
    'Performance',
    'Account Issues',
    'Other',
  ];

  @override
  void dispose() {
    _suggestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cFFF1DFD5, // light peach
              AppColors.cFFEADFDB, // pale pinkish-beige
              AppColors.cFFDDE4EC, // light bluish-gray
              AppColors.cFFDDE4EC, // repeated to extend the bottom color
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      _buildWelcomeSection(),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Category Selection
                      _buildCategorySection(),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Suggestion Form
                      _buildSuggestionForm(),

                      SizedBox(height: MediaQueryUtil.spacing(32)),

                      // Submit Button
                      _buildSubmitButton(),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // FAQ Section
                      _buildFAQSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(20),
        vertical: MediaQueryUtil.spacing(16),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Get.toNamed(Routes.SETTINGS),
            child: Container(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(8)),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.black87,
                size: MediaQueryUtil.iconSize(20),
              ),
            ),
          ),

          SizedBox(width: MediaQueryUtil.spacing(16)),

          // Title
          Expanded(
            child: Text(
              'Suggestions',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(24),
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
                decoration: BoxDecoration(
                  color: AppColors.cFF1E88E5.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(12),
                  ),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.cFF1E88E5,
                  size: MediaQueryUtil.iconSize(24),
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share Your Ideas',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(18),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black87,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      'Help us improve Oapp with your feedback',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),
          Wrap(
            spacing: MediaQueryUtil.spacing(8),
            runSpacing: MediaQueryUtil.spacing(8),
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                    vertical: MediaQueryUtil.spacing(10),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cFF1E88E5
                        : AppColors.grey[100],
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(20),
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.cFF1E88E5
                          : AppColors.grey[300]!,
                      width: MediaQueryUtil.spacing(1),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(14),
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionForm() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Suggestion',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),
          TextField(
            controller: _suggestionController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText:
                  'Describe your suggestion, feedback, or report a bug...',
              hintStyle: TextStyle(
                color: AppColors.grey[500],
                fontSize: MediaQueryUtil.fontSize(14),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.cFF1E88E5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
                borderSide: BorderSide(color: AppColors.grey[300]!),
              ),
              contentPadding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
            ),
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQueryUtil.dynamicSize(small: 48, medium: 56, large: 64),
      child: ElevatedButton(
        onPressed: isSubmitting ? null : _submitSuggestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cFF1E88E5,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
          ),
          elevation: 0,
        ),
        child: isSubmitting
            ? SizedBox(
                width: MediaQueryUtil.spacing(20),
                height: MediaQueryUtil.spacing(20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                'Submit Suggestion',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: MediaQueryUtil.spacing(10),
            spreadRadius: MediaQueryUtil.spacing(2),
            offset: Offset(0, MediaQueryUtil.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),

          _buildFAQItem(
            'How long does it take to review suggestions?',
            'We typically review all suggestions within 1-2 business days and respond to valuable feedback.',
          ),

          SizedBox(height: MediaQueryUtil.spacing(12)),

          _buildFAQItem(
            'Will I get notified about updates?',
            'Yes! We\'ll notify you via email when your suggestion is implemented or if we need more information.',
          ),

          SizedBox(height: MediaQueryUtil.spacing(12)),

          _buildFAQItem(
            'Can I submit multiple suggestions?',
            'Absolutely! We encourage you to share all your ideas and feedback to help us improve the app.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(14),
            fontWeight: FontWeight.w600,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(4)),
        Text(
          answer,
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(13),
            fontWeight: FontWeight.w400,
            color: AppColors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _submitSuggestion() async {
    if (_suggestionController.text.trim().isEmpty) {
      _showSnackBar('Please enter your suggestion before submitting.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isSubmitting = false;
    });

    _showSuccessDialog();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(8)),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
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
              'Thank You!',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(18),
                fontWeight: FontWeight.w600,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              'Your suggestion has been submitted successfully. We\'ll review it and get back to you soon!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(14),
                fontWeight: FontWeight.w400,
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
                  _suggestionController.clear();
                  setState(() {
                    selectedCategory = 'General';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cFF1E88E5,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(8),
                    ),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(16),
                    fontWeight: FontWeight.w600,
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
