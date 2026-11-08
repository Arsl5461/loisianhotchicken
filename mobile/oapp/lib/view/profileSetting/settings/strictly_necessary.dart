import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class StrictlyNecessaryScreen extends StatefulWidget {
  const StrictlyNecessaryScreen({super.key});

  @override
  State<StrictlyNecessaryScreen> createState() =>
      _StrictlyNecessaryScreenState();
}

class _StrictlyNecessaryScreenState extends State<StrictlyNecessaryScreen> {
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
              title: 'Strictly necessary',
              onBack: () => Get.back(),
              showCloseButton: false,
            ),

            // Content
            Expanded(child: _buildContent()),
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
          SizedBox(height: MediaQueryUtil.spacing(8)),

          // Subtitle
          Center(
            child: Text(
              'Learn about our integrations',
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[700],
              ),
            ),
          ),

          SizedBox(height: MediaQueryUtil.spacing(40)),

          // Integration Sections
          _buildIntegrationSection(
            title: 'Facebook',
            description:
                'This lets you upload and display photos from Facebook',
          ),

          SizedBox(height: MediaQueryUtil.spacing(16)),

          _buildIntegrationSection(
            title: 'Instagram',
            description:
                'This lets you upload and display photos from Instagram',
          ),

          SizedBox(height: MediaQueryUtil.spacing(16)),

          _buildIntegrationSection(
            title: 'Apple',
            description: 'This lets you log in to Oapp using your Apple ID',
          ),

          SizedBox(height: MediaQueryUtil.spacing(40)),
        ],
      ),
    );
  }

  Widget _buildIntegrationSection({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.small(
            fontWeight: AppFontWeight.semi,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(2)),
        Text(
          description,
          style: AppTextStyles.verySmall(
            color: AppColors.grey[700],
            fontWeight: AppFontWeight.semi,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
