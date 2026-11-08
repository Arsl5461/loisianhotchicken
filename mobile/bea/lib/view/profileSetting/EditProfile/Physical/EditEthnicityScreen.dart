import 'package:OApp/hardcoded_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../../../../widgets/Selection/CustomRadioButton.dart';
import '../../../../widgets/Toggle/DisplayToggle.dart';
import '../edit_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class EditEthnicityScreen extends GetView<EditController> {
  const EditEthnicityScreen({super.key});

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
                title: 'Ethnicity',
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
                          MediaQueryUtil.spacing(7),
                        ),
                        child: Text(
                          'Select one',
                          style: AppTextStyles.regular(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.grey[600],
                          ),
                        ),
                      ),
                      ...(HardCodedData.ethnicities.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final ethnicity = entry.value;
                        final isSelected =
                            controller.user.value?.ethnicity == ethnicity;
                        return Column(
                          children: [
                            CustomRadioButton(
                              label: ethnicity,
                              isSelected: isSelected,
                              onTap: () {
                                controller.user.value?.ethnicity = ethnicity;
                                controller.user.refresh();
                              },
                            ),
                            if (index < HardCodedData.ethnicities.length - 1)
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: AppColors.grey[300],
                              ),
                          ],
                        );
                      }).toList()),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: AppColors.grey[300],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryUtil.spacing(20),
                          vertical: MediaQueryUtil.spacing(16),
                        ),
                        child: DisplayToggle(
                          label: 'Display on profile',
                          value: controller.user.value?.showEthnicity ?? false,
                          onChanged: (bool value) {
                            controller.user.value?.showEthnicity = value;
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
