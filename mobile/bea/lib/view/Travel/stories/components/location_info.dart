import 'package:flutter/material.dart';
import 'package:OApp/utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class LocationInfo extends StatelessWidget {
  const LocationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on,
          color: AppColors.cFF2A8281, // Teal color
          size: MediaQueryUtil.iconSize(16),
        ),
        SizedBox(width: MediaQueryUtil.spacing(4)),
        Text(
          'New York, NY',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(14),
            fontWeight: FontWeight.w600,
            color: AppColors.cFF2A8281, // Teal color
          ),
        ),
      ],
    );
  }
}
