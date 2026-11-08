// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:OApp/config/error_handler.dart';
import 'package:OApp/core/constants/app_defaults.dart';
import 'package:OApp/core/constants/app_keys.dart';
import 'package:OApp/view/Travel/choose_location_controller.dart';
import 'package:OApp/widget_helper/loading_helper.dart';
import 'package:OApp/widget_helper/widget_helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../data/repositories/travel_repository.dart';
import '../../../services/secure_storage_service.dart';
import '../../../services/storage_service.dart';
import '../../../utils/toast.dart';
import '../models/create_post_model.dart';

import 'package:OApp/core/constants/app_colors.dart';

enum GalleryState { loading, loaded, permissionDenied, error, empty }

class CreatePostController extends GetxController {
  final RxMap<int, Uint8List> editedImageBytesMap = <int, Uint8List>{}.obs;
  final RxList<String> selectedImages = <String>[].obs;
  final RxInt currentIndex = 0.obs;
  final String _tag = "CreatePostController";
  final TravelRepository _travelRepo = Get.find<TravelRepository>();
  final Rx<GalleryState> galleryState = GalleryState.loading.obs;
  List<String> uploadedImagesToStorage = [];
  ChooseLocationController get chooseLocationController =>
      Get.find<ChooseLocationController>();
  final _uuid = const Uuid();
  final SecureStorageService _storage = Get.find<SecureStorageService>();
  final RxList<AssetEntity> galleryImages = <AssetEntity>[].obs;
  StorageService get _storageService => Get.find<StorageService>();
  final RxBool isSongUploading = false.obs;
  final RxString uploadedSongUrl = ''.obs;
  final RxDouble latitude = AppDefaults.fallbackLatitude.obs;
  final RxDouble longitude = AppDefaults.fallbackLongitude.obs;
  static const double fallbackLat = AppDefaults.fallbackLatitude;
  static const double fallbackLng = AppDefaults.fallbackLongitude;

  final AudioPlayer _player = AudioPlayer();
  RxBool showEditOptions = false.obs;
  final RxBool isLocLoading = false.obs;
  final RxBool isLocLoaded = false.obs;
  late TextEditingController captionController;
  final ImagePicker _picker = ImagePicker();
  RxString imagePath = ''.obs;
  // Sample recent images
  final recentImages = <String>[
    'https://images.unsplash.com/photo-1527736947477-2790e28f3443?w=400',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
    'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=400',
    'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
    'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400',
  ];
  @override
  void onInit() {
    super.onInit();
    captionController = TextEditingController(); // initialize controller
    unawaited(loadGalleryImages());
  }

  @override
  void onClose() {
    captionController.dispose(); // dispose controller to free memory
    super.onClose();
  }

  /// Converts an image file at [imagePath] to a Base64 string
  Future<String> imagePathToBase64(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception("File does not exist at path: $imagePath");
      }
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint("Error converting image to Base64: $e");
      return "";
    }
  }

  void setEditedImageBytes(Uint8List bytes, {int? index}) {
    final targetIndex = index ?? currentIndex.value;

    if (targetIndex < 0 || targetIndex >= selectedImages.length) return;

    editedImageBytesMap[targetIndex] = bytes;
    update();
  }

  Uint8List? getEditedImageBytes({int? index}) {
    final targetIndex = index ?? currentIndex.value;
    return editedImageBytesMap[targetIndex];
  }

  bool hasEditedImageBytes({int? index}) {
    final targetIndex = index ?? currentIndex.value;
    return editedImageBytesMap.containsKey(targetIndex);
  }

  void removeEditedImageBytes({int? index}) {
    final targetIndex = index ?? currentIndex.value;
    editedImageBytesMap.remove(targetIndex);
    update();
  }

  Future<void> saveEditedImageAndReplace(Uint8List bytes, {int? index}) async {
    try {
      final targetIndex = index ?? currentIndex.value;

      if (targetIndex < 0 || targetIndex >= selectedImages.length) return;

      final dir = await getTemporaryDirectory();
      final fileName = 'edited_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(bytes, flush: true);

      selectedImages[targetIndex] = file.path;
      selectedImages.refresh();
    } catch (e) {
      debugPrint('Error saving edited image: $e');
    }
  }

  void clearAllEditedImageBytes() {
    editedImageBytesMap.clear();
    update();
  }

  String fileNameFromPath(String path) {
    return path.split('/').last;
  }

  String? songFileName = "";

  Future<void> removeMusic() async {
    _player.stop();
    if (uploadedSongUrl.value.isNotEmpty) {
      unawaited(_storageService.deleteFileByUrl(uploadedSongUrl.value));
    }

    uploadedSongUrl.value = '';
    songFileName = "";
    isSongUploading.value = false;
    audioStatus.value = AudioStatus.idle;
  }

  Future<void> addMusic() async {
    try {
      isSongUploading.value = true;
      var permission = await WidgetHelpers.requestPermission(
        Permission.storage,
        message:
            "Storage permission is required to select music for your post.",
      );

      if (!permission.isGranted) return;

      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
      );

      if (files.isEmpty) {
        Toast.error("No file selected");
        return;
      }

      final file = files.single;

      final url = await _storageService.uploadMusic(
        uniqueId: _uuid.v4(),
        filePath: file.path,
        fileName: file.name,
      );
      songFileName = fileNameFromPath(file.path ?? "XYZ");
      uploadedSongUrl.value = url;
    } catch (e, s) {
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
    } finally {
      isSongUploading.value = false;
    }
  }

  Rx<AudioStatus> audioStatus = AudioStatus.idle.obs;
  Future<void> playMusic(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      debugPrint("Error playing music: $e");
    }
  }

  Future<void> toggleState() async {
    try {
      switch (audioStatus.value) {
        case AudioStatus.idle:
          if (uploadedSongUrl.value.isNotEmpty) {
            audioStatus.value = AudioStatus.loading;
            await _player.setUrl(uploadedSongUrl.value);
            _player.play();
            audioStatus.value = AudioStatus.playing;
          }
          break;
        case AudioStatus.loading:
          // Do nothing or show loading indicator
          break;
        case AudioStatus.playing:
          await _player.pause();
          audioStatus.value = AudioStatus.idle;
          break;
        case AudioStatus.error:
          Toast.error("Error playing music");
          break;
      }
    } catch (e) {
      debugPrint("Error playing music: $e");
    }
  }

  Future<void> loadGalleryImages() async {
    galleryState.value = GalleryState.loading;

    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    /// Permission denied
    if (!permission.isAuth && !permission.hasAccess) {
      galleryState.value = GalleryState.permissionDenied;
      await _showPermissionDialog();
      return;
    }

    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isEmpty) {
        galleryState.value = GalleryState.empty;
        return;
      }

      final recentAlbum = albums.first;

      final images = await recentAlbum.getAssetListPaged(page: 0, size: 100);

      if (images.isEmpty) {
        galleryState.value = GalleryState.empty;
      } else {
        galleryImages.assignAll(images);
        galleryState.value = GalleryState.loaded;
      }
    } catch (e) {
      galleryState.value = GalleryState.error;
      debugPrint("Gallery error: $e");
    }
  }

  /// Permission dialog
  Future<void> _showPermissionDialog() async {
    bool? openSettings = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 50,
                color: AppColors.orange,
              ),

              const SizedBox(height: 16),

              const Text(
                "Gallery Permission Required",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "We need access to your photos so you can select images for your post.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text("Open Settings"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (openSettings == true) {
      await PhotoManager.openSetting();
    }
  }

  /// Open camera and navigate to editor
  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null) {
        navigateToPostEditor([photo.path]);
      }
    } catch (e) {
      showError('Failed to take photo: $e');
    }
  }

  Future<void> addMoreImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
      if (images.isNotEmpty) {
        selectedImages.addAll(images.map((e) => e.path));
      }
    } catch (e) {
      showError('Failed to select images: $e');
    }
  }

  void removeImageAt(int index) {
    if (index < 0 || index >= selectedImages.length) return;

    selectedImages.removeAt(index);
    editedImageBytesMap.remove(index);

    // reindex map after removal
    final updatedMap = <int, Uint8List>{};
    for (final entry in editedImageBytesMap.entries) {
      if (entry.key > index) {
        updatedMap[entry.key - 1] = entry.value;
      } else if (entry.key < index) {
        updatedMap[entry.key] = entry.value;
      }
    }
    editedImageBytesMap.assignAll(updatedMap);

    if (selectedImages.isEmpty) {
      Get.back();
      return;
    }

    if (currentIndex.value >= selectedImages.length) {
      currentIndex.value = selectedImages.length - 1;
    }
  }

  void setCurrentIndex(int index) {
    if (index >= 0 && index < selectedImages.length) {
      currentIndex.value = index;
    }
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = selectedImages.removeAt(oldIndex);
    selectedImages.insert(newIndex, item);

    if (currentIndex.value == oldIndex) {
      currentIndex.value = newIndex;
    } else {
      if (oldIndex < currentIndex.value && newIndex >= currentIndex.value) {
        currentIndex.value -= 1;
      } else if (oldIndex > currentIndex.value &&
          newIndex <= currentIndex.value) {
        currentIndex.value += 1;
      }
    }
  }

  void replaceEditedImage(int index, String newPath) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages[index] = newPath;
      editedImageBytesMap.remove(index);
    }
  }

  Future<String?> uploadPostImage(String path) async {
    try {
      String? userId = await _storage.getKey(AppKeys.userID);

      final file = File(path);
      if (!file.existsSync()) return null;

      final uniqueName = "${_uuid.v4()}_${file.path.split('/').last}";

      final url = await _storageService.uploadFile(
        storagePath: "user_posts/$userId",
        filePath: path,
        fileName: uniqueName,
      );

      return url;
    } catch (e) {
      debugPrint("Upload image error: $e");
      return null;
    }
  }

  Future<void> sharePost() async {
    if (selectedImages.isEmpty) {
      showError('No image selected.');
      return;
    }

    if (captionController.text.trim().isEmpty) {
      showError('Caption cannot be empty.');
      return;
    }

    try {
      CallLoadingHelper.show(text: "Sharing your post...");

      final List<String> uploadedUrls = [];

      for (final path in selectedImages) {
        final uploadedImage = await uploadPostImage(path);
        if (uploadedImage == null) {
          showError("One of the image uploads failed");
          return;
        }
        uploadedUrls.add(uploadedImage);
      }

      await requestPermissionAndSetLocation();
      String city = "Unknown";
      String country = "Unknown";
      List<Placemark> placemarks = [];

      try {
        placemarks = await Geocoding().placemarkFromCoordinates(
          latitude.value,
          longitude.value,
        );
      } catch (e) {
        debugPrint("Geocoding failed: $e");
      }

      if (placemarks.isEmpty) {
        // fallback safe values
        city = "Unknown";
        country = "Unknown";
      } else {
        Placemark place = placemarks.first;

        city =
            [
              place.locality,
              place.subAdministrativeArea,
              place.administrativeArea,
            ].firstWhere(
              (e) => e != null && e.trim().isNotEmpty,
              orElse: () => "Unknown",
            )!;

        country = place.country ?? "Unknown";
      }
      final post = CreatePostModel(
        songUrl: uploadedSongUrl.value,
        imageUrls: uploadedUrls,
        caption: captionController.text.trim(),
        city: city,
        country: country,
        location: {"latitude": latitude.value, "longitude": longitude.value},
      );

      final result = await _travelRepo.createPost(post.toJson());

      if (result.isSuccess) {
        chooseLocationController.refresh();
        Toast.success('Post shared successfully!');
        CallLoadingHelper.hide();
        await Future.delayed(const Duration(milliseconds: 500));
        Get.close(2);
      } else {
        showError(result.errorMessage ?? "Failed to upload post");
      }
    } catch (e) {
      debugPrint("Share post error: $e");
      showError("Something went wrong");
    } finally {
      CallLoadingHelper.hide();
    }
  }

  /// Pick images from gallery and navigate
  Future<void> selectFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
      if (images.isNotEmpty) {
        navigateToPostEditor(images.map((e) => e.path).toList());
      }
    } catch (e) {
      showError('Failed to select images: $e');
    }
  }

  Future<bool> requestPermissionAndSetLocation() async {
    isLocLoading.value = true;

    try {
      // 1) service enabled?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        _setFallback();
        return false;
      }

      // 2) permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _setFallback();
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
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
      isLocLoaded.value = true;
      return true;
    } catch (e) {
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

  /// Navigate to post editor screen
  void navigateToPostEditor(List<String> imagePaths, {int initialIndex = 0}) {
    selectedImages.assignAll(imagePaths);
    currentIndex.value = initialIndex;
    Get.toNamed(
      Routes.POST_EDITOR,
      arguments: {'imagePaths': imagePaths, 'initialIndex': initialIndex},
    );
  }

  void openSelectedImageEditor() {
    if (selectedImages.isEmpty) {
      showError('No image selected');
      return;
    }

    showEditOptions.value = true;
    Get.toNamed(Routes.POST_IMAGE_EDITOR);
  }

  /// Show error using snackbar
  void showError(String message) {
    Toast.error(message);
  }

  /// Show bottom sheet camera/gallery options
  void showCameraOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              icon: Icons.camera_alt,
              title: 'Take Photo',
              onTap: () {
                Get.back();
                takePhoto();
              },
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              icon: Icons.photo_library,
              title: 'Choose from Gallery',
              onTap: () {
                Get.back();
                selectFromGallery();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.black87),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
