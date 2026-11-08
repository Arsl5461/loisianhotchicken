import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/Travel/stories/components/image_carousel.dart';
import 'package:OApp/view/Travel/stories/components/action_sheets.dart';

import 'package:OApp/core/constants/app_colors.dart';

class TravelPostDetailScreen extends StatefulWidget {
  const TravelPostDetailScreen({super.key});

  @override
  State<TravelPostDetailScreen> createState() => _TravelPostDetailScreenState();
}

class _TravelPostDetailScreenState extends State<TravelPostDetailScreen> {
  // Different image URLs for carousel
  static const List<String> imageUrls = [
    'https://images.unsplash.com/photo-1586351012965-861624544334?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    'https://images.unsplash.com/photo-1609505848912-b7c3b8b4beda?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=765',
  ];

  int _currentIndex = 0;
  final TextEditingController _messageController = TextEditingController();
  bool _isFavorite = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image carousel exactly like travel post screen
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

            // Timestamp
            Padding(
              padding: EdgeInsets.only(
                top: MediaQueryUtil.spacing(8),
                bottom: MediaQueryUtil.spacing(16),
              ),
              child: Text(
                '2h ago',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
              ),
            ),

            // Message input section
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQueryUtil.spacing(12),
                0,
                MediaQueryUtil.spacing(12),
                MediaQueryUtil.spacing(12),
              ),
              child: Row(
                children: [
                  // Message input field with profile picture inside
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.black, width: 1),
                      ),
                      child: Row(
                        children: [
                          // Profile picture inside the input box
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQueryUtil.spacing(8),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                              ),
                            ),
                          ),
                          SizedBox(width: MediaQueryUtil.spacing(8)),
                          // Text input field
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Send message',
                                hintStyle: TextStyle(
                                  color: AppColors.grey[500],
                                  fontSize: MediaQueryUtil.fontSize(14),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQueryUtil.spacing(8),
                                  vertical: MediaQueryUtil.spacing(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQueryUtil.spacing(12)),
                  // Heart icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? AppColors.red : AppColors.grey[600],
                      size: MediaQueryUtil.iconSize(28),
                    ),
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
