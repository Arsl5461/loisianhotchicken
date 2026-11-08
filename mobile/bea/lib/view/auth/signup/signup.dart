import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../widgets/Inputs/GradientTextField.dart';
import '../../../widgets/ElevatedButton/gradientButton.dart';
import '../../../utils/media_query.dart';
import '../../ProfileMaking/profile_making_controller/profile_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EmailInputPageEnhanced extends GetView<ProfileController> {
  const EmailInputPageEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
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
                AppColors.cFFDDE4EC, // repeated to extend the bottom color
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Progress indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(20),
                      vertical: MediaQueryUtil.spacing(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: MediaQueryUtil.spacing(4),
                            decoration: BoxDecoration(
                              color: AppColors.cFF1E88E5,
                              borderRadius: BorderRadius.circular(
                                MediaQueryUtil.spacing(2),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQueryUtil.spacing(4)),
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: MediaQueryUtil.spacing(4),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(
                                MediaQueryUtil.spacing(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQueryUtil.spacing(20)),

                        Text(
                          "What's your email?",
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(22),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black87,
                            height: 1.2,
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(12)),

                        Text(
                          'For access to the beta, please use the same email as our waitlist',
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(12),
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey[600],
                            height: 1.4,
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(20)),

                        GradientTextField(
                          controller: controller.emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(360)),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQueryUtil.spacing(16),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: MediaQueryUtil.fontSize(11),
                                color: Color(
                                  0xFF6B7280,
                                ), // Gray color matching image
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "By tapping 'Continue', you agree to our ",
                                ),
                                TextSpan(
                                  text: "Terms of Service",
                                  style: TextStyle(
                                    color: Color(
                                      0xFF3B82F6,
                                    ), // Blue color matching image
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.cFF3B82F6,
                                    decorationThickness: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: ". Learn how we process your data in ",
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Color(
                                      0xFF3B82F6,
                                    ), // Blue color matching image
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.cFF3B82F6,
                                    decorationThickness: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(text: " and "),
                                TextSpan(
                                  text: "Cookies Policy",
                                  style: TextStyle(
                                    color: Color(
                                      0xFF3B82F6,
                                    ), // Blue color matching image
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.cFF3B82F6,
                                    decorationThickness: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(text: "."),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(5)),

                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Go back',
                              style: TextStyle(
                                fontSize: MediaQueryUtil.fontSize(12),
                                color: AppColors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(height: 6.h),

                        // Dynamic continue button - changes color when email is valid
                        Obx(
                          () => GradientButton(
                            text: 'Continue',
                            onPressed: controller.isEmailValid
                                ? () {
                                    debugPrint(
                                      'Valid email: ${controller.rxEmail.value}',
                                    );
                                    Get.toNamed(Routes.PHONE_VERIFICATION);
                                  }
                                : null,
                            backgroundColor: controller.isEmailValid
                                ? AppColors.cFF1E88E5
                                : AppColors.grey,
                            textColor: AppColors.white,
                            borderRadius: MediaQueryUtil.spacing(12),
                            textSize: MediaQueryUtil.fontSize(16),
                          ),
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(60)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
