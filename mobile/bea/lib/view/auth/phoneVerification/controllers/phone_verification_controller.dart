import 'package:OApp/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/toast.dart';
import '../../../../core/routing/app_routes.dart';

class PhoneVerificationController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode countryFocusNode = FocusNode();

  final RxBool isPhoneValid = false.obs;
  final RxBool isPhoneFocused = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedCountryName = 'US'.obs;

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

  final RxList<Map<String, String>> filteredCountries =
      <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredCountries.assignAll(allCountries);

    phoneFocusNode.addListener(() {
      isPhoneFocused.value = phoneFocusNode.hasFocus;
    });

    phoneController.addListener(() {
      isPhoneValid.value = phoneController.text.length >= 9;
    });

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

  void filterCountries(String query) {
    if (query.isEmpty) {
      filteredCountries.assignAll(allCountries);
    } else {
      filteredCountries.assignAll(
        allCountries.where((country) {
          return country['name']!.toLowerCase().contains(query.toLowerCase()) ||
              country['dialCode']!.contains(query);
        }).toList(),
      );
    }
  }

  void selectCountry(
    String name,
    String dialCode,
    String code,
    BuildContext context,
  ) {
    selectedCountryName.value = code;
    selectedCountryCode.value = dialCode;
    searchController.clear();
    // Assuming Get.back() handles the modal close, but we might need context if using standard showModalBottomSheet
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
      Navigator.pop(context);
    }
  }

  void onContinue(BuildContext context) async {
    if (isPhoneValid.value) {
      isLoading.value = true;
      try {
        final fullPhoneNumber =
            '${selectedCountryCode.value}${phoneController.text}'.replaceAll(
              RegExp(r'\D'),
              '',
            ); // Sanitize
        // Keep the +
        final formatted = '+$fullPhoneNumber';

        final result = await _authRepo.requestSignUpOtp(formatted);

        if (result.isSuccess) {
          Get.toNamed(
            Routes.OTP_VERIFICATION.replaceFirst(':phoneNumber', formatted),
          );
        } else {
          Toast.error(result.errorMessage ?? 'Failed to send OTP');
        }
      } catch (e) {
        Toast.error('Something went wrong. Please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
