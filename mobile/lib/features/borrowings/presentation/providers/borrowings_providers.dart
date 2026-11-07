import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paged_result.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../sales/presentation/providers/finance_providers.dart';
import '../../../stores/presentation/providers/store_selection_provider.dart';
import '../../data/borrowings_repository.dart';

final borrowingsRepositoryProvider = Provider<BorrowingsRepository>(
  (ref) => BorrowingsRepositoryImpl(ref.watch(apiClientProvider)),
);

final borrowingsQueryProvider = StateProvider<ListQuery>((ref) => const ListQuery());

final borrowingsListProvider = FutureProvider.autoDispose<PagedResult<Borrowing>>((ref) {
  final query = ref.watch(borrowingsQueryProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  return ref.watch(borrowingsRepositoryProvider).list(
        page: query.page,
        search: query.search,
        storeId: storeId,
      );
});
