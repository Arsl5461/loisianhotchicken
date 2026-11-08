import 'package:OApp/models/user_model.dart';

class CommentModel {
  final String comment;
  final DateTime dateTime;
  final String id;
  final UserModel? user;

  CommentModel({
    required this.comment,
    required this.dateTime,
    required this.id,
    this.user,
  });

  /// fromJson
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      comment: json['comment'] ?? '',
      dateTime: DateTime.parse(json['dateTime']),
      id: json['_id'] ?? '',
      user: json['user'] is Map<String, dynamic>
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'comment': comment,
      'dateTime': dateTime.toIso8601String(),
      '_id': id,
    };
  }

  /// copyWith
  CommentModel copyWith({
    UserModel? user,
    String? comment,
    DateTime? dateTime,
    String? id,
  }) {
    return CommentModel(
      user: user ?? this.user,
      comment: comment ?? this.comment,
      dateTime: dateTime ?? this.dateTime,
      id: id ?? this.id,
    );
  }
}
