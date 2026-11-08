import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/utils/platform_support.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../widget_helper/common_widgets.dart';
import '../../../../widgets/ElevatedButton/customElevatedButtom.dart';
import '../controllers/login_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);

    return GetBuilder<LoginController>(
      builder: (ctrl) => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset:
                false, // Prevents UI from pushing up when keyboard appears
            body: GestureDetector(
              onTap: () {
                // Dismiss keyboard when tapping anywhere on screen
                FocusScope.of(context).unfocus();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.cFFF1DFD5, // light peach
                      AppColors.cFFEADFDB, // pale pinkish-beige
                      AppColors.cFFDDE4EC, // light bluish-gray
                      AppColors
                          .cFFDDE4EC, // repeated to extend the bottom color
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQueryUtil.spacing(28),
                      ),
                      child: Form(
                        key: ctrl.formKey,
                        child: Column(
                          children: [
                            SizedBox(height: MediaQueryUtil.spacing(40)),

                            // App Title
                            CommonWidgets.appLogo(reducedSizeFactor: 0.7),

                            SizedBox(height: MediaQueryUtil.spacing(30)),

                            // Log in text
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Log in',
                                style: AppTextStyles.heading(
                                  fontFamily: AppFontFamily.urbanist,
                                  //  fontSize: MediaQueryUtil.fontSize(32),
                                  fontWeight: AppFontWeight.semi,
                                  color: AppColors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ),

                            SizedBox(height: MediaQueryUtil.spacing(10)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Country code container (flex: 3)
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: MediaQueryUtil.spacing(8),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showCountryPicker(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MediaQueryUtil.spacing(
                                              12,
                                            ),
                                            vertical: MediaQueryUtil.spacing(
                                              12,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.grey[300]!,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${ctrl.selectedCountryName} ${ctrl.selectedCountryCode}',
                                                  style: AppTextStyles.text(
                                                    customSize: 16,
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        AppFontWeight.regular,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: AppColors.grey[600],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: MediaQueryUtil.spacing(12)),

                                // Phone number container (flex: 7)
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: MediaQueryUtil.spacing(8),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ctrl.phoneFocusNode.hasFocus
                                                ? AppColors.cFF006C6A
                                                : AppColors.grey[600]!,
                                            width: ctrl.phoneFocusNode.hasFocus
                                                ? 2
                                                : 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: ctrl.phoneController,
                                          focusNode: ctrl.phoneFocusNode,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintStyle: AppTextStyles.text(
                                              customSize: 16,
                                              color: AppColors.grey[400],
                                              fontWeight: AppFontWeight.regular,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQueryUtil.spacing(
                                                        16,
                                                      ),
                                                  vertical:
                                                      MediaQueryUtil.spacing(
                                                        12,
                                                      ),
                                                ),
                                            counterText: '',
                                          ),
                                          style: AppTextStyles.text(
                                            customSize: 16,
                                            color: AppColors.black,
                                            fontWeight: AppFontWeight.regular,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(10)),

                            SizedBox(height: MediaQueryUtil.spacing(12)),

                            // Log in button
                            CustomButton(
                              text: 'Log in',
                              textSize: MediaQueryUtil.fontSize(15),
                              onPressed: () {
                                if (ctrl.formKey.currentState!.validate()) {
                                  ctrl.login();
                                }
                              },
                              backgroundColor:
                                  AppColors.cFF1878F3, // Blue color
                              textColor: AppColors.white,
                              borderRadius: MediaQueryUtil.spacing(8),
                            ),

                            // Forgot password
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQueryUtil.spacing(2),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Handle forgot password
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: AppTextStyles.small(
                                    color: AppColors.black54,
                                    fontWeight: AppFontWeight.regular,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: MediaQueryUtil.spacing(90)),

                            // Social login buttons
                            Column(
                              children: [
                                // Sign in with Apple
                                if (appleSignInSupported) ...[
                                  CustomButton(
                                    text: 'Sign in with Apple',
                                    onPressed: () {
                                      controller.addAppleId();
                                    },
                                    backgroundColor: AppColors.cFF000000,
                                    textColor: AppColors.white,
                                    borderRadius: MediaQueryUtil.spacing(8),
                                    textSize: MediaQueryUtil.fontSize(14),
                                  ),

                                  SizedBox(height: MediaQueryUtil.spacing(8)),
                                ],

                                // Sign in with Facebook
                                CustomButton(
                                  text: 'Sign in with Facebook',
                                  onPressed: () {
                                    controller.addFacebookLogin();
                                    // Handle Facebook sign in
                                  },
                                  backgroundColor: AppColors.cFF1878F3,
                                  textColor: AppColors.white,
                                  borderRadius: MediaQueryUtil.spacing(8),
                                  textSize: MediaQueryUtil.fontSize(14),
                                ),

                                SizedBox(height: MediaQueryUtil.spacing(8)),

                                // Sign in with phone number
                                CustomButton(
                                  text: 'Sign in with Google',
                                  onPressed: () {
                                    controller.addGoogleLogin();
                                    // Handle phone sign in
                                  },
                                  backgroundColor: AppColors.cFF424242,
                                  textColor: AppColors.white,
                                  borderRadius: MediaQueryUtil.spacing(8),
                                  textSize: MediaQueryUtil.fontSize(14),
                                ),
                              ],
                            ),

                            SizedBox(height: MediaQueryUtil.spacing(40)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            return ctrl.isLoading.value
                ? Container(
                    color: AppColors.black.withValues(alpha: 0.3),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    controller.resetSearch();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (BuildContext context) {
        return GetBuilder<LoginController>(
          builder: (ctrl) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Search bar with Cancel button
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQueryUtil.spacing(16),
                    MediaQueryUtil.spacing(12),
                    MediaQueryUtil.spacing(16),
                    MediaQueryUtil.spacing(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQueryUtil.spacing(40),
                          decoration: BoxDecoration(
                            color: AppColors.cFFE5E7E6,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: ctrl.searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search Country',
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.grey[600],
                                size: MediaQueryUtil.iconSize(20),
                              ),
                              hintStyle: AppTextStyles.small(
                                color: AppColors.grey[600],
                                fontWeight: AppFontWeight.regular,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: MediaQueryUtil.spacing(12),
                                vertical: MediaQueryUtil.spacing(10),
                              ),
                              isDense: true,
                              alignLabelWithHint: false,
                            ),
                            style: AppTextStyles.small(color: AppColors.black),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQueryUtil.spacing(8)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.text(
                            customSize: 16,
                            color: AppColors.grey[700],
                            fontWeight: AppFontWeight.regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Country list
                Expanded(
                  child: ListView.builder(
                    itemCount: ctrl.filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = ctrl.filteredCountries[index];
                      return _buildCountryItem(
                        context,
                        country['name']!,
                        country['dialCode']!,
                        country['code']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryItem(
    BuildContext context,
    String name,
    String dialCode,
    String code,
  ) {
    return InkWell(
      onTap: () {
        controller.updateCountry(dialCode, code);
        controller.resetSearch();
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(12),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grey[200]!, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppTextStyles.text(
                customSize: 16,
                fontWeight: AppFontWeight.regular,
                color: AppColors.black87,
              ),
            ),
            Text(
              dialCode,
              style: AppTextStyles.text(
                customSize: 16,
                fontWeight: AppFontWeight.regular,
                color: AppColors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
