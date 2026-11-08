import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/constants/app_defaults.dart';

class PrefsPoint {
  const PrefsPoint(this.latitude, this.longitude, {this.isReal = true});

  final double latitude;
  final double longitude;

  /// False when the device refused, so a caller can say "turn on location"
  /// instead of quietly centring on the fallback.
  final bool isReal;

  static const PrefsPoint fallback = PrefsPoint(
    AppDefaults.fallbackLatitude,
    AppDefaults.fallbackLongitude,
    isReal: false,
  );
}

/// One place that asks for the device location, so every part 4 screen that
/// needs a centre behaves the same when permission is refused.
class PrefsLocation {
  static PrefsPoint? _cached;

  static PrefsPoint? get cached => _cached;

  static Future<PrefsPoint> current({bool force = false}) async {
    if (_cached != null && _cached!.isReal && !force) return _cached!;

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _cached = PrefsPoint.fallback;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _cached = PrefsPoint.fallback;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return _cached = PrefsPoint(position.latitude, position.longitude);
    } catch (error) {
      debugPrint('PrefsLocation.current failed: $error');
      return _cached = PrefsPoint.fallback;
    }
  }
}
