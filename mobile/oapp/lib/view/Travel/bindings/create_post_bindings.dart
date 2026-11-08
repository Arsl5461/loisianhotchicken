import 'package:get/get.dart';

import '../controller/create_post_controller.dart';

class CreatePostBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CreatePostController>()) {
      Get.lazyPut<CreatePostController>(() => CreatePostController());
    }
  }
}
