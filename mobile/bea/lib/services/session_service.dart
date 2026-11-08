import 'package:get/get.dart';

import '../core/constants/app_keys.dart';
import '../core/routing/app_routes.dart';
import '../services/secure_storage_service.dart';
import '../services/socket_service.dart';
import '../view/Dashboard/dashboard_controller.dart';
import '../view/ProfileMaking/profile_making_controller/profile_controller.dart';

/// Centralized session invalidation used by 401 handlers and manual logout.
class SessionService extends GetxService {
  SessionService({SecureStorageService? storage})
    : _storage = storage ?? SecureStorageService.instance;

  final SecureStorageService _storage;
  bool _isInvalidating = false;

  Future<void> invalidateSession({bool navigate = true}) async {
    if (_isInvalidating) return;
    _isInvalidating = true;

    try {
      Get.closeAllSnackbars();

      if (Get.isRegistered<SocketService>()) {
        Get.find<SocketService>().disconnect();
      }

      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().selectedIndex.value = 0;
      }

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().clearAll();
      }

      await _storage.deleteKey(AppKeys.authToken);
      await _storage.deleteKey(AppKeys.userID);
      await _storage.deleteAllKeys();

      if (navigate && Get.currentRoute != Routes.OPTION_SCREEN) {
        Get.offAllNamed(Routes.OPTION_SCREEN);
      }
    } finally {
      _isInvalidating = false;
    }
  }
}
