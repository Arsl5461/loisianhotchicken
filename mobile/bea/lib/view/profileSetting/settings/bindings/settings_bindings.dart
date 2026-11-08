import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:OApp/view/profileSetting/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileDisplayController());

    Get.lazyPut(() => SettingsController());
  }
}
