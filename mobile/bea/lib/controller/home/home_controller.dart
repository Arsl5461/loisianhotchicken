import 'package:get/get.dart';

import 'home_controller_base.dart';
import 'home_matches_mixin.dart';
import 'home_onboarding_mixin.dart';
import 'home_preferences_mixin.dart';
import 'home_swipe_mixin.dart';

class HomeController extends HomeControllerBase
    with
        GetTickerProviderStateMixin,
        HomeMatchesMixin,
        HomePreferencesMixin,
        HomeSwipeMixin,
        HomeOnboardingMixin {
  @override
  void onInit() {
    super.onInit();
    initSwipeAnimations(this);
    fetchInitialData();
  }

  @override
  void onClose() {
    disposeSwipeAnimations();
    super.onClose();
  }
}
