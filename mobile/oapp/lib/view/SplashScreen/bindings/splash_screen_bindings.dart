import 'package:get/get.dart';

import '../../ProfileMaking/profile_making_controller/profile_controller.dart';
import '../controllers/splash_screen_controller.dart';

class OappSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OappSplashController(), permanent: false);
    Get.put(ProfileController(), permanent: true);
  }
}
