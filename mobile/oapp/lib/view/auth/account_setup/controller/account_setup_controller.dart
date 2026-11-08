import 'package:get/get.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../../services/secure_storage_service.dart';

class AccountSetupController extends GetxController {
  RxString referralCode = ''.obs;
  final SecureStorageService _storage = Get.find<SecureStorageService>();

  @override
  void onInit() {
    super.onInit();
    getReferralCode();
  }

  getReferralCode() async {
    referralCode.value = await _storage.getKey(AppKeys.referralCode) ?? "";
  }

  Future<void> saveReferralCode(String code) async {
    referralCode.value = code.trim();
    if (code.trim().isEmpty) {
      await _storage.deleteKey(AppKeys.referralCode);
    } else {
      await _storage.setKey(AppKeys.referralCode, code.trim());
    }
  }
}
