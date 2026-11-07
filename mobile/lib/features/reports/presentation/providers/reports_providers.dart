import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/timezone.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../stores/presentation/providers/store_selection_provider.dart';
import '../../data/reports_repository.dart';

final reportsRepositoryProvider = Provider((ref) => ReportsRepositoryImpl(ref.watch(apiClientProvider)));

final profitLossRangeProvider = StateProvider<String>((ref) => '30d');

final profitLossProvider = FutureProvider.autoDispose<ProfitLossReport>((ref) {
  final range = ref.watch(profitLossRangeProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  final groupBy = range == 'ytd' || range == '6m' ? 'month' : range == '3m' ? 'week' : 'day';
  return ref.watch(reportsRepositoryProvider).profitLoss(range: range, storeId: storeId, groupBy: groupBy);
});

class ReportPeriod {
  const ReportPeriod({required this.startDate, required this.endDate});
  final String startDate;
  final String endDate;
}

ReportPeriod currentMonthPeriod() {
  final now = AppTimezone.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 0);
  return ReportPeriod(
    startDate: AppTimezone.toYmd(start),
    endDate: AppTimezone.toYmd(end),
  );
}

final reportPeriodProvider = StateProvider<ReportPeriod>((ref) => currentMonthPeriod());

final reportsStatementProvider = FutureProvider.autoDispose<IncomeExpenseStatement>((ref) {
  final period = ref.watch(reportPeriodProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  return ref.watch(reportsRepositoryProvider).statement(
        storeId: storeId,
        startDate: period.startDate,
        endDate: period.endDate,
      );
});

final tenderMonthProvider = StateProvider<String>((ref) => AppTimezone.currentMonth());

final tenderReportProvider = FutureProvider.autoDispose<TenderReport>((ref) {
  final month = ref.watch(tenderMonthProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  return ref.watch(reportsRepositoryProvider).tenderTypes(month: month, storeId: storeId);
});
