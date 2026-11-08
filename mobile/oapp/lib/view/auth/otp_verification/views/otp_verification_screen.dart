import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../controllers/otp_verification_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class OTPVerificationScreen extends GetView<OTPVerificationController> {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQueryUtil.spacing(40)),
                      Text(
                        "Verify your phone\nnumber",
                        style: AppTextStyles.large(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Enter the code we've texted to ${controller.phoneNumber}",
                              style: AppTextStyles.regular(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: Get.back,
                            child: Text(
                              "Change",
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.cFF006C6A,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(20)),

                      Text(
                        "Enter code",
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(8)),

                      otpInput(),
                      SizedBox(height: MediaQueryUtil.spacing(24)),

                      Obx(
                        () => controller.isResendEnabled.value
                            ? GestureDetector(
                                onTap: controller.resendCode,
                                child: Text(
                                  "Didn't get a Code",
                                  style: AppTextStyles.small(
                                    fontWeight: AppFontWeight.semi,
                                    color: AppColors.cFF006C6A,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            : Text(
                                "Resend code in ${controller.countdown.value}s",
                                style: AppTextStyles.small(
                                  fontWeight: AppFontWeight.regular,
                                  color: AppColors.grey[500],
                                ),
                              ),
                      ),

                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(left: 20, right: 20, top: 12),
                child: SafeArea(top: false, child: bottomNav()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomNav() {
    return Obx(
      () => Row(
        children: [
          Text(
            "This text should arrive within ${controller.countdown.value}s",
            style: AppTextStyles.small(
              fontWeight: AppFontWeight.regular,
              color: AppColors.black,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: controller.isOTPValid.value && !controller.isLoading.value
                ? controller.verifyOTP
                : null,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: controller.isOTPValid.value
                    ? AppColors.cFF006C6A
                    : AppColors.grey[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: controller.isOTPValid.value
                    ? [
                        BoxShadow(
                          color: Color(0xFF006c6a).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: controller.isLoading.value
                  ? Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.white,
                      size: 28,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  otpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(6, (index) {
        return Expanded(
          // <-- make each box expand evenly
          child: Padding(
            padding: EdgeInsets.only(
              right: index < 5 ? 3.0 : 0, // 3 pixels spacing
            ),
            child: AspectRatio(
              // keep it square
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.focusNodes[index].hasFocus
                        ? AppColors.cFF006C6A
                        : AppColors.grey[300]!,
                    width: 2, // can be fixed or dynamic
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.white,
                ),
                child: Center(
                  child: TextField(
                    controller: controller.controllers[index],
                    focusNode: controller.focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: AppTextStyles.text(
                      customSize: 24,
                      fontWeight: AppFontWeight.semi,
                      color: AppColors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      controller.onDigitChanged(value, index);
                    },
                    onTap: () {
                      controller.controllers[index].selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: controller.controllers[index].text.length,
                      );
                    },
                    onSubmitted: (value) {
                      if (value.length == 1 && index < 5) {
                        controller.focusNodes[index + 1].requestFocus();
                      } else {
                        controller.focusNodes[index].unfocus();
                      }
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
