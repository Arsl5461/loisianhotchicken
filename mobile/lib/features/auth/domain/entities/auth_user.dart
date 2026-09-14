import '../../../../core/constants/permissions.dart';
import '../../../../core/utils/json.dart';

class RoleSummary {
  const RoleSummary({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.permissions = const [],
    this.isSystem = false,
  });

  final String id;
  final String name;
  final String slug;
  final String? description;
  final List<String> permissions;
  final bool isSystem;

  factory RoleSummary.fromJson(Map<String, dynamic> json) {
    return RoleSummary(
      id: asId(json['_id'] ?? json['id']),
      name: asString(json['name']),
      slug: asString(json['slug']),
      description: asString(json['description']).isEmpty ? null : asString(json['description']),
      permissions: asList(json['permissions']).map(asString).where((item) => item.isNotEmpty).toList(),
      isSystem: asBool(json['isSystem']),
    );
  }
}

class StoreSummary {
  const StoreSummary({
    required this.id,
    required this.name,
    required this.storeCode,
    this.status,
    this.city,
    this.state,
  });

  final String id;
  final String name;
  final String storeCode;
  final String? status;
  final String? city;
  final String? state;

  factory StoreSummary.fromJson(Map<String, dynamic> json) {
    return StoreSummary(
      id: asId(json['_id'] ?? json['id']),
      name: asString(json['name']),
      storeCode: asString(json['storeCode']),
      status: asString(json['status']).isEmpty ? null : asString(json['status']),
      city: asString(json['city']).isEmpty ? null : asString(json['city']),
      state: asString(json['state']).isEmpty ? null : asString(json['state']),
    );
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.organizationId,
    required this.role,
    required this.permissions,
    required this.stores,
    required this.isSuperAdmin,
    this.avatar,
    this.defaultStore,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String organizationId;
  final RoleSummary role;
  final List<String> permissions;
  final List<StoreSummary> stores;
  final String? defaultStore;
  final bool isSuperAdmin;
  final bool isActive;

  bool can(String permission) {
    if (isSuperAdmin) return true;
    return permissions.contains(permission);
  }

  bool get canManageUsers => isSuperAdmin && can(Permissions.usersRead);
  bool get canManageRoles => isSuperAdmin && can(Permissions.rolesRead);

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: asId(json['id'] ?? json['_id']),
      name: asString(json['name']),
      email: asString(json['email']),
      avatar: asString(json['avatar']).isEmpty ? null : asString(json['avatar']),
      organizationId: asId(json['organizationId']),
      role: RoleSummary.fromJson(asMap(json['role'])),
      permissions: asList(json['permissions']).map(asString).where((item) => item.isNotEmpty).toList(),
      stores: asList(json['stores']).whereType<Map>().map((item) => StoreSummary.fromJson(Map<String, dynamic>.from(item))).toList(),
      defaultStore: asString(json['defaultStore']).isEmpty ? null : asId(json['defaultStore']),
      isSuperAdmin: asBool(json['isSuperAdmin']),
      isActive: asBool(json['isActive'], fallback: true),
    );
  }
}

class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final AuthUser user;
  final String accessToken;
  final String refreshToken;
}
