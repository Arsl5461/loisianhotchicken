import 'package:get/get.dart';

import '../../../services/global_service.dart';
import '../choose_location_controller.dart';
import '../controller/travel_posts_viewer_controller.dart';

class TravelPostsViewerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelPostsViewerController>(
      () => TravelPostsViewerController(
        globalService: Get.find<GlobalService>(),
        chooseLocationController: Get.find<ChooseLocationController>(),
      ),
    );
  }
}
