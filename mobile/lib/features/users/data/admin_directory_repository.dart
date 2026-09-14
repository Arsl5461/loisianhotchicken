import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/paged_result.dart';
import '../../../core/utils/json.dart';

class AdminUser {
  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    this.roleName,
    this.roleId,
    this.roleSlug,
    this.storeNames = const [],
    this.storeIds = const [],
    this.lastLogin,
  });

  final String id;
  final String name;
  final String email;
  final bool isActive;
  final String? roleName;
  final String? roleId;
  final String? roleSlug;
  final List<String> storeNames;
  final List<String> storeIds;
  final DateTime? lastLogin;

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    final role = json['roleId'];
    final stores = asList(json['stores']);
    return AdminUser(
      id: asId(json['_id'] ?? json['id']),
      name: asString(json['name']),
      email: asString(json['email']),
      isActive: asBool(json['isActive'], fallback: true),
      roleName: role is Map ? asString(role['name']) : asString(json['role']),
      roleId: asId(role),
      roleSlug: role is Map ? asString(role['slug']) : null,
      storeNames: stores.map((item) => item is Map ? asString(item['name']) : asString(item)).where((item) => item.isNotEmpty).toList(),
      storeIds: stores.map(asId).where((item) => item.isNotEmpty).toList(),
      lastLogin: asDate(json['lastLogin']),
    );
  }
}

class AdminRole {
  const AdminRole({
    required this.id,
    required this.name,
    required this.slug,
    required this.permissions,
    this.description,
    this.isSystem = false,
  });

  final String id;
  final String name;
  final String slug;
  final String? description;
  final List<String> permissions;
  final bool isSystem;

  factory AdminRole.fromJson(Map<String, dynamic> json) {
    return AdminRole(
      id: asId(json['_id'] ?? json['id']),
      name: asString(json['name']),
      slug: asString(json['slug']),
      description: asString(json['description']).isEmpty ? null : asString(json['description']),
      permissions: asList(json['permissions']).map(asString).where((item) => item.isNotEmpty).toList(),
      isSystem: asBool(json['isSystem']),
    );
  }
}

class PermissionGroup {
  const PermissionGroup({required this.key, required this.label, required this.permissions});
  final String key;
  final String label;
  final List<String> permissions;

  factory PermissionGroup.fromJson(Map<String, dynamic> json) {
    return PermissionGroup(
      key: asString(json['key']),
      label: asString(json['label']),
      permissions: asList(json['permissions']).map(asString).where((item) => item.isNotEmpty).toList(),
    );
  }
}

class OrganizationProfile {
  const OrganizationProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.slug,
    this.logo,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? slug;
  final String? logo;
  final bool isActive;

  factory OrganizationProfile.fromJson(Map<String, dynamic> json) {
    String? optional(dynamic value) {
      final text = asString(value);
      return text.isEmpty ? null : text;
    }

    return OrganizationProfile(
      id: asId(json['_id'] ?? json['id']),
      name: asString(json['name']),
      email: optional(json['email']),
      phone: optional(json['phone']),
      address: optional(json['address']),
      slug: optional(json['slug']),
      logo: optional(json['logo']),
      isActive: asBool(json['isActive'], fallback: true),
    );
  }
}

abstract class AdminDirectoryRepository {
  Future<PagedResult<AdminUser>> users({int page = 1, String? search, String? status});
  Future<AdminUser> createUser(Map<String, dynamic> body);
  Future<AdminUser> updateUser(String id, Map<String, dynamic> body);
  Future<void> deleteUser(String id);
  Future<void> resetPassword(String id, String password);

  Future<List<AdminRole>> roles();
  Future<AdminRole> updateRolePermissions(String id, List<String> permissions);
  Future<List<PermissionGroup>> permissionCatalog();

  Future<OrganizationProfile> organization();
  Future<OrganizationProfile> updateOrganization(Map<String, dynamic> body);
}

class AdminDirectoryRepositoryImpl implements AdminDirectoryRepository {
  AdminDirectoryRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<PagedResult<AdminUser>> users({int page = 1, String? search, String? status}) async {
    final envelope = await _client.get(ApiPaths.users, query: {
      'page': page,
      'limit': 20,
      'search': search,
      'status': status,
      'sortBy': 'name',
      'sortOrder': 'asc',
    });
    return parsePaged(envelope.data, envelope.meta, AdminUser.fromJson);
  }

  @override
  Future<AdminUser> createUser(Map<String, dynamic> body) async {
    final envelope = await _client.post(ApiPaths.users, data: body);
    return AdminUser.fromJson(asMap(envelope.data));
  }

  @override
  Future<AdminUser> updateUser(String id, Map<String, dynamic> body) async {
    final envelope = await _client.patch('${ApiPaths.users}/$id', data: body);
    return AdminUser.fromJson(asMap(envelope.data));
  }

  @override
  Future<void> deleteUser(String id) => _client.delete('${ApiPaths.users}/$id');

  @override
  Future<void> resetPassword(String id, String password) {
    return _client.post('${ApiPaths.users}/$id/reset-password', data: {'password': password});
  }

  @override
  Future<List<AdminRole>> roles() async {
    final envelope = await _client.get(ApiPaths.roles);
    return asList(envelope.data).whereType<Map>().map((item) => AdminRole.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<AdminRole> updateRolePermissions(String id, List<String> permissions) async {
    final envelope = await _client.patch('${ApiPaths.roles}/$id', data: {'permissions': permissions});
    return AdminRole.fromJson(asMap(envelope.data));
  }

  @override
  Future<List<PermissionGroup>> permissionCatalog() async {
    final envelope = await _client.get(ApiPaths.permissions);
    return asList(envelope.data).whereType<Map>().map((item) => PermissionGroup.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<OrganizationProfile> organization() async {
    final envelope = await _client.get(ApiPaths.organization);
    return OrganizationProfile.fromJson(asMap(envelope.data));
  }

  @override
  Future<OrganizationProfile> updateOrganization(Map<String, dynamic> body) async {
    final envelope = await _client.patch(ApiPaths.organization, data: body);
    return OrganizationProfile.fromJson(asMap(envelope.data));
  }
}
