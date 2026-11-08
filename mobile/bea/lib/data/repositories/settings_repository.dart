import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/models/settings_models.dart';
import 'package:get/get.dart';

class SettingsResult<T> {
  const SettingsResult.success(this.value)
      : errorMessage = null,
        statusCode = 200;

  const SettingsResult.failure(this.errorMessage, [this.statusCode])
      : value = null;

  final T? value;
  final String? errorMessage;
  final int? statusCode;

  bool get isSuccess => errorMessage == null;
}

class SettingsRepository {
  SettingsRepository({NetworkManager? api})
      : _api = api ?? Get.find<NetworkManager>();

  final NetworkManager _api;

  static String _messageFrom(dynamic data, String fallback) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return fallback;
  }

  /// The account identity the Connect Accounts screen renders: the login
  /// phone and email, the Apple key and the recovery address.
  Future<SettingsResult<Map<String, dynamic>>> fetchAccount() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.getUser,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load your account'),
        response?.statusCode,
      );
    }

    final user = response!.data['user'] ?? response.data['data'];
    if (user is! Map<String, dynamic>) {
      return const SettingsResult.failure('Could not read your account');
    }

    return SettingsResult.success(user);
  }

  Future<SettingsResult<PrivacySettings>> fetchPrivacySettings() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.privacySettings,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load your privacy settings'),
        response?.statusCode,
      );
    }

    final payload = response!.data['privacy'];
    return SettingsResult.success(
      PrivacySettings.fromJson(payload is Map<String, dynamic> ? payload : {}),
    );
  }

  Future<SettingsResult<PrivacySettings>> savePrivacySettings(
    Map<String, dynamic> patch,
  ) async {
    final response = await _api.callApi(
      method: HttpMethod.Put,
      urlEndPoint: EndPoints.privacySettings,
      body: patch,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not save that. Try again.'),
        response?.statusCode,
      );
    }

    final payload = response!.data['privacy'];
    return SettingsResult.success(
      PrivacySettings.fromJson(payload is Map<String, dynamic> ? payload : {}),
    );
  }

  Future<SettingsResult<NotificationPreferences>>
      fetchNotificationPreferences() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.notificationPreferences,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load your notifications'),
        response?.statusCode,
      );
    }

    final payload = response!.data['notification_preferences'];
    return SettingsResult.success(
      NotificationPreferences.fromJson(
        payload is Map<String, dynamic> ? payload : {},
      ),
    );
  }

  Future<SettingsResult<NotificationPreferences>>
      saveNotificationPreferences(Map<String, dynamic> patch) async {
    final response = await _api.callApi(
      method: HttpMethod.Put,
      urlEndPoint: EndPoints.notificationPreferences,
      body: patch,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not save that. Try again.'),
        response?.statusCode,
      );
    }

    final payload = response!.data['notification_preferences'];
    return SettingsResult.success(
      NotificationPreferences.fromJson(
        payload is Map<String, dynamic> ? payload : {},
      ),
    );
  }

  Future<SettingsResult<bool>> pauseAccount(bool paused) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.pauseAccount,
      body: {'paused': paused},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(
          response?.data,
          paused ? 'Could not pause your account' : 'Could not resume',
        ),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<bool>> deleteAccount() async {
    final response = await _api.callApi(
      method: HttpMethod.Delete,
      urlEndPoint: EndPoints.deleteUser,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not delete your account'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<List<BlockedUser>>> fetchBlockedUsers() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.blockedUsers,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load your blocked list'),
        response?.statusCode,
      );
    }

    final list = response!.data['blockedUsers'];
    return SettingsResult.success(
      list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(BlockedUser.fromJson)
              .toList()
          : const [],
    );
  }

  Future<SettingsResult<bool>> unblockUser(String userId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.unblockUser,
      body: {'blockedUserId': userId},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not unblock them'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<bool>> blockUser(String userId) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.blockUser,
      body: {'blockedUserId': userId},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not block them'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<List<HelpArticle>>> fetchHelpArticles(
    String collection,
  ) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: '${EndPoints.helpContent}/$collection',
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load help content'),
        response?.statusCode,
      );
    }

    final data = response?.data;
    final list = data is Map ? (data['articles'] ?? data['data']) : data;
    if (list is! List) {
      return const SettingsResult.failure('Could not read help content');
    }

    return SettingsResult.success([
      for (final entry in list)
        if (entry is Map)
          HelpArticle(
            title: (entry['title'] ?? '').toString(),
            body: (entry['body'] ?? '').toString(),
          ),
    ]);
  }

  Future<SettingsResult<LegalDocument>> fetchLegalDocument(String slug) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: '${EndPoints.legalDocument}/$slug',
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load that document'),
        response?.statusCode,
      );
    }

    final data = response?.data;
    final doc = data is Map ? (data['document'] ?? data['data'] ?? data) : null;
    if (doc is! Map) {
      return const SettingsResult.failure('Could not read that document');
    }

    final sections = doc['sections'];
    return SettingsResult.success(
      LegalDocument(
        slug: slug,
        lastUpdated: (doc['lastUpdated'] ?? doc['updatedAt'] ?? '').toString(),
        sections: [
          if (sections is List)
            for (final entry in sections)
              if (entry is Map)
                HelpArticle(
                  title: (entry['title'] ?? '').toString(),
                  body: (entry['body'] ?? '').toString(),
                ),
        ],
      ),
    );
  }

  Future<SettingsResult<String>> submitSupportTicket({
    required String topic,
    required String description,
    List<String> screenshots = const [],
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.supportTickets,
      body: {
        'topic': topic,
        'description': description,
        if (screenshots.isNotEmpty) 'screenshots': screenshots,
      },
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 && response?.statusCode != 201) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not send your report'),
        response?.statusCode,
      );
    }

    final data = response?.data;
    final id = data is Map
        ? (data['ticketId'] ?? data['id'] ?? data['data']?['ticketId'])
        : null;
    return SettingsResult.success(id?.toString() ?? '');
  }

  Future<SettingsResult<String>> requestPhoneChange(String phoneNumber) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.requestPhoneChange,
      body: {'phoneNumber': phoneNumber},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not send a code to that number'),
        response?.statusCode,
      );
    }

    final token = response!.data['changeToken'];
    if (token is! String || token.isEmpty) {
      return SettingsResult.failure(
        'The server did not return a verification token',
        response.statusCode,
      );
    }

    return SettingsResult.success(token);
  }

  Future<SettingsResult<String>> confirmPhoneChange({
    required String changeToken,
    required String otp,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.confirmPhoneChange,
      body: {'changeToken': changeToken, 'otp': otp},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'That code did not work'),
        response?.statusCode,
      );
    }

    return SettingsResult.success(
      (response!.data['phoneNumber'] ?? '').toString(),
    );
  }

  Future<SettingsResult<String>> requestEmailChange(
    String email, {
    bool recovery = false,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.requestEmailChange,
      body: {'email': email, if (recovery) 'recovery': true},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not send a code to that address'),
        response?.statusCode,
      );
    }

    final token = response!.data['changeToken'];
    if (token is! String || token.isEmpty) {
      return SettingsResult.failure(
        'The server did not return a verification token',
        response.statusCode,
      );
    }

    return SettingsResult.success(token);
  }

  Future<SettingsResult<String>> confirmEmailChange({
    required String changeToken,
    required String otp,
    bool recovery = false,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.confirmEmailChange,
      body: {'changeToken': changeToken, 'otp': otp},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'That code did not work'),
        response?.statusCode,
      );
    }

    final key = recovery ? 'recovery_email' : 'email';
    return SettingsResult.success((response!.data[key] ?? '').toString());
  }

  Future<SettingsResult<bool>> removeRecoveryEmail() async {
    final response = await _api.callApi(
      method: HttpMethod.Delete,
      urlEndPoint: EndPoints.recoveryEmail,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not remove that address'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<bool>> updateAppleKey(String? appleKey) async {
    final response = await _api.callApi(
      method: HttpMethod.Put,
      urlEndPoint: EndPoints.updateLoginMethods,
      body: {'applekey': appleKey},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(
          response?.data,
          appleKey == null
              ? 'Could not disconnect Apple'
              : 'Could not connect Apple',
        ),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }
}
