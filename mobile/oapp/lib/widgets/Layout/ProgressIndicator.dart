import 'package:flutter/material.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? progressColor;
  final Color? remainingColor;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? padding;

  const CustomProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.progressColor,
    this.remainingColor,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil for responsive design
    MediaQueryUtil.init(context);

    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(20),
            vertical: MediaQueryUtil.spacing(12),
          ),
      child: Row(
        children: [
          Expanded(
            flex: currentStep,
            child: Container(
              height: MediaQueryUtil.spacing(height ?? 4),
              decoration: BoxDecoration(
                color: progressColor ?? AppColors.cFF1E88E5,
                borderRadius: BorderRadius.circular(
                  MediaQueryUtil.spacing(borderRadius ?? 2),
                ),
              ),
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(4)),
          Expanded(
            flex: totalSteps - currentStep,
            child: Container(
              height: MediaQueryUtil.spacing(height ?? 4),
              decoration: BoxDecoration(
                color: (remainingColor ?? AppColors.white).withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(
                  MediaQueryUtil.spacing(borderRadius ?? 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
