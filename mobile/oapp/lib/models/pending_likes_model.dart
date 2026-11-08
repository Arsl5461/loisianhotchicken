import 'package:OApp/models/user_model.dart';

import '../view/profileSetting/models/ice_breaker_model.dart';

class PendingLikesModel {
  final int count;
  final List<LikeItemModel> likes;

  PendingLikesModel({required this.count, required this.likes});

  factory PendingLikesModel.fromJson(Map<String, dynamic> json) {
    return PendingLikesModel(
      count: json['count'] ?? 0,
      likes: (json['likes'] as List<dynamic>? ?? [])
          .map((e) => LikeItemModel.fromJson(e))
          .toList(),
    );
  }
}

class LikeItemModel {
  final SendLikeModel? initiatedFromLike;
  final UserModel? user;

  LikeItemModel({this.initiatedFromLike, this.user});

  factory LikeItemModel.fromJson(Map<String, dynamic> json) {
    return LikeItemModel(
      initiatedFromLike: json['initiatedFromLike'] != null
          ? SendLikeModel.fromJson(json['initiatedFromLike'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

class SendLikeModel {
  final String? toUserId;
  final String? comment;
  final bool? isLike;
  final bool? isComment;
  final bool? isReply;
  final String? icebreakerId;
  final String? reply;
  final IceBreakerModel? icebreaker;
  final String? toUserIcebreakerAnswer;
  final String? prompt;

  SendLikeModel({
    this.prompt,
    this.toUserIcebreakerAnswer,
    this.toUserId,
    this.comment,
    this.isLike,
    this.isComment,
    this.isReply,
    this.icebreakerId,
    this.reply,
    this.icebreaker,
  });

  // FROM JSON
  factory SendLikeModel.fromJson(Map<String, dynamic> json) {
    return SendLikeModel(
      toUserId: json['toUserId'],
      comment: json['comment'],
      isLike: json['isLike'],
      isComment: json['isComment'],
      isReply: json['isReply'],
      icebreakerId: json['icebreakerId'],
      reply: json['reply'],
      toUserIcebreakerAnswer: json['toUserIcebreakerAnswer'],
      icebreaker: json['icebreaker'] != null
          ? IceBreakerModel.fromJson(json['icebreaker'])
          : null,
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'toUserIcebreakerAnswer': toUserIcebreakerAnswer,
      'icebreaker': icebreaker?.toJson(),
      'toUserId': toUserId,
      'comment': comment,
      'isLike': isLike,
      'isComment': isComment,
      'isReply': isReply,
      'icebreakerid': icebreakerId,
      'reply': reply,
    };
  }

  // COPY WITH
  SendLikeModel copyWith({
    String? prompt,
    String? toUserId,
    String? toUserIcebreakerAnswer,
    String? comment,
    bool? isLike,
    bool? isComment,
    bool? isReply,
    String? icebreakerId,
    String? reply,
    IceBreakerModel? icebreaker,
  }) {
    return SendLikeModel(
      prompt: prompt ?? this.prompt,
      toUserIcebreakerAnswer:
          toUserIcebreakerAnswer ?? this.toUserIcebreakerAnswer,
      toUserId: toUserId ?? this.toUserId,
      comment: comment ?? this.comment,
      isLike: isLike ?? this.isLike,
      isComment: isComment ?? this.isComment,
      isReply: isReply ?? this.isReply,
      icebreakerId: icebreakerId ?? this.icebreakerId,
      reply: reply ?? this.reply,
      icebreaker: icebreaker ?? this.icebreaker,
    );
  }
}
