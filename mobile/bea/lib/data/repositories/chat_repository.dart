import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/models/chat_message_model.dart';
import 'package:OApp/view/messages/models/chat_history_model.dart';
import 'package:get/get.dart';

class ChatRepository {
  ChatRepository({NetworkManager? api}) : _api = api ?? Get.find<NetworkManager>();

  final NetworkManager _api;

  static List<MatchModel> parseMatchesResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final matches = data['matches'];
    if (matches is! List) return [];

    return matches
        .whereType<Map<String, dynamic>>()
        .map(MatchModel.fromJson)
        .toList();
  }

  static MatchModel? parseSingleMatchResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    return MatchModel.fromJson(data);
  }

  static ChatHistoryResponse? parseChatHistoryResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    return ChatHistoryResponse.fromJson(data);
  }

  Future<List<MatchModel>?> fetchMatches() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.matches,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseMatchesResponse(response!.data);
  }

  Future<MatchModel?> fetchSingleMatch(String otherUserId) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.matchesSingle(otherUserId),
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseSingleMatchResponse(response!.data);
  }

  Future<ChatHistoryResponse?> fetchChatHistory(
    String userId, {
    int? limit,
    String? cursor,
    String? id,
  }) async {
    final queryParameters = <String, String>{};
    if (limit != null) queryParameters['limit'] = limit.toString();
    if (cursor != null) queryParameters['cursor'] = cursor;
    if (id != null) queryParameters['id'] = id;

    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: '${EndPoints.chatHistoryCursor(userId)}/',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseChatHistoryResponse(response!.data);
  }

  Future<bool> unmatch(String matchId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.unMatch,
      body: {'matchId': matchId},
    );

    return response?.statusCode == 200;
  }

  Future<int?> updateMatch(String matchId, Map<String, dynamic> body) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.updateMatch(matchId),
      body: body,
    );

    return response?.statusCode;
  }
}
