import 'dart:async';

import 'package:OApp/data/repositories/home_repository.dart';
import 'package:OApp/models/pending_likes_model.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/routing/app_routes.dart';
import '../utils/toast.dart';
import '../view/Dashboard/dashboard_controller.dart';
import '../widget_helper/loading_helper.dart';

class YourLikesController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  // UI/state
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;
  RxString messageText = ''.obs;
  // Data
  final RxList<LikeItemModel> pendingLikes = <LikeItemModel>[].obs;
  final RxList<LikeItemModel> expiredLikes =
      <LikeItemModel>[].obs; // keep for future

  // Modal / message state
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    onrefresh();
    super.onInit();
  }

  Future<void> onrefresh() async {
    unawaited(getPendingLikes());
    unawaited(getLikeByStatus("expired"));
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  // --------------------------
  // Screen logic (moved here)
  // --------------------------

  void setTab(int index) {
    selectedTabIndex.value = index;
  }

  /// Your Likes is a dashboard tab, not a pushed route — switch to Home to swipe.
  void goToHomeTab() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().changeIndex(0);
    }
  }

  int calculateAge(String? dob) {
    if (dob == null) return 0;
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  void _prefetchLikePhotos(Iterable<LikeItemModel> likes) {
    final urls = likes
        .map((like) => like.user?.photos?.firstOrNull ?? '')
        .where(Base64OrNetworkImage.isNetworkUrl);
    Base64OrNetworkImage.prefetchUrls(Get.context, urls);
  }

  void openLikeModal(UserModel profile) {
    messageController.clear();

    // Uses Get.dialog so UI doesn't need to pass BuildContext.
    // Your screen will provide the dialog widget (you'll do that next).
    // We keep opening/closing logic here.
    // Example usage from view: controller.openLikeModal(profile); then build dialog with Get.dialog(...)
    //
    // Since you asked controller-first, I’m leaving the actual dialog widget creation to the screen.
  }

  void closeModal() {
    messageController.clear();
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  Future<bool> createMatch(UserModel profile) async {
    final result = await _homeRepository.createMatch(profile.id ?? '');

    if (result.isSuccess) {
      return true;
    }

    Toast.error(
      result.errorMessage ?? 'Failed to create match. Please try again later.',
    );
    return false;
  }

  void goToConversation({required UserModel profile, String? message}) async {
    CallLoadingHelper.show(text: "Creating match...");

    try {
      var matchCreated = await createMatch(profile);
      messageController.clear();
      if (!matchCreated) {
        return;
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      CallLoadingHelper.hide(); // ✅ always close before navigate
    }
    // Navigate first
    Get.toNamed(
      Routes.CHAT,
      arguments: {
        'targetUserId': profile.id,
        'name': profile.fullName ?? 'Unknown',
        'heroTag': profile.id ?? '',
        'timeLeft': 'Active now',
        'profileImageUrl': profile.photos?.first,
        'message': messageText.value,
      },
    );

    // Ensure controller exists

    messageText.value =
        ''; // Clear after sending to avoid stale data if user goes back to modal
  }

  // --------------------------
  // API
  // --------------------------

  Future<void> getPendingLikes({bool showError = true}) async {
    isLoading.value = true;
    try {
      final data = await _homeRepository.fetchPendingLikes();

      if (data != null) {
        pendingLikes
          ..clear()
          ..addAll(data.likes);
        _prefetchLikePhotos(data.likes);
      } else {
        if (showError) {
          Toast.error('Failed to load pending likes');
        }
      }
    } catch (_) {
      if (showError) {
        Toast.error('Something went wrong. Please try again.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLiveLikes() async {
    isLoading.value = true;
    try {
      final data = await _homeRepository.fetchPendingLikes();

      if (data != null) {
        final filteredLikes = data.likes.where((like) {
          return !pendingLikes.any(
            (pending) => pending.user?.id == like.user?.id,
          );
        }).toList();
        pendingLikes.addAll(filteredLikes);

        // expiredLikes stays for future if your API returns it later
      } else {
        Toast.error('Failed to load pending likes');
      }
    } catch (_) {
      Toast.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLikeByStatus(String status) async {
    isLoading.value = true;
    try {
      final data = await _homeRepository.fetchLikesByStatus(status);

      if (data != null) {
        expiredLikes
          ..clear()
          ..addAll(data.likes);
        _prefetchLikePhotos(data.likes);
      } else {
        Toast.error('Failed to load expired likes');
      }
    } catch (_) {
      Toast.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
