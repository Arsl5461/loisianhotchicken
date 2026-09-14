import '../entities/store.dart';

abstract class StoresRepository {
  Future<StoreListResult> list({int page = 1, int limit = 20, String? search, String? status});
  Future<Store> getById(String id);
  Future<Store> create(Map<String, dynamic> body);
  Future<Store> update(String id, Map<String, dynamic> body);
  Future<void> delete(String id);
  Future<void> bulkDelete(List<String> ids);
  Future<List<AuthLiteUser>> usersForStore(String id);
}

class AuthLiteUser {
  const AuthLiteUser({required this.id, required this.name, required this.email, this.role});

  final String id;
  final String name;
  final String email;
  final String? role;
}
