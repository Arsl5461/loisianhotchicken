import 'package:OApp/config/error_handler.dart';
import 'package:OApp/services/global_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../models/user_model.dart';
import '../../../../services/firebaseauth_service.dart';
import '../../../../utils/toast.dart';

class LoginMethodsController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  FirebaseAuthService get _authService => Get.find<FirebaseAuthService>();
  GlobalService get _globalService => Get.find<GlobalService>();
  final RxString currentPhoneNumber = '******4286'.obs;
  final RxBool isEditingPhone = false.obs;
  final RxString appleLoginKey = "".obs;
  final RxString facebookLoginKey = "".obs;
  final RxString googleLoginKey = "".obs;
  final RxBool isLoading = false.obs;
  final RxBool showError = false.obs;
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  UserModel? user;
  final String _tag = "LoginMethodsController";
  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validatePhone);
    user = _globalService.getUserModel();
    assignValues();
  }

  @override
  void onClose() {
    phoneController.removeListener(_validatePhone);
    phoneController.dispose();
    super.onClose();
  }

  void _validatePhone() {
    showError.value =
        phoneController.text.isNotEmpty && phoneController.text.length < 10;
  }

  void togglePhoneEditing() {
    if (isEditingPhone.value) {
      if (phoneController.text.length < 10) {
        showError.value = true;
        return;
      }

      currentPhoneNumber.value = phoneController.text;
      isEditingPhone.value = false;
      showError.value = false;
      return;
    }

    isEditingPhone.value = true;
    phoneController.clear();
  }

  bool get hasAnyOtherLoginMethod =>
      appleLoginKey.value.isNotEmpty ||
      facebookLoginKey.value.isNotEmpty ||
      googleLoginKey.value.isNotEmpty ||
      currentPhoneNumber.value.isNotEmpty;

  void addAppleId() async {
    UserCredential? userCred = await _authService.signInWithApple();
    if (userCred != null) {
      appleLoginKey.value = userCred.user?.uid ?? "";
    }
    _showAddedMessage('Apple ID');
  }

  void addFacebookLogin() async {
    UserCredential? userCred = await _authService.signInWithFacebook();
    if (userCred != null) {
      facebookLoginKey.value = userCred.user?.uid ?? "";
      _showAddedMessage('Facebook');
    }
  }

  void addGoogleLogin() async {
    UserCredential? userCred = await _authService.signInWithGoogle();
    if (userCred != null) {
      googleLoginKey.value = userCred.user?.uid ?? "";
      _showAddedMessage('Google');
    }
  }

  void _showAddedMessage(String providerName) {
    Get.snackbar(
      'Login Method Added',
      '$providerName login added successfully.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void updateLoginMethods() async {
    try {
      isLoading.value = true;
      if (hasAnyOtherLoginMethod) {
        final success = await _authRepo.updateLoginMethods(
          phoneNumber: currentPhoneNumber.value,
          facebookKey: facebookLoginKey.value,
          googleKey: googleLoginKey.value,
          appleKey: appleLoginKey.value,
        );

        if (success) {
          Toast.success("Login methods updated successfully.");
        } else {
          Toast.error("Failed to update login methods. Please try again.");
        }
      }
    } catch (e, s) {
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
      Toast.error("Failed to update login methods. Please try again.");
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void removePhoneNumber() {
    phoneController.clear();
    currentPhoneNumber.value = '';
    Toast.success("Phone number removed successfully.");
  }

  void assignValues() {
    currentPhoneNumber.value = user?.phoneNumber ?? 'No phone number';
    appleLoginKey.value = user?.applekey ?? "";
    facebookLoginKey.value = user?.facebookkey ?? "";
    googleLoginKey.value = user?.googlekey ?? "";
  }
}
