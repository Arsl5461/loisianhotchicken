import 'package:OApp/models/pending_likes_model.dart';
import 'package:get/get.dart';

import '../../data/repositories/home_repository.dart';
import '../../services/dailog_service.dart';
import 'home_controller_base.dart';

mixin HomeMatchesMixin on HomeControllerBase {
  @override
  Future<void> loadPosts() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final feed = await homeRepository.fetchMatches();

      if (feed.matches.isNotEmpty) {
        allMatches
          ..clear()
          ..addAll(feed.matches);

        data.assignAll(feed.matches);
        currentIndex.value = 0;
        emptyFeedMessage.value =
            'No profiles found right now. Pull down to refresh.';
        resetForNextProfile();
        prefetchImagesAroundIndex(0, profileCount: 3);
      } else {
        emptyFeedMessage.value = feed.emptyMessage;
      }
    } catch (e) {
      // Keep UI responsive when match loading fails.
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<bool> doLike(String toUserId) async {
    try {
      final result = await homeRepository.likeUser(toUserId);
      showOutOfLikesDialogIfNeeded(result);
      return result.isSuccess;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> doUnLike(String toUserId) async {
    try {
      final result = await homeRepository.unlikeUser(toUserId);
      showOutOfLikesDialogIfNeeded(result);
      return result.isSuccess;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> doLikeWithIcePrompt({SendLikeModel? likeModel}) async {
    try {
      if (likeModel == null) return false;

      final result = await homeRepository.likeWithPayload(likeModel);

      replyText.value = '';
      replyController.clear();

      return result.isSuccess;
    } catch (_) {
      return false;
    }
  }

  void showOutOfLikesDialogIfNeeded(MatchActionResult result) {
    if (!result.isForbidden) return;

    dialogService.showAppDialog(
      message: DialogMessage(
        title: 'Out of likes',
        subheading:
            'Upgrade to a premium membership for unlimited access and additional perks.',
        okText: 'Upgrade',
      ),
      primaryResult: true,
    );
  }
}
