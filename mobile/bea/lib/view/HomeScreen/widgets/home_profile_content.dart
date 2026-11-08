import 'package:OApp/controller/home_controller.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/view/HomeScreen/widgets/home_profile_card.dart';
import 'package:OApp/view/HomeScreen/widgets/home_profile_section.dart';
import 'package:flutter/material.dart';
import '../../../utils/media_query.dart';

class HomeProfileContent extends StatelessWidget {
  const HomeProfileContent({
    super.key,
    required this.controller,
    required this.profile,
    required this.cardHeight,
  });

  final HomeController controller;
  final UserModel profile;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadPosts,
      child: ListView(
        controller: controller.scrollController,
        padding: EdgeInsets.zero,
        cacheExtent: cardHeight,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQueryUtil.spacing(4)),
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: controller.swipeAnimation,
                child: HomeProfileCard.buildProfileCard(
                  controller: controller,
                  context: context,
                  user: profile,
                  cardHeight: cardHeight,
                ),
                builder: (context, child) {
                  final isLeft = controller.isSwipeLeft.value;
                  final translationX = isLeft
                      ? -controller.swipeAnimation.value * 400
                      : controller.swipeAnimation.value * 400;
                  final rotation = isLeft
                      ? -controller.swipeAnimation.value * 0.3
                      : controller.swipeAnimation.value * 0.3;

                  return Transform.translate(
                    offset: Offset(translationX, 0),
                    child: Transform.rotate(
                      angle: rotation,
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
          HomeProfileSection(
            currentProfile: profile,
            parentContext: context,
          ),
        ],
      ),
    );
  }
}
