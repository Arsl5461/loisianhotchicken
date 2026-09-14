import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  SessionStorage(this._prefs);

  static const _storeKey = 'lhc_store_id';

  final SharedPreferences _prefs;

  String? readStoreId() => _prefs.getString(_storeKey);

  Future<void> saveStoreId(String? id) async {
    if (id == null || id.isEmpty) {
      await _prefs.remove(_storeKey);
      return;
    }
    await _prefs.setString(_storeKey, id);
  }
}
