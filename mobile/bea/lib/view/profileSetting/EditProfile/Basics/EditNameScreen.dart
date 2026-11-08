import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../widgets/profile_edit_text_field.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditNameScreen extends GetView<EditController> {
  const EditNameScreen({super.key, this.currentValue});

  final String? currentValue;

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(
              title: 'Name',
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
                            'What should people call you',
                            style: AppTextStyles.medium(
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: MediaQueryUtil.spacing(20)),
                          ProfileEditTextField(
                            controller: controller.nameController,
                            onChanged: (val) {
                              controller.user.value?.fullName = val;
                              controller.user.refresh();
                            },
                            hintText: 'First name',
                            keyboardType: TextInputType.name,
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
                        vertical: MediaQueryUtil.spacing(12),
                      ),
                      child: Text(
                        'Your name is required',
                        style: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.black,
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
    );
  }
}
