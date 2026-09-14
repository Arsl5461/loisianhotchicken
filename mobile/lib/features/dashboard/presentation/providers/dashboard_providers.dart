import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../stores/presentation/providers/store_selection_provider.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_overview.dart';

class DashboardFilter {
  const DashboardFilter({this.range = '30d', this.startDate, this.endDate});
  final String range;
  final String? startDate;
  final String? endDate;

  String get groupBy {
    if (range == 'custom') {
      if (startDate == null || endDate == null) return 'day';
      final days = DateTime.parse(endDate!).difference(DateTime.parse(startDate!)).inDays;
      if (days > 180) return 'month';
      if (days > 45) return 'week';
      return 'day';
    }
    switch (range) {
      case '3m':
        return 'week';
      case '6m':
      case 'ytd':
        return 'month';
      default:
        return 'day';
    }
  }
}

final dashboardFilterProvider = StateProvider<DashboardFilter>((ref) => const DashboardFilter());

final dashboardRepositoryProvider = Provider((ref) => DashboardRepositoryImpl(ref.watch(apiClientProvider)));

final dashboardOverviewProvider = FutureProvider.autoDispose<DashboardOverview>((ref) async {
  final filter = ref.watch(dashboardFilterProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  final isCustom = filter.range == 'custom' && filter.startDate != null && filter.endDate != null;
  return ref.watch(dashboardRepositoryProvider).overview(
        DateRangeQuery(
          range: isCustom ? 'custom' : (filter.range == 'custom' ? '30d' : filter.range),
          groupBy: filter.groupBy,
          startDate: isCustom ? filter.startDate : null,
          endDate: isCustom ? filter.endDate : null,
          storeId: storeId,
        ),
      );
});
