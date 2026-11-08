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

class EditWorkScreen extends GetView<EditController> {
  const EditWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              EditProfileHeader(
                title: 'Work',
                onBack: controller.saveWork,
                onClose: controller.saveWork,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Job Title
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                          vertical: MediaQueryUtil.spacing(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job Title',
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                              ),
                            ),
                            SizedBox(height: MediaQueryUtil.spacing(8)),

                            ProfileEditTextField(
                              controller: controller.jobTitleController,
                              hintText: 'Job Title',

                              focusColor: AppColors.cFF006C6A,
                            ),
                          ],
                        ),
                      ),

                      /// Quick Options
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Options',
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                              ),
                            ),

                            SizedBox(height: MediaQueryUtil.spacing(12)),

                            GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: MediaQueryUtil.spacing(5),
                              mainAxisSpacing: MediaQueryUtil.spacing(10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 2.2,
                              children: HardCodedData.quickJobOptions.map((
                                option,
                              ) {
                                return SelectableBox(
                                  text: option,
                                  isSelected:
                                      controller.user.value?.jobTitle == option,

                                  onTap: () {
                                    controller.user.value?.jobTitle = option;
                                    controller.user.refresh();
                                  },
                                  selectedBackgroundColor: AppColors.cFF006C6A,
                                  unselectedBackgroundColor:
                                      AppColors.grey[100]!,
                                  selectedTextColor: AppColors.white,
                                  unselectedTextColor: AppColors.grey[800],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),

                      /// Company Name
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company Name',
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semi,
                                color: AppColors.grey[600],
                              ),
                            ),

                            SizedBox(height: MediaQueryUtil.spacing(8)),

                            ProfileEditTextField(
                              controller: controller.companyNameController,
                              onChanged: (val) {
                                controller.user.value?.companyName = val;
                                controller.user.refresh();
                              },

                              hintText: 'Company Name',
                              focusColor: AppColors.cFF006C6A,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(40)),

                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.grey[300],
                      ),

                      /// Display Toggle
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                          vertical: MediaQueryUtil.spacing(16),
                        ),
                        child: DisplayToggle(
                          label: 'Display on profile',
                          value: controller.user.value?.showJobTitle ?? false,
                          onChanged: (value) {
                            controller.user.value?.showJobTitle = value;
                            controller.user.refresh();
                          },
                          activeColor: AppColors.cFF006C6A,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(16)),

                      /// Preview
                      Center(
                        child: Text(
                          '${controller.jobTitleController.text.isNotEmpty ? controller.jobTitleController.text : "Job Title"} at ${controller.companyNameController.text.isNotEmpty ? controller.companyNameController.text : "Company Name"}',
                          style: AppTextStyles.small(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.black,
                          ),
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
