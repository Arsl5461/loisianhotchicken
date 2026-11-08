import '../../../models/user_model.dart';
import 'comment_model.dart';

class TravelPostModel {
  String? id;
  UserModel? user;

  /// backend sends array
  List<String>? imageUrls;

  /// convenience (first image)
  String? imageUrl;

  String? caption;
  String? city;
  String? country;
  String? cityId;
  String? songUrl;

  Location? location;

  /// arrays from backend
  List<String>? likes;
  List<String>? views;
  List<CommentModel>? comments;

  /// counts
  int likesCount;
  int commentsCount;
  int viewsCount;

  DateTime? createdAt;

  TravelPostModel({
    this.id,
    this.user,
    this.songUrl,
    this.imageUrls,
    this.imageUrl,
    this.caption,
    this.city,
    this.country,
    this.cityId,
    this.location,
    this.likes,
    this.comments,
    this.views,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    this.createdAt,
  });

  factory TravelPostModel.fromJson(Map<String, dynamic> json) {
    final commentsList =
        (json['comments'] as List?)
            ?.map((e) => CommentModel.fromJson(e))
            .toList() ??
        [];
    final urls =
        (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final likesList =
        (json['likes'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final viewsList =
        (json['views'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return TravelPostModel(
      songUrl: json['songUrl']?.toString(),
      id: json['_id']?.toString(),

      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,

      imageUrls: urls,

      /// fallback support if backend returns single imageUrl
      imageUrl: urls.isNotEmpty ? urls.first : json['imageUrl']?.toString(),

      caption: json['caption']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      cityId: json['cityId']?.toString(),

      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,

      likes: likesList,
      views: viewsList,

      likesCount: json['likesCount'] ?? likesList.length,
      commentsCount: json['commentsCount'] ?? 0,
      viewsCount: viewsList.length,

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songUrl': songUrl,
      'comments': comments?.map((e) => e.toJson()).toList(),
      '_id': id,
      'user': user?.toJson(),
      'imageUrls': imageUrls,
      'imageUrl': imageUrl,
      'caption': caption,
      'city': city,
      'country': country,
      'cityId': cityId,
      'location': location?.toJson(),
      'likes': likes,
      'views': views,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'viewsCount': viewsCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class Location {
  String? type; // usually "Point"
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}
