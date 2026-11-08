import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EngagementMetrics extends StatelessWidget {
  final VoidCallback onViewsTap;
  final VoidCallback onRepliesTap;
  final VoidCallback onLikesTap;

  const EngagementMetrics({
    super.key,
    required this.onViewsTap,
    required this.onRepliesTap,
    required this.onLikesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: onViewsTap,
          child: _buildEngagementMetric(
            icon: LucideIcons.eye,
            count: '256',
            label: 'VIEWS',
          ),
        ),
        GestureDetector(
          onTap: onRepliesTap,
          child: _buildEngagementMetric(
            icon: LucideIcons.send,
            count: '14',
            label: 'REPLIES',
          ),
        ),
        GestureDetector(
          onTap: onLikesTap,
          child: _buildEngagementMetric(
            icon: LucideIcons.heart,
            count: '3',
            label: 'LIKES',
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementMetric({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(14),
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: MediaQueryUtil.spacing(4)),
        Icon(icon, size: MediaQueryUtil.iconSize(18), color: AppColors.black),
        SizedBox(height: MediaQueryUtil.spacing(2)),
        Text(
          label,
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(10),
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
