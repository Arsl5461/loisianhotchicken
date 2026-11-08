import 'package:get/get.dart';

import '../profile_making_controller/profile_controller.dart';

class ProfileMakingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
