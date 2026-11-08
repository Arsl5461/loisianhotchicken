import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:OApp/utils/media_query.dart';
import '../../../../core/typography/app_text_styles.dart';
import '../controllers/phone_verification_controller.dart';

import 'package:OApp/core/constants/app_colors.dart';

class PhoneVerificationScreen extends GetView<PhoneVerificationController> {
  const PhoneVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    final double fieldHeight = MediaQueryUtil.spacing(48);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top app bar with back button
            Padding(
              padding: MediaQueryUtil.padding(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.black,
                      size: MediaQueryUtil.iconSize(24),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: MediaQueryUtil.padding(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MediaQueryUtil.verticalSpace(24),

                      // Title
                      Text(
                        "Enter your phone number\nto get started",
                        style: AppTextStyles.large(
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),

                      MediaQueryUtil.verticalSpace(16),

                      // Subtitle
                      Text(
                        "We use your number for login and security\nverification",
                        style: AppTextStyles.medium(
                          fontWeight: AppFontWeight.semi,
                          color: AppColors.grey[600],
                        ),
                      ),

                      MediaQueryUtil.verticalSpace(32),

                      // Country and Phone input row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Country container
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "COUNTRY",
                                  style: AppTextStyles.verySmall(
                                    fontWeight: AppFontWeight.semi,
                                    color: AppColors.grey[600],
                                  ),
                                ),
                                SizedBox(height: MediaQueryUtil.spacing(8)),

                                GestureDetector(
                                  onTap: () {
                                    _showCountryPicker(context);
                                  },
                                  child: Container(
                                    height:
                                        fieldHeight, // SAME HEIGHT AS TEXTFIELD
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQueryUtil.spacing(16),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.grey[300]!,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Obx(
                                            () => Text(
                                              '${controller.selectedCountryName} ${controller.selectedCountryCode}',
                                              style: AppTextStyles.regular(
                                                fontWeight: AppFontWeight.semi,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: AppColors.grey[600],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: MediaQueryUtil.spacing(12)),

                          // Phone number container
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PHONE",
                                  style: AppTextStyles.verySmall(
                                    fontWeight: AppFontWeight.semi,
                                    color: AppColors.grey[600],
                                  ),
                                ),
                                SizedBox(height: MediaQueryUtil.spacing(8)),

                                Obx(
                                  () => Container(
                                    height: fieldHeight, // SAME HEIGHT
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller.isPhoneFocused.value
                                            ? AppColors.cFF006C6A
                                            : AppColors.grey[300]!,
                                        width: controller.isPhoneFocused.value
                                            ? 2
                                            : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: controller.phoneController,
                                      focusNode: controller.phoneFocusNode,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: AppColors.grey[400],
                                          fontSize: MediaQueryUtil.fontSize(16),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: MediaQueryUtil.spacing(
                                            16,
                                          ),
                                          vertical: MediaQueryUtil.spacing(12),
                                        ),
                                        counterText: '',
                                      ),
                                      style: AppTextStyles.medium(
                                        fontWeight: AppFontWeight.semi,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom section with privacy text and continue button
            Padding(
              padding: MediaQueryUtil.padding(all: 24),
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: Text(
                      "Your phone number won't be shared with anyone nor be displayed on your profile",
                      style: AppTextStyles.small(
                        fontWeight: AppFontWeight.regular,
                        color: AppColors.grey[600],
                      ),
                    ),
                  ),
                  Center(child: _buildContinueButton(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    controller.searchController.clear();
    controller.filterCountries(''); // Reset filter

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Search bar with Cancel button
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQueryUtil.spacing(16),
                  MediaQueryUtil.spacing(12),
                  MediaQueryUtil.spacing(16),
                  MediaQueryUtil.spacing(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQueryUtil.spacing(40),
                        decoration: BoxDecoration(
                          color: AppColors.cFFE5E7E6,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search Country',
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.grey[600],
                              size: AppIcons.size(AppIconSize.medium),
                            ),
                            hintStyle: AppTextStyles.small(
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.grey[600],
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: MediaQueryUtil.spacing(12),
                              vertical: MediaQueryUtil.spacing(10),
                            ),
                            isDense: true,
                            alignLabelWithHint: false,
                          ),
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(14),
                            color: AppColors.black,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQueryUtil.spacing(8)),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.medium(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Country list
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = controller.filteredCountries[index];
                      return _buildCountryItem(
                        context,
                        country['name']!,
                        country['dialCode']!,
                        country['code']!,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryItem(
    BuildContext context,
    String name,
    String dialCode,
    String code,
  ) {
    return InkWell(
      onTap: () {
        controller.selectCountry(name, dialCode, code, context);
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(16),
          vertical: MediaQueryUtil.spacing(12),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grey[200]!, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppTextStyles.medium(
                fontWeight: AppFontWeight.semi,
                color: AppColors.grey[800],
              ),
            ),
            Text(
              dialCode,
              style: AppTextStyles.medium(
                fontWeight: AppFontWeight.semi,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: controller.isPhoneValid.value && !controller.isLoading.value
            ? () {
                controller.onContinue(context);
              }
            : null,
        child: Container(
          width: MediaQueryUtil.spacing(64),
          height: MediaQueryUtil.spacing(64),
          decoration: BoxDecoration(
            color: controller.isPhoneValid.value
                ? AppColors.cFF006C6A
                : AppColors.grey[300],
            borderRadius: MediaQueryUtil.borderRadius(12),
            boxShadow: controller.isPhoneValid.value
                ? [
                    BoxShadow(
                      color: AppColors.cFF006C6A.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: controller.isLoading.value
              ? Center(
                  child: SizedBox(
                    width: MediaQueryUtil.spacing(24),
                    height: MediaQueryUtil.spacing(24),
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.white,
                  size: MediaQueryUtil.iconSize(28),
                ),
        ),
      ),
    );
  }
}
