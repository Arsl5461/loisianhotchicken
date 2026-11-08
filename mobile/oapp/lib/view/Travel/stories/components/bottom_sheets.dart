import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:OApp/core/constants/app_colors.dart';

class BottomSheets {
  static void showViewsBottomSheet(BuildContext context) {
    final viewProfiles = [
      {
        'image':
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
        'name': 'Emma Wilson',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Sophie Chen',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Isabella Rodriguez',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Olivia Thompson',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Ava Martinez',
      },
    ];

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(12),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: MediaQueryUtil.spacing(40),
                  height: MediaQueryUtil.spacing(4),
                  decoration: BoxDecoration(
                    color: AppColors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(8)),

              // Title
              Text(
                'Views',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Profile list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: viewProfiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQueryUtil.spacing(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            viewProfiles[index]['image']!,
                          ),
                        ),
                        SizedBox(width: MediaQueryUtil.spacing(12)),
                        Text(
                          viewProfiles[index]['name']!,
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(12),
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void showRepliesBottomSheet(BuildContext context) {
    final replies = [
      {
        'image':
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
        'name': 'Emma Wilson',
        'reply':
            'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh',
        'time': '10:25 pm',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Sophie Chen',
        'reply':
            'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh',
        'time': '10:25 pm',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Isabella Rodriguez',
        'reply':
            'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh',
        'time': '10:25 pm',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Olivia Thompson',
        'reply':
            'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh',
        'time': '10:25 pm',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Ava Martinez',
        'reply':
            'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh',
        'time': '10:25 pm',
      },
    ];

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(12),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: MediaQueryUtil.spacing(40),
                  height: MediaQueryUtil.spacing(4),
                  decoration: BoxDecoration(
                    color: AppColors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(8)),

              // Title
              Text(
                'Replies',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Replies list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: replies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQueryUtil.spacing(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            replies[index]['image']!,
                          ),
                        ),
                        SizedBox(width: MediaQueryUtil.spacing(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                replies[index]['name']!,
                                style: TextStyle(
                                  fontSize: MediaQueryUtil.fontSize(12),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: MediaQueryUtil.spacing(4)),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      replies[index]['reply']!,
                                      style: TextStyle(
                                        fontSize: MediaQueryUtil.fontSize(12),
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey[600],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: MediaQueryUtil.spacing(12)),
                                  Icon(
                                    LucideIcons.send,
                                    size: MediaQueryUtil.iconSize(18),
                                    color: AppColors.black87,
                                  ),
                                ],
                              ),
                              SizedBox(height: MediaQueryUtil.spacing(4)),
                              Text(
                                replies[index]['time']!,
                                style: TextStyle(
                                  fontSize: MediaQueryUtil.fontSize(10),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void showLikesBottomSheet(BuildContext context) {
    final likeProfiles = [
      {
        'image':
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
        'name': 'Kendall Jenner',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Kendall Jenner',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=687&auto=format&fit=crop&ixlib=rb-5.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Kendall Jenner',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=687&auto=format&fit=crop&ixlib=rb-5.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Kendall Jenner',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=687&auto=format&fit=crop&ixlib=rb-5.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'name': 'Kendall Jenner',
      },
    ];

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        MediaQueryUtil.init(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(12),
            MediaQueryUtil.spacing(16),
            MediaQueryUtil.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: MediaQueryUtil.spacing(40),
                  height: MediaQueryUtil.spacing(4),
                  decoration: BoxDecoration(
                    color: AppColors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(8)),

              // Title
              Text(
                'Likes',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(12)),

              // Likes list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: likeProfiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQueryUtil.spacing(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            likeProfiles[index]['image']!,
                          ),
                        ),
                        SizedBox(width: MediaQueryUtil.spacing(12)),
                        Expanded(
                          child: Text(
                            likeProfiles[index]['name']!,
                            style: TextStyle(
                              fontSize: MediaQueryUtil.fontSize(12),
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        Icon(
                          LucideIcons.send,
                          size: MediaQueryUtil.iconSize(18),
                          color: AppColors.black87,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
