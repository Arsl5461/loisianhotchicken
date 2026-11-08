import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../utils/media_query.dart';

class CommonDatingWidgets {
  Widget buildDealBreakerWidget({
    required String title,
    required String description,
    required RxBool isDealBreaker,
  }) {
    return // Deal breaker toggle
    Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(20),
        vertical: MediaQueryUtil.spacing(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Is this a deal breaker?',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(16),
                fontWeight: FontWeight.w500,
                color: AppColors.black87,
              ),
            ),
          ),
          Obx(
            () => Transform.scale(
              scale: MediaQueryUtil.isTablet ? 1.2 : 1.0,
              child: Switch(
                value: isDealBreaker.value,
                onChanged: (value) {
                  isDealBreaker.value = value;
                },
                activeThumbColor: AppColors.white,
                activeTrackColor: AppColors.cFF4A90E2,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.grey[300],
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget goBackButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Text(
        "Go back",
        style: TextStyle(
          fontSize: MediaQueryUtil.fontSize(14),
          fontWeight: FontWeight.w400,
          color: AppColors.black87,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.black87,
          decorationThickness: 1.0,
        ),
      ),
    );
  }

  static Widget goBackNavigation() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(20),
        vertical: MediaQueryUtil.spacing(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),

              child: Icon(
                Icons.arrow_back_ios,
                size: MediaQueryUtil.iconSize(20),
                color: AppColors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
