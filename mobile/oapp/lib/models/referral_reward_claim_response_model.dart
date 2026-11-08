import 'package:OApp/models/user_model.dart';

class ReferralRewardClaimResponseModel {
  final bool success;
  final String message;
  final ReferralRewardClaimData data;

  ReferralRewardClaimResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReferralRewardClaimResponseModel.fromJson(Map<String, dynamic> json) {
    return ReferralRewardClaimResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: ReferralRewardClaimData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }
}

class ReferralRewardClaimData {
  final ClaimedReferralRewardModel? reward;
  final Subscription? subscription;

  ReferralRewardClaimData({
    required this.reward,
    required this.subscription,
  });

  factory ReferralRewardClaimData.fromJson(Map<String, dynamic> json) {
    return ReferralRewardClaimData(
      reward: json['reward'] is Map<String, dynamic>
          ? ClaimedReferralRewardModel.fromJson(
              json['reward'] as Map<String, dynamic>,
            )
          : null,
      subscription: json['subscription'] is Map<String, dynamic>
          ? Subscription.fromJson(
              json['subscription'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ClaimedReferralRewardModel {
  final String id;
  final String status;
  final String? claimedAt;
  final ClaimedRewardContextModel? claimContext;

  ClaimedReferralRewardModel({
    required this.id,
    required this.status,
    required this.claimedAt,
    required this.claimContext,
  });

  factory ClaimedReferralRewardModel.fromJson(Map<String, dynamic> json) {
    return ClaimedReferralRewardModel(
      id: json['_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      claimedAt: json['claimedAt'] as String?,
      claimContext: json['claimContext'] is Map<String, dynamic>
          ? ClaimedRewardContextModel.fromJson(
              json['claimContext'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ClaimedRewardContextModel {
  final String appliedSubscriptionTier;
  final int durationDays;
  final String appliedFrom;
  final String appliedUntil;

  ClaimedRewardContextModel({
    required this.appliedSubscriptionTier,
    required this.durationDays,
    required this.appliedFrom,
    required this.appliedUntil,
  });

  factory ClaimedRewardContextModel.fromJson(Map<String, dynamic> json) {
    return ClaimedRewardContextModel(
      appliedSubscriptionTier:
          json['appliedSubscriptionTier'] as String? ?? '',
      durationDays: _toInt(json['durationDays']),
      appliedFrom: json['appliedFrom'] as String? ?? '',
      appliedUntil: json['appliedUntil'] as String? ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
