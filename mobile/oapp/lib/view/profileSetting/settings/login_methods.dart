import 'package:OApp/utils/media_query.dart';
import 'package:OApp/utils/platform_support.dart';
import 'package:OApp/widgets/Layout/EditProfileHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/typography/app_text_styles.dart';
import 'controllers/login_methods_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LoginMethodsScreen extends GetView<LoginMethodsController> {
  const LoginMethodsScreen({super.key});

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
              title: 'Login Methods',
              onBack: () => Get.back(),
              trailing: Obx(
                () => GestureDetector(
                  onTap: controller.updateLoginMethods,
                  behavior: HitTestBehavior.opaque,
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: MediaQueryUtil.spacing(18),
                          height: MediaQueryUtil.spacing(18),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Update',
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.cFF006C6A,
                          ),
                        ),
                ),
              ),
            ),

            // Content
            Expanded(child: _buildContent()),

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

  Widget _buildContent() {
    return Obx(
      () => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQueryUtil.spacing(16)),

            Center(
              child: Text(
                'Protect your account with your login method',
                style: AppTextStyles.small(
                  color: AppColors.grey[800],
                  fontWeight: AppFontWeight.semi,
                ),
              ),
            ),

            SizedBox(height: MediaQueryUtil.spacing(24)),

            Text(
              'Current login method',
              style: AppTextStyles.verySmall(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[600],
              ),
            ),

            SizedBox(height: MediaQueryUtil.spacing(8)),

            _buildCurrentLoginMethod(),

            SizedBox(height: MediaQueryUtil.spacing(15)),

            Text(
              'Other login methods',
              style: AppTextStyles.verySmall(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[600],
              ),
            ),

            SizedBox(height: MediaQueryUtil.spacing(12)),

            if (appleSignInSupported && controller.appleLoginKey.value.isEmpty)
              _buildAddLoginButton(
                title: 'Add Apple ID',
                backgroundColor: AppColors.black,
                onTap: controller.addAppleId,
              ),

            if (controller.facebookLoginKey.value.isEmpty)
              _buildAddLoginButton(
                title: 'Add Facebook',
                backgroundColor: AppColors.cFF1877F2,
                onTap: controller.addFacebookLogin,
              ),

            if (controller.googleLoginKey.value.isEmpty)
              _buildAddLoginButton(
                title: 'Add Google Account',
                backgroundColor: AppColors.grey[500]!,
                onTap: controller.addGoogleLogin,
              ),

            if (controller.showError.value)
              Padding(
                padding: EdgeInsets.only(top: MediaQueryUtil.spacing(16)),
                child: Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: AppColors.dangerRed,
                      size: MediaQueryUtil.fontSize(16),
                    ),
                    SizedBox(width: MediaQueryUtil.spacing(6)),
                    Expanded(
                      child: Text(
                        'Invalid phone number. Please add a valid phone to continue.',
                        style: AppTextStyles.extraSmall(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.dangerRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (!controller.hasAnyOtherLoginMethod)
              Container(
                margin: EdgeInsets.only(top: MediaQueryUtil.spacing(24)),
                padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
                decoration: BoxDecoration(
                  color: AppColors.grey[100],
                  borderRadius: BorderRadius.circular(
                    MediaQueryUtil.spacing(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'At least one login method is required',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(8)),
                    Center(
                      child: Text(
                        'Add another login method to remove this one.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQueryUtil.spacing(16)),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'OK, got it',
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.bold,
                            color: AppColors.cFF328EEF,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: MediaQueryUtil.spacing(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLoginMethod() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(MediaQueryUtil.spacing(14)),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.grey[300]!),
            ),
            child: Row(
              children: [
                // Phone number input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(4)),
                      controller.isEditingPhone.value
                          ? TextField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Enter phone number',
                                hintStyle: AppTextStyles.verySmall(
                                  color: AppColors.grey[400],
                                ),
                              ),
                              style: AppTextStyles.verySmall(
                                color: AppColors.black,
                              ),
                            )
                          : Text(
                              controller.currentPhoneNumber.value.isEmpty
                                  ? 'No phone number linked'
                                  : controller.currentPhoneNumber.value,
                              style: AppTextStyles.verySmall(
                                color: AppColors.grey[600],
                              ),
                            ),
                    ],
                  ),
                ),

                // Change/Update button
                GestureDetector(
                  onTap: controller.togglePhoneEditing,
                  child: Text(
                    controller.isEditingPhone.value ? 'Update' : 'Change',
                    style: AppTextStyles.verySmall(
                      fontWeight: AppFontWeight.semiBold,
                      color:
                          controller.isEditingPhone.value &&
                              controller.showError.value
                          ? AppColors.grey[400]
                          : AppColors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Close button
        GestureDetector(
          onTap: controller.removePhoneNumber,
          child: Padding(
            padding: EdgeInsets.only(left: MediaQueryUtil.spacing(12)),
            child: Icon(
              Icons.close,
              size: MediaQueryUtil.spacing(32),
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddLoginButton({
    required String title,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: MediaQueryUtil.spacing(55),
        margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(6)),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQueryUtil.fontSize(20) + MediaQueryUtil.spacing(8),
            ),
            Text(
              title,
              style: AppTextStyles.small(
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: MediaQueryUtil.spacing(16)),
              child: Icon(
                Icons.chevron_right,
                size: MediaQueryUtil.fontSize(24),
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
