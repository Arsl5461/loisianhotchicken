import '../../../config/app_config.dart';

class RemoteConfigModel {
  final String liveUrl;

  const RemoteConfigModel({required this.liveUrl});

  /// ---------- FROM JSON ----------
  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    return RemoteConfigModel(
      liveUrl: json['liveUrl'] ?? DefaultRemoteConfig.liveUrl,
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {'liveUrl': liveUrl};
  }
}

class DefaultRemoteConfig {
  static RemoteConfigModel get model => RemoteConfigModel(liveUrl: liveUrl);
  static String liveUrl = AppConfig.baseUrl;
}
