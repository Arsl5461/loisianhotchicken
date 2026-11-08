import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showProfilePreviewDialog({
  required UserModel user,
  required String profileImage,
}) {
  showDialog(
    barrierDismissible: true,
    context: Get.context!,
    barrierColor: AppColors.c185755.withValues(alpha: 0.2),
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.only(
          left: MediaQueryUtil.spacing(4),
          right: MediaQueryUtil.spacing(4),
          top: MediaQueryUtil.spacing(120),
          bottom: MediaQueryUtil.spacing(0),
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQueryUtil.height * 0.6,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MediaQueryUtil.spacing(30),
                        ),
                        child: Base64OrNetworkImage(
                          width: double.infinity,
                          height: MediaQueryUtil.height * 0.6,
                          imageData: profileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: MediaQueryUtil.spacing(20),
                        left: MediaQueryUtil.spacing(20),
                        right: MediaQueryUtil.spacing(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQueryUtil.spacing(8),
                                vertical: MediaQueryUtil.spacing(4),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cFF2FB9B6,
                                borderRadius: BorderRadius.circular(
                                  MediaQueryUtil.spacing(6),
                                ),
                              ),
                              child: Text(
                                'New Member',
                                style: AppTextStyles.small(
                                  fontWeight: AppFontWeight.semiBold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(10)),
                            Text(
                              user.fullName ?? 'Claudia',
                              style: AppTextStyles.large(
                                fontFamily: AppFontFamily.publicSans,
                                fontWeight: AppFontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(4)),
                            Text(
                              (user.jobTitle != null && user.companyName != null)
                                  ? '${user.jobTitle} at ${user.companyName}'
                                  : 'Founder at Pine',
                              style: AppTextStyles.regular(
                                fontWeight: AppFontWeight.semiBold,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(2)),
                            Text(
                              user.hometown ?? 'Manhattan, NY',
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(20)),
                SizedBox(
                  width: double.infinity,
                  height: MediaQueryUtil.spacing(50),
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await Future.delayed(const Duration(milliseconds: 300));
                      Get.toNamed(Routes.EDIT_PROFILE, arguments: user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cFF006C6A,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          MediaQueryUtil.spacing(12),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.regular(
                        fontWeight: AppFontWeight.semiBold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
