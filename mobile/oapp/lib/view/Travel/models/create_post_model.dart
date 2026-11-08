import '../../../models/user_model.dart' hide Location;
import 'comment_model.dart';
import 'travel_post_model.dart';

class CreatePostModel {
  final List<String>? imageUrls;
  final String? caption;
  final String? city;
  final String? country;
  final Map<String, double>? location;
  final String? id;
  final String? songUrl;

  CreatePostModel({
    this.imageUrls,
    this.caption,
    this.city,
    this.country,
    this.location,
    this.id,
    this.songUrl,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
      songUrl: json['songUrl']?.toString(),
      id: json['_id']?.toString(),
      imageUrls: (json['imageUrls'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      caption: json['caption']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      location: json['location'] != null
          ? {
              "latitude": (json['location']['latitude'] as num).toDouble(),
              "longitude": (json['location']['longitude'] as num).toDouble(),
            }
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "songUrl": songUrl,
      "imageUrls": imageUrls,
      "caption": caption,
      "city": city,
      "country": country,
      "location": location,
    };
  }
}

class GetPostModel {
  final String? id;
  final List<String>? imageUrls;
  final String? caption;
  final String? city;
  final String? country;
  final String? cityId;
  final String? songUrl;

  final double? latitude;
  final double? longitude;

  final int? likesCount;
  final int? commentsCount;
  final int? viewsCount;

  final DateTime? createdAt;

  final UserModel? user;

  final List<String>? likes;
  final List<String>? views;

  List<CommentModel>? comments;

  GetPostModel({
    this.songUrl,
    this.id,
    this.imageUrls,
    this.caption,
    this.city,
    this.country,
    this.cityId,
    this.latitude,
    this.longitude,
    this.likesCount,
    this.commentsCount,
    this.viewsCount,
    this.createdAt,
    this.user,
    this.likes,
    this.views,
    this.comments,
  });

  factory GetPostModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GetPostModel();

    double? lat;
    double? lng;
    final commentsList =
        (json['comments'] as List?)
            ?.map((e) => CommentModel.fromJson(e))
            .toList() ??
        [];
    if (json['location'] != null && json['location']['coordinates'] != null) {
      final coords = json['location']['coordinates'];
      lng = (coords[0] as num?)?.toDouble();
      lat = (coords[1] as num?)?.toDouble();
    }

    final likesList =
        (json['likes'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final viewsList =
        (json['views'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return GetPostModel(
      id: json['_id']?.toString(),
      songUrl: json['songUrl']?.toString(),
      imageUrls: (json['imageUrls'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      caption: json['caption']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      cityId: json['cityId']?.toString(),

      latitude: lat,
      longitude: lng,

      likes: likesList,
      views: viewsList,

      likesCount: json['likesCount'] ?? likesList.length,
      viewsCount: viewsList.length,

      commentsCount: json['commentsCount'] ?? 0,
      comments: commentsList,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "songUrl": songUrl,
      "imageUrls": imageUrls,
      "caption": caption,
      "city": city,
      "country": country,
      "cityId": cityId,
      "likes": likes,
      "comments": comments?.map((e) => e.toJson()).toList(),
      "views": views,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "viewsCount": viewsCount,
      "createdAt": createdAt?.toIso8601String(),
      "location": latitude != null && longitude != null
          ? {
              "type": "Point",
              "coordinates": [longitude, latitude],
            }
          : null,
      "user": user?.toJson(),
    };
  }

  TravelPostModel toTravelPostModel() {
    return TravelPostModel(
      id: id,
      songUrl: songUrl,
      user: user,
      imageUrls: imageUrls,
      imageUrl: imageUrls != null && imageUrls!.isNotEmpty
          ? imageUrls!.first
          : null,
      caption: caption,
      city: city,
      country: country,
      cityId: cityId,
      comments: comments,
      location: (latitude != null && longitude != null)
          ? Location(type: "Point", coordinates: [longitude!, latitude!])
          : null,
      likes: likes,
      views: views,
      likesCount: likesCount ?? likes?.length ?? 0,
      commentsCount: commentsCount ?? 0,
      viewsCount: viewsCount ?? views?.length ?? 0,
      createdAt: createdAt,
    );
  }
}
