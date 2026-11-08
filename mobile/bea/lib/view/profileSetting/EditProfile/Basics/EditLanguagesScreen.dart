import 'package:OApp/hardcoded_data.dart';
import 'package:flutter/material.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../../../../utils/media_query.dart';
import '../../../../widgets/Layout/EditProfileHeader.dart';
import '../../../../widgets/Selection/CustomRadioButton.dart';
import '../../../../widgets/Toggle/DisplayToggle.dart';
import 'package:get/get.dart';
import '../edit_controller.dart';
import 'package:OApp/core/constants/app_colors.dart';

class EditLanguagesScreen extends GetView<EditController> {
  const EditLanguagesScreen({super.key});
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
                title: 'Languages',
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
                          'Select up to two',
                          style: AppTextStyles.regular(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.grey[600],
                          ),
                        ),
                      ),
                      ...(HardCodedData.languages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final language = entry.value;
                        final isSelected =
                            (controller.user.value?.languages ?? []).contains(
                              language,
                            );
                        return Column(
                          children: [
                            CustomRadioButton(
                              label: language,
                              isSelected: isSelected,
                              onTap: () {
                                final user = controller.user.value;
                                if (user == null) return;
                                user.languages = (user.languages ?? [])
                                    .toSet()
                                    .toList();
                                if (user.languages!.contains(language)) {
                                  user.languages!.removeWhere(
                                    (item) => item == language,
                                  );
                                } else {
                                  user.languages!.add(language);
                                }
                                controller.user.refresh();
                              },
                            ),
                            if (index < HardCodedData.languages.length - 1)
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
                          value: controller.user.value?.showLanguages ?? false,
                          onChanged: (bool value) {
                            controller.user.value?.showLanguages = value;
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
