import 'package:OApp/config/app_config.dart';

class ReferralOverviewModel {
  final bool success;
  final String message;
  final ReferralOverviewData data;

  ReferralOverviewModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReferralOverviewModel.fromJson(Map<String, dynamic> json) {
    return ReferralOverviewModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: ReferralOverviewData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }
}

class ReferralOverviewData {
  final String referralCode;
  final List<String> referredUserIds;
  final int referredUsersCount;
  final ReferralStatsModel stats;

  ReferralOverviewData({
    required this.referralCode,
    required this.referredUserIds,
    required this.referredUsersCount,
    required this.stats,
  });

  factory ReferralOverviewData.fromJson(Map<String, dynamic> json) {
    final referredUserIds = _toStringList(json['referredUserIds']);
    final referredUsersCount = ReferralStatsModel._toInt(
      json['referredUsersCount'],
    );

    return ReferralOverviewData(
      referralCode: json['referralCode'] as String? ?? '',
      referredUserIds: referredUserIds,
      referredUsersCount: referredUsersCount > 0
          ? referredUsersCount
          : referredUserIds.length,
      stats: ReferralStatsModel.fromJson(
        (json['stats'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  String get shareableReferralLink {
    if (referralCode.trim().isEmpty) {
      return '';
    }

    final baseUri = Uri.parse(AppConfig.baseUrl);
    return baseUri
        .replace(
          path: '/option-screen',
          queryParameters: {'ref': referralCode},
        )
        .toString();
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .toList();
  }
}

class ReferralStatsModel {
  final int totalReferrals;
  final int successfulReferrals;
  final int claimableRewards;
  final int claimedRewards;

  ReferralStatsModel({
    required this.totalReferrals,
    required this.successfulReferrals,
    required this.claimableRewards,
    required this.claimedRewards,
  });

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatsModel(
      totalReferrals: _toInt(json['totalReferrals']),
      successfulReferrals: _toInt(json['successfulReferrals']),
      claimableRewards: _toInt(json['claimableRewards']),
      claimedRewards: _toInt(json['claimedRewards']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
