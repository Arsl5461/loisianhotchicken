import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paged_result.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../stores/presentation/providers/store_selection_provider.dart';
import '../../data/repositories/finance_repositories_impl.dart';
import '../../domain/entities/finance_records.dart';

final salesRepositoryProvider = Provider<SalesRepository>((ref) => SalesRepositoryImpl(ref.watch(apiClientProvider)));
final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) => ExpensesRepositoryImpl(ref.watch(apiClientProvider)));
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) => CatalogRepositoryImpl(ref.watch(apiClientProvider)));

class ListQuery {
  const ListQuery({this.page = 1, this.search = ''});
  final int page;
  final String search;
  ListQuery copyWith({int? page, String? search}) => ListQuery(page: page ?? this.page, search: search ?? this.search);
}

final salesQueryProvider = StateProvider<ListQuery>((ref) => const ListQuery());
final expensesQueryProvider = StateProvider<ListQuery>((ref) => const ListQuery());

final salesListProvider = FutureProvider.autoDispose<PagedResult<Sale>>((ref) {
  final query = ref.watch(salesQueryProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  return ref.watch(salesRepositoryProvider).list(page: query.page, search: query.search, storeId: storeId);
});

final expensesListProvider = FutureProvider.autoDispose<PagedResult<Expense>>((ref) {
  final query = ref.watch(expensesQueryProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  return ref.watch(expensesRepositoryProvider).list(page: query.page, search: query.search, storeId: storeId);
});

final expenseCategoriesProvider = FutureProvider.autoDispose<PagedResult<NamedRecord>>((ref) {
  return ref.watch(catalogRepositoryProvider).expenseCategories(limit: 100);
});

final paymentMethodsProvider = FutureProvider.autoDispose<PagedResult<NamedRecord>>((ref) {
  return ref.watch(catalogRepositoryProvider).paymentMethods(limit: 100, status: 'ACTIVE');
});

final allPaymentMethodsProvider = FutureProvider.autoDispose<PagedResult<NamedRecord>>((ref) {
  return ref.watch(catalogRepositoryProvider).paymentMethods(limit: 100);
});
