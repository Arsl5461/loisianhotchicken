import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../dashboard/presentation/widgets/admin_shell.dart';
import '../providers/reports_providers.dart';

class ProfitLossScreen extends ConsumerWidget {
  const ProfitLossScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(profitLossRangeProvider);
    final async = ref.watch(profitLossProvider);
    return AdminScaffold(
      title: 'Profit & Loss',
      actions: const [StoreFilterButton()],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DropdownButtonFormField<String>(
              initialValue: range,
              items: const [
                DropdownMenuItem(value: '7d', child: Text('7 days')),
                DropdownMenuItem(value: '30d', child: Text('30 days')),
                DropdownMenuItem(value: '3m', child: Text('Quarter')),
                DropdownMenuItem(value: 'ytd', child: Text('This year')),
              ],
              onChanged: (value) => ref.read(profitLossRangeProvider.notifier).state = value ?? '30d',
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(profitLossProvider)),
              data: (report) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _metric('Gross revenue', money(report.grossRevenue)),
                  _metric('Total expenses', money(report.totalExpenses)),
                  _metric('Net profit', money(report.netProfit)),
                  _metric('Profit margin', percent(report.profitMargin)),
                  const SizedBox(height: 12),
                  AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Series', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        if (report.series.isEmpty) const Text('No P&L data for this range.', style: TextStyle(color: AppColors.muted)),
                        ...report.series.map(
                          (point) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(point.label),
                            subtitle: Text('Rev ${money(point.revenue)} · Exp ${money(point.expenses)}'),
                            trailing: Text(money(point.netProfit), style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AdminCard(
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: AppColors.muted))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(reportPeriodProvider);
    final async = ref.watch(reportsStatementProvider);
    return AdminScaffold(
      title: 'Reports',
      subtitle: '${period.startDate} – ${period.endDate}',
      actions: const [StoreFilterButton()],
      body: async.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(reportsStatementProvider)),
        data: (statement) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AdminCard(
              child: Column(
                children: [
                  _row('Total sales', money(statement.totalSales)),
                  _row('Total expenses', money(statement.totalExpenses)),
                  _row('Operating profit', money(statement.operatingProfit)),
                  _row('Profit margin', percent(statement.profitMargin)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Revenue sources', style: TextStyle(fontWeight: FontWeight.w700)),
                  ...statement.revenueSources.map((item) => ListTile(contentPadding: EdgeInsets.zero, title: Text(item.name), trailing: Text(money(item.amount)))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expense categories', style: TextStyle(fontWeight: FontWeight.w700)),
                  ...statement.expenseCategories.map((item) => ListTile(contentPadding: EdgeInsets.zero, title: Text(item.name), trailing: Text(money(item.amount)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class TenderTypesScreen extends ConsumerWidget {
  const TenderTypesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(tenderMonthProvider);
    final async = ref.watch(tenderReportProvider);
    return AdminScaffold(
      title: 'Tender types',
      subtitle: month,
      actions: const [StoreFilterButton()],
      body: async.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString(), onRetry: () => ref.invalidate(tenderReportProvider)),
        data: (report) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (report.rows.isEmpty) const EmptyStateView(title: 'No tender activity', message: 'No collections for this month.'),
            ...report.rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AdminCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(row.tenderType, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('Sales ${money(row.salesTotal)}'),
                      Text('Refunds ${money(row.refundTotal)}'),
                      Text('Collected ${money(row.amountCollected)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
            AdminCard(
              child: Text(
                'Totals ${money(report.totals.amountCollected)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
