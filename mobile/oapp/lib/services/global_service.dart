import 'package:OApp/core/constants/app_keys.dart';

import '../models/user_model.dart';
import 'secure_storage_service.dart';

class GlobalService {
  String tag = "Global Service";

  final SecureStorageService _secureStorage = SecureStorageService.instance;
  String? userId;
  UserModel? _userModel;

  setUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  UserModel? getUserModel() {
    return _userModel;
  }

  setUserId(String userId) {
    this.userId = userId;
  }

  Future<String?> getUserId() async {
    return userId ?? await _secureStorage.getKey(AppKeys.userID);
  }
}
