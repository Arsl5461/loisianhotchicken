import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../hardcoded_data.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../../../../widgets/Selection/selectableBox.dart';
import '../../../../widgets/Toggle/DisplayToggle.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditGenderScreen extends GetView<EditController> {
  const EditGenderScreen({super.key});

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
                title: 'Gender',
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
                        padding: EdgeInsets.fromLTRB(
                          MediaQueryUtil.spacing(15),
                          MediaQueryUtil.spacing(15),
                          MediaQueryUtil.spacing(15),
                          MediaQueryUtil.spacing(15),
                        ),
                        child: Text(
                          'Select the gender that you most identify as',
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.semi,
                            color: AppColors.grey[600],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQueryUtil.spacing(5),
                          horizontal: MediaQueryUtil.spacing(15),
                        ),
                        child: Row(
                          children: HardCodedData.genderOptions.map((gender) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: MediaQueryUtil.spacing(4),
                                ),
                                child: SelectableBox(
                                  text: gender,
                                  isSelected:
                                      controller.user.value?.gender == gender,
                                  onTap: () {
                                    controller.user.value?.gender = gender;
                                    controller.user.refresh();
                                  },
                                  selectedBackgroundColor: AppColors.cFF006C6A,
                                  unselectedBackgroundColor:
                                      AppColors.grey[100]!,
                                  selectedTextColor: AppColors.white,
                                  unselectedTextColor: AppColors.grey[800],
                                  borderRadius: 12.0,
                                  textSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 55,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(40)),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.grey[300],
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(12)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                          vertical: MediaQueryUtil.spacing(16),
                        ),
                        child: DisplayToggle(
                          label: 'Display on profile',
                          value: controller.user.value?.showGender ?? false,
                          onChanged: (bool value) {
                            controller.user.value?.showGender = value;
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
