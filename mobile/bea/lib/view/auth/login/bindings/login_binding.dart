import 'package:get/get.dart';
import '../../signin_otp/controllers/otp_signin_controller.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<OTPSignInController>(() => OTPSignInController());
  }
}
