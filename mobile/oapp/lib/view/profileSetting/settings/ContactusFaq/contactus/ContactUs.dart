import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/routing/app_routes.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  late final List<ContactOption> contactOptions;
  final TextEditingController _paymentIssueController = TextEditingController();
  final TextEditingController _safetyDescriptionController =
      TextEditingController();
  final TextEditingController _dataEmailController = TextEditingController();
  final TextEditingController _technicalIssueController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    contactOptions = [
      ContactOption(
        title: 'Ask a general question',
        onTap: () {
          Get.toNamed(Routes.ASK_GENERAL_QUESTION);
        },
      ),
      ContactOption(
        title: 'Help with payment',
        onTap: () {
          _openPaymentHelp();
        },
      ),
      ContactOption(
        title: 'Report a safety concern',
        onTap: () {
          _openSafetyConcernForm();
        },
      ),
      ContactOption(
        title: 'Request my data',
        onTap: () {
          _openDataRequestDialog();
        },
      ),
      ContactOption(
        title: 'Report a technical issue',
        onTap: () {
          _openTechnicalIssueForm();
        },
      ),
    ];
  }

  @override
  void dispose() {
    _paymentIssueController.dispose();
    _safetyDescriptionController.dispose();
    _dataEmailController.dispose();
    _technicalIssueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            EditProfileHeader(
              title: 'Contact us',
              onBack: () => Get.back(),
              showCloseButton: false,
            ),

            // Content
            Expanded(child: _buildContent()),

            // Bottom home indicator
            Padding(
              padding: EdgeInsets.only(bottom: MediaQueryUtil.spacing(8)),
              child: Container(
                width: MediaQueryUtil.spacing(134),
                height: MediaQueryUtil.spacing(5),
                decoration: BoxDecoration(
                  color: AppColors.grey[300],
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPaymentHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        ),
        title: Text(
          'Help with payment',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: MediaQueryUtil.spacing(8)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.BILLING);
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
                  'Go to Billing',
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(12)),
            TextField(
              controller: _paymentIssueController,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Describe your payment issue',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment support request submitted'),
                  backgroundColor: AppColors.cFF4A90E2,
                ),
              );
              _paymentIssueController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cFF30AEAE,
              foregroundColor: AppColors.white,
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _openSafetyConcernForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        ),
        title: Text(
          'Report a safety concern',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _safetyDescriptionController,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Describe the safety concern',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Safety concern submitted'),
                  backgroundColor: AppColors.green,
                ),
              );
              _safetyDescriptionController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cFF30AEAE,
              foregroundColor: AppColors.white,
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _openDataRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        ),
        title: Text(
          'Request my data',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your email to request a copy of your data.',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                color: AppColors.grey[700],
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(12)),
            TextField(
              controller: _dataEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Data request submitted for ${_dataEmailController.text}',
                  ),
                  backgroundColor: AppColors.cFF4A90E2,
                ),
              );
              _dataEmailController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cFF30AEAE,
              foregroundColor: AppColors.white,
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _openTechnicalIssueForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        ),
        title: Text(
          'Report a technical issue',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _technicalIssueController,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Describe the issue you are facing',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Technical issue submitted'),
                  backgroundColor: AppColors.orange,
                ),
              );
              _technicalIssueController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cFF30AEAE,
              foregroundColor: AppColors.white,
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQueryUtil.spacing(60)),

          // Contact options list with dividers
          for (int i = 0; i < contactOptions.length; i++) ...[
            _buildContactOptionTile(contactOptions[i]),
            if (i < contactOptions.length - 1)
              Divider(height: 1, thickness: 1, color: AppColors.grey[300]),
          ],
        ],
      ),
    );
  }

  Widget _buildContactOptionTile(ContactOption option) {
    return GestureDetector(
      onTap: option.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(16),
        ),
        child: Text(
          option.title,
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}

// Data model for contact options
class ContactOption {
  final String title;
  final VoidCallback onTap;

  ContactOption({required this.title, required this.onTap});
}
