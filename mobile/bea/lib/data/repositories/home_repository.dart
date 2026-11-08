import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/models/dating_preferences_model.dart';
import 'package:OApp/models/pending_likes_model.dart';
import 'package:OApp/models/travel_destination_model.dart';
import 'package:OApp/models/user_model.dart';
import 'package:get/get.dart';

/// Result of a like/dislike API call, including HTTP status for UI handling.
class MatchActionResult {
  final int? statusCode;

  const MatchActionResult({this.statusCode});

  bool get isSuccess => statusCode == 200;
  bool get isForbidden => statusCode == 403;
}

class MatchCreateResult {
  final int? statusCode;
  final String? errorMessage;

  const MatchCreateResult({this.statusCode, this.errorMessage});

  bool get isSuccess => statusCode == 200 || statusCode == 201;
}

class MatchFeedResult {
  final List<UserModel> matches;
  final int totalUsers;
  final int afterExcludeCount;
  final int afterFilterCount;
  final int likedCount;
  final int dislikedCount;

  const MatchFeedResult({
    required this.matches,
    this.totalUsers = 0,
    this.afterExcludeCount = 0,
    this.afterFilterCount = 0,
    this.likedCount = 0,
    this.dislikedCount = 0,
  });

  bool get isEmpty => matches.isEmpty;

  String get emptyMessage {
    if (afterFilterCount == 0 && afterExcludeCount > 0) {
      return 'No profiles match your current dating preferences. '
          'Try widening your age range or distance.';
    }

    if (likedCount + dislikedCount > 0 && afterExcludeCount == 0) {
      return "You've seen everyone in your area for now. "
          'Check back later for new profiles.';
    }

    return 'No profiles found right now. Pull down to refresh.';
  }
}

class HomeRepository {
  HomeRepository({NetworkManager? api}) : _api = api ?? Get.find<NetworkManager>();

  final NetworkManager _api;

  static List<UserModel> parseMatchesResponse(dynamic data) {
    return parseMatchFeedResult(data).matches;
  }

  static MatchFeedResult parseMatchFeedResult(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return const MatchFeedResult(matches: []);
    }

    final matches = data['matches'];
    if (matches is! List) {
      return const MatchFeedResult(matches: []);
    }

    final users = matches
        .whereType<Map<String, dynamic>>()
        .map(UserModel.fromJson)
        .toList();

    final debug = data['debug'];
    if (debug is! Map<String, dynamic>) {
      return MatchFeedResult(matches: users);
    }

    final counts = debug['counts'];
    final excluded = debug['excluded'];
    final breakdown = excluded is Map<String, dynamic>
        ? excluded['breakdown']
        : null;

    int listLen(dynamic value) => value is List ? value.length : 0;

    return MatchFeedResult(
      matches: users,
      totalUsers: counts is Map ? (counts['totalUsers'] as int? ?? 0) : 0,
      afterExcludeCount: counts is Map
          ? (counts['afterExcludeCount'] as int? ?? 0)
          : 0,
      afterFilterCount: counts is Map
          ? (counts['afterFilterCount'] as int? ?? 0)
          : 0,
      likedCount: breakdown is Map ? listLen(breakdown['liked']) : 0,
      dislikedCount: breakdown is Map ? listLen(breakdown['disliked']) : 0,
    );
  }

  static DatingPreferencesModel? parsePreferencesResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final payload = data['data'];
    if (payload is! Map<String, dynamic>) return null;
    return DatingPreferencesModel.fromJson(payload);
  }

  Future<MatchFeedResult> fetchMatches({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.userPosts,
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return const MatchFeedResult(matches: []);
    }

    return parseMatchFeedResult(response!.data);
  }

  Future<MatchActionResult> likeUser(String toUserId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.like,
      body: {'toUserId': toUserId},
      returnRawResponse: true,
    );
    return MatchActionResult(statusCode: response?.statusCode);
  }

  Future<MatchActionResult> unlikeUser(String toUserId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.unlike,
      body: {'toUserId': toUserId},
    );
    return MatchActionResult(statusCode: response?.statusCode);
  }

  Future<MatchActionResult> likeWithPayload(SendLikeModel likeModel) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.like,
      body: likeModel.toJson(),
    );
    return MatchActionResult(statusCode: response?.statusCode);
  }

  Future<DatingPreferencesModel?> fetchPreferences() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.preferences,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parsePreferencesResponse(response!.data);
  }

  static PendingLikesModel? parsePendingLikesResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    return PendingLikesModel.fromJson(data);
  }

  Future<PendingLikesModel?> fetchPendingLikes() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.pendingLikes,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parsePendingLikesResponse(response!.data);
  }

  Future<PendingLikesModel?> fetchLikesByStatus(String status) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.likesBystatus,
      queryParameters: {'status': status},
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parsePendingLikesResponse(response!.data);
  }

  Future<MatchCreateResult> createMatch(String toUserId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.createMatch,
      body: {'toUserId': toUserId},
    );

    final errorMessage = response?.data is Map
        ? response?.data['message'] as String?
        : null;

    return MatchCreateResult(
      statusCode: response?.statusCode,
      errorMessage: errorMessage,
    );
  }

  Future<TravelTrip?> setTravelDestination({
    required TravelDestination destination,
    DateTime? arrivalDate,
  }) async {
    if (!destination.hasCoordinates) return null;

    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.updateLocationTravel,
      body: {
        'latitude': destination.latitude,
        'longitude': destination.longitude,
        'travelCity': destination.name,
        'travelCountry': destination.country,
        if (destination.cityId.isNotEmpty) 'cityId': destination.cityId,
        if (arrivalDate != null)
          'arrivalDate': arrivalDate.toIso8601String(),
      },
    );

    if (response?.statusCode != 200 || response?.data is! Map) return null;

    final user = response!.data['user'];
    if (user is! Map<String, dynamic>) return null;
    return TravelTrip.fromUserJson(user);
  }

  Future<bool> setTravelMode(bool isTraveling) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.toggleTravelMode,
      body: {'isTraveling': isTraveling},
    );

    return response?.statusCode == 200;
  }

  Future<TravelTrip?> fetchTravelTrip() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.getUser,
    );

    if (response?.statusCode != 200 || response?.data is! Map) return null;

    final user = response!.data['user'] ?? response.data['data'];
    if (user is! Map<String, dynamic>) return null;
    return TravelTrip.fromUserJson(user);
  }

  Future<DatingPreferencesModel?> savePreferences(
    DatingPreferencesModel preferences,
  ) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.preferences,
      body: preferences.toJson(),
    );

    if (response == null) return null;
    if (response.statusCode != 200 && response.statusCode != 201) return null;

    return parsePreferencesResponse(response.data);
  }
}
