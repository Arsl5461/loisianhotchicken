import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/models/referral_overview_model.dart';
import 'package:OApp/models/referral_reward_claim_response_model.dart';
import 'package:OApp/models/referral_reward_model.dart';
import 'package:get/get.dart';

class ReferralRepository {
  ReferralRepository({NetworkManager? api})
      : _api = api ?? Get.find<NetworkManager>();

  final NetworkManager _api;

  static ReferralOverviewData? parseOverviewResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final overview = ReferralOverviewModel.fromJson(data);
    return overview.data;
  }

  static List<ReferralRewardModel> parseRewardsResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final rewardsList = data['data']?['rewards'];
    if (rewardsList is! List) return [];

    return rewardsList
        .whereType<Map<String, dynamic>>()
        .map(ReferralRewardModel.fromJson)
        .toList();
  }

  static String? parseErrorMessage(dynamic data, {String? fallback}) {
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString() ?? '';
      if (message.isNotEmpty) return message;
    }
    return fallback;
  }

  Future<ReferralOverviewData?> fetchOverview() async {
    final response = await _api.callApi(
      debugNeeded: true,
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.referralOverview,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseOverviewResponse(response!.data);
  }

  Future<List<ReferralRewardModel>?> fetchRewards({
    bool claimableOnly = false,
  }) async {
    final response = await _api.callApi(
      debugNeeded: true,
      method: HttpMethod.Get,
      urlEndPoint: claimableOnly
          ? EndPoints.referralRewardsQuery(claimableOnly: true)
          : EndPoints.referralRewards,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseRewardsResponse(response!.data);
  }

  Future<ReferralRewardClaimResponseModel?> claimReward(String rewardId) async {
    final response = await _api.callApi(
      debugNeeded: true,
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.claimReferralReward(rewardId),
      body: const {},
    );

    if (response?.statusCode != 200 || response?.data is! Map<String, dynamic>) {
      return null;
    }

    return ReferralRewardClaimResponseModel.fromJson(
      response!.data as Map<String, dynamic>,
    );
  }
}
