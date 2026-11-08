import 'dart:convert';

import 'package:OApp/config/error_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigService {
  final String _tag = "RemoteConfigService";
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instanceFor(
    app: Firebase.app('OApp'),
  );
  String jsonname = "app_config";
  Future<void> init({
    Duration minimumFetchInterval = const Duration(seconds: 2),
  }) async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: minimumFetchInterval,
        ),
      );

      // Optional: Set default values for keys
      await _remoteConfig.setDefaults(<String, dynamic>{
        jsonname: jsonEncode({}), // empty JSON by default
      });

      // Fetch and activate latest values from server
      final success = await _remoteConfig.fetchAndActivate();

      if (success) {
        debugPrint("✅ Remote Config: New values fetched and activated");
      } else {
        debugPrint("ℹ️ Remote Config: No new data (cached values used)");
      }
    } catch (e, s) {
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
    }
  }

  /// Get a simple string value
  String getString(String key, {String fallback = ""}) {
    final value = _remoteConfig.getString(key);
    return value.isEmpty ? fallback : value;
  }

  /// Get JSON parameter as Map
  Map<String, dynamic> getJson(String key, {Map<String, String>? fallback}) {
    final jsonString = _remoteConfig.getString(key);
    if (jsonString.isEmpty) return fallback ?? {};

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) return decoded;
      return fallback ?? {};
    } catch (e) {
      debugPrint("Remote Config JSON decode error for key '$key': $e");
      return fallback ?? {};
    }
  }

  /// Get a specific tenant's config by tenant ID
  Map<String, dynamic>? getTenant(String tenantId) {
    final tenants = getJson("tenants");
    if (tenants.containsKey(tenantId)) {
      final tenantData = tenants[tenantId];
      if (tenantData is Map<String, dynamic>) {
        return tenantData;
      }
    }
    return null;
  }

  /// Convenience method: Get tenant property directly
  dynamic getTenantProperty(
    String tenantId,
    String property, {
    dynamic fallback,
  }) {
    final tenant = getTenant(tenantId);
    if (tenant != null && tenant.containsKey(property)) {
      return tenant[property];
    }
    return fallback;
  }

  /// Force fetch & activate latest values
  Future<bool> refresh() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint("Remote Config refresh error: $e");
      return false;
    }
  }
}
