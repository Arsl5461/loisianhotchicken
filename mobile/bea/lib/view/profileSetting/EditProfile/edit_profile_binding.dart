import 'package:get/get.dart';
import 'edit_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditController>(() => EditController());
  }
}
