import 'package:flutter/material.dart';
import '../../utils/media_query.dart';
import 'ProgressIndicator.dart';
import 'PageTitle.dart';
import '../Navigation/GoBackLink.dart';
import '../ElevatedButton/gradientButton.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ProfileScreenLayout extends StatelessWidget {
  final String title;
  final Widget content;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool isButtonEnabled;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onGoBack;
  final bool showGoBack;
  final EdgeInsets? contentPadding;
  final Color? buttonColor;
  final Color? disabledButtonColor;
  final Color? buttonTextColor;
  final double? buttonBorderRadius;
  final double? buttonTextSize;

  const ProfileScreenLayout({
    super.key,
    required this.title,
    required this.content,
    this.buttonText,
    this.onButtonPressed,
    this.isButtonEnabled = false,
    this.currentStep = 1,
    this.totalSteps = 10,
    this.onGoBack,
    this.showGoBack = true,
    this.contentPadding,
    this.buttonColor,
    this.disabledButtonColor,
    this.buttonTextColor,
    this.buttonBorderRadius,
    this.buttonTextSize,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
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
            child: Column(
              children: [
                // Progress indicator
                CustomProgressIndicator(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                ),

                // Main content area
                Expanded(
                  child: Padding(
                    padding:
                        contentPadding ??
                        EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(28),
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQueryUtil.spacing(40)),

                        // Title
                        PageTitle(title: title),

                        SizedBox(height: MediaQueryUtil.spacing(40)),

                        // Main content
                        Expanded(child: content),

                        SizedBox(height: MediaQueryUtil.spacing(20)),

                        // Go back link
                        if (showGoBack)
                          GoBackLink(
                            onTap: onGoBack ?? () => Navigator.pop(context),
                          ),

                        // This will push the button to the bottom
                        Spacer(),
                      ],
                    ),
                  ),
                ),

                // Bottom section with button
                if (buttonText != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(28),
                    ),
                    child: Column(
                      children: [
                        // Continue button
                        GradientButton(
                          text: buttonText!,
                          onPressed: isButtonEnabled ? onButtonPressed : null,
                          backgroundColor: isButtonEnabled
                              ? (buttonColor ?? AppColors.cFF1E88E5)
                              : (disabledButtonColor ?? AppColors.cFF9CA2AE),
                          textColor: buttonTextColor ?? AppColors.white,
                          borderRadius: buttonBorderRadius ?? 12.0,
                          textSize: buttonTextSize ?? 16,
                        ),

                        SizedBox(height: MediaQueryUtil.spacing(30)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
