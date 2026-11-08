import '../../../models/pending_likes_model.dart';
import '../../../models/user_model.dart';

class ChatHistoryModel {
  final String matchId;
  final UserModel user;
  final List<MessageModel> messages;

  ChatHistoryModel({
    required this.matchId,
    required this.user,
    required this.messages,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      matchId: json['matchId'] ?? '',
      user: UserModel.fromJson(json['user']),
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "matchId": matchId,
      "user": user.toJson(),
      "messages": messages.map((e) => e.toJson()).toList(),
    };
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isRead;
  final String timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "isRead": isRead,
      "timestamp": timestamp,
    };
  }
}

class MatchModel {
  final String matchId;
  final String matchedAt;
  final String userId;
  final UserModel user;
  final List<String> isArchived;
  final SendLikeModel? initiatedFromLike;
  bool isReported;

  MatchModel({
    this.isReported = false,
    this.initiatedFromLike,
    required this.matchId,
    required this.matchedAt,
    required this.userId,
    required this.user,
    required this.isArchived,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      isReported: json['isReported'] ?? false,
      matchId: json['matchId']?.toString() ?? '',
      matchedAt: json['matchedAt']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      isArchived: List<String>.from(json['isArchived'] ?? []),
      initiatedFromLike: json['initiatedFromLike'] != null
          ? SendLikeModel.fromJson(json['initiatedFromLike'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isReported': isReported,
      'matchId': matchId,
      'matchedAt': matchedAt,
      'userId': userId,
      'user': user.toJson(),
      'isArchived': isArchived,
      'initiatedFromLike': initiatedFromLike?.toJson(),
    };
  }

  MatchModel copyWith({
    bool? isReported,
    String? matchId,
    String? matchedAt,
    String? userId,
    UserModel? user,
    List<String>? isArchived,
  }) {
    return MatchModel(
      isReported: isReported ?? this.isReported,
      matchId: matchId ?? this.matchId,
      matchedAt: matchedAt ?? this.matchedAt,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
