import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routing/app_routes.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../../../core/typography/app_text_styles.dart';

class ContactAndFaqScreen extends StatefulWidget {
  const ContactAndFaqScreen({super.key});

  @override
  State<ContactAndFaqScreen> createState() => _ContactAndFaqScreenState();
}

class _ContactAndFaqScreenState extends State<ContactAndFaqScreen> {
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
              title: 'Contact and FAQ',
              onBack: () => Get.back(),
              showCloseButton: false,
            ),

            // Content
            Expanded(child: _buildContent()),

            // Home indicator
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQueryUtil.spacing(16)),

          // Subtitle - centered
          Center(
            child: Text(
              'Get some information',
              textAlign: TextAlign.center,
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[700],
              ),
            ),
          ),

          SizedBox(height: MediaQueryUtil.spacing(24)),

          // List of options
          _buildOptionItem(
            title: 'FAQ',
            onTap: () {
              Get.toNamed(Routes.FAQ);
            },
          ),

          _buildOptionItem(
            title: 'Contact Us',
            onTap: () {
              Get.toNamed(Routes.CONTACT_US);
            },
          ),

          _buildOptionItem(
            title: 'Terms of Service',
            onTap: () {
              Get.toNamed(Routes.TERMS_OF_SERVICE);
            },
          ),

          _buildOptionItem(
            title: 'Privacy Policy',
            onTap: () {
              Get.toNamed(Routes.PRIVACY_POLICY_PAGE);
            },
          ),

          _buildOptionItem(
            title: 'Advertising',
            onTap: () {
              Get.toNamed(Routes.ADVERTISING_INFO);
            },
          ),

          SizedBox(height: MediaQueryUtil.spacing(40)),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.small(
                // fontSize: MediaQueryUtil.fontSize(16),
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.black,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: MediaQueryUtil.fontSize(24),
              color: AppColors.grey[800],
            ),
          ],
        ),
      ),
    );
  }
}
