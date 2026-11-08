import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/models/travel_destination_model.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/view/Travel/models/comment_model.dart';
import 'package:OApp/view/Travel/models/create_post_model.dart';
import 'package:OApp/view/Travel/models/get_post_request_model.dart';
import 'package:OApp/view/Travel/models/travel_city_model.dart';
import 'package:OApp/view/Travel/models/travel_post_model.dart';
import 'package:get/get.dart';

class TravelPostCreateResult {
  final int? statusCode;
  final String? errorMessage;

  const TravelPostCreateResult({this.statusCode, this.errorMessage});

  bool get isSuccess => statusCode == 200;
}

class TravelRepository {
  TravelRepository({NetworkManager? api})
      : _api = api ?? Get.find<NetworkManager>();

  final NetworkManager _api;

  static List<TravelPostModel> parsePostsResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final posts = data['posts'];
    if (posts is! List) return [];

    return posts
        .whereType<Map<String, dynamic>>()
        .map(TravelPostModel.fromJson)
        .toList();
  }

  static List<TravelCity> parseCitiesResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final cities = data['cities'];
    if (cities is! List) return [];

    return cities
        .whereType<Map<String, dynamic>>()
        .map(TravelCity.fromJson)
        .toList();
  }

  static List<GetPostModel> parseCityPostsResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final posts = data['posts'];
    if (posts is! List) return [];

    return posts
        .whereType<Map<String, dynamic>>()
        .map(GetPostModel.fromJson)
        .toList();
  }

  static List<CommentModel> parseCommentsResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final comments = data['comments'];
    if (comments is! List) return [];

    return comments
        .whereType<Map<String, dynamic>>()
        .map(CommentModel.fromJson)
        .toList();
  }

  static List<UserModel> parseUsersResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final users = data['users'];
    if (users is! List) return [];

    return users
        .whereType<Map<String, dynamic>>()
        .map(UserModel.fromJson)
        .toList();
  }

  Future<bool> recordView(String postId, String userId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.setViewByUserId(postId),
      queryParameters: {'userId': userId},
    );

    return response?.statusCode == 200;
  }

  Future<bool> recordLike(String postId, String userId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.setLikeByUserId(postId),
      queryParameters: {'userId': userId},
    );

    return response?.statusCode == 200;
  }

  Future<bool> addComment({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.setComments(postId),
      body: {'userId': userId, 'comment': comment},
    );

    return response?.statusCode == 200;
  }

  Future<List<CommentModel>?> fetchComments(String postId) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.setComments(postId),
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseCommentsResponse(response!.data);
  }

  Future<List<UserModel>?> fetchUsersByIds(List<String> userIds) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.getUsers,
      body: {'userIds': userIds},
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseUsersResponse(response!.data);
  }

  Future<List<TravelPostModel>?> fetchPosts(GetPostsRequest request) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.getPost,
      queryParameters: request.toQuery(),
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parsePostsResponse(response!.data);
  }

  Future<List<TravelCity>?> fetchCitiesPosted() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.getCitiesPost,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseCitiesResponse(response!.data);
  }

  static List<TravelDestination> parseDestinationsResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final cities = data['cities'];
    if (cities is! List) return [];

    return cities
        .whereType<Map<String, dynamic>>()
        .map(TravelDestination.fromJson)
        .toList();
  }

  Future<List<TravelDestination>?> searchDestinations(
    String query, {
    int limit = 20,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.searchDestinations,
      queryParameters: {'query': trimmed, 'limit': limit},
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseDestinationsResponse(response!.data);
  }

  Future<List<TravelDestination>?> fetchNearbyDestinations({
    required double latitude,
    required double longitude,
    int limit = 20,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.nearbyDestinations,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'limit': limit,
      },
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseDestinationsResponse(response!.data);
  }

  Future<TravelDestination?> fetchDestination(String cityId) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.destination(cityId),
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return null;
    }

    final city = response!.data['city'];
    if (city is! Map<String, dynamic>) return null;
    return TravelDestination.fromJson(city);
  }

  Future<List<TravelCity>?> searchCities(String query) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.searchCities,
      queryParameters: {'query': query},
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseCitiesResponse(response!.data);
  }

  Future<List<TravelCity>?> fetchNearbyCities({
    required double latitude,
    required double longitude,
    int limit = 20,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.nearbyCities,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'limit': limit,
      },
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseCitiesResponse(response!.data);
  }

  Future<List<GetPostModel>?> fetchPostsByCityId(String cityId) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.getCitiesPostCityID(cityId),
      body: {'cityId': cityId},
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseCityPostsResponse(response!.data);
  }

  Future<TravelPostCreateResult> createPost(Map<String, dynamic> body) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      body: body,
      urlEndPoint: EndPoints.createPost,
    );

    final errorMessage = response?.data is Map
        ? response?.data['message'] as String?
        : null;

    return TravelPostCreateResult(
      statusCode: response?.statusCode,
      errorMessage: errorMessage,
    );
  }
}
