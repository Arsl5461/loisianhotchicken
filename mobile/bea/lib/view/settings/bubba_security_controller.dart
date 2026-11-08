import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/design/widgets/bubba_loading.dart';
import '../../data/repositories/settings_repository.dart';
import '../../models/settings_models.dart';
import '../../services/global_service.dart';

/// Face ID is the one setting that is genuinely device-local: it gates this
/// install, not the account, so it stays in `GetStorage`. Everything else on
/// this controller is enforced by the server and has to reach it.
const String securityFaceIdKey = 'security.faceId';

class BubbaSecurityController extends GetxController {
  BubbaSecurityController({
    SettingsRepository? repository,
    LocalAuthentication? auth,
  }) : _repository = repository ?? Get.find<SettingsRepository>(),
       _auth = auth ?? LocalAuthentication();

  final SettingsRepository _repository;
  final LocalAuthentication _auth;
  final GetStorage _box = GetStorage();

  final Rx<PrivacySettings> privacy = const PrivacySettings().obs;
  final RxList<BlockedUser> blocked = <BlockedUser>[].obs;

  final RxBool loading = false.obs;
  final RxBool saving = false.obs;
  final RxBool blockedLoading = false.obs;
  final RxnString error = RxnString();
  final RxnString blockedError = RxnString();

  final RxBool faceId = false.obs;
  final RxBool biometricsAvailable = false.obs;

  bool _loadedOnce = false;

  @override
  void onInit() {
    super.onInit();
    BubbaBusy.watch([loading, saving, blockedLoading, accountLoading]);
    faceId.value = _box.read(securityFaceIdKey) as bool? ?? false;
    _checkBiometrics();
    load();
    loadAccount();
  }

  Future<void> _checkBiometrics() async {
    try {
      biometricsAvailable.value =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (error) {
      biometricsAvailable.value = false;
      debugPrint('BubbaSecurityController._checkBiometrics failed: $error');
    }
  }

  Future<void> load({bool force = false}) async {
    if (loading.value) return;
    if (_loadedOnce && !force) return;

    loading.value = true;
    error.value = null;

    final result = await _repository.fetchPrivacySettings();
    if (result.isSuccess && result.value != null) {
      privacy.value = result.value!;
      _loadedOnce = true;
    } else {
      error.value = result.errorMessage;
    }

    loading.value = false;
  }

  Future<bool> _save(
    Map<String, dynamic> patch,
    PrivacySettings optimistic,
  ) async {
    if (saving.value) return false;

    final previous = privacy.value;
    saving.value = true;
    error.value = null;
    privacy.value = optimistic;

    final result = await _repository.savePrivacySettings(patch);

    if (result.isSuccess && result.value != null) {
      privacy.value = result.value!;
    } else {
      privacy.value = previous;
      error.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  Future<bool> setReadReceipts(bool value) => _save({
    'read_receipts': value,
  }, privacy.value.copyWith(readReceipts: value));

  Future<bool> setLastActiveVisibility(LastActiveVisibility value) => _save({
    'last_active_visibility': value.apiValue,
  }, privacy.value.copyWith(lastActiveVisibility: value));

  Future<bool> setIncognito(bool value) =>
      _save({'incognito': value}, privacy.value.copyWith(incognito: value));

  Future<bool> setProfileVisibility(ProfileVisibility value) => _save({
    'profile_visibility': value.apiValue,
  }, privacy.value.copyWith(profileVisibility: value));

  Future<bool> setHideFromContacts(bool value) => _save({
    'hide_from_contacts': value,
  }, privacy.value.copyWith(hideFromContacts: value));

  // ---- Face ID ----

  /// Turning it on has to prove the device can actually do it, so it asks for
  /// the real biometric first. Turning it off never prompts.
  Future<bool> setFaceId(bool value) async {
    if (!value) {
      faceId.value = false;
      await _box.write(securityFaceIdKey, false);
      return true;
    }

    if (!biometricsAvailable.value) {
      await _checkBiometrics();
      if (!biometricsAvailable.value) {
        error.value = 'This device has no Face ID or fingerprint set up.';
        return false;
      }
    }

    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Confirm it is you to turn on Face ID',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      if (!ok) {
        error.value = 'Face ID was not confirmed.';
        return false;
      }

      faceId.value = true;
      await _box.write(securityFaceIdKey, true);
      return true;
    } catch (failure) {
      error.value = 'Face ID is not available right now.';
      debugPrint('BubbaSecurityController.setFaceId failed: $failure');
      return false;
    }
  }

  /// The unlock prompt the app shows on resume when Face ID is on.
  Future<bool> authenticate() async {
    if (!faceId.value) return true;

    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock Bubba',
        persistAcrossBackgrounding: true,
      );
    } catch (failure) {
      debugPrint('BubbaSecurityController.authenticate failed: $failure');
      return false;
    }
  }

  // ---- blocked users ----

  Future<void> loadBlocked({bool force = false}) async {
    if (blockedLoading.value) return;
    if (blocked.isNotEmpty && !force) return;

    blockedLoading.value = true;
    blockedError.value = null;

    final result = await _repository.fetchBlockedUsers();
    if (result.isSuccess) {
      blocked.assignAll(result.value ?? const []);
    } else {
      blockedError.value = result.errorMessage;
    }

    blockedLoading.value = false;
  }

  Future<bool> unblock(String userId) async {
    if (saving.value) return false;

    saving.value = true;
    blockedError.value = null;

    final result = await _repository.unblockUser(userId);
    if (result.isSuccess) {
      blocked.removeWhere((user) => user.id == userId);
    } else {
      blockedError.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  // ---- connected accounts ----

  final RxnString phone = RxnString();
  final RxnString emailAddress = RxnString();
  final RxnString appleKey = RxnString();
  final RxnString recoveryEmail = RxnString();
  final RxBool accountLoading = false.obs;

  String get phoneNumber =>
      phone.value ??
      Get.find<GlobalService>().getUserModel()?.phoneNumber ??
      '';

  String get email =>
      emailAddress.value ??
      Get.find<GlobalService>().getUserModel()?.email ??
      '';

  bool get appleConnected => (appleKey.value ?? '').isNotEmpty;

  Future<void> loadAccount({bool force = false}) async {
    if (accountLoading.value) return;
    accountLoading.value = true;

    final result = await _repository.fetchAccount();
    if (result.isSuccess && result.value != null) {
      final user = result.value!;
      phone.value = user['phoneNumber'] as String?;
      emailAddress.value = user['email'] as String?;
      appleKey.value = user['applekey'] as String?;
      recoveryEmail.value = user['recovery_email'] as String?;
    } else {
      error.value = result.errorMessage;
    }

    accountLoading.value = false;
  }

  Future<bool> setAppleKey(String? key) async {
    if (saving.value) return false;

    saving.value = true;
    error.value = null;

    final result = await _repository.updateAppleKey(key);
    if (result.isSuccess) {
      appleKey.value = key;
    } else {
      error.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  Future<bool> removeRecoveryEmail() async {
    if (saving.value) return false;

    saving.value = true;
    error.value = null;

    final result = await _repository.removeRecoveryEmail();
    if (result.isSuccess) {
      recoveryEmail.value = null;
    } else {
      error.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  String get connectedSummary {
    final parts = <String>[];
    if (phoneNumber.isNotEmpty) parts.add('Phone');
    if (appleConnected) parts.add('Apple');
    if ((recoveryEmail.value ?? email).isNotEmpty) parts.add('Email');
    return parts.isEmpty ? 'Not connected' : parts.join(', ');
  }

  static BubbaSecurityController get to {
    if (!Get.isRegistered<BubbaSecurityController>()) {
      Get.put(BubbaSecurityController(), permanent: true);
    }
    return Get.find<BubbaSecurityController>();
  }
}
