import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../../widgets/Layout/EditProfileHeader.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  String selectedCategory = 'General Inquiry';
  bool isSubmitting = false;

  final List<String> categories = [
    'General Inquiry',
    'Account Issues',
    'Technical Problems',
    'Billing Questions',
    'Safety Concerns',
    'Feature Request',
    'Bug Report',
    'Other',
  ];

  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'How do I reset my password?',
      'answer':
          'Go to the login screen and tap "Forgot Password". Enter your email address and follow the instructions sent to your email.',
    },
    {
      'question': 'How do I delete my account?',
      'answer':
          'Go to Settings > Account > Delete Account. Please note that this action cannot be undone.',
    },
    {
      'question': 'How do I report inappropriate behavior?',
      'answer':
          'Tap the three dots on any profile or message, then select "Report". Our team will review your report within 24 hours.',
    },
    {
      'question': 'How do I change my location?',
      'answer':
          'Go to Settings > Location and update your current location. Make sure location services are enabled.',
    },
    {
      'question': 'Why can\'t I see my matches?',
      'answer':
          'Check your internet connection and try refreshing the app. If the problem persists, contact our support team.',
    },
    {
      'question': 'How do I upgrade to Premium?',
      'answer':
          'Go to Settings > Subscription Plan and choose your preferred plan. You can also access this from the profile page.',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
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
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     AppColors.cFFF1DFD5, // light peach
          //     AppColors.cFFEADFDB, // pale pinkish-beige
          //     AppColors.cFFDDE4EC, // light bluish-gray
          //     AppColors.cFFDDE4EC, // repeated to extend the bottom color
          //   ],
          // ),
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

                      // Quick Actions
                      _buildQuickActions(),

                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      // Contact Form
                      _buildContactForm(),

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
    return EditProfileHeader(
      title: 'Support',
      onBack: () => Get.back(),
      showCloseButton: false,
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
                  Icons.support_agent,
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
                      'We\'re Here to Help',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(18),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black87,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      'Get assistance with your account and app experience',
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

  Widget _buildQuickActions() {
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
            'Quick Actions',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'FAQ',
                  Icons.help_outline,
                  AppColors.cFF4CAF50,
                  () => _scrollToFAQ(),
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(12)),
              Expanded(
                child: _buildQuickActionButton(
                  'Contact',
                  Icons.email_outlined,
                  AppColors.cFF2196F3,
                  () => _scrollToContactForm(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: MediaQueryUtil.iconSize(24)),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              title,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(14),
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
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
            'Contact Support',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),

          // Category Selection
          Text(
            'Category',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              fontWeight: FontWeight.w500,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(8)),
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
                    horizontal: MediaQueryUtil.spacing(12),
                    vertical: MediaQueryUtil.spacing(8),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cFF1E88E5
                        : AppColors.grey[100],
                    borderRadius: BorderRadius.circular(
                      MediaQueryUtil.spacing(16),
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
                      fontSize: MediaQueryUtil.fontSize(12),
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: MediaQueryUtil.spacing(16)),

          // Message Input
          Text(
            'Message',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(14),
              fontWeight: FontWeight.w500,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(8)),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe your issue or question...',
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
        onPressed: isSubmitting ? null : _submitSupportRequest,
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
                'Send Message',
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
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(16)),

          ...faqItems.map(
            (faq) => Column(
              children: [
                _buildFAQItem(faq['question'], faq['answer']),
                if (faq != faqItems.last)
                  SizedBox(height: MediaQueryUtil.spacing(16)),
              ],
            ),
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
        SizedBox(height: MediaQueryUtil.spacing(8)),
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

  void _scrollToFAQ() {
    // Scroll to FAQ section
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToContactForm() {
    // Scroll to contact form
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _submitSupportRequest() async {
    if (_messageController.text.trim().isEmpty) {
      _showSnackBar('Please enter your message before submitting.');
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
              'Message Sent!',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(18),
                fontWeight: FontWeight.w600,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(8)),
            Text(
              'We\'ve received your support request. Our team will get back to you within 24 hours.',
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
                  _messageController.clear();
                  setState(() {
                    selectedCategory = 'General Inquiry';
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
