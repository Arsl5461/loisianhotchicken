import 'package:OApp/view/Travel/choose_location_screen.dart';
import 'package:OApp/view/Travel/new_travel_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/widgets/ButtomNavigationBar/customBottomNavBar.dart';
import 'package:OApp/core/animations/bottom_nav_animation.dart';
import 'dashboard_controller.dart';

// Screens
import 'package:OApp/view/HomeScreen/home_screen.dart';
import 'package:OApp/view/YourLikes/your_likes_screen.dart';
import 'package:OApp/view/messages/contact_list.dart';
import 'package:OApp/view/profileSetting/ProfilrMainPage/profile.dart';

import 'package:OApp/core/constants/app_colors.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: PageView(
        controller: controller.pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swiping for tab-like behavior
        onPageChanged: (index) {
          // Only update if not disposed
          if (!controller.isDisposed) {
            controller.selectedIndex.value = index;
          }
        },
        children: [
          HomeScreen(),
          YourLikesScreen(),
          Obx(() {
            final selectedCity = controller.selectedTravelCity.value;
            if (selectedCity == null) {
              return ChooseLocationScreen();
            }
            return NewTravelScreen(onBack: controller.closeTravelCity);
          }),
          Chatlist(),
          ThemedProfileScreen(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavBar(
          child: CustomBottomNavBar(
            selectedIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
          ),
        ),
      ),
    );
  }
}
