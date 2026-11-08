import 'dart:async';

import 'package:OApp/config/error_handler.dart';
import 'package:OApp/view/messages/controller/chat_list_controller.dart';
import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:OApp/view/profileSetting/Invite/controller/invite_friends_controller.dart';
import 'package:OApp/view/profileSetting/models/ice_breaker_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/home_repository.dart';
import '../../widgets/Images/Base64OrNetworkImage.dart';
import '../../helper/location_helper.dart';
import '../../models/pending_likes_model.dart';
import '../../models/user_model.dart';
import '../../services/dailog_service.dart';
import '../../services/global_service.dart';
import '../../services/secure_storage_service.dart';
import '../../view/Dashboard/dashboard_controller.dart';
import '../../view/Travel/choose_location_controller.dart';
import '../../view/profileSetting/controller/profile_display_controller.dart';
import '../your_likes_controller.dart';

abstract class HomeControllerBase extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLiking = false.obs;
  final RxBool isDisliking = false.obs;
  late final ScrollController scrollController;

  final String tag = 'HomeController';
  final HomeRepository homeRepository = Get.find<HomeRepository>();
  final SecureStorageService storage = Get.find<SecureStorageService>();

  GlobalService get globalService => Get.find<GlobalService>();
  DialogService get dialogService => Get.find<DialogService>();
  DashboardController get dashboardController => Get.find<DashboardController>();

  EditController get editController => Get.find<EditController>();
  ProfileDisplayController get profileDisplayController =>
      Get.find<ProfileDisplayController>();
  ChatListController get chatListController => Get.find<ChatListController>();
  InviteFriendsController get inviteFriendsController =>
      Get.find<InviteFriendsController>();
  ChooseLocationController get chooseLocationController =>
      Get.find<ChooseLocationController>();
  YourLikesController get yourLikesController => Get.find<YourLikesController>();

  RxList<UserModel> data = <UserModel>[].obs;
  final List<UserModel> allMatches = [];
  final RxString emptyFeedMessage =
      'No profiles found right now. Pull down to refresh.'.obs;

  final RxInt currentIndex = 0.obs;
  final RxInt selectedImageIndex = 0.obs;

  RxBool isTraveliingPreference = false.obs;
  bool isAlreadyFetching = false;
  RxBool isFirstTimeUser = false.obs;

  TextEditingController replyController = TextEditingController();
  RxString replyText = ''.obs;
  RxString locationNameText = ''.obs;

  String? _cachedIceBreakerUserId;
  List<IceBreakerModel> _cachedIceBreakers = const [];
  bool _iceBreakersFetchStarted = false;

  UserModel? get currentProfile {
    if (data.isEmpty) return null;
    final idx = currentIndex.value % data.length;
    return data[idx];
  }

  Future<String?> locationName(Location? userLocation) async {
    if (userLocation == null ||
        userLocation.latitude == null ||
        userLocation.longitude == null) {
      return null;
    }
    return LocationHelper.getPlaceName(
      latitude: userLocation.latitude ?? 23.3535,
      longitude: userLocation.longitude ?? 85.1235,
    );
  }

  Future<void> loadLocationName(Location? userLocation) async {
    final name = await locationName(userLocation);
    locationNameText.value = name ?? '';
  }

  String getLocationDifference(Location? userLocation) {
    try {
      final currentUser = globalService.getUserModel();
      if (currentUser == null) return '';

      final myLocation = currentUser.location;
      final otherLocation = userLocation;

      if (myLocation == null ||
          otherLocation == null ||
          myLocation.latitude == null ||
          myLocation.longitude == null ||
          otherLocation.latitude == null ||
          otherLocation.longitude == null) {
        return '';
      }

      return LocationHelper.getDistanceText(
        lat1: myLocation.latitude!,
        lon1: myLocation.longitude!,
        lat2: otherLocation.latitude!,
        lon2: otherLocation.longitude!,
      );
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
      return '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  void fetchInitialData() {
    if (isAlreadyFetching) return;
    isAlreadyFetching = true;
    unawaited(loadPosts());
    _scheduleBackgroundWarmup();
  }

  /// Loads match feed first, then warms up other tabs in the background so
  /// the home screen stays responsive on first paint.
  void _scheduleBackgroundWarmup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(getPrefrencesfromApi());
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!isClosed) {
        unawaited(editController.fetchIceBreakers(showError: false));
        unawaited(
          profileDisplayController.fetchUserProfile(isWithoutLoading: true),
        );
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) {
        unawaited(yourLikesController.getPendingLikes(showError: false));
        unawaited(inviteFriendsController.fetchReferralOverview());
        unawaited(chatListController.getChatList());
        unawaited(chatListController.connect());
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (!isClosed && Get.isRegistered<ChooseLocationController>()) {
        unawaited(chooseLocationController.initialize());
      }
    });
  }

  void clearIceBreakerCache() {
    _cachedIceBreakerUserId = null;
    _cachedIceBreakers = const [];
  }

  void prefetchCurrentProfileImages() {
    if (data.isEmpty) return;

    final profile = data[currentIndex.value];
    final urls = (profile.photos ?? const <String>[])
        .where(Base64OrNetworkImage.isNetworkUrl);

    final context = Get.context;
    final size = context != null ? MediaQuery.sizeOf(context) : null;

    Base64OrNetworkImage.prefetchUrls(
      context,
      urls,
      width: size?.width,
      height: size != null ? size.height * 0.82 : null,
    );
  }

  void prefetchImagesAroundIndex(int index, {int profileCount = 2}) {
    if (data.isEmpty) return;

    final context = Get.context;
    final size = context != null ? MediaQuery.sizeOf(context) : null;
    final cardWidth = size?.width;
    final cardHeight = size != null ? size.height * 0.82 : null;
    final urls = <String>[];

    for (var offset = 0; offset < profileCount; offset++) {
      final profile = data[(index + offset) % data.length];
      final photos = profile.photos ?? const <String>[];
      for (final photo in photos.take(2)) {
        if (Base64OrNetworkImage.isNetworkUrl(photo)) {
          urls.add(photo);
        }
      }
    }

    Base64OrNetworkImage.prefetchUrls(
      context,
      urls,
      width: cardWidth,
      height: cardHeight,
    );
  }

  List<IceBreakerModel> getIceBreakers(
    String userId,
    List<IceBreakerModel> iceBreakers,
  ) {
    if (iceBreakers.isEmpty) return const [];

    if (_cachedIceBreakerUserId == userId) {
      return _cachedIceBreakers;
    }

    if (editController.iceBreakers.isEmpty) {
      if (!_iceBreakersFetchStarted) {
        _iceBreakersFetchStarted = true;
        unawaited(editController.fetchIceBreakers(showError: false));
      }
      return const [];
    }

    // A prompt the catalogue no longer carries used to throw out of
    // `firstWhere` and take the whole card stack down with it; an answer whose
    // prompt is gone is dropped instead.
    final merged = <IceBreakerModel>[];
    for (final e in iceBreakers.where((e) => e.answer != null)) {
      final match = editController.iceBreakers
          .firstWhereOrNull((i) => i.id != null && i.id == e.id);
      if (match == null) continue;
      merged.add(
        e.copyWith().copyWith(id: e.id, answer: e.answer)
          ..prompt = match.prompt,
      );
    }

    _cachedIceBreakerUserId = userId;
    _cachedIceBreakers = merged;
    return merged;
  }

  @override
  void onClose() {
    replyController.dispose();
    super.onClose();
  }

  Future<void> loadPosts();
  Future<void> getPrefrencesfromApi();

  void resetForNextProfile();
  Future<bool> doLike(String toUserId);
  Future<bool> doUnLike(String toUserId);
  Future<bool> doLikeWithIcePrompt({SendLikeModel? likeModel});
}
