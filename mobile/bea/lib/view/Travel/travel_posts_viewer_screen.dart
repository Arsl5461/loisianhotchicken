import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../utils/media_query.dart';
import 'controller/travel_posts_viewer_controller.dart';
import 'sub_widgets/travel_bottom_sheet.dart';

class TravelPostsViewerScreen extends GetView<TravelPostsViewerController> {
  const TravelPostsViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Obx(() {
      if (!controller.isReady.value) {
        return const Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.cFF006A68),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(child: TravelPostsViewer(isFullScreen: true)),
      );
    });
  }
}
