import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_keys.dart';
import 'secure_storage_service.dart';

class DeepLinkService {
  final SecureStorageService _storage = Get.find<SecureStorageService>();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  void init() {
    // Handle app opened from terminated state
    if (Platform.isWindows || Platform.isLinux) {
      return;
    }
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    });

    // Handle app opened from background
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) async {
    debugPrint("Deep link received: $uri");

    // Example URL:
    // https://edra-unimmigrating-unadjunctively.ngrok-free.dev/signup?ref=TEST123

    final refCode = uri.queryParameters['ref'];

    if (refCode != null) {
      debugPrint("Referral Code: $refCode");
      saveReferralCode(refCode);

      //   Toast.success("Referral code saved!");
      // if (!Get.isRegistered<ProfileDisplayController>()) {
      //   Get.put(ProfileDisplayController());
      // }
      // ProfileDisplayController profileController =
      //     Get.find<ProfileDisplayController>();

      // await profileController.logout();
      // Get.offAllNamed(Routes.ACCOUNT_SETUP);
      // 👉 Navigate or store it
      // Example using Navigator: Navigator.pushNamed(context, '/signup', arguments: refCode);
    }
  }

  Future<void> saveReferralCode(String refCode) async {
    // final existing = await _storage.getKey(AppKeys.referralCode);

    //if (existing == null) {
    await _storage.setKey(AppKeys.referralCode, refCode);
    // }
  }

  Future<String?> getReferralCode() async {
    return _storage.getKey(AppKeys.referralCode);
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
