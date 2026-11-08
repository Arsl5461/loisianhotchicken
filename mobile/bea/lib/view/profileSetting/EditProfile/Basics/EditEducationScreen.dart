import 'package:OApp/hardcoded_data.dart';
import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../../../../widgets/Selection/selectableBox.dart';
import '../../../../widgets/Toggle/DisplayToggle.dart';
import '../widgets/profile_edit_text_field.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditEducationScreen extends GetView<EditController> {
  const EditEducationScreen({super.key});

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
                title: 'Education',
                onBack: () {
                  Get.back();
                },
                onClose: () {
                  Get.back();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(20),
                    vertical: MediaQueryUtil.spacing(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileEditTextField(
                        controller: controller.schoolNameController,
                        hintText: 'School Name',
                        keyboardType: TextInputType.text,

                        borderColor: AppColors.cFF006C6A,
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(24)),
                      Text(
                        'Highest level of education completed',
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[600],
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(24)),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: MediaQueryUtil.spacing(10),
                        mainAxisSpacing: MediaQueryUtil.spacing(10),
                        childAspectRatio: 2.2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: HardCodedData.educationLevels.map((option) {
                          return SelectableBox(
                            text: option,
                            isSelected:
                                controller.user.value?.education == option,
                            onTap: () {
                              controller.user.value?.education = option;
                              controller.user.refresh();
                            },
                            selectedBackgroundColor: AppColors.cFF006C6A,
                            unselectedBackgroundColor: AppColors.grey[100]!,
                            borderRadius: 12.0,
                            textSize: 12,
                            fontWeight: FontWeight.w500,
                            selectedTextColor: AppColors.white,
                            unselectedTextColor: AppColors.grey[800],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(24)),
                      SizedBox(height: MediaQueryUtil.spacing(20)),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.grey[300],
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(12)),
                      DisplayToggle(
                        label: 'Display on profile',
                        value: controller.user.value?.showSchoolName ?? false,
                        onChanged: (bool value) {
                          controller.user.value?.showSchoolName = value;
                          controller.user.refresh();
                        },
                        activeColor: AppColors.cFF006C6A,
                        labelStyle: AppTextStyles.regular(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.grey[700],
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(40)),
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
