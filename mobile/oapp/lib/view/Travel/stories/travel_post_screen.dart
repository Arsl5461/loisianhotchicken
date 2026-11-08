import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/Travel/stories/components/image_carousel.dart';
import 'package:OApp/view/Travel/stories/components/engagement_metrics.dart';
import 'package:OApp/view/Travel/stories/components/location_info.dart';
import 'package:OApp/view/Travel/stories/components/bottom_sheets.dart';
import 'package:OApp/view/Travel/stories/components/action_sheets.dart';

import 'package:OApp/core/constants/app_colors.dart';

class TravelPostScreen extends StatefulWidget {
  const TravelPostScreen({super.key});

  @override
  State<TravelPostScreen> createState() => _TravelPostScreenState();
}

class _TravelPostScreenState extends State<TravelPostScreen> {
  static const List<String> imageUrls = [
    'https://images.unsplash.com/photo-1527736947477-2790e28f3443?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=762',
    'https://plus.unsplash.com/premium_photo-1664474515281-7fc50ac83da4?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    'https://plus.unsplash.com/premium_photo-1670282393309-70fd7f8eb1ef?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Full-length main photo with time overlay and carousel dots
            Expanded(
              child: ImageCarousel(
                images: imageUrls,
                currentIndex: _currentIndex,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                onActionTap: () => ActionSheets.showActionSheet(context),
              ),
            ),

            // Location and engagement metrics
            Padding(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
              child: Column(
                children: [
                  // Location with teal color
                  LocationInfo(),
                  SizedBox(height: MediaQueryUtil.spacing(16)),

                  // Engagement metrics
                  EngagementMetrics(
                    onViewsTap: () =>
                        BottomSheets.showViewsBottomSheet(context),
                    onRepliesTap: () =>
                        BottomSheets.showRepliesBottomSheet(context),
                    onLikesTap: () =>
                        BottomSheets.showLikesBottomSheet(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
