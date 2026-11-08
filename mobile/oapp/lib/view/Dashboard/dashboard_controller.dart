import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/utils/scroll_notifier.dart';

import '../messages/controller/chat_list_controller.dart';

class DashboardController extends GetxController {
  ChatListController get chatListController => Get.find<ChatListController>();
  static DashboardController get to => Get.find();

  var selectedIndex = 0.obs;
  final RxnString selectedTravelCity = RxnString();
  bool isDisposed = false;
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();

    // Ensure nav bar is visible initially
    globalScrollNotifier.resetToVisible();

    // Determine selected index from the current route/arguments
    String currentRoute = Get.currentRoute;
    if (currentRoute.startsWith(Routes.MATCHES)) {
      selectedIndex.value = 1;
    } else if (currentRoute.startsWith(Routes.TRAVEL) ||
        currentRoute.startsWith(Routes.NEW_TRAVEL) ||
        currentRoute.startsWith(Routes.CHOOSE_LOCATION)) {
      selectedIndex.value = 2;
    } else if (currentRoute.startsWith(Routes.MESSAGES)) {
      selectedIndex.value = 3;
    } else if (currentRoute.startsWith(Routes.PROFILE)) {
      selectedIndex.value = 4;
    }

    // Override with argument if provided
    if (Get.arguments != null && Get.arguments is int) {
      selectedIndex.value = Get.arguments;
    }

    // Initialize PageController once after index is finalized
    pageController = PageController(initialPage: selectedIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    isDisposed = true;
    super.onClose();
  }

  void changeIndex(int index) {
    if (selectedIndex.value == index) return;

    if (index == 3) {
      if (!chatListController.isConnected.value) {
        chatListController.connect();
      }
    }

    selectedIndex.value = index;

    // Ensure safe jump after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.jumpToPage(index);
      }
    });

    globalScrollNotifier.resetToVisible();
  }

  void openTravelCity(String cityName) {
    selectedTravelCity.value = cityName;
    changeIndex(2);
  }

  void closeTravelCity() {
    selectedTravelCity.value = null;
    changeIndex(2);
  }
}
