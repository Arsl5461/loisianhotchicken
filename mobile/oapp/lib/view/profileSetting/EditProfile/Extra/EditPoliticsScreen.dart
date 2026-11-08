import 'package:OApp/hardcoded_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../../../../widgets/Selection/selectableBox.dart';
import '../../../../widgets/Toggle/DisplayToggle.dart';
import '../edit_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditPoliticsScreen extends GetView<EditController> {
  const EditPoliticsScreen({super.key});

  void _saveAndGoBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              EditProfileHeader(
                title: 'Politics',
                onBack: _saveAndGoBack,
                onClose: _saveAndGoBack,
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
                      Text(
                        'Which political affiliation best describes your views',
                        style: AppTextStyles.verySmall(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[600],
                        ),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(18)),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: MediaQueryUtil.spacing(10),
                        mainAxisSpacing: MediaQueryUtil.spacing(10),
                        childAspectRatio: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: HardCodedData.politicsOptions.map((option) {
                          return SelectableBox(
                            text: option,
                            isSelected:
                                controller.user.value?.politicalAffiliation ==
                                option,
                            onTap: () {
                              controller.user.value?.politicalAffiliation =
                                  option;
                              controller.user.refresh();
                            },
                            selectedBackgroundColor: AppColors.cFF006C6A,
                            unselectedBackgroundColor: AppColors.grey[100],
                            borderRadius: 12.0,
                            textSize: 12,
                            fontWeight: FontWeight.w500,
                            selectedTextColor: AppColors.white,
                            unselectedTextColor: AppColors.grey[800],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(40)),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.grey[300],
                      ),
                      SizedBox(height: MediaQueryUtil.spacing(12)),
                      DisplayToggle(
                        label: 'Display on profile',
                        value:
                            controller.user.value?.showPoliticalAffiliation ??
                            false,
                        onChanged: (bool value) {
                          controller.user.value?.showPoliticalAffiliation =
                              value;
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
