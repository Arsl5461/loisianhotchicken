import '../network/paged_result.dart';

String asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  if (value is Map) {
    return asString(value['_id'] ?? value['id'] ?? value['name']);
  }
  return value.toString();
}

String asId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) return asString(value['_id'] ?? value['id']);
  return value.toString();
}

double asDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int asInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

bool asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value == null) return fallback;
  final text = value.toString().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return fallback;
}

DateTime? asDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

Map<String, dynamic> asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<dynamic> asList(dynamic value) {
  if (value is List) return value;
  if (value is Map && value['items'] is List) return value['items'] as List;
  return const [];
}

PagedResult<T> parsePaged<T>(
  dynamic data,
  Map<String, dynamic>? meta,
  T Function(Map<String, dynamic> json) mapItem,
) {
  final items = asList(data)
      .whereType<Map>()
      .map((item) => mapItem(Map<String, dynamic>.from(item)))
      .toList();
  return PagedResult(
    items: items,
    page: asInt(meta?['page'] ?? 1),
    limit: asInt(meta?['limit'] ?? items.length),
    total: asInt(meta?['total'] ?? items.length),
    totalPages: asInt(meta?['totalPages'] ?? 1),
  );
}
