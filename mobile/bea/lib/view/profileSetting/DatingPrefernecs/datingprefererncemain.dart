import 'package:OApp/controller/home_controller.dart';
import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../hardcoded_data.dart';
import '../../../widgets/custom_svg_icons.dart';

class DatingPreferencesMain extends GetView<HomeController> {
  const DatingPreferencesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        leadingWidth: 34,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(MediaQueryUtil.spacing(8)),
            width: 30,
            child: CustomSvgIcons.backArrow(
              color: AppColors.black,
              size: MediaQueryUtil.iconSize(4),
            ),
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,

        automaticallyImplyLeading: false,

        title: Obx(
          () => Text(
            controller.isTraveliingPreference.value
                ? "Travel Preferences"
                : 'Dating Preferences',
            style: AppTextStyles.regular(
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.black87,
            ),
          ),
        ),
        actions: [
          Obx(
            () => controller.isSavingPreferences.value
                ? BlurShimmerPlaceholder()
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(8),
                      vertical: MediaQueryUtil.spacing(8),
                    ),
                    // decoration: BoxDecoration(
                    //   color: AppColors.cFF006C6A,
                    //   borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(8)),
                    // ),
                    margin: EdgeInsets.only(right: MediaQueryUtil.spacing(16)),
                    child: InkWell(
                      onTap: () {
                        controller.savePreferenceSelectionsToStorage();
                      },
                      child: Text(
                        "Save",
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.cFF006C6A,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          children: [
            if (controller.isTraveliingPreference.value)
              Divider(color: AppColors.grey[500]!, thickness: 0.4),
            if (controller.isTraveliingPreference.value)
              Column(
                children: [
                  TravelStatusTile(
                    value: controller.datingPreferences.value.istraveling,
                    onChanged: (val) {
                      controller.datingPreferences.value = controller
                          .datingPreferences
                          .value
                          .copyWith(istraveling: val);
                    },
                  ),
                ],
              ),

            if (controller.isTraveliingPreference.value)
              Column(
                children: [
                  SizedBox(height: MediaQueryUtil.spacing(20)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(16),
                      vertical: MediaQueryUtil.spacing(4),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Dating Preferences",
                          style: AppTextStyles.regular(
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (controller.isTraveliingPreference.value)
              PreferenceTile(
                showTop: false,
                title: 'Travel Preferences',
                subtitle: "Open to all",

                onTap: () => {},
              ),
            PreferenceTile(
              title: 'Age Range',
              subtitle:
                  '${controller.datingPreferences.value.ageRange.start.round()} to ${controller.datingPreferences.value.ageRange.end.round()}',
              onTap: _openAgeRangeSheet,
            ),
            PreferenceTile(
              title: 'Maximum Distance',
              subtitle:
                  '${controller.datingPreferences.value.maxDistance.round()} mi',
              onTap: _openDistanceSheet,
            ),
            PreferenceTile(
              title: 'Height',
              subtitle:
                  controller.datingPreferences.value.height ?? "No preference",
              onTap: () => Get.toNamed(Routes.HEIGHT_PREFERENCE),
            ),
            PreferenceTile(
              title: 'Politics',
              subtitle: controller.datingPreferences.value.politics.isEmpty
                  ? "Open to all"
                  : controller.datingPreferences.value.politics.join(", "),
              onTap: () => Get.toNamed(Routes.POLITICS_PREFERENCE),
            ),
            PreferenceTile(
              title: 'Education',
              subtitle:
                  controller.datingPreferences.value.education ?? "Open to all",
              onTap: () => Get.toNamed(Routes.EDUCATION_PREFERENCE),
            ),
            PreferenceTile(
              title: 'Languages',
              subtitle: controller.datingPreferences.value.languages.isEmpty
                  ? "Open to all"
                  : controller.datingPreferences.value.languages.join(", "),
              onTap: () => Get.toNamed(Routes.LANGUAGE_PREFERENCE),
            ),
            PreferenceTile(
              title: 'Ethnicity',
              subtitle: controller.datingPreferences.value.ethnicity.isEmpty
                  ? "Open to all"
                  : controller.datingPreferences.value.ethnicity.join(', '),
              onTap: () => Get.toNamed(Routes.ETHNICITY_PREFERENCE),
            ),
            PreferenceTile(
              title: 'Religion',
              subtitle: controller.datingPreferences.value.religion.isEmpty
                  ? "Open to all"
                  : controller.datingPreferences.value.religion.join(', '),
              onTap: () => Get.toNamed(Routes.RELIGIOUS_PREFERENCE),
            ),
          ],
        ),
      ),
    );
  }

  void _openAgeRangeSheet() {
    Get.bottomSheet(
      Obx(
        () => commonBottomSheet(
          title: "Age Range",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.datingPreferences.value.ageRange.start.round()} to '
                '${controller.datingPreferences.value.ageRange.end.round()} years',
                style: AppTextStyles.text(
                  customSize: 15,
                  color: AppColors.grey[600],
                ),
              ),

              SizedBox(height: MediaQueryUtil.spacing(10)),

              RangeSlider(
                values: controller.datingPreferences.value.ageRange,
                min: 18,
                max: 65,
                divisions: 47,
                activeColor: AppColors.cFF006C6A,
                inactiveColor: AppColors.grey[300],
                onChanged: (val) {
                  controller.datingPreferences.value = controller
                      .datingPreferences
                      .value
                      .copyWith(ageRange: val);
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _openGenderSheet() {
    Get.bottomSheet(
      Obx(
        () => commonBottomSheet(
          title: "Sexuality",
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: MediaQueryUtil.spacing(10),
              runSpacing: MediaQueryUtil.spacing(10),
              children: HardCodedData.genderOptions.map((gender) {
                final selected =
                    controller.datingPreferences.value.gender == gender;

                IconData icon;

                switch (gender.toLowerCase()) {
                  case "male":
                    icon = Icons.male;
                    break;
                  case "female":
                    icon = Icons.female;
                    break;
                  default:
                    icon = Icons.person;
                }

                return ChoiceChip(
                  avatar: Icon(
                    icon,
                    color: selected ? Colors.white : AppColors.black87,
                    size: 18,
                  ),
                  label: Text(gender),
                  selected: selected,
                  selectedColor: AppColors.cFF006C6A,
                  backgroundColor: AppColors.grey[200],
                  labelStyle: AppTextStyles.regular(
                    color: selected ? Colors.white : AppColors.black87,
                  ),
                  onSelected: (_) {
                    controller.datingPreferences.value = controller
                        .datingPreferences
                        .value
                        .copyWith(gender: gender);
                    Get.back();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _openDistanceSheet() {
    Get.bottomSheet(
      Obx(
        () => commonBottomSheet(
          title: "Maximum Distance",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.datingPreferences.value.maxDistance.round()} mi',
                style: AppTextStyles.text(
                  customSize: 15,
                  color: AppColors.grey[600],
                ),
              ),

              Slider(
                value: controller.datingPreferences.value.maxDistance,
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: AppColors.cFF006C6A,
                inactiveColor: AppColors.grey[300],
                onChanged: (val) {
                  controller.datingPreferences.value = controller
                      .datingPreferences
                      .value
                      .copyWith(maxDistance: val);
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget commonBottomSheet({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        MediaQueryUtil.spacing(20),
        MediaQueryUtil.spacing(10),
        MediaQueryUtil.spacing(20),
        MediaQueryUtil.spacing(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQueryUtil.spacing(18)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Instagram gray handle
          Center(
            child: Container(
              width: MediaQueryUtil.spacing(40),
              height: MediaQueryUtil.spacing(4),
              margin: EdgeInsets.only(bottom: MediaQueryUtil.spacing(14)),
              decoration: BoxDecoration(
                color: AppColors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          /// Title
          Text(
            title,
            style: AppTextStyles.text(
              customSize: 18,
              fontWeight: AppFontWeight.semi,
              color: AppColors.black87,
            ),
          ),

          SizedBox(height: MediaQueryUtil.spacing(16)),

          child,
        ],
      ),
    );
  }
}

class PreferenceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showTop;
  const PreferenceTile({
    super.key,
    this.showTop = true,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: showTop
              ? Border(top: BorderSide(color: AppColors.grey[500]!, width: 0.4))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.small(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: MediaQueryUtil.spacing(6)),
                  Text(
                    subtitle,
                    style: AppTextStyles.small(
                      color: AppColors.grey[700],
                      fontWeight: AppFontWeight.semi,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey[500],
              fontWeight: FontWeight.w400,
              size: MediaQueryUtil.iconSize(28),
            ),
          ],
        ),
      ),
    );
  }
}

class TravelStatusTile extends StatelessWidget {
  const TravelStatusTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(1),
        vertical: MediaQueryUtil.spacing(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(15),
                vertical: MediaQueryUtil.spacing(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you traveling?',
                    style: AppTextStyles.regular(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: MediaQueryUtil.spacing(5)),
                  Text(
                    'Indicating your status will help you connect with other travelers',
                    style: AppTextStyles.small(
                      color: AppColors.black,
                      fontWeight: AppFontWeight.semi,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.cFF006A68,
            inactiveTrackColor: AppColors.grey[300],
            thumbColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
