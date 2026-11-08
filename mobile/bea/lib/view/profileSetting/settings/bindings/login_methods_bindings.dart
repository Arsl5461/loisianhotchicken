import 'package:OApp/view/profileSetting/settings/controllers/login_methods_controller.dart';
import 'package:get/get.dart';

class LoginMethodsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginMethodsController());
  }
}
