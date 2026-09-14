import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paged_result.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../sales/presentation/providers/finance_providers.dart';
import '../../data/admin_directory_repository.dart';

final adminDirectoryRepositoryProvider = Provider((ref) => AdminDirectoryRepositoryImpl(ref.watch(apiClientProvider)));

final usersQueryProvider = StateProvider<ListQuery>((ref) => const ListQuery());
final usersStatusProvider = StateProvider<String>((ref) => 'ALL');

final usersListProvider = FutureProvider.autoDispose<PagedResult<AdminUser>>((ref) {
  final query = ref.watch(usersQueryProvider);
  final status = ref.watch(usersStatusProvider);
  return ref.watch(adminDirectoryRepositoryProvider).users(
        page: query.page,
        search: query.search,
        status: status == 'ALL' ? null : status,
      );
});

final rolesListProvider = FutureProvider.autoDispose<List<AdminRole>>((ref) {
  return ref.watch(adminDirectoryRepositoryProvider).roles();
});

final permissionGroupsProvider = FutureProvider.autoDispose<List<PermissionGroup>>((ref) {
  return ref.watch(adminDirectoryRepositoryProvider).permissionCatalog();
});

final organizationProvider = FutureProvider.autoDispose<OrganizationProfile>((ref) {
  return ref.watch(adminDirectoryRepositoryProvider).organization();
});
