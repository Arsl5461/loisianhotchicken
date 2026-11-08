import 'package:OApp/view/profileSetting/Invite/controller/referral_rewards_controller.dart';
import 'package:get/get.dart';

class ReferralRewardsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReferralRewardsController());
  }
}
