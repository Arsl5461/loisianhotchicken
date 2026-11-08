import 'package:get/get.dart';
import '../controllers/otp_signin_controller.dart';

class OTPSignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OTPSignInController>(() => OTPSignInController());
  }
}
