import 'package:OApp/services/dailog_service.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/common_widgets/buttons.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:OApp/widgets/Navigation/GoBackLink.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import 'controllers/settings_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  EditProfileHeader(
                    title: 'Settings',
                    onBack: () => Get.back(),
                    onClose: () => Get.back(),
                  ),

                  Expanded(child: _buildSettingsList()),

                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return SingleChildScrollView(
      padding: MediaQueryUtil.padding(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          /// Pause Account
          _buildSettingTile(
            title: 'Pause Account',
            subtitle: 'You wont be charged the next billing cycle',
            hasToggle: true,
            toggleValue: controller.pauseAccount.value,
            onToggleChanged: (value) {
              if (value) {
                controller.dialogService.showConfirmationBottomSheet(
                  message: DialogMessage(
                    title: 'Are you sure you want to pause your account',
                    subheading:
                        'By pausing your account you’ll lose access todiscovery and travel features after the billing cycle and your account wont be charged until you Logout unpause',
                    okText: 'Yes, Pause',
                    cancelText: 'No, Cancel',
                    onConfirm: () {
                      controller.pauseAccountConfirm(value);
                    },
                  ),
                );
              } else {
                controller.dialogService.showConfirmationBottomSheet(
                  message: DialogMessage(
                    title: 'Are you sure you want to unpause your account',
                    subheading:
                        'Are you sure you want to unpause your account? You can pause it again at any time from the settings.',
                    okText: 'Yes, Unpause',
                    cancelText: 'No, Keep it Paused',
                    onConfirm: () {
                      controller.pauseAccountConfirm(value);
                    },
                    onCancel: () {},
                  ),
                );
              }
            },
          ),

          SizedBox(height: MediaQueryUtil.spacing(2)),

          /// Incognito Mode
          _buildSettingTile(
            title: 'Incognito Mode',
            subtitle:
                'Others wont see you in discovery unless you like them first',
            hasToggle: true,
            toggleValue: controller.incognitoMode.value,
            onToggleChanged: controller.toggleIncognito,
          ),

          SizedBox(height: MediaQueryUtil.spacing(2)),

          /// Notification Settings
          _buildSettingTile(
            title: 'Notification Settings',
            subtitle:
                'Control how you get alerted by us in and out of\nthe app',
            hasArrow: true,
            onTap: () => Get.toNamed(Routes.NOTIFICATIONS_PAGE),
          ),

          SizedBox(height: MediaQueryUtil.spacing(2)),

          /// Security & Privacy
          _buildSettingTile(
            title: 'Security and Privacy',
            subtitle: "Let's make sure you feel secure",
            hasArrow: true,
            onTap: () => Get.toNamed(Routes.SECURITY_AND_PRIVACY),
          ),

          SizedBox(height: MediaQueryUtil.spacing(2)),

          /// Subscription
          _buildSettingTile(
            title: 'Subscription Plan',
            subtitle: "Decide which subscription tier you'd like to\nexplore",
            hasArrow: true,
            onTap: () => Get.toNamed(Routes.PREMIUM_UPGRADE),
          ),

          SizedBox(height: MediaQueryUtil.spacing(2)),

          /// FAQ
          _buildSettingTile(
            title: 'Contact and FAQ',
            subtitle: 'Find information or get in touch with us',
            hasArrow: true,
            onTap: () => Get.toNamed(Routes.CONTACT_AND_FAQ),
          ),

          SizedBox(height: MediaQueryUtil.spacing(2)),

          /// Billing
          _buildSettingTile(
            title: 'Billing',
            subtitle: 'Keep track of your account history',
            hasArrow: true,
            onTap: () => Get.toNamed(Routes.BILLING),
          ),

          SizedBox(height: MediaQueryUtil.spacing(40)),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    bool hasToggle = false,
    bool hasArrow = false,
    bool? toggleValue,
    Function(bool)? onToggleChanged,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: hasToggle && toggleValue != null
          ? () => onToggleChanged?.call(!toggleValue)
          : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(12)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.regular(
                      fontWeight: AppFontWeight.semi,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.verySmall(
                      fontWeight: AppFontWeight.regular,
                      // fontSize: MediaQueryUtil.fontSize(13),
                      color: AppColors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            if (hasToggle && toggleValue != null)
              Container(
                width: 51,
                height: 31,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.5),
                  color: toggleValue
                      ? AppColors.cFF006C6A
                      : AppColors.grey[300],
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: toggleValue
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 27,
                    height: 27,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

            if (hasArrow)
              Icon(
                Icons.chevron_right,
                color: AppColors.grey[600],
                size: MediaQueryUtil.fontSize(24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQueryUtil.spacing(16)),
      child: Column(
        children: [
          GoBackLink(
            textStyle: AppTextStyles.regular(
              // fontSize: 18,
              fontWeight: AppFontWeight.semiBold,
            ),
            text: "Delete Account",
            onTap: () {
              Get.back();
            },
          ),
          CommonButtons.commonButton(
            borderRadius: 10,
            text: 'Logout',
            textStyle: AppTextStyles.regular(
              color: AppColors.white,
              // fontSize: 18,
              fontWeight: AppFontWeight.bold,
            ),
            onPressed: () {
              controller.dialogService.selectionDialog(
                message: DialogMessage(
                  title: 'Logout',
                  subheading: 'Are you sure you want to logout?',
                  okText: 'Yes, Logout',
                  cancelText: 'No, Stay Logged In',
                  onConfirm: controller.logout,
                  onCancel: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// DELETE DIALOG
}
