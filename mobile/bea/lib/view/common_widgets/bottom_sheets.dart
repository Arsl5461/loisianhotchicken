import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../utils/media_query.dart';

class CommonBottomSheets {
  static Widget commonBottomSheet({
    required String title,
    EdgeInsetsGeometry? paddingSheet,
    required Widget child,
    bool centerTitle = false,
  }) {
    return SafeArea(
      child: Container(
        padding:
            paddingSheet ??
            EdgeInsets.fromLTRB(
              MediaQueryUtil.spacing(20),
              MediaQueryUtil.spacing(10),
              MediaQueryUtil.spacing(20),
              MediaQueryUtil.spacing(20),
            ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MediaQueryUtil.spacing(18)),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              /// Instagram style handle
              Center(
                child: Container(
                  width: MediaQueryUtil.spacing(40),
                  height: MediaQueryUtil.spacing(4),
                  margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(14)),
                  decoration: BoxDecoration(
                    color: AppColors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              /// Title
              Align(
                alignment: centerTitle
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black87,
                  ),
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(16)),

              /// Content
              child,
            ],
          ),
        ),
      ),
    );
  }
}
