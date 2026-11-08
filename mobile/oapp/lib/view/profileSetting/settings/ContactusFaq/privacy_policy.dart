import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(
              title: 'Privacy Policy',
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
                      'Your privacy matters',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(16),
                        color: AppColors.grey[600],
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(24)),
                    Text(
                      'We collect and store limited information to operate the app, improve features, and keep your account secure. '
                      'You control notification and privacy preferences in Settings. We do not sell your personal data. '
                      'You may request your data or delete your account from the Contact Us section.',
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
