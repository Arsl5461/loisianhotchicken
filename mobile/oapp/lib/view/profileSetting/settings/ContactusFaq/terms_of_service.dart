import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(
              title: 'Terms of Service',
              onBack: () => Get.back(),
              showCloseButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQueryUtil.spacing(16)),
                    Text(
                      'Please read these terms carefully',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(16),
                        color: AppColors.grey[600],
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(24)),
                    Text(
                      'By using this app, you agree to these terms and conditions. '
                      'We provide features to help you connect and interact. You must use the app responsibly. '
                      'Do not share harmful content, and respect other users. We may update these terms over time.',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(14),
                        color: AppColors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(16)),
                    Text(
                      'If you have questions regarding these terms, contact support through the Contact Us section.',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(14),
                        color: AppColors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
