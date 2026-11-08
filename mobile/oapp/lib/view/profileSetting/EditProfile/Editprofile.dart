import 'dart:io';

import 'package:OApp/view/HomeScreen/widgets/home_profile_card.dart';
import 'package:OApp/view/HomeScreen/widgets/home_profile_section.dart';
import 'package:OApp/widgets/Profile/ImageSourceBottomSheet.dart';
import 'package:OApp/view/profileSetting/EditProfile/Profile/ProfileImageSlot.dart';
import 'package:OApp/view/profileSetting/EditProfile/Profile/ProfileItem.dart';
import 'package:OApp/view/profileSetting/EditProfile/Profile/ProfileSectionHeader.dart';
import 'package:OApp/view/profileSetting/EditProfile/Profile/PromptEditBottomSheet.dart';
import 'package:OApp/view/profileSetting/EditProfile/Profile/PromptItem.dart';
import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Toggle/DisplayToggle.dart';

import 'package:OApp/core/constants/app_colors.dart';

import '../models/ice_breaker_model.dart';

class EditProfilePage extends GetView<EditController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Obx(() {
      return Scaffold(
        //  backgroundColor: const Color.fromARGB(255, 244, 244, 244),
        body: SafeArea(
          child: DefaultTabController(
            length: controller.tabBars.length,
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.assignValues();
                              Get.back();
                            },
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.small(
                                fontWeight: AppFontWeight.semiBold,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Edit Profile',
                            style: AppTextStyles.regular(
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          ),
                          TextButton(
                            onPressed:
                                controller.isLoadingData.value ||
                                    controller.isLoading.value
                                ? null
                                : controller.updateProfile,
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: MediaQueryUtil.spacing(18),
                                    height: MediaQueryUtil.spacing(18),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Update',
                                    style: AppTextStyles.small(
                                      fontWeight: AppFontWeight.semiBold,
                                      color: AppColors.cFF006C6A,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      _buildTabs(),
                      Divider(
                        color: AppColors.grey[500],
                        thickness: 1,
                        height: MediaQueryUtil.spacing(16),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: controller.isLoadingData.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.errorMessage.value.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.errorMessage.value,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.small(
                                  color: AppColors.red,
                                  fontWeight: AppFontWeight.semi,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: controller.loadUserProfile,
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : TabBarView(
                          // ✅ NO Expanded here
                          children: [
                            SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQueryUtil.spacing(10),
                              ),
                              child: buildSectionEdit(context),
                            ),
                            SingleChildScrollView(
                              controller:
                                  controller.homeController.scrollController,
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQueryUtil.spacing(10),
                              ),
                              child: Column(
                                children: [
                                  HomeProfileCard.buildProfileCard(
                                    user: controller.user.value!,
                                    cardHeight:
                                        MediaQueryUtil.height *
                                        0.7, // You can adjust this as needed
                                    controller: controller.homeController,
                                    showUserView: false,
                                    context:
                                        context, // Hide interactive elements
                                  ),

                                  SizedBox(height: MediaQueryUtil.spacing(20)),
                                  HomeProfileSection(
                                    showUserView: false,
                                    currentProfile: controller.user.value!,
                                    parentContext: context,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  // Hardcoded questions since they are not in the model

  void _showImageSourceModal(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) => ImageSourceBottomSheet(
        title: 'Select Image Source',
        onTakePhoto: () {
          controller.pickImage(ImageSource.camera, index);
        },
        onUploadPhotos: () {
          controller.pickImage(ImageSource.gallery, index);
        },
      ),
    );
  }

  void _showAddPromptModal(BuildContext context, int index) {
    // Ensure prompts list is big enough
    while (controller.iceBreakers.length <= index) {
      controller.iceBreakers.add(IceBreakerModel());
    }

    String currentAnswer = controller.iceBreakers[index].answer ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQueryUtil.spacing(20)),
        ),
      ),
      builder: (BuildContext context) {
        return PromptEditBottomSheet(
          question: controller.iceBreakers[index].prompt ?? '',
          answer: currentAnswer,
          onAnswerChanged: (value) {
            controller.iceBreakers[index].answer = value;
            controller.iceBreakers.refresh(); // Notify listeners of the change
          },
          onSave: () {
            // State is already updated via Obx in controller if bound, but here we just update list
            Get.back();
          },
        );
      },
    );
  }

  Widget buildSectionEdit(BuildContext context) {
    return Column(
      children: [
        // Image Section
        SizedBox(height: MediaQueryUtil.spacing(5)),
        buildPhotosSection(context),
        SizedBox(height: MediaQueryUtil.spacing(16)),

        // Photo requirement text
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '*5 photos are required',
              style: AppTextStyles.small(
                color: AppColors.green,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ],
        ),

        SizedBox(height: MediaQueryUtil.spacing(30)),

        // Best Photo Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Photo',
                    style: AppTextStyles.small(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: MediaQueryUtil.spacing(4)),
                  Text(
                    'Allow us to display your best photo to increase connections',
                    style: AppTextStyles.verySmall(
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            DisplayToggle(
              label: '',
              value: controller.isBestPhotoEnabled.value,
              onChanged: (bool value) {
                controller.isBestPhotoEnabled.value = value;
              },
              activeColor: AppColors.cFF006C6A,
            ),
          ],
        ),

        SizedBox(height: MediaQueryUtil.spacing(30)),

        // Prompts Section
        Obx(() {
          final isExpanded = controller.isPromptsExpanded.value;

          final displayCount = isExpanded
              ? controller.iceBreakers.length
              : (controller.iceBreakers.length > 3
                    ? 3
                    : controller.iceBreakers.length);

          return Column(
            children: [
              ProfileSectionHeader(
                onTap: controller.togglePrompts,
                title: 'Prompts',
                showExpansion: true,
                isExpanded: isExpanded,
              ),

              ...List.generate(displayCount, (index) {
                IceBreakerModel? iceBreaker =
                    index < controller.iceBreakers.length
                    ? controller.iceBreakers[index]
                    : null;

                String answer = iceBreaker?.answer ?? '';
                String question = iceBreaker?.prompt ?? '';

                bool hasContent = question.isNotEmpty;
                bool hasAnswer = answer.isNotEmpty;

                return PromptItem(
                  // backgroundColor: AppColors.grey[100],
                  question: question,
                  answer: answer.isNotEmpty ? answer : 'Enter answer here',
                  hasContent: hasContent,
                  hasAnswer: hasAnswer,
                  onTap: () => _showAddPromptModal(context, index),
                );
              }),
            ],
          );
        }),

        SizedBox(height: MediaQueryUtil.spacing(30)),

        // Basics Section
        ProfileSectionHeader(title: 'Basics'),

        ...List.generate(controller.basicItems.length, (index) {
          final item = controller.basicItems[index];

          return ProfileItem(
            label: item.label,
            answer: item.answer,
            privacy: item.privacy,
            onTap: () {
              if (item.label == 'Name') {
                Get.toNamed(Routes.EDIT_NAME);
              } else if (item.label == 'Hometown') {
                Get.toNamed(Routes.EDIT_HOMETOWN);
              } else if (item.label == 'Work') {
                Get.toNamed(Routes.EDIT_WORK);
              } else if (item.label == 'Education') {
                Get.toNamed(Routes.EDIT_EDUCATION);
              } else if (item.label == 'Birthday') {
                Get.toNamed(Routes.EDIT_BIRTHDAY);
              }
            },
          );
        }),

        SizedBox(height: MediaQueryUtil.spacing(30)),

        // Physical Section
        ProfileSectionHeader(title: 'Physical'),
        ...List.generate(controller.physicalItems.length, (index) {
          final item = controller.physicalItems[index];

          return ProfileItem(
            label: item.label,
            answer: item.answer,
            privacy: item.privacy,
            onTap: () {
              if (item.label == 'Ethnicity') {
                Get.toNamed(Routes.EDIT_ETHNICITY);
              } else if (item.label == 'Height') {
                Get.toNamed(Routes.EDIT_HEIGHT);
              } else if (item.label == 'Gender') {
                Get.toNamed(Routes.EDIT_GENDER);
              }
            },
          );
        }),

        SizedBox(height: MediaQueryUtil.spacing(30)),

        // Extra Section
        ProfileSectionHeader(title: 'Extra'),
        ...List.generate(controller.extraItems.length, (index) {
          final item = controller.extraItems[index];

          return ProfileItem(
            label: item.label,
            answer: item.answer,
            privacy: item.privacy,
            onTap: () {
              if (item.label == 'Religion') {
                Get.toNamed(Routes.EDIT_RELIGION);
              } else if (item.label == 'Politics') {
                Get.toNamed(Routes.EDIT_POLITICS);
              } else if (item.label == 'Languages') {
                Get.toNamed(Routes.EDIT_LANGUAGES);
              }
            },
          );
        }),

        SizedBox(height: MediaQueryUtil.spacing(40)),
      ],
    );
  }

  Widget _buildTabs() {
    return TabBar(
      padding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab, // 👈 IMPORTANT
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3,
          color: AppColors.c185755, // your color
        ),
        //  insets: const EdgeInsets.only(bottom: 2),
        insets: EdgeInsets.symmetric(
          horizontal: MediaQueryUtil.spacing(65),
          vertical: 0,
        ), // 👈 controls width
      ),
      labelColor: Colors.black,

      unselectedLabelColor: Colors.black,
      labelStyle: AppTextStyles.small(fontWeight: AppFontWeight.semiBold),

      tabs: const [
        Tab(text: "Edit"),
        Tab(text: "View"),
      ],
    );
  }

  Widget buildPhotosSection(BuildContext context) {
    final mainItem = controller.selectedImages[0];

    return Column(
      children: [
        ProfileImageSlot(
          borderRadius: MediaQueryUtil.spacing(35),
          isMainPhoto: true,
          hasImage: mainItem != null,
          isDefaultImage: mainItem is String,
          defaultImageUrl: mainItem is String ? mainItem : null,
          selectedImage: mainItem is File ? mainItem : null,
          onTap: () => _showImageSourceModal(context, 0),
          onRemove: () => controller.removeImage(0),
        ),
        SizedBox(height: MediaQueryUtil.spacing(16)),

        Row(
          children: List.generate(4, (index) {
            final item = controller.selectedImages[index + 1];

            return Expanded(
              child: ProfileImageSlot(
                isMainPhoto: false,
                hasImage: item != null,
                isDefaultImage: item is String,
                defaultImageUrl: item is String ? item : null,
                selectedImage: item is File ? item : null,
                onTap: () => _showImageSourceModal(context, index + 1),
                onRemove: () => controller.removeImage(index + 1),
              ),
            );
          }),
        ),
      ],
    );
  }
}
