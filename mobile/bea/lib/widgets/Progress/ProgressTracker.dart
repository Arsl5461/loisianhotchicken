import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class ProgressTracker extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  final Color? color;

  const ProgressTracker({super.key, required this.progress, this.color});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    final backgroundColor = color ?? AppColors.cFF006C6A; // Teal color

    return Container(
      width: double.infinity,
      height: MediaQueryUtil.spacing(4),
      decoration: BoxDecoration(
        color: AppColors.grey[200],
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(2)),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(2)),
          ),
        ),
      ),
    );
  }
}
