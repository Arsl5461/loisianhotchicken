import 'package:OApp/widget_helper/common_widgets.dart';
import 'package:OApp/widgets/custom_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

class DatingProfileHeader extends StatelessWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onFilterTap;

  const DatingProfileHeader({super.key, this.onBackTap, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back arrow icon (left)
            GestureDetector(
              onTap: onBackTap ?? () => Get.back(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
                child: CustomSvgIcons.backArrow(
                  color: AppColors.black,
                  size: MediaQueryUtil.iconSize(14),
                ),
              ),
            ),

            // Base64OrNetworkImage(
            //   imageData: 'assets/images/logo.png',

            //   width: MediaQueryUtil.spacing(110),
            //   height: MediaQueryUtil.spacing(40),
            //   fit: BoxFit.cover,
            // ),
            CommonWidgets.appLogo(
              reducedSizeFactor: 0.35,
              color: AppColors.black,
            ),
            // Title "Oapp" (center)
            // Text(
            //   'Oapp',
            //   style: AppTextStyles.text(
            //     fontFamily: AppFontFamily.playfair,
            //     customSize: MediaQueryUtil.fontSize(30),
            //     fontWeight: AppFontWeight.semiBold,
            //   ),
            // ),

            // Filter icon (right side) — min 44pt tap target
            SizedBox(
              width: MediaQueryUtil.iconSize(44),
              height: MediaQueryUtil.iconSize(44),
              child: GestureDetector(
                onTap: onFilterTap,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: CustomSvgIcons.filter(
                    color: AppColors.black,
                    size: MediaQueryUtil.iconSize(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
