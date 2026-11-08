import 'dart:math';

import 'package:geocoding/geocoding.dart';

class LocationHelper {
  static Future<String> getPlaceName({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks =
          await Geocoding().placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        /// Customize format like: Manhattan, NY
        String area = place.subLocality ?? place.locality ?? '';
        String city = place.locality ?? '';
        String state = place.administrativeArea ?? '';

        if (area.isNotEmpty && state.isNotEmpty) {
          return "$area, $state";
        } else if (city.isNotEmpty && state.isNotEmpty) {
          return "$city, $state";
        } else {
          return state.isNotEmpty ? state : "Unknown location";
        }
      }

      return "Unknown location";
    } catch (e) {
      return "Location not found";
    }
  }

  static String getDistanceText({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
    bool useMiles = false,
  }) {
    final distanceInMeters = _calculateDistance(lat1, lon1, lat2, lon2);

    if (useMiles) {
      final miles = distanceInMeters / 1609.34;

      if (miles < 0.1) {
        return "${distanceInMeters.round()} m away";
      } else if (miles < 10) {
        return "${miles.toStringAsFixed(1)} miles away";
      } else {
        return "${miles.round()} miles away";
      }
    } else {
      if (distanceInMeters < 1000) {
        return "${distanceInMeters.round()} m away";
      } else if (distanceInMeters < 10000) {
        return "${(distanceInMeters / 1000).toStringAsFixed(1)} km away";
      } else {
        return "${(distanceInMeters / 1000).round()} km away";
      }
    }
  }

  // ✅ Haversine formula
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000;

    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degToRad(double deg) => deg * pi / 180;
}
