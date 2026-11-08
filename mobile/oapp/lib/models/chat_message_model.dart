import 'package:OApp/models/user_model.dart';

import 'pending_likes_model.dart';

enum MessageType { text, initiatedChat, video, audio, system }

class ChatMessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final MessageType chatType;
  SendLikeModel? initiatedFromLike;

  ChatMessageModel({
    this.chatType = MessageType.text,
    this.initiatedFromLike,
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final int chatTypeIndex = json['chat_type'] ?? 0;

    return ChatMessageModel(
      initiatedFromLike: json['initiatedFromLike'] != null
          ? SendLikeModel.fromJson(json['initiatedFromLike'])
          : null,
      chatType:
          (chatTypeIndex >= 0 && chatTypeIndex < MessageType.values.length)
          ? MessageType.values[chatTypeIndex]
          : MessageType.text,
      id: json['_id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'chat_type': chatType.index,
    };
  }

  static DateTime _parseTimestamp(dynamic rawTimestamp) {
    if (rawTimestamp is DateTime) {
      return rawTimestamp;
    }

    if (rawTimestamp is String) {
      return DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    }

    if (rawTimestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    }

    if (rawTimestamp is Map<String, dynamic>) {
      final milliseconds = rawTimestamp['\$date'];
      if (milliseconds is int) {
        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      }
    }

    return DateTime.now();
  }
}

class CursorModel {
  final DateTime? nextCursor;
  final bool hasMore;
  String? nextId;

  CursorModel({this.nextCursor, required this.hasMore, this.nextId});

  factory CursorModel.fromJson(Map<String, dynamic> json) {
    return CursorModel(
      nextCursor: json['nextCursor'] != null
          ? DateTime.tryParse(json['nextCursor'])
          : null,
      hasMore: json['hasMore'] ?? false,
      nextId: json['nextId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nextCursor': nextCursor?.toIso8601String(),
      'hasMore': hasMore,
      'nextId': nextId,
    };
  }
}

class ChatHistoryResponse {
  final List<ChatMessageModel> messages;
  final CursorModel? cursor;
  final UserModel? user;
  final String? matchId;

  ChatHistoryResponse({
    this.user,
    required this.messages,
    this.cursor,
    this.matchId,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['messages'] ?? [];
    final messages = data.map((e) => ChatMessageModel.fromJson(e)).toList();
    final cursor = json['cursor'] != null
        ? CursorModel.fromJson(json['cursor'])
        : null;
    final user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    final matchId = json['matchId'];

    return ChatHistoryResponse(
      user: user,
      messages: messages,
      cursor: cursor,
      matchId: matchId,
    );
  }
}
