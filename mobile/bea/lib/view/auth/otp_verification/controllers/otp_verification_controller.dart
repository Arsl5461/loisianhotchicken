import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/toast.dart';

class OTPVerificationController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  final RxBool isOTPValid = false.obs;
  final RxInt countdown = 30.obs;
  final RxBool isResendEnabled = false.obs;
  final RxBool isLoading = false.obs;

  late String phoneNumber;

  @override
  void onInit() {
    super.onInit();
    phoneNumber = Get.arguments?['phoneNumber'] ?? '';
    if (phoneNumber.isEmpty && Get.parameters.containsKey('phoneNumber')) {
      phoneNumber = Get.parameters['phoneNumber']!;
    }

    _startCountdown();
    _setupControllers();
  }

  void _setupControllers() {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() => _validateOTP());
    }
  }

  void _startCountdown() {
    countdown.value = 30;
    isResendEnabled.value = false;
    Future.delayed(const Duration(seconds: 1), _updateCountdown);
  }

  void _updateCountdown() {
    if (countdown.value > 0) {
      countdown.value--;
      Future.delayed(const Duration(seconds: 1), _updateCountdown);
    } else {
      isResendEnabled.value = true;
    }
  }

  void _validateOTP() {
    final otp = controllers.map((controller) => controller.text).join();
    isOTPValid.value = otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }

  void onDigitChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void onBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      controllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> resendCode() async {
    _startCountdown();

    try {
      final success = await _authRepository.resendSignUpCode(phoneNumber);
      if (success) {
        Toast.success('Code resent successfully');
      } else {
        Toast.error('Failed to resend code');
      }
    } catch (_) {
      Toast.error('Failed to resend code. Please try again.');
    }
  }

  Future<void> verifyOTP() async {
    if (!isOTPValid.value) return;

    isLoading.value = true;
    try {
      final otp = controllers.map((c) => c.text).join();
      final referralCode = await _authRepository.getReferralCode();
      final verificationData = await _authRepository.verifySignUpOtp(
        phoneNumber: phoneNumber,
        otp: otp,
        referralCode: referralCode,
      );

      if (verificationData != null) {
        await _authRepository.saveSession(
          verificationData,
          clearReferral: true,
        );
        Get.toNamed(Routes.LOCATION_SETUP);
        return;
      }

      Toast.error('Failed to verify OTP');
    } catch (_) {
      Toast.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }
}
