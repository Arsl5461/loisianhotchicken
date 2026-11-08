import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:OApp/widgets/Toggle/DisplayToggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SecurityAndPrivacyScreen extends StatefulWidget {
  const SecurityAndPrivacyScreen({super.key});

  @override
  State<SecurityAndPrivacyScreen> createState() =>
      _SecurityAndPrivacyScreenState();
}

class _SecurityAndPrivacyScreenState extends State<SecurityAndPrivacyScreen> {
  bool faceIdEnabled = true;
  final GetStorage _box = GetStorage();

  @override
  void initState() {
    super.initState();
    final stored = _box.read('security.faceIdEnabled');
    if (stored is bool) {
      faceIdEnabled = stored;
    }
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
              title: 'Security and Privacy',
              onBack: () => Get.back(),
              showCloseButton: false,
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQueryUtil.spacing(12)),

                    // Section heading
                    Text(
                      'Things to keep you safe',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.semi,
                        color: AppColors.grey[700],
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(24)),

                    // Face ID
                    _buildSettingRow(
                      title: 'Face ID',
                      subtitle: 'Enable FaceID for faster login',
                      hasToggle: true,
                      toggleValue: faceIdEnabled,
                      onToggleChanged: (value) {
                        setState(() => faceIdEnabled = value);
                        _box.write('security.faceIdEnabled', value);
                      },
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(2)),

                    // Login Methods
                    _buildSettingRow(
                      title: 'Login Methods',
                      hasArrow: true,
                      onTap: () {
                        Get.toNamed(Routes.LOGIN_METHODS);
                      },
                    ),

                    // Privacy Settings
                    _buildSettingRow(
                      title: 'Privacy Settings',
                      hasArrow: true,
                      onTap: () {
                        Get.toNamed(Routes.PRIVACY_SETTINGS);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Home indicator
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

  Widget _buildSettingRow({
    required String title,
    String? subtitle,
    bool hasToggle = false,
    bool hasArrow = false,
    bool? toggleValue,
    ValueChanged<bool>? onToggleChanged,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(16)),
        child: Row(
          children: [
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.small(
                      fontWeight: AppFontWeight.semi,
                      color: AppColors.black,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: MediaQueryUtil.spacing(4)),
                    Text(
                      subtitle,
                      style: AppTextStyles.verySmall(
                        color: AppColors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Toggle or arrow
            if (hasToggle && toggleValue != null)
              DisplayToggle(
                label: '',
                value: toggleValue,
                onChanged: onToggleChanged ?? (value) {},
                activeColor: AppColors.cFF006C6A,
                inactiveColor: AppColors.grey[300],
              )
            else if (hasArrow)
              Icon(
                Icons.chevron_right,
                color: AppColors.grey[800],
                size: MediaQueryUtil.fontSize(24),
              ),
          ],
        ),
      ),
    );
  }
}
