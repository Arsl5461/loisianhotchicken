import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:OApp/view/profileSetting/settings/controllers/premium_upgrade_controller.dart';
import 'package:get/get.dart';

class PremiumUpgradeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileDisplayController());

    Get.lazyPut(() => PremiumUpgradeController());
  }
}
