import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/models/user_model.dart';
import 'package:OApp/view/profileSetting/models/ice_breaker_model.dart';
import 'package:get/get.dart';

class AddProfileResult {
  final int? statusCode;
  final UserModel? user;
  final String? errorMessage;

  const AddProfileResult({
    this.statusCode,
    this.user,
    this.errorMessage,
  });

  bool get isSuccess => statusCode == 200;
}

class LocationUpdateResult {
  final bool isSuccess;
  final String? errorMessage;

  const LocationUpdateResult({
    required this.isSuccess,
    this.errorMessage,
  });
}

class ProfileUpdateResult {
  final int? statusCode;
  final UserModel? user;
  final String? errorMessage;

  const ProfileUpdateResult({
    this.statusCode,
    this.user,
    this.errorMessage,
  });

  bool get isSuccess => statusCode == 200;
}

class ProfileRepository {
  ProfileRepository({NetworkManager? api})
      : _api = api ?? Get.find<NetworkManager>();

  final NetworkManager _api;

  static UserModel? parseUserResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final userPayload = data['user'];
    if (userPayload is Map<String, dynamic>) {
      return UserModel.fromJson(userPayload);
    }

    return UserModel.fromJson(data);
  }

  static List<IceBreakerModel> parseIceBreakersResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    final iceBreakers = data['iceBreakers'];
    if (iceBreakers is! List) return [];

    return iceBreakers
        .whereType<Map<String, dynamic>>()
        .map(IceBreakerModel.fromJson)
        .toList();
  }

  Future<UserModel?> fetchUser() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.getUser,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseUserResponse(response!.data);
  }

  Future<ProfileUpdateResult> updateProfile(UserModel body) async {
    final response = await _api.callApi(
      method: HttpMethod.Put,
      urlEndPoint: EndPoints.updateProfile,
      body: body,
    );

    if (response == null) {
      return const ProfileUpdateResult();
    }

    UserModel? updatedUser;
    if (response.data is Map && response.data['user'] != null) {
      updatedUser = UserModel.fromJson(response.data['user']);
    }

    final errorMessage = response.data is Map
        ? response.data['message'] as String?
        : null;

    return ProfileUpdateResult(
      statusCode: response.statusCode,
      user: updatedUser,
      errorMessage: errorMessage,
    );
  }

  Future<AddProfileResult> addProfile(Map<String, dynamic> body) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.addProfile,
      body: body,
    );

    UserModel? user;
    if (response?.data is Map && response!.data['user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    }

    final errorMessage = response?.data is Map
        ? response?.data['message'] as String?
        : null;

    return AddProfileResult(
      statusCode: response?.statusCode,
      user: user,
      errorMessage: errorMessage,
    );
  }

  Future<LocationUpdateResult> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.updateLocation,
      body: {
        'latitude': latitude.toStringAsFixed(6),
        'longitude': longitude.toStringAsFixed(6),
      },
    );

    final errorMessage = response?.data is Map
        ? response?.data['message'] as String?
        : null;

    return LocationUpdateResult(
      isSuccess: response?.statusCode == 200,
      errorMessage: errorMessage,
    );
  }

  Future<List<IceBreakerModel>?> fetchIceBreakers() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.getIceBreakers,
    );

    if (response?.statusCode != 200 || response?.data == null) {
      return null;
    }

    return parseIceBreakersResponse(response!.data);
  }

  Future<IceBreakerModel?> createIceBreaker(String prompt) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.createIceBreaker,
      body: {'prompt': prompt},
    );

    final status = response?.statusCode ?? 0;
    if (status < 200 || status >= 300) return null;

    final data = response?.data;
    if (data is! Map) return null;
    final created = data['iceBreaker'];
    if (created is! Map<String, dynamic>) return null;
    return IceBreakerModel.fromJson(created);
  }
}
