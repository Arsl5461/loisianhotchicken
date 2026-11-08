import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

class AdvertisingInfoScreen extends StatefulWidget {
  const AdvertisingInfoScreen({super.key});

  @override
  State<AdvertisingInfoScreen> createState() => _AdvertisingInfoScreenState();
}

class _AdvertisingInfoScreenState extends State<AdvertisingInfoScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(
              title: 'Advertising',
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
                      'About ads in the app',
                      style: TextStyle(
                        fontSize: MediaQueryUtil.fontSize(16),
                        color: AppColors.grey[600],
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(24)),
                    Text(
                      'We may show limited promotional content to help keep the app running. '
                      'Your preferences can reduce certain marketing messages. '
                      'We aim to keep ads relevant and minimal to avoid interrupting your experience.',
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
