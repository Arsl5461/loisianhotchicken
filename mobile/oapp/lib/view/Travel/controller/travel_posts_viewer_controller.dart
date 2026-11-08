import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../services/global_service.dart';
import '../../../utils/toast.dart';
import '../../../widget_helper/widget_helpers.dart';
import '../choose_location_controller.dart';
import '../models/travel_post_model.dart';

class TravelPostsViewerController extends GetxController {
  final AudioPlayer _player = AudioPlayer();

  TravelPostsViewerController({
    required GlobalService globalService,
    required ChooseLocationController chooseLocationController,
  }) : _globalService = globalService,
       _chooseLocationController = chooseLocationController;

  final GlobalService _globalService;
  final ChooseLocationController _chooseLocationController;

  final RxString currentUserId = ''.obs;
  final RxList<TravelPostModel> posts = <TravelPostModel>[].obs;
  final RxBool isOwner = true.obs;
  final RxBool isReady = false.obs;
  final Rx<AudioStatus> audioStatus = AudioStatus.idle.obs;

  // UI state
  final PageController pageController = PageController();
  final TextEditingController replyController = TextEditingController();

  final RxInt currentPostIndex = 0.obs;
  final RxnInt replyingPostIndex = RxnInt();

  final RxList<bool> likedPosts = <bool>[].obs;
  final RxList<int> likesCount = <int>[].obs;

  final Map<int, PageController> imageControllers = {};
  final Map<int, RxInt> imageIndexes = {};

  @override
  Future<void> onInit() async {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      final routePosts = args['posts'];
      final routeIsOwner = args['isOwner'];

      if (routePosts is List<TravelPostModel>) {
        posts.assignAll(routePosts);
      } else if (routePosts is List) {
        posts.assignAll(routePosts.whereType<TravelPostModel>());
      }

      if (routeIsOwner is bool) {
        isOwner.value = routeIsOwner;
      }
    }

    currentUserId.value = await _globalService.getUserId() ?? '';

    _initializeLocalState();

    if (!isOwner.value && posts.isNotEmpty) {
      unawaited(_chooseLocationController.sendView(posts));
    }

    isReady.value = true;
  }

  void _initializeLocalState() {
    likedPosts.assignAll(
      posts.map((post) => post.likes?.contains(currentUserId.value) ?? false),
    );

    likesCount.assignAll(
      posts.map((post) => post.likes?.length ?? post.likesCount),
    );
  }

  PageController getImageController(int postIndex) {
    return imageControllers.putIfAbsent(postIndex, () => PageController());
  }

  RxInt getImageIndex(int postIndex) {
    return imageIndexes.putIfAbsent(postIndex, () => 0.obs);
  }

  void onPostChanged(int index) {
    currentPostIndex.value = index;
    replyingPostIndex.value = null;
    replyController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onImageChanged(int postIndex, int imageIndex) {
    getImageIndex(postIndex).value = imageIndex;
  }

  void toggleLike(int index) {
    if (index < 0 || index >= posts.length) return;

    final post = posts[index];

    if (likedPosts[index]) {
      likedPosts[index] = false;
      likesCount[index] = likesCount[index] > 0 ? likesCount[index] - 1 : 0;
      onUnlike(post);
    } else {
      likedPosts[index] = true;
      likesCount[index] = likesCount[index] + 1;
      onLike(post);
    }

    likedPosts.refresh();
    likesCount.refresh();
  }

  void toggleReplyField(int index) {
    if (replyingPostIndex.value == index) {
      replyingPostIndex.value = null;
      replyController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      replyingPostIndex.value = index;
      replyController.clear();
    }
  }

  void sendReply() {
    final text = replyController.text.trim();
    if (text.isEmpty) return;

    onReply(text);

    replyController.clear();
    replyingPostIndex.value = null;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String extractSongName(String url) {
    // Decode URL
    String decoded = Uri.decodeFull(url);

    // Get file name
    String fileName = decoded.split('/').last;

    // Split using "-"
    String name = fileName.split('-').first;

    return name;
  }

  Future<void> toggleState(String url) async {
    try {
      switch (audioStatus.value) {
        case AudioStatus.idle:
          debugPrint("url to play: $url");
          if (url.isNotEmpty) {
            audioStatus.value = AudioStatus.playing;
            await _player.setUrl(url);
            await _player.play();
          }
          break;
        case AudioStatus.loading:
          await _player.pause();
          audioStatus.value = AudioStatus.idle;

          break;
        case AudioStatus.playing:
          await _player.pause();
          audioStatus.value = AudioStatus.idle;
          break;
        case AudioStatus.error:
          await _player.pause();
          audioStatus.value = AudioStatus.idle;

          Toast.error("Error playing music");
          break;
      }
    } catch (e) {
      debugPrint("Error playing music: $e");
      audioStatus.value = AudioStatus.error;
    }
  }

  void stopAudio() {
    if (audioStatus.value == AudioStatus.playing) {
      _player.stop();
      audioStatus.value = AudioStatus.idle;
    }
  }

  void onLikeView(TravelPostModel post) {
    unawaited(
      _chooseLocationController.getUsersViews(post.likes ?? [], 'Likes'),
    );
  }

  void onToggleMusic(TravelPostModel post) {
    if (post.songUrl != null && post.songUrl!.isNotEmpty) {
      unawaited(toggleState(post.songUrl!));
    }
  }

  void onViewsView(TravelPostModel post) {
    unawaited(
      _chooseLocationController.getUsersViews(post.views ?? [], 'Views'),
    );
  }

  void onLike(TravelPostModel post) {
    unawaited(_chooseLocationController.setLike(posts));
  }

  void onUnlike(TravelPostModel post) {
    unawaited(_chooseLocationController.setLike(posts));
  }

  void onRepliesView(TravelPostModel post) {
    unawaited(_chooseLocationController.getReplies(posts, ''));
  }

  void onReply(String value) {
    unawaited(_chooseLocationController.sendReply(posts, value));
  }

  @override
  void onClose() {
    for (final controller in imageControllers.values) {
      controller.dispose();
    }
    pageController.dispose();
    replyController.dispose();
    _player.dispose();
    super.onClose();
  }
}
