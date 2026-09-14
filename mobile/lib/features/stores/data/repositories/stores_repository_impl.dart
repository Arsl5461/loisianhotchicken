import '../../../../core/constants/api_paths.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/json.dart';
import '../../domain/entities/store.dart';
import '../../domain/repositories/stores_repository.dart';

class StoresRepositoryImpl implements StoresRepository {
  StoresRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<StoreListResult> list({int page = 1, int limit = 20, String? search, String? status}) async {
    final envelope = await _client.get(
      ApiPaths.stores,
      query: {'page': page, 'limit': limit, 'search': search, 'status': status, 'sortBy': 'name', 'sortOrder': 'asc'},
    );
    final data = asMap(envelope.data);
    final items = asList(data['items']).whereType<Map>().map((item) => Store.fromJson(Map<String, dynamic>.from(item))).toList();
    return StoreListResult(
      items: items,
      counts: StoreCounts.fromJson(asMap(data['counts'])),
      total: asInt(envelope.meta?['total'] ?? items.length),
      page: asInt(envelope.meta?['page'] ?? page),
      totalPages: asInt(envelope.meta?['totalPages'] ?? 1),
    );
  }

  @override
  Future<Store> getById(String id) async {
    final envelope = await _client.get('${ApiPaths.stores}/$id');
    return Store.fromJson(asMap(envelope.data));
  }

  @override
  Future<Store> create(Map<String, dynamic> body) async {
    final envelope = await _client.post(ApiPaths.stores, data: body);
    return Store.fromJson(asMap(envelope.data));
  }

  @override
  Future<Store> update(String id, Map<String, dynamic> body) async {
    final envelope = await _client.patch('${ApiPaths.stores}/$id', data: body);
    return Store.fromJson(asMap(envelope.data));
  }

  @override
  Future<void> delete(String id) async {
    await _client.delete('${ApiPaths.stores}/$id');
  }

  @override
  Future<void> bulkDelete(List<String> ids) async {
    await _client.post('${ApiPaths.stores}/bulk-delete', data: {'ids': ids});
  }

  @override
  Future<List<AuthLiteUser>> usersForStore(String id) async {
    final envelope = await _client.get('${ApiPaths.stores}/$id/users');
    return asList(envelope.data).whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      return AuthLiteUser(
        id: asId(map['_id'] ?? map['id']),
        name: asString(map['name']),
        email: asString(map['email']),
        role: asString(asMap(map['roleId'])['name']).isEmpty ? asString(map['role']) : asString(asMap(map['roleId'])['name']),
      );
    }).toList();
  }
}
