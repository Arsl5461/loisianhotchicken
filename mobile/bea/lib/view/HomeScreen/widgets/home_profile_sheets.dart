import 'package:OApp/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Images/Base64OrNetworkImage.dart';
import '../../../widgets/Input/CustomTextField.dart';
import '../../../widgets/Navigation/GoBackLink.dart';
import '../../common_widgets/bottom_sheets.dart';
import '../../common_widgets/buttons.dart';
import '../../profileSetting/models/ice_breaker_model.dart';
import 'ImageViewerModal.dart';
import 'ice_breaker_card.dart';

class HomeProfileSheets {
  HomeProfileSheets._();

  static void showImageViewerModal({
    required BuildContext context,
    required UserModel currentProfile,
    required HomeController controller,
  }) {
    if (currentProfile.photos == null || currentProfile.photos!.isEmpty) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: AppColors.black,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return ImageViewerModal(
          images: currentProfile.photos!,
          initialIndex: controller.selectedImageIndex.value,
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static void openLikeSheet({
    required UserModel currentProfile,
    required HomeController controller,
  }) {
    Get.bottomSheet(
      SizedBox(
        height: Get.height,
        child: CommonBottomSheets.commonBottomSheet(
          paddingSheet: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(10),
            vertical: MediaQueryUtil.spacing(10),
          ),
          title: "",
          child: SizedBox(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                ),
                child: Column(
                  spacing: MediaQueryUtil.spacing(20),
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.start,
                          currentProfile.fullName ?? "User",
                          style: AppTextStyles.medium(
                            fontWeight: AppFontWeight.semiBold,
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Base64OrNetworkImage(
                        imageData: currentProfile.photos?.first ?? "",
                        width: double.infinity,
                        height: MediaQueryUtil.height * 0.50,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: CustomTextField(
                        controller: controller.replyController,
                        hintText: 'Add a Comment',

                        backgroundColor: AppColors.white,
                        borderColor: AppColors.grey[300], // Teal color
                        hintStyle: AppTextStyles.verySmall(
                          color: AppColors.grey[700],
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        borderRadius: 12,
                        onChanged: (val) {
                          controller.replyText.value = val;
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                    ),

                    CommonButtons.commonButton(
                      marginButton: EdgeInsets.symmetric(
                        horizontal: MediaQueryUtil.spacing(0),
                        vertical: MediaQueryUtil.spacing(0),
                      ),
                      borderRadius: 50,
                      height: MediaQueryUtil.spacing(60),
                      text: "Send Like",
                      backgroundColor: AppColors.c185755,
                      textStyle: AppTextStyles.small(
                        fontWeight: AppFontWeight.bold,
                        color: AppColors.white,
                      ),
                      onPressed: () async {
                        Get.back();
                        if (controller.replyText.value.trim().isEmpty) {
                          controller.swipeRight(({required bool isLeft}) async {
                            controller.isSwipeLeft.value = false;
                            await controller.runSwipeAnimation(isLeft: false);
                          });
                        } else {
                          controller.swipeRightWithComment(
                            currentProfile.id ?? "",
                            controller.replyText.value,

                            ({required bool isLeft}) async {
                              controller.isSwipeLeft.value = false;
                              await controller.runSwipeAnimation(isLeft: false);
                            },
                          );
                        }
                      },
                    ),
                    GoBackLink(
                      text: "Cancel",
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  static void openReplyBottomSheet({
    required IceBreakerModel item,
    required UserModel currentProfile,
    required HomeController controller,
  }) {
    Get.bottomSheet(
      Obx(
        () => SizedBox(
          height: Get.height,
          child: CommonBottomSheets.commonBottomSheet(
            title: "",
            paddingSheet: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(10),
              vertical: MediaQueryUtil.spacing(10),
            ),
            child: SizedBox(
              height: MediaQueryUtil.height * 0.85,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                  ),
                  child: Column(
                    spacing: MediaQueryUtil.spacing(20),
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: MediaQueryUtil.spacing(20),
                          children: [
                            Row(
                              children: [
                                SizedBox(width: MediaQueryUtil.spacing(10)),
                                Text(
                                  textAlign: TextAlign.start,
                                  currentProfile.fullName ?? "User",
                                  style: AppTextStyles.medium(
                                    fontWeight: AppFontWeight.semiBold,
                                  ),
                                ),
                              ],
                            ),
                            IceBreakerCard(
                              //  backgroundColor: Colors.white,
                              paddingEnabled: false,
                              prompt: item.prompt ?? "",
                              answer: item.answer ?? "",
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(10)),
                            SizedBox(
                              width: double.infinity,
                              child: CustomTextField(
                                controller: controller.replyController,
                                hintText: 'Reply to prompt',
                                backgroundColor: AppColors.white,
                                borderColor: AppColors.grey[300], // Teal color
                                hintStyle: AppTextStyles.verySmall(
                                  color: AppColors.grey[600],
                                  fontWeight: AppFontWeight.semiBold,
                                ),
                                focusColor: AppColors.c185755,
                                borderRadius: 12,
                                onChanged: (val) {
                                  controller.replyText.value = val;
                                },
                                keyboardType: TextInputType.multiline,
                              ),
                            ),

                            Visibility(
                              visible: controller.replyText.value
                                  .trim()
                                  .isNotEmpty,
                              child: CommonButtons.commonButton(
                                text: "Send Like",
                                marginButton: EdgeInsets.symmetric(
                                  horizontal: MediaQueryUtil.spacing(0),
                                  vertical: MediaQueryUtil.spacing(0),
                                ),
                                borderRadius: 50,
                                height: MediaQueryUtil.spacing(60),

                                backgroundColor: AppColors.c185755,
                                textStyle: AppTextStyles.small(
                                  fontWeight: AppFontWeight.bold,
                                  color: AppColors.white,
                                ),
                                onPressed: () async {
                                  Get.back();

                                  controller.swipeRightWithIceReply(
                                    currentProfile.id ?? "",
                                    controller.replyText.value,
                                    item.id ?? "",
                                    ({required bool isLeft}) async {
                                      controller.isSwipeLeft.value = false;
                                      await controller.runSwipeAnimation(
                                        isLeft: false,
                                      );
                                    },
                                  );
                                },
                                isEnabled: controller.replyText.value
                                    .trim()
                                    .isNotEmpty,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GoBackLink(
                                  text: "Cancel",
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
