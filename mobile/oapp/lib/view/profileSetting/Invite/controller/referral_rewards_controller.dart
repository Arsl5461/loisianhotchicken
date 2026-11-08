import 'package:OApp/data/repositories/referral_repository.dart';
import 'package:OApp/models/referral_reward_model.dart';
import 'package:OApp/utils/toast.dart';
import 'package:OApp/view/messages/controller/chat_list_controller.dart';
import 'package:OApp/view/profileSetting/Invite/controller/invite_friends_controller.dart';
import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:get/get.dart';

class ReferralRewardsController extends GetxController {
  final ReferralRepository _referralRepo = Get.find<ReferralRepository>();

  final RxBool isLoadingClaimable = false.obs;
  final RxBool isLoadingAllRewards = false.obs;
  final RxString claimableErrorMessage = ''.obs;
  final RxString allRewardsErrorMessage = ''.obs;
  final RxList<ReferralRewardModel> claimableRewards =
      <ReferralRewardModel>[].obs;
  final RxList<ReferralRewardModel> allRewards = <ReferralRewardModel>[].obs;
  final RxString claimingRewardId = ''.obs;

  ProfileDisplayController? get profileDisplayController =>
      Get.isRegistered<ProfileDisplayController>()
      ? Get.find<ProfileDisplayController>()
      : null;
  ChatListController? get chatListController =>
      Get.isRegistered<ChatListController>()
      ? Get.find<ChatListController>()
      : null;
  InviteFriendsController? get inviteFriendsController =>
      Get.isRegistered<InviteFriendsController>()
      ? Get.find<InviteFriendsController>()
      : null;

  @override
  void onInit() {
    super.onInit();
    refreshRewards();
  }

  Future<void> refreshRewards() async {
    await Future.wait([fetchClaimableRewards(), fetchAllRewards()]);
  }

  Future<void> fetchClaimableRewards() async {
    isLoadingClaimable.value = true;
    claimableErrorMessage.value = '';

    try {
      final rewards = await _referralRepo.fetchRewards(claimableOnly: true);

      if (rewards != null) {
        claimableRewards.assignAll(rewards);
      } else {
        claimableRewards.clear();
        claimableErrorMessage.value = 'Failed to load claimable rewards';
      }
    } catch (_) {
      claimableRewards.clear();
      claimableErrorMessage.value =
          'Something went wrong while loading claimable rewards.';
    } finally {
      isLoadingClaimable.value = false;
    }
  }

  Future<void> fetchAllRewards() async {
    isLoadingAllRewards.value = true;
    allRewardsErrorMessage.value = '';

    try {
      final rewards = await _referralRepo.fetchRewards();

      if (rewards != null) {
        allRewards.assignAll(rewards);
      } else {
        allRewards.clear();
        allRewardsErrorMessage.value = 'Failed to load rewards';
      }
    } catch (_) {
      allRewards.clear();
      allRewardsErrorMessage.value =
          'Something went wrong while loading rewards.';
    } finally {
      isLoadingAllRewards.value = false;
    }
  }

  Future<void> claimReward(ReferralRewardModel reward) async {
    if (!reward.isClaimable || !reward.claimSupported || reward.id.isEmpty) {
      Toast.error('This reward cannot be claimed right now');
      return;
    }

    claimingRewardId.value = reward.id;
    try {
      final claimResponse = await _referralRepo.claimReward(reward.id);

      if (claimResponse != null) {
        final subscription = claimResponse.data.subscription;
        if (subscription != null) {
          profileDisplayController?.updateLocalSubscription(subscription);
          chatListController?.refreshChatList();
        }

        Toast.success(claimResponse.message);
        await refreshRewards();
        await inviteFriendsController?.fetchReferralOverview();
      } else {
        Toast.error('Failed to claim reward');
      }
    } catch (_) {
      Toast.error('Something went wrong while claiming reward.');
    } finally {
      claimingRewardId.value = '';
    }
  }

  int get claimedRewardsCount =>
      allRewards.where((reward) => reward.claimedAt != null).length;

  int get unlockedRewardsCount => allRewards
      .where((reward) => reward.status.toLowerCase() == 'unlocked')
      .length;

  bool isClaiming(String rewardId) => claimingRewardId.value == rewardId;
}
