import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../services/dailog_service.dart';
import '../../controller/profile_display_controller.dart';

class SettingsController extends GetxController {
  final GetStorage _box = GetStorage();

  final RxBool pauseAccount = false.obs;
  final RxBool incognitoMode = false.obs;

  final DialogService dialogService = Get.find<DialogService>();

  final ProfileDisplayController profileController =
      Get.find<ProfileDisplayController>();

  @override
  void onInit() {
    super.onInit();

    final p = _box.read('settings.pauseAccount');
    final i = _box.read('settings.incognitoMode');

    if (p is bool) pauseAccount.value = p;
    if (i is bool) incognitoMode.value = i;
  }

  void toggleIncognito(bool value) {
    incognitoMode.value = value;
    _box.write('settings.incognitoMode', value);
  }

  void pauseAccountConfirm(bool value) {
    pauseAccount.value = value;

    _box.write('settings.pauseAccount', true);
  }

  void unpauseAccount() {
    pauseAccount.value = false;

    _box.write('settings.pauseAccount', false);
  }

  void logout() {
    profileController.logout();
  }
}
