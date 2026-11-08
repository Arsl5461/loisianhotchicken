import 'dart:async';
import 'dart:io';

import 'package:OApp/config/error_handler.dart';
import 'package:OApp/services/secure_storage_service.dart';
import 'package:OApp/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:uuid/uuid.dart';
import '../../../controller/home_controller.dart';
import '../../../core/constants/app_keys.dart';
import '../../../hardcoded_data.dart';
import '../../../models/user_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../utils/toast.dart';

import '../models/ice_breaker_model.dart';

class EditController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late FixedExtentScrollController heightScrollController;
  final UserModel? initialUser;
  final RxBool isLoadingData = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  List<Widget> tabBars = [
    Center(child: Text("Edit Screen")),
    Center(child: Text("View Screen")),
  ];
  List<String> uploadedImagesToStorage = [];
  late TabController tabController;
  final _uuid = const Uuid();
  final SecureStorageService _storage = Get.find<SecureStorageService>();
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController hometownController = TextEditingController();
  final TextEditingController socialHandleController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  HomeController get homeController => Get.find<HomeController>();
  final RxList<dynamic> selectedImages = List<dynamic>.filled(6, null).obs;
  final RxBool isLoading = false.obs;
  // Observable fields for dynamic data
  final RxList<String> hobbies = <String>[].obs;
  final RxList<String> removedPhotoUrls = <String>[].obs;
  final RxBool isPromptsExpanded = false.obs;
  // Images
  final RxList<String> photoUrls = RxList<String>.filled(6, '');
  RxList<IceBreakerModel> iceBreakers = <IceBreakerModel>[].obs;

  // Visibility Flags

  void togglePrompts() {
    isPromptsExpanded.value = !isPromptsExpanded.value;
  }

  // Location
  double? latitude;
  double? longitude;

  final RxnInt calculatedAge = RxnInt();
  final RxnString zodiacSign = RxnString();
  String? currentPrivacy;
  final ProfileRepository _profileRepo = Get.find<ProfileRepository>();
  StorageService get _storageService => Get.find<StorageService>();

  final List<String> heightOptions = List.generate(37, (index) {
    int feet = 4 + (index ~/ 12);
    int inches = index % 12;
    return "$feet ft $inches in";
  });

  EditController({this.initialUser});
  void saveWork() {
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();

    try {
      final userModel =
          initialUser ??
          (Get.arguments is Map
              ? (Get.arguments['userModel'] as UserModel?)
              : null);

      if (userModel != null) {
        isLoadingData.value = true;
        user.value = userModel;
        assignValues();
        return;
      }

      loadUserProfile();
      heightScrollController = FixedExtentScrollController(
        initialItem: selectedHeightIndex.value,
      );
      tabController = TabController(length: tabBars.length, vsync: this);
    } catch (e) {
      errorMessage.value = 'Error initializing profile: $e';
      isLoadingData.value = false;
    } finally {
      if (isLoadingData.value) {
        isLoadingData.value = false;
      }
    }
  }

  Future<void> loadUserProfile() async {
    isLoadingData.value = true;
    errorMessage.value = '';

    try {
      final userData = await _profileRepo.fetchUser();

      if (userData != null) {
        user.value = userData;
        assignValues();
      } else {
        errorMessage.value = 'Failed to load profile';
      }
    } catch (e) {
      errorMessage.value = 'Error loading profile: $e';
    } finally {
      isLoadingData.value = false;
    }
  }

  void calculateAge() {
    if (selectedDate.value != null) {
      final now = DateTime.now();
      final birthDate = selectedDate.value!;

      int age = now.year - birthDate.year;

      // Check if birthday has NOT occurred this year yet
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      calculatedAge.value = age;
      zodiacSign.value = HardCodedData.getZodiacSign(
        selectedDate.value!.month,
        selectedDate.value!.day,
      );
    }
  }

  // Image Picking
  final ImagePicker _picker = ImagePicker();
  final RxBool isBestPhotoEnabled = true.obs;

  Future<void> pickImage(ImageSource source, int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final currentItem = selectedImages[index];

      // If replacing an existing uploaded image, mark it for removal
      if (currentItem is String && currentItem.isNotEmpty) {
        if (!removedPhotoUrls.contains(currentItem)) {
          removedPhotoUrls.add(currentItem);
        }
      }

      selectedImages[index] = File(pickedFile.path);
      selectedImages.refresh();

      debugPrint('Selected image: ${pickedFile.name}');
    } catch (e) {
      Toast.error('Error picking image: $e');
    }
  }

  Future<List<String>> uploadNewSelectedImages() async {
    try {
      final currentUserId = await _storage.getKey(AppKeys.userID);
      if (currentUserId == null || currentUserId.isEmpty) return [];

      final uploaded = List<String>.filled(6, '');

      for (int i = 0; i < selectedImages.length; i++) {
        final item = selectedImages[i];

        if (item == null) continue;

        // Existing uploaded image, no need to upload again
        if (item is String) {
          continue;
        }

        // New local file, upload on update only
        if (item is File) {
          if (!item.existsSync()) continue;
          if (item.path.isEmpty) continue;

          final base = p.basename(item.path);
          final uniqueFileName = '${_uuid.v4()}_$base';

          final res = await _storageService.uploadFile(
            storagePath: 'user_photos/$currentUserId',
            filePath: item.path,
            fileName: uniqueFileName,
          );

          if (res.isNotEmpty) {
            uploaded[i] = res;
          }
        }
      }

      uploadedImagesToStorage
        ..clear()
        ..addAll(uploaded.where((e) => e.isNotEmpty));

      return uploaded;
    } catch (e, s) {
      handleError(
        tag: 'EditController.uploadNewSelectedImages',
        error: e.toString(),
        stack: s.toString(),
      );
      return [];
    }
  }

  Future<List<String>> buildFinalPhotosList() async {
    final uploadedSlotUrls = await uploadNewSelectedImages();

    final List<String> finalPhotos = [];

    for (int i = 0; i < selectedImages.length; i++) {
      final item = selectedImages[i];

      if (item == null) continue;

      // Existing URL
      if (item is String) {
        if (!removedPhotoUrls.contains(item) && item.trim().isNotEmpty) {
          finalPhotos.add(item);
        }
        continue;
      }

      // New file
      if (item is File) {
        // uploadedSlotUrls keeps the same slot positions as selectedImages
        if (i < uploadedSlotUrls.length) {
          final uploadedUrl = uploadedSlotUrls[i];
          if (uploadedUrl.trim().isNotEmpty) {
            finalPhotos.add(uploadedUrl);
          }
        } else {
          debugPrint("⚠️ Missing uploaded URL for file at index $i");
        }
      }
    }

    return finalPhotos;
  }

  void removeImage(int index) {
    final currentItem = selectedImages[index];

    if (currentItem is String && currentItem.isNotEmpty) {
      if (!removedPhotoUrls.contains(currentItem)) {
        removedPhotoUrls.add(currentItem);
      }
    }

    selectedImages[index] = null;
    selectedImages.refresh();
  }

  @override
  void dispose() {
    schoolNameController.dispose();
    hometownController.dispose();
    socialHandleController.dispose();
    nameController.dispose();
    nameFocus.dispose();
    jobTitleController.dispose();
    companyNameController.dispose();
    super.dispose();
  }

  final RxInt selectedHeightIndex = 11.obs; // Default to "5 ft 11 in"

  List<ProfileFieldItem> get basicItems => [
    ProfileFieldItem(
      label: 'Name',
      answer: user.value?.fullName ?? '',
      privacy: 'Public',
    ),
    ProfileFieldItem(
      label: 'Hometown',
      answer: user.value?.hometown ?? '',
      privacy: (user.value?.showHometown ?? false) ? 'Public' : 'Private',
    ),
    ProfileFieldItem(
      label: 'Work',
      answer: user.value?.jobTitle ?? '',
      privacy: (user.value?.showJobTitle ?? false) ? 'Public' : 'Private',
    ),
    ProfileFieldItem(
      label: 'Education',
      answer: user.value?.education ?? '',
      privacy: (user.value?.showSchoolName ?? false) ? 'Public' : 'Private',
    ),
    ProfileFieldItem(
      label: 'Birthday',
      answer: selectedDate.value != null
          ? "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}"
          : '',
      privacy: 'Public',
    ),
  ];

  List<ProfileFieldItem> get physicalItems => [
    ProfileFieldItem(
      label: 'Height',
      answer: heightOptions[selectedHeightIndex.value],
      privacy: (user.value?.showHeight ?? false) ? 'Public' : 'Private',
    ),
    ProfileFieldItem(
      label: 'Ethnicity',
      answer: user.value?.ethnicity ?? '',
      privacy: (user.value?.showEthnicity ?? false) ? 'Public' : 'Private',
    ),
    ProfileFieldItem(
      label: 'Gender',
      answer: user.value?.gender ?? '',
      privacy: (user.value?.showGender ?? false) ? 'Public' : 'Private',
    ),
  ];

  List<ProfileFieldItem> get extraItems => [
    ProfileFieldItem(
      label: 'Religion',
      answer: user.value?.religiousViews ?? '',
      privacy: (user.value?.showReligion ?? false) ? 'Public' : 'Private',
    ),
    ProfileFieldItem(
      label: 'Languages',
      answer: user.value?.languages?.join(', ') ?? '',
      privacy: (user.value?.showLanguages ?? false) ? 'Public' : 'Private',
    ),
    ProfileFieldItem(
      label: 'Politics',
      answer: user.value?.politicalAffiliation ?? '',
      privacy: (user.value?.showPoliticalAffiliation ?? false)
          ? 'Public'
          : 'Private',
    ),
  ];
  String getSelectedDate(DateTime? value) {
    return value == null
        ? ""
        : "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
  }

  Future<void> updateProfile() async {
    isLoading.value = true;

    try {
      if (user.value == null) {
        Toast.error('User data is not loaded');
        return;
      }

      List<String> finalPhotos = await buildFinalPhotosList();

      final body = user.value!.copyWith(
        dateOfBirth: getSelectedDate(selectedDate.value ?? DateTime.now()),
        photos: finalPhotos,
        fullName: nameController.text.trim(),
        jobTitle: jobTitleController.text.trim(),
        schoolName: schoolNameController.text.trim(),
        companyName: companyNameController.text.trim(),
        iceBreakers: iceBreakers
            .whereType<IceBreakerModel>()
            .where((e) => e.answer?.trim().isNotEmpty == true)
            .toList(),
      );

      final result = await _profileRepo.updateProfile(body);

      if (result.isSuccess) {
        // After successful update, convert runtime state back to server URLs
        selectedImages.value = List<dynamic>.filled(6, null);
        for (int i = 0; i < finalPhotos.length && i < 6; i++) {
          selectedImages[i] = finalPhotos[i];
        }

        removedPhotoUrls.clear();
        selectedImages.refresh();

        if (Get.isRegistered<ProfileDisplayController>()) {
          final displayController = Get.find<ProfileDisplayController>();

          if (result.user != null) {
            user.value = result.user;
            displayController.user.value = result.user;
          }
        }

        Toast.success('Profile updated successfully');
      } else {
        Toast.error(result.errorMessage ?? 'Failed to update profile');
      }
    } catch (e, s) {
      debugPrint('Update Profile Error: $e');
      debugPrintStack(stackTrace: s);

      handleError(
        tag: 'EditController.updateProfile',
        error: e.toString(),
        stack: s.toString(),
      );

      Toast.error('Update failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadFiles() async {
    try {
      String? currentUserId = await _storage.getKey(AppKeys.userID);
      for (var v in selectedImages) {
        if (v?.path.isEmpty ?? true) continue;
        final uniqueFileName = '${_uuid.v4()}_${v?.path}';
        var res = await _storageService.uploadFile(
          storagePath: 'user_photos/$currentUserId',
          filePath: v?.path ?? "",
          fileName: uniqueFileName,
        );
        if (res.isNotEmpty) {
          uploadedImagesToStorage.add(res);
        }
      }
    } catch (e, s) {
      handleError(
        tag: 'Edit Controller.dart',
        error: e.toString(),
        stack: s.toString(),
      );
    }
  }

  Future<void> fetchIceBreakers({bool showError = true}) async {
    isLoading.value = true;

    try {
      final fetchedIceBreakers = await _profileRepo.fetchIceBreakers();

      if (fetchedIceBreakers != null) {
        iceBreakers.value = fetchedIceBreakers;

        for (var v in iceBreakers) {
          if (user.value?.iceBreakers != null) {
            var match = user.value!.iceBreakers!.firstWhere(
              (element) => element.id == v.id,
              orElse: () =>
                  IceBreakerModel(id: v.id, prompt: v.prompt, answer: ''),
            );
            v.answer = match.answer;
          }
        }
      } else if (showError) {
        Toast.error('Failed to load ice breakers');
      }
    } catch (e) {
      if (showError) {
        Toast.error('Something went wrong');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void assignValues() {
    if (user.value == null) {
      return;
    }

    final p = user.value!;
    schoolNameController.text = p.schoolName ?? " ";
    jobTitleController.text = p.jobTitle ?? " ";
    companyNameController.text = p.companyName ?? " ";
    hometownController.text = p.hometown ?? " ";

    socialHandleController.text = p.socialHandle ?? " ";
    nameController.text = p.fullName ?? " ";

    selectedDate.value = p.dateOfBirth != null
        ? DateTime.parse(p.dateOfBirth!)
        : null;

    selectedImages.value = List<dynamic>.filled(6, null);

    final photos = p.photos ?? [];
    for (int i = 0; i < photos.length && i < 6; i++) {
      selectedImages[i] = photos[i];
    }
    removedPhotoUrls.clear();
    selectedImages.refresh();
    calculateAge();
    setselectedHeight(p.height);

    fetchIceBreakers();
  }

  setselectedHeight(String? val) {
    if (val == null) {
      selectedHeightIndex.value = heightOptions.length - 1; // "No preference"

      return;
    }
    selectedHeightIndex.value = heightOptions.indexWhere(
      (option) => option == val,
    );
    if (selectedHeightIndex.value == -1) {
      selectedHeightIndex.value = heightOptions.length - 1; // "No preference"
    }
  }
}

class ProfileFieldItem {
  final String label;
  final String answer;
  final String privacy;

  const ProfileFieldItem({
    required this.label,
    required this.answer,
    required this.privacy,
  });
}
