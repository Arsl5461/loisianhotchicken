/// Application-wide default values.
///
/// Centralizes magic numbers that were previously duplicated across multiple
/// controllers (e.g. fallback map coordinates).
class AppDefaults {
  AppDefaults._();

  /// Fallback geo-coordinates used when a device location is unavailable.
  /// (Lahore, Pakistan.)
  static const double fallbackLatitude = 31.4697;
  static const double fallbackLongitude = 74.2728;
}
