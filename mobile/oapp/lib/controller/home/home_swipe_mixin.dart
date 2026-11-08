import 'dart:async';

import 'package:OApp/models/pending_likes_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller_base.dart';

mixin HomeSwipeMixin on HomeControllerBase {
  final RxBool isSwipeInProgress = false.obs;
  final RxBool isSwipeLeft = false.obs;
  final RxDouble swipeProgress = 0.0.obs;
  final RxBool showSwipeFeedback = false.obs;
  final RxDouble totalSwipeDistance = 0.0.obs;

  final double swipeThreshold = 20.0;

  late final AnimationController swipeController;
  late final Animation<double> swipeAnimation;

  void initSwipeAnimations(TickerProvider vsync) {
    swipeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    swipeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: swipeController, curve: Curves.easeOut),
    );
  }

  void disposeSwipeAnimations() {
    swipeController.dispose();
  }

  Future<void> runSwipeAnimation({required bool isLeft}) async {
    await swipeController.forward();
    swipeController.reset();
  }

  @override
  void resetForNextProfile() {
    clearIceBreakerCache();
    selectedImageIndex.value = 0;
    if (data.isNotEmpty) {
      final profile = data[currentIndex.value];
      locationNameText.value = profile.hometown ?? '';
      unawaited(loadLocationName(profile.location));
      prefetchCurrentProfileImages();
    } else {
      locationNameText.value = '';
    }
    showSwipeFeedback.value = false;
    swipeProgress.value = 0;
    totalSwipeDistance.value = 0;
  }

  void goNextProfile() {
    if (data.isEmpty) return;
    currentIndex.value = (currentIndex.value + 1) % data.length;
    resetForNextProfile();
    prefetchImagesAroundIndex(currentIndex.value, profileCount: 2);
  }

  void scrollToTop() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onImageSelected(int idx) {
    selectedImageIndex.value = idx;
  }

  void onPanStart() {
    showSwipeFeedback.value = true;
    swipeProgress.value = 0;
    totalSwipeDistance.value = 0;
  }

  void onPanUpdate(double deltaDx, double screenWidth) {
    totalSwipeDistance.value += deltaDx;
    swipeProgress.value = (totalSwipeDistance.value / screenWidth).clamp(
      -1.0,
      1.0,
    );
  }

  void onPanEnd({
    required double velocityDx,
    required Future<void> Function({required bool isLeft}) runSwipeAnimation,
  }) {
    final totalDistance = totalSwipeDistance.value.abs();
    final isRightSwipe = velocityDx > 0 || totalSwipeDistance.value > 0;

    showSwipeFeedback.value = false;
    swipeProgress.value = 0;
    totalSwipeDistance.value = 0;

    if (totalDistance > swipeThreshold || velocityDx.abs() > 500) {
      if (isRightSwipe) {
        unawaited(swipeRight(runSwipeAnimation));
      } else {
        unawaited(swipeLeft(runSwipeAnimation));
      }
    }
  }

  Future<void> swipeLeft(
    Future<void> Function({required bool isLeft}) animate,
  ) async {
    if (isSwipeInProgress.value) return;

    final user = currentProfile;
    if (user == null || user.id == null) return;

    isSwipeInProgress.value = true;
    isSwipeLeft.value = true;

    unawaited(doUnLike(user.id!));

    await animate(isLeft: true);
    goNextProfile();

    isSwipeInProgress.value = false;
    isSwipeLeft.value = false;
  }

  Future<void> swipeRight(
    Future<void> Function({required bool isLeft}) animate,
  ) async {
    if (isSwipeInProgress.value) return;

    final user = currentProfile;
    if (user == null || user.id == null) return;

    isSwipeInProgress.value = true;
    isSwipeLeft.value = false;

    unawaited(doLike(user.id!));

    await animate(isLeft: false);
    goNextProfile();

    isSwipeInProgress.value = false;
  }

  Future<void> swipeRightWithIceReply(
    String? toUserId,
    String? reply,
    String? icebreakerid,
    Future<void> Function({required bool isLeft}) animate,
  ) async {
    if (isSwipeInProgress.value) return;

    final user = currentProfile;
    if (user == null || user.id == null) return;

    isSwipeInProgress.value = true;
    isSwipeLeft.value = false;

    unawaited(
      doLikeWithIcePrompt(
        likeModel: SendLikeModel(
          toUserId: toUserId ?? '',
          reply: replyText.value,
          icebreakerId: icebreakerid ?? '',
          comment: null,
          isReply: true,
          isComment: false,
        ),
      ),
    );

    await animate(isLeft: false);
    goNextProfile();
    scrollToTop();
    isSwipeInProgress.value = false;
  }

  Future<void> swipeRightWithComment(
    String? toUserId,
    String? comment,
    Future<void> Function({required bool isLeft}) animate,
  ) async {
    if (isSwipeInProgress.value) return;

    final user = currentProfile;
    if (user == null || user.id == null) return;

    isSwipeInProgress.value = true;
    isSwipeLeft.value = false;

    unawaited(
      doLikeWithIcePrompt(
        likeModel: SendLikeModel(
          toUserId: toUserId ?? '',
          comment: replyText.value,
          isReply: false,
          isComment: true,
        ),
      ),
    );

    await animate(isLeft: false);
    goNextProfile();
    scrollToTop();
    isSwipeInProgress.value = false;
  }

}
