// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:OApp/hardcoded_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../config/error_handler.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/constants/app_keys.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../core/routing/app_routes.dart';
import '../../../models/dating_preferences_model.dart';
import '../../../models/profile_form_model.dart';
import '../../../models/user_model.dart';
import '../../../services/global_service.dart';
import '../../../services/secure_storage_service.dart';
import '../../../services/storage_service.dart';
import '../../../utils/toast.dart';
import '../../../widget_helper/loading_helper.dart';
import 'package:path/path.dart' as p;

import '../../profileSetting/models/ice_breaker_model.dart';

/// =======================================================
/// Profile Controller
/// Handles all profile-making related state & logic
/// =======================================================
class ProfileController extends GetxController {
  final String _tag = "Profile Controller";
  List<String> uploadedImagesToStorage = [];
  GlobalService get _globalService => Get.find<GlobalService>();
  final _uuid = const Uuid();
  final SecureStorageService _storage = Get.find<SecureStorageService>();
  final Rx<DatingPreferencesModel> datingPreferences = DatingPreferencesModel(
    ageRange: const RangeValues(22, 36),
    maxDistance: 8,
    lookingFor: null,
    interests: const [],
    height: null,
    ethnicity: const [],
    education: null,
    religion: const [],
    drinking: null,
    smoking: null,
    gender: null,
    politics: const [],
    languages: const [],
  ).obs;
  StorageService get _storageService => Get.find<StorageService>();
  final RxDouble latitude = AppDefaults.fallbackLatitude.obs;
  final RxDouble longitude = AppDefaults.fallbackLongitude.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  static const double fallbackLat = AppDefaults.fallbackLatitude;
  static const double fallbackLng = AppDefaults.fallbackLongitude;
  RxString platform = "".obs;
  bool get isEmailValid {
    final email = (profile.value.email ?? '').trim();
    final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');

    final isMatch = regex.hasMatch(email);

    return isMatch;
  }

  final RxBool isLocLoading = false.obs;
  final email = ''.obs;
  RxString socialHandle = ''.obs;

  RxString selectedPlatforms = ''.obs;
  final RxnString locError = RxnString();
  // =======================
  // BASIC PROFILE INFO
  // =======================
  final Rx<ProfileFormModel> profile = ProfileFormModel().obs;
  void clearAll() {
    profile.value = ProfileFormModel();
    firstNameController.clear();
    schoolNameController.clear();
    jobTitleController.clear();
    companyNameController.clear();
    hometownController.clear();
    socialHandleController.clear();
    emailController.clear();
    selectedDate = null;
    selectedImages.value = List<dynamic>.filled(6, null);
    selectedHeightIndex = heightOptions.length - 1; // "No preference"
    answers = [];
    user.value = null;
    for (final e in icebreakers) {
      e?.answer = null;
    }
    for (int i = 0; i < selectedImages.length; i++) {
      selectedImages[i] = null;
    }
  }

  bool get isPubliclyDisplayed => profile.value.isPubliclyDisplayed;
  set isPubliclyDisplayed(bool value) =>
      profile.update((p) => p?.isPubliclyDisplayed = value);

  final RxBool displayOnProfile = false.obs;

  bool get displayOnProfile1 => profile.value.displayOnProfile1;
  set displayOnProfile1(bool value) =>
      profile.update((p) => p?.displayOnProfile1 = value);

  var hometownText = ''.obs;
  final rxEmail = ''.obs;

  // =======================
  // TEXT CONTROLLERS
  // =======================
  RxString socialHandler = "".obs;
  RxString firstName = "".obs;
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController hometownController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController socialHandleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RxList<IceBreakerModel?> icebreakers = RxList<IceBreakerModel?>([]);
  final RxBool isLoading = false.obs;
  final ProfileRepository _profileRepo = Get.find<ProfileRepository>();

  // =======================
  // DATE OF BIRTH / AGE
  // =======================
  DateTime? get selectedDate => profile.value.selectedDate;
  set selectedDate(DateTime? value) =>
      profile.update((p) => p?.selectedDate = value);

  int? get calculatedAge => profile.value.calculatedAge;
  set calculatedAge(int? value) =>
      profile.update((p) => p?.calculatedAge = value);

  String? get zodiacSign => profile.value.zodiacSign;
  set zodiacSign(String? value) => profile.update((p) => p?.zodiacSign = value);

  // =======================
  // GENDER SELECTION STATE
  // =======================

  // =======================
  // HEIGHT
  // =======================
  int get selectedHeightIndex => profile.value.selectedHeightIndex;
  set selectedHeightIndex(int value) =>
      profile.update((p) => p?.selectedHeightIndex = value);

  final List<String> heightOptions = List.generate(37, (index) {
    int feet = 4 + (index ~/ 12);
    int inches = index % 12;
    return "$feet ft $inches in";
  });

  // =======================
  // PROMPTS
  // =======================
  List<String> get answers => profile.value.answers;
  set answers(List<String> value) => profile.update((p) => p?.answers = value);

  RxList<int> expandedIds = <int>[].obs;
  set expandedStates(List<bool> value) =>
      profile.update((p) => p?.expandedStates = value);

  // =======================
  // IMAGE PICKER
  // =======================
  final RxList<dynamic> selectedImages = List<dynamic>.filled(6, null).obs;

  final ImagePicker picker = ImagePicker();

  // =======================
  // OPTIONS LISTS
  // =======================

  bool get hasAtLeastOneAnswer {
    return icebreakers.whereType<IceBreakerModel>().any(
          (e) => e.answer != null && e.answer!.trim().isNotEmpty,
        ) ||
        answers.any((answer) => answer.trim().isNotEmpty);
  }

  Map<String, dynamic> toJson() {
    profile.update((p) {
      if (p != null) {
        p.displayOnProfile = displayOnProfile.value;
      }
    });
    return profile.value.toJson();
  }

  void loadFromJson(Map<String, dynamic> json) {
    profile.value = ProfileFormModel.fromJson(json);
    displayOnProfile.value = profile.value.displayOnProfile;
  }

  void setImageAt(int index, dynamic image) {
    if (index < 0 || index >= selectedImages.length) return;
    selectedImages[index] = image;
    selectedImages.refresh();
  }

  Future<void> removeImageAt(int index) async {
    if (index < 0 || index >= selectedImages.length) return;

    final item = selectedImages[index];

    if (item is String && item.startsWith('http')) {
      try {
        remove(item);
      } catch (_) {}
    }

    selectedImages[index] = null;
    selectedImages.refresh();
  }

  RxString loadingMessage = "Preparing...".obs;
  // =======================
  // LIFECYCLE
  // =======================

  @override
  void onInit() {
    super.onInit();

    displayOnProfile.value = profile.value.displayOnProfile;

    // Default DOB (25 years old)
    selectedDate = DateTime.now().subtract(const Duration(days: 25 * 365));
    calculateAge();
    if (user.value == null) {
      unawaited(fetchUserProfile(isWithoutLoading: true));
    }
    // Listeners

    firstNameController.addListener(update);
    ever<bool>(displayOnProfile, (value) {
      profile.update((p) {
        if (p != null) {
          p.displayOnProfile = value;
        }
      });
    });
  }

  // =======================
  // AGE & ZODIAC
  // =======================
  void calculateAge() {
    if (selectedDate == null) return;

    final now = DateTime.now();
    int age = now.year - selectedDate!.year;

    if (now.month < selectedDate!.month ||
        (now.month == selectedDate!.month && now.day < selectedDate!.day)) {
      age--;
    }

    calculatedAge = age;
    zodiacSign = HardCodedData.getZodiacSign(
      selectedDate!.month,
      selectedDate!.day,
    );
    update();
  }

  // =======================
  // GENDER SELECTION
  // =======================

  // =======================
  // DATING PREFERENCE
  // =======================

  // =======================
  // CLEANUP
  // =======================
  @override
  void dispose() {
    schoolNameController.dispose();
    hometownController.dispose();
    jobTitleController.dispose();
    companyNameController.dispose();
    firstNameController.dispose();
    socialHandleController.dispose();
    super.dispose();
  }

  Future<bool> requestPermissionAndSetLocation() async {
    isLocLoading.value = true;
    locError.value = null;

    try {
      // 1) service enabled?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        locError.value = 'Please enable location services in device settings';
        _setFallback();
        return false;
      }

      // 2) permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        locError.value = 'Location permission was denied';
        _setFallback();
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        locError.value =
            'Location permission permanently denied. Enable it from settings.';
        _setFallback();
        return false;
      }

      // 3) granted -> get location
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      latitude.value = pos.latitude;
      longitude.value = pos.longitude;

      return true;
    } catch (e) {
      locError.value = 'Failed to get location: $e';
      _setFallback();
      return false;
    } finally {
      isLocLoading.value = false;
    }
  }

  void _setFallback() {
    latitude.value = fallbackLat;
    longitude.value = fallbackLng;
  }

  String getSelectedDate(DateTime? value) {
    return value == null
        ? ""
        : "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
  }

  void remove(String url) {
    _storageService.deleteFileByUrl(url);
  }

  Future<List<String>> uploadFiles() async {
    uploadedImagesToStorage.clear();

    final currentUserId = await _storage.getKey(AppKeys.userID);
    if (currentUserId == null || currentUserId.isEmpty) return [];

    final validItems = selectedImages.where((e) => e != null).toList();
    final filesToUpload = selectedImages.whereType<File>().toList();

    final totalFiles = filesToUpload.length;
    int uploadedCount = 0;

    // Optional: if you still want existing String images preserved
    for (final item in validItems) {
      if (item is String) {
        uploadedImagesToStorage.add(item);
      }
    }

    for (final file in filesToUpload) {
      uploadedCount++;

      loadingMessage.value = "Uploading photo $uploadedCount of $totalFiles";
      currentStep.value = uploadedCount;
      totalStep.value = totalFiles;
      uploadProgress.value = totalFiles == 0 ? 0.0 : uploadedCount / totalFiles;

      final base = p.basename(file.path);
      final uniqueFileName = '${_uuid.v4()}_$base';

      final res = await _storageService.uploadFile(
        storagePath: 'user_photos/$currentUserId',
        filePath: file.path,
        fileName: uniqueFileName,
      );

      if (res.isNotEmpty) {
        uploadedImagesToStorage.add(res);
      }
    }

    return uploadedImagesToStorage;
  }

  final RxInt currentStep = 2.obs;
  final RxInt totalStep = 6.obs;
  final RxDouble uploadProgress = 0.33.obs;
  void addUserByIndex({required int index}) async {
    try {
      if (icebreakers.isEmpty) {
        unawaited(fetchIceBreakers());
      }

      /// 2️⃣ Prepare profile
      if (index == 4) {
        loadingMessage.value = "Saving Photos ..";
        currentStep.value = 0;
        totalStep.value = selectedImages.length;
        uploadProgress.value = 0.0;

        UploadProgressDialog.show(
          title: loadingMessage,
          currentStep: currentStep,
          totalStep: totalStep,
          progress: uploadProgress,
        );
        await uploadFiles();

        loadingMessage.value = "Completed";
        uploadProgress.value = 1.0;

        UploadProgressDialog.hide();
      }

      profile.update((p) {
        if (p == null) return;

        p.fullName = firstNameController.text.trim();
        p.stepsDone = index;
        p.schoolName = schoolNameController.text.trim();
        p.photos = uploadedImagesToStorage;
        if (index == 1) {
          if (selectedDate != null) {
            p.dateOfBirth = getSelectedDate(selectedDate ?? DateTime.now());
          }
          p.latitude = latitude.value;
          p.longitude = longitude.value;
        }
        p.initialSetup = index == 4;
        p.companyName = companyNameController.text.trim();
        p.hometown = hometownController.text.trim();
        p.socialHandle = socialHandleController.text.trim();

        p.email = emailController.text.trim();
        p.iceBreakers = icebreakers
            .whereType<IceBreakerModel>()
            .where((e) => e.answer?.trim().isNotEmpty == true)
            .toList();
      });

      /// 3️⃣ Convert to JSON

      final body = profile.value.toJson();

      /// 4️⃣ API Call

      final result = await _profileRepo.addProfile(body);

      if (result.isSuccess && result.user != null) {
        user.value = result.user;
        profile.value = ProfileFormModel.fromUserModel(user.value!);
        _globalService.setUserModel(user.value!);

        switch (index) {
          case 4:
            Get.toNamed(Routes.PROFILE_COMPLETE);
            break;
          case 3:
            Get.toNamed(Routes.ICEBREAKERS);
            break;

          case 1:
            Get.toNamed(Routes.RELIGIOUS_VIEWS);
            break;

          case 2:
            Get.toNamed(Routes.JOB_SELECTION);
            break;
        }
      } else {
        Toast.error(result.errorMessage ?? 'Failed to create profile');
      }
    } catch (e, s) {
      UploadProgressDialog.hide();
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile({bool isWithoutLoading = false}) async {
    isLoading.value = true;

    try {
      final fetchedUser = await _profileRepo.fetchUser();

      if (fetchedUser != null) {
        user.value = fetchedUser;
        profile.value = ProfileFormModel.fromUserModel(fetchedUser);
        _globalService.setUserModel(fetchedUser);
        assignValues();
      } else if (!isWithoutLoading) {
        Toast.error('Failed to load profile');
      }
    } catch (e) {
      Toast.error('Something went wrong: $e');
    } finally {
      isLoading.value = false;
      if (icebreakers.isEmpty) {
        unawaited(fetchIceBreakers(isWithoutLoading: isWithoutLoading));
      }
    }
  }

  /// Pushes the coordinates already in [latitude] / [longitude] to the
  /// account. Part 1 of the Bubba flow asks for location and the API keeps it
  /// on the user document, so without this the permission prompt only ever
  /// moved a number into memory.
  Future<bool> saveLocationToAccount() async {
    try {
      final result = await _profileRepo.updateLocation(
        latitude: latitude.value,
        longitude: longitude.value,
      );
      if (!result.isSuccess) {
        locError.value = result.errorMessage ?? 'Could not save your location';
      }
      return result.isSuccess;
    } catch (e) {
      locError.value = 'Could not save your location';
      return false;
    }
  }

  void setLiveLocation() async {
    await requestPermissionAndSetLocation();
    CallLoadingHelper.show(text: "Setting you Location...");

    /// ---------- TEXT FIELDS ----------

    /// ---------- ARRAY FIELDS ----------

    /// ---------- IMAGES AS BASE64 ----------

    isLoading.value = true;
    try {
      final result = await _profileRepo.updateLocation(
        latitude: latitude.value,
        longitude: longitude.value,
      );

      if (result.isSuccess) {
        CallLoadingHelper.hide();
        Get.back();
      } else {
        Toast.error(result.errorMessage ?? 'Failed to create profile');
      }
    } catch (e) {
      CallLoadingHelper.hide();
      Toast.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
      CallLoadingHelper.hide();
    }
  }

  void assignValuestoIceBreakers() {
    for (var v in user.value?.iceBreakers ?? []) {
      if (v.answer != null) {
        icebreakers.where((e) => e?.id == v.id).firstOrNull?.answer = v.answer;
      }
    }
  }

  Future<void> fetchIceBreakers({bool isWithoutLoading = false}) async {
    isLoading.value = true;

    try {
      final fetchedIceBreakers = await _profileRepo.fetchIceBreakers();

      if (fetchedIceBreakers != null) {
        icebreakers.value = fetchedIceBreakers;
        icebreakers.refresh();
      } else if (!isWithoutLoading) {
        Toast.error('Failed to load ice breakers');
      }
    } catch (e) {
      if (!isWithoutLoading) {
        Toast.error('Something went wrong');
      }
    } finally {
      isLoading.value = false;
      assignValuestoIceBreakers();
    }
  }

  void skipNotificationSetup() {
    Get.toNamed(Routes.GENDER_SELECTION);
  }

  void assignValues() {
    ProfileFormModel p = profile.value;
    email.value = p.email ?? " ";
    schoolNameController.text = p.schoolName ?? " ";
    jobTitleController.text = p.jobTitle ?? " ";
    companyNameController.text = p.companyName ?? " ";
    hometownController.text = p.hometown ?? " ";
    socialHandle.value = p.socialHandle ?? " ";
    socialHandleController.text = p.socialHandle ?? " ";
    firstNameController.text = p.fullName ?? " ";
    emailController.text = p.email ?? " ";
    socialHandle.value = p.socialHandle ?? " ";
    selectedDate = p.dateOfBirth != null
        ? DateTime.parse(p.dateOfBirth!)
        : null;

    selectedImages.value = List<Object?>.filled(6, null);
    for (int i = 0; i < p.photos.length && i < 6; i++) {
      selectedImages[i] = p.photos[i];
    }
    selectedImages.refresh();
    calculateAge();
    setselectedHeight(p.height);

    for (var v in p.iceBreakers) {
      if (v.prompt != null && v.answer != null) {
        icebreakers.where((e) => e?.id == v.id).firstOrNull?.answer = v.answer;
      }
    }
  }

  setselectedHeight(String? val) {
    if (val == null) {
      selectedHeightIndex = heightOptions.length - 1; // "No preference"

      return;
    }
    selectedHeightIndex = heightOptions.indexWhere((option) => option == val);
    if (selectedHeightIndex == -1) {
      selectedHeightIndex = heightOptions.length - 1; // "No preference"
    }
  }

  String getPrompt(String iceBreakerId) {
    int index = icebreakers.indexWhere((e) => e?.id == iceBreakerId);
    if (index != -1) {
      return icebreakers[index]?.prompt ?? "";
    }
    return "";
  }
}
