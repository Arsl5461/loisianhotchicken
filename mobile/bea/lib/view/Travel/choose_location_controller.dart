import 'dart:async';
import 'package:OApp/core/routing/app_routes.dart';
import 'package:OApp/view/Travel/models/travel_city_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../../config/helper_countries.dart';
import '../../controller/home_controller.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_keys.dart';
import '../../data/repositories/travel_repository.dart';
import '../../widgets/Images/Base64OrNetworkImage.dart';
import '../../services/secure_storage_service.dart';
import '../../widget_helper/loading_helper.dart';
import '../Dashboard/dashboard_controller.dart';
import 'models/create_post_model.dart';
import 'models/get_post_request_model.dart';
import 'models/travel_post_model.dart';
import 'sub_widgets/reply_bottom_sheet.dart';
import 'sub_widgets/story_action_bottom_sheet.dart';
import '../../utils/toast.dart';

class ChooseLocationController extends GetxController {
  HomeController get homeController => Get.find<HomeController>();
  late ScrollController? scrollcontroller;
  RxString searchQuery = "".obs;
  GetPostsRequest postRequest = GetPostsRequest();
  RxList<TravelPostModel> travelPosts = <TravelPostModel>[].obs;
  RxList<GetPostModel> getCityPosts = <GetPostModel>[].obs;
  RxList<TravelCity> travelCities = <TravelCity>[].obs;
  Rx<TravelCity> selectedTravelCity = TravelCity().obs;
  RxBool isNearbyFilter = false.obs;
  RxBool isLocationSet = false.obs;
  final RxDouble latitude = AppDefaults.fallbackLatitude.obs;
  final RxDouble longitude = AppDefaults.fallbackLongitude.obs;
  static const double fallbackLat = AppDefaults.fallbackLatitude;
  static const double fallbackLng = AppDefaults.fallbackLongitude;
  RxString country = "".obs;
  final SecureStorageService secureStorage = Get.find<SecureStorageService>();
  final TravelRepository _travelRepo = Get.find<TravelRepository>();
  RxBool isLocationGranted = false.obs;
  RxBool isLoading = false.obs;
  RxBool isPostLoading = false.obs;
  RxBool isCitiesLoading = false.obs;
  Rx<String?> selectedCity = "".obs;
  @override
  void onInit() {
    scrollcontroller = ScrollController();
    unawaited(checkLocationPermission());

    super.onInit();
  }

  @override
  void refresh({bool goBack = false}) {
    unawaited(refreshData());
    if (goBack) {
      Get.back();
    }
  }

  Future<void> initialize() async {
    await refreshData();
  }

  Future<void> refreshData() async {
    await Future.wait([getPosts(), getCitiesPosted()]);
  }

  bool isLocationNeeded() {
    bool needed =
        fallbackLat == latitude.value && fallbackLng == longitude.value;
    return needed;
  }

  /// Checks current location permission
  Future<void> checkLocationPermission() async {
    try {
      final status = await Permission.location.status;
      isLocationGranted.value = status == PermissionStatus.granted;
    } catch (e) {
      isLocationGranted.value = false;
    }
  }

  Future<void> showTravelPostsViewer(
    List<TravelPostModel> posts, {
    bool isOwner = true,
  }) async {
    await Get.toNamed(
      Routes.TRAVEL_POSTS_VIEWER,
      arguments: {'posts': posts, 'isOwner': isOwner},
    );
  }

  Future<void>? sendView(List<TravelPostModel> posts) async {
    try {
      final userId = await secureStorage.getKey(AppKeys.userID);
      await _travelRepo.recordView(posts.first.id ?? '', userId ?? '');
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {}
  }

  Future<void>? setLike(List<TravelPostModel> posts) async {
    try {
      final userId = await secureStorage.getKey(AppKeys.userID);
      await _travelRepo.recordLike(posts.first.id ?? '', userId ?? '');
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {}
  }

  Future<void>? sendReply(List<TravelPostModel> posts, String reply) async {
    try {
      final userId = await secureStorage.getKey(AppKeys.userID);
      final success = await _travelRepo.addComment(
        postId: posts.first.id ?? '',
        userId: userId ?? '',
        comment: reply,
      );
      if (success) {
        Toast.success("Replied To Story");
      }
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {}
  }

  Future<void>? getReplies(List<TravelPostModel> posts, String reply) async {
    try {
      CallLoadingHelper.show(text: "Loading Replies ...");
      final comments = await _travelRepo.fetchComments(posts.first.id ?? '');
      if (comments != null) {
        CallLoadingHelper.hide();
        await RepliesBottomSheet.show(Get.context!, comments: comments);
      }
    } catch (e) {
      CallLoadingHelper.hide();
      debugPrint("Error fetching posts: $e");
    } finally {}
  }

  Future<void>? getUsersViews(List<String> users, String title) async {
    try {
      if (users.isEmpty) {
        Toast.info("No $title yet".toLowerCase());
        return;
      }
      CallLoadingHelper.show(text: "Loading $title ...");
      final fetchedUsers = await _travelRepo.fetchUsersByIds(users.toList());
      if (fetchedUsers != null) {
        CallLoadingHelper.hide();
        await UsersBottomSheet.show(
          Get.context!,
          users: fetchedUsers,
          title: title,
        );
      }
    } catch (e) {
      CallLoadingHelper.hide();
      debugPrint("Error fetching posts: $e");
    } finally {}
  }

  Future<void> getPosts() async {
    try {
      isPostLoading.value = true;
      final userId = await secureStorage.getKey(AppKeys.userID);
      postRequest = GetPostsRequest(userId: userId, todaysStory: true);
      final posts = await _travelRepo.fetchPosts(postRequest);
      if (posts != null) {
        travelPosts.value = posts;
        final avatar = headerAvatarUrl(travelCities, posts);
        if (avatar != null && Base64OrNetworkImage.isNetworkUrl(avatar)) {
          unawaited(Base64OrNetworkImage.warmNetworkCache(avatar));
        }
      }
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {
      isPostLoading.value = false;
    }
  }

  Future<void> getCitiesPosted() async {
    final showInitialLoader = travelCities.isEmpty;

    try {
      if (showInitialLoader) isLoading.value = true;
      isCitiesLoading.value = true;

      final cities = await _travelRepo.fetchCitiesPosted();
      if (cities != null) {
        travelCities.value = cities;
        assignimagesCities();
        _prefetchCityImages();
      }
    } catch (e) {
      debugPrint("Error fetching cities: $e");
    } finally {
      isCitiesLoading.value = false;
      if (showInitialLoader) isLoading.value = false;
    }
  }

  Future<void> getCitiesSearch(String query) async {
    try {
      isCitiesLoading.value = true;

      final cities = await _travelRepo.searchCities(query);
      if (cities != null) {
        travelCities.value = cities;
        assignimagesCities();
        _prefetchCityImages();
      }
    } catch (e) {
      debugPrint("Error searching cities: $e");
    } finally {
      isCitiesLoading.value = false;
    }
  }

  /// Requests location permission

  Future<bool> requestPermissionAndSetLocation() async {
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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      latitude.value = pos.latitude;
      longitude.value = pos.longitude;
      isLocationSet.value = true;

      List<geo.Placemark> placemarks =
          await geo.Geocoding().placemarkFromCoordinates(
        latitude.value,
        longitude.value,
      );

      geo.Placemark place = placemarks.first;

      String city =
          [
            place.locality,
            place.subAdministrativeArea,
            place.administrativeArea,
            WorldDefaults.countryCapitals[place.country],
            "Washington",
          ].whereType<String>().firstWhere(
            (e) => e.trim().isNotEmpty,
            orElse: () => "Washington",
          );

      country.value =
          (place.country != null && place.country!.trim().isNotEmpty)
          ? "${place.country!},$city"
          : "USA,$city";

      return true;
    } catch (e) {
      _setFallback();
      return false;
    } finally {}
  }

  void _setFallback() {
    latitude.value = fallbackLat;
    longitude.value = fallbackLng;
  }

  Future<void> useCurrentLocation() async {
    // Show loading

    await requestPermissionAndSetLocation();

    isNearbyFilter.value = true;
    getNearbyCitiesWithStories();
  }

  Future<void> getNearbyCitiesWithStories() async {
    try {
      isCitiesLoading.value = true;
      final cities = await _travelRepo.fetchNearbyCities(
        latitude: latitude.value,
        longitude: longitude.value,
      );
      if (cities != null) {
        travelCities.value = cities;
        assignimagesCities();
        _prefetchCityImages();
      }
    } catch (e) {
      debugPrint("Error fetching nearby cities: $e");
    } finally {
      isCitiesLoading.value = false;
    }
  }

  Future<bool> getPostsByCityId(String cityId) async {
    try {
      final posts = await _travelRepo.fetchPostsByCityId(cityId);

      if (posts != null) {
        getCityPosts.value = posts;
        return true;
      }

      Toast.error('Failed to load posts for the selected city.');
    } catch (e) {
      Toast.error('An error occurred while loading posts.');
      debugPrint("Error fetching city posts: $e");
    }
    return false;
  }

  Future<void> updateLocation(TravelCity city) async {
    try {
      selectedTravelCity.value = city;
      var res = await getPostsByCityId(city.cityId ?? "");
      if (!res) return;

      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.openTravelCity(city.name ?? "");
        return;
      }

      Get.offAllNamed(Routes.TRAVEL, arguments: 2);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().openTravelCity(city.name ?? "");
        }
      });
    } catch (e) {
      Toast.error('Failed to update location: ${e.toString()}');
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  List<String> citiesImages = [
    "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1541849546-216549ae216d?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1500916434205-0c77489c6cf7?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1516900557549-41557d405adf?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ];

  void assignimagesCities() {
    if (travelCities.isEmpty) return;

    for (int i = 0; i < travelCities.length; i++) {
      final currentImage = travelCities[i].image;
      if (currentImage == null || currentImage.trim().isEmpty) {
        travelCities[i].image = citiesImages[i % citiesImages.length];
      }
    }

    travelCities.refresh();
  }

  void _prefetchCityImages() {
    final urls = travelCities
        .map((city) => city.image ?? '')
        .where(Base64OrNetworkImage.isNetworkUrl);

    Base64OrNetworkImage.prefetchUrls(
      Get.context,
      urls,
      width: 180,
      height: 200,
    );
  }

  void searchPostedCities() {
    isNearbyFilter.toggle();
    if (isNearbyFilter.value) {
      useCurrentLocation();
      getNearbyCitiesWithStories();
    } else if (searchQuery.value.trim().isEmpty) {
      getCitiesPosted();
    } else {
      getCitiesSearch(searchQuery.value.trim());
    }
  }

  Future<void> showStoryActionSheet() async {
    final context = Get.context;
    if (context == null) return;

    await StoryActionBottomSheet.show(
      context: context,
      hasStory: travelPosts.isNotEmpty,
      storyCount: travelPosts.length,
      avatarUrl: headerAvatarUrl(travelCities, travelPosts),
      onCreateStory: () => Get.toNamed(Routes.CREATE_POST),
      onViewStory: () => showTravelPostsViewer(travelPosts),
    );
  }

  String? headerAvatarUrl(
    List<TravelCity> cities,
    List<TravelPostModel> posts,
  ) {
    final firstPostImage = posts.isNotEmpty ? posts.first.imageUrl : null;
    if (firstPostImage != null && firstPostImage.isNotEmpty) {
      return firstPostImage;
    }
    if (cities.isNotEmpty && cities.first.image!.isNotEmpty) {
      return cities.first.image;
    }
    return null;
  }
}
