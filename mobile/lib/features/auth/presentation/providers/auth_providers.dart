import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/session_storage.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../stores/presentation/providers/store_selection_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_notifier.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final sessionStorageProvider = Provider<SessionStorage>((ref) {
  return SessionStorage(ref.watch(sharedPreferencesProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    tokenStorage: ref.watch(tokenStorageProvider),
    storeIdReader: () => ref.read(selectedStoreIdProvider),
    onSessionExpired: () async {
      await ref.read(tokenStorageProvider).clear();
      ref.read(authNotifierProvider.notifier).markExpired();
    },
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
});

final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.watch(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.watch(authRepositoryProvider)));
final getCurrentUserUseCaseProvider = Provider((ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)));
final refreshSessionUseCaseProvider = Provider((ref) => RefreshSessionUseCase(ref.watch(authRepositoryProvider)));
