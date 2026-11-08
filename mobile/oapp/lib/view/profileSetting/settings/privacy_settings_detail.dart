import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:OApp/widgets/Toggle/DisplayToggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routing/app_routes.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../../../core/typography/app_text_styles.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool marketingPermissions = true;
  bool strictlyNecessaryPermissions = true;
  final GetStorage _box = GetStorage();

  @override
  void initState() {
    super.initState();
    final m = _box.read('privacy.marketingPermissions');
    final s = _box.read('privacy.strictlyNecessaryPermissions');
    if (m is bool) marketingPermissions = m;
    if (s is bool) strictlyNecessaryPermissions = s;
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
              title: 'Privacy Settings',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQueryUtil.spacing(12)),

                    // Section heading
                    Center(
                      child: Text(
                        'Things to keep you safe',
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[700],
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQueryUtil.spacing(24)),

                    // Marketing Permissions
                    _buildSettingRow(
                      title: 'Marketing Permissions',
                      subtitle: 'Enable FaceID for faster login',
                      hasToggle: true,
                      toggleValue: marketingPermissions,
                      onToggleChanged: (value) {
                        setState(() => marketingPermissions = value);
                        _box.write('privacy.marketingPermissions', value);
                      },
                    ),

                    // Strictly Necessary Permissions
                    _buildSettingRow(
                      title: 'Strictly Necessary Permissions',
                      hasToggle: true,
                      toggleValue: strictlyNecessaryPermissions,
                      onToggleChanged: (value) {
                        setState(() => strictlyNecessaryPermissions = value);
                        _box.write(
                          'privacy.strictlyNecessaryPermissions',
                          value,
                        );
                      },
                    ),

                    // View strictly necessary permissions
                    _buildSettingRow(
                      title: 'View strictly necessary permissions',
                      subtitle: 'Enable FaceID for faster login',
                      hasArrow: true,
                      onTap: () {
                        Get.toNamed(Routes.STRICTLY_NECESSARY);
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
        padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(8)),
        child: Row(
          children: [
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: MediaQueryUtil.spacing(2)),
                    Text(
                      subtitle,
                      style: AppTextStyles.extraSmall(
                        //   fontSize: MediaQueryUtil.fontSize(12),
                        fontWeight: AppFontWeight.semi,
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
