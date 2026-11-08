import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<Map<String, String>> _faqs = const [
    {
      'q': 'How do I update my profile?',
      'a':
          'Go to Profile, tap Edit Profile, and update your information. Changes are saved automatically.',
    },
    {
      'q': 'How do notifications work?',
      'a':
          'You can enable or disable Push and SMS notifications in Settings → Notifications.',
    },
    {
      'q': 'How can I manage privacy?',
      'a':
          'Visit Settings → Security and Privacy to control Face ID, login methods, and privacy preferences.',
    },
    {
      'q': 'How do I contact support?',
      'a':
          'Use Contact and FAQ → Contact Us to reach out. You can also ask a general question from the same section.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(
              title: 'FAQ',
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
                    Center(
                      child: Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(16),
                          color: AppColors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(24)),
                    ..._faqs.map(
                      (item) => _buildFaqItem(
                        question: item['q'] ?? '',
                        answer: item['a'] ?? '',
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

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        border: Border.all(color: AppColors.grey[300]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: AppColors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(16),
            vertical: MediaQueryUtil.spacing(4),
          ),
          childrenPadding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(16),
            vertical: MediaQueryUtil.spacing(12),
          ),
          title: Text(
            question,
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          trailing: Icon(
            Icons.expand_more,
            size: MediaQueryUtil.fontSize(22),
            color: AppColors.grey[700],
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(14),
                color: AppColors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
