import '../../../auth/domain/entities/auth_user.dart';
import '../../../../core/utils/json.dart';

class Store {
  const Store({
    required this.id,
    required this.name,
    required this.storeCode,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.status = 'ACTIVE',
    this.managerName,
    this.managerId,
    this.openingDate,
  });

  final String id;
  final String name;
  final String storeCode;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String status;
  final String? managerName;
  final String? managerId;
  final DateTime? openingDate;

  StoreSummary get summary => StoreSummary(
        id: id,
        name: name,
        storeCode: storeCode,
        status: status,
        city: city,
        state: state,
      );

  factory Store.fromJson(Map<String, dynamic> json) {
    final manager = json['manager'];
    return Store(
      id: asId(json['_id'] ?? json['id']),
      name: asString(json['name']),
      storeCode: asString(json['storeCode']),
      email: _emptyToNull(json['email']),
      phone: _emptyToNull(json['phone']),
      address: _emptyToNull(json['address']),
      city: _emptyToNull(json['city']),
      state: _emptyToNull(json['state']),
      country: _emptyToNull(json['country']),
      postalCode: _emptyToNull(json['postalCode']),
      status: asString(json['status']).isEmpty ? 'ACTIVE' : asString(json['status']),
      managerName: manager is Map ? _emptyToNull(manager['name']) : null,
      managerId: manager is Map ? asId(manager['_id'] ?? manager['id']) : asId(manager),
      openingDate: asDate(json['openingDate']),
    );
  }
}

class StoreCounts {
  const StoreCounts({this.total = 0, this.active = 0, this.inactive = 0, this.closed = 0});

  final int total;
  final int active;
  final int inactive;
  final int closed;

  factory StoreCounts.fromJson(Map<String, dynamic> json) {
    return StoreCounts(
      total: asInt(json['total']),
      active: asInt(json['active']),
      inactive: asInt(json['inactive']),
      closed: asInt(json['closed']),
    );
  }
}

class StoreListResult {
  const StoreListResult({required this.items, required this.counts, required this.total, required this.page, required this.totalPages});

  final List<Store> items;
  final StoreCounts counts;
  final int total;
  final int page;
  final int totalPages;
}

String? _emptyToNull(dynamic value) {
  final text = asString(value);
  return text.isEmpty ? null : text;
}
