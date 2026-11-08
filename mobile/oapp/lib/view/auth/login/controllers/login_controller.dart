import 'package:OApp/config/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/data/repositories/auth_repository.dart';
import 'package:OApp/utils/toast.dart';

import '../../../../services/firebaseauth_service.dart';
import '../../signin_otp/controllers/otp_signin_controller.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  bool obscurePassword = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  OTPSignInController get otpController => Get.find<OTPSignInController>();
  FirebaseAuthService get _authService => Get.find<FirebaseAuthService>();
  final TextEditingController phoneController = TextEditingController();
  final RxBool isOTPValid = false.obs;
  final RxString appleLoginKey = "".obs;
  final RxString facebookLoginKey = "".obs;
  final RxString googleLoginKey = "".obs;

  /// Text controller for country search
  final TextEditingController searchController = TextEditingController();

  /// Focus nodes for handling focus state
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode countryFocusNode = FocusNode();
  bool isPhoneValid = false;

  /// Selected country info
  String selectedCountryCode = '+1';
  String selectedCountryName = 'US';

  /// Full list of supported countries
  final List<Map<String, String>> allCountries = [
    {'name': 'United States', 'dialCode': '+1', 'code': 'US'},
    {'name': 'United Kingdom', 'dialCode': '+44', 'code': 'GB'},
    {'name': 'Canada', 'dialCode': '+1', 'code': 'CA'},
    {'name': 'Australia', 'dialCode': '+61', 'code': 'AU'},
    {'name': 'Pakistan', 'dialCode': '+92', 'code': 'PK'},
    {'name': 'Turkey', 'dialCode': '+90', 'code': 'TR'},
    {'name': 'France', 'dialCode': '+33', 'code': 'FR'},
    {'name': 'Germany', 'dialCode': '+49', 'code': 'DE'},
    {'name': 'United Arab Emirates', 'dialCode': '+971', 'code': 'AE'},
    {'name': 'India', 'dialCode': '+91', 'code': 'IN'},
  ];

  /// List of countries filtered by search query
  List<Map<String, String>> filteredCountries = [];

  /// Filter countries based on search query
  void filterCountries(String query) {
    if (query.isEmpty) {
      filteredCountries = allCountries;
    } else {
      filteredCountries = allCountries.where((country) {
        final name = country['name']!.toLowerCase();
        final dial = country['dialCode']!;
        return name.contains(query.toLowerCase()) || dial.contains(query);
      }).toList();
    }
    // Update UI after filtering
    update();
  }

  void updateCountry(String dialCode, String code) {
    selectedCountryCode = dialCode;
    selectedCountryName = code;
    update();
  }

  void resetSearch() {
    searchController.clear();
    filteredCountries = allCountries;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    // Initialize filtered countries list
    filteredCountries = allCountries;

    // Listen to phone input changes
    phoneController.addListener(() {
      isPhoneValid = phoneController.text.length >= 10;
      update(); // Refresh UI if validation changes
    });

    // Listen to country search input changes
    searchController.addListener(() {
      filterCountries(searchController.text);
    });
  }

  @override
  void onClose() {
    phoneController.dispose();
    searchController.dispose();
    phoneFocusNode.dispose();
    countryFocusNode.dispose();
    super.onClose();
  }

  final RxBool isLoading = false.obs;

  void login() async {
    var phoneNumber = selectedCountryCode + phoneController.text.toString();

    isLoading.value = true;
    try {
      debugPrint("${AppConfig.baseUrl} phoneNumber: $phoneNumber");
      final result = await _authRepo.requestSignInOtp(phoneNumber);
      debugPrint(phoneNumber);
      if (result.isSuccess) {
        Get.toNamed(Routes.SIGNIN_OTP, arguments: {'phoneNumber': phoneNumber});
      } else {
        Toast.error(result.errorMessage ?? 'Failed to sign in');
      }
    } catch (e) {
      Toast.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void addAppleId() async {
    UserCredential? userCred = await _authService.signInWithApple();
    if (userCred != null) {
      appleLoginKey.value = userCred.user?.uid ?? "";
      await tryLoginWithKeys();
    }
  }

  void addFacebookLogin() async {
    UserCredential? userCred = await _authService.signInWithFacebook();
    if (userCred != null) {
      facebookLoginKey.value = userCred.user?.uid ?? "";
      await tryLoginWithKeys();
    }
  }

  void addGoogleLogin() async {
    UserCredential? userCred = await _authService.signInWithGoogle();
    if (userCred != null) {
      googleLoginKey.value = userCred.user?.uid ?? "";
      await tryLoginWithKeys();
    }
  }

  bool get hasAnyOtherLoginMethod =>
      appleLoginKey.value.isNotEmpty ||
      facebookLoginKey.value.isNotEmpty ||
      googleLoginKey.value.isNotEmpty;

  Future<void> tryLoginWithKeys() async {
    isLoading.value = true;
    try {
      if (hasAnyOtherLoginMethod) {
        final verificationData = await _authRepo.loginWithKeys(
          facebookKey: facebookLoginKey.value,
          googleKey: googleLoginKey.value,
          appleKey: appleLoginKey.value,
        );

        if (verificationData != null) {
          otpController.saveDataAndNavigate(verificationData);
        } else {
          Toast.error('Failed to sign in');
        }
      } else {
        Toast.error(
          'No linked login methods found. Please sign in with phone number first.',
        );
      }
    } catch (e) {
      Toast.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
