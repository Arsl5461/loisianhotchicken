import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../../../../widgets/Toggle/DisplayToggle.dart';
import '../widgets/profile_edit_text_field.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditHometownScreen extends GetView<EditController> {
  const EditHometownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              EditProfileHeader(
                title: 'Hometown',
                onBack: () {
                  Get.back();
                },
                onClose: () {
                  Get.back();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                          vertical: MediaQueryUtil.spacing(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Where are you from?',
                              style: AppTextStyles.medium(
                                fontWeight: AppFontWeight.semiBold,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(20)),
                            ProfileEditTextField(
                              controller: controller.hometownController,
                              onChanged: (value) {
                                controller.user.value?.hometown = value;
                                controller.user.refresh();
                              },
                              hintText: 'Hometown',
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.grey[300],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                          vertical: MediaQueryUtil.spacing(16),
                        ),
                        child: DisplayToggle(
                          label: 'Display on profile',
                          value: controller.user.value?.showHometown ?? false,
                          onChanged: (bool value) {
                            controller.user.value?.showHometown = value;
                            controller.user.refresh();
                          },
                          activeColor: AppColors.cFF006C6A,
                          labelStyle: AppTextStyles.regular(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
