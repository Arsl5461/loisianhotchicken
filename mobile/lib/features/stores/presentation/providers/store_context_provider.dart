import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/stores_repository_impl.dart';
import '../../domain/entities/store.dart';
import '../../domain/repositories/stores_repository.dart';
import 'store_selection_provider.dart';

export 'store_selection_provider.dart';

final storesRepositoryProvider = Provider<StoresRepository>((ref) {
  return StoresRepositoryImpl(ref.watch(apiClientProvider));
});

final storesListProvider = FutureProvider.autoDispose<StoreListResult>((ref) async {
  return ref.watch(storesRepositoryProvider).list(limit: 100);
});

Future<void> selectStore(WidgetRef ref, String? id) async {
  ref.read(selectedStoreIdProvider.notifier).state = id;
  await ref.read(sessionStorageProvider).saveStoreId(id);
}
