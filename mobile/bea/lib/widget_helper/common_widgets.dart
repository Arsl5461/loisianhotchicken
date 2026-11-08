import 'package:flutter/material.dart';

import '../config/app_common_sizes.dart';
import '../core/constants/app_colors.dart';
import '../widgets/Images/base64OrNetworkImage.dart';

class CommonWidgets {
  static Widget appLogo({double reducedSizeFactor = 1.0, Color? color}) {
    return Base64OrNetworkImage(
      height: AppCommonSizes.appLogoHeight * reducedSizeFactor,
      width: AppCommonSizes.appLogoWidth * reducedSizeFactor,

      svgColor: color ?? AppColors.white,
      imageData: 'assets/svg/bubba_logo_wordmark.svg',

      fit: BoxFit.contain,
    );
  }
}
