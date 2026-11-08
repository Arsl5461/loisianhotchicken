import 'package:OApp/controller/home_controller.dart';
import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:get/get.dart';

class DatingPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EditController>()) {
      Get.lazyPut<EditController>(() => EditController(), fenix: true);
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    }
  }
}
