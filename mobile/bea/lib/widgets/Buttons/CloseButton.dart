import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CustomCloseButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomCloseButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return GestureDetector(
      onTap: onTap ?? () => Get.back(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
        child: Icon(
          Icons.close,
          size: MediaQueryUtil.iconSize(30),
          color: AppColors.black87,
        ),
      ),
    );
  }
}
