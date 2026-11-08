import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorageService extends GetxService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const AndroidOptions _androidOptions = AndroidOptions(
    resetOnError: true,
  );

  Future<void> setKey(String key, String value) async {
    await _storage.write(key: key, value: value, aOptions: _androidOptions);
  }

  Future<String?> getKey(String key) async {
    return _storage.read(key: key, aOptions: _androidOptions);
  }

  Future<void> deleteKey(String key) async {
    await _storage.delete(key: key, aOptions: _androidOptions);
  }

  Future<void> deleteAllKeys() async {
    await _storage.deleteAll(aOptions: _androidOptions);
  }

  Future<Map<String, String>> getAllKeys() async {
    return _storage.readAll(aOptions: _androidOptions);
  }
}
