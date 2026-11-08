import 'package:OApp/models/user_model.dart';

class ReferralRewardModel {
  final String id;
  final String ruleId;
  final String ruleName;
  final String rewardType;
  final RewardValueModel? rewardValue;
  final String status;
  final bool isClaimable;
  final bool claimSupported;
  final String unlockedAt;
  final String? claimedAt;
  final List<UserModel> users;

  ReferralRewardModel({
    required this.id,
    required this.ruleId,
    required this.ruleName,
    required this.rewardType,
    required this.rewardValue,
    required this.status,
    required this.isClaimable,
    required this.claimSupported,
    required this.unlockedAt,
    required this.claimedAt,
    required this.users,
  });

  factory ReferralRewardModel.fromJson(Map<String, dynamic> json) {
    return ReferralRewardModel(
      id: json['_id'] as String? ?? '',
      ruleId: json['ruleId'] as String? ?? '',
      ruleName: json['ruleName'] as String? ?? '',
      rewardType: json['rewardType'] as String? ?? '',
      rewardValue: json['rewardValue'] is Map<String, dynamic>
          ? RewardValueModel.fromJson(
              json['rewardValue'] as Map<String, dynamic>,
            )
          : null,
      status: json['status'] as String? ?? '',
      isClaimable: json['isClaimable'] as bool? ?? false,
      claimSupported: json['claimSupported'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] as String? ?? '',
      claimedAt: json['claimedAt'] as String?,
      users: (json['users'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(UserModel.fromJson)
          .toList(),
    );
  }
}

class RewardValueModel {
  final int durationDays;

  RewardValueModel({required this.durationDays});

  factory RewardValueModel.fromJson(Map<String, dynamic> json) {
    return RewardValueModel(durationDays: _toInt(json['durationDays']));
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
