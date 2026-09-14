import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/admin_widgets.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/admin_shell.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _ranges = [
    ('7d', '7 days'),
    ('30d', '30 days'),
    ('3m', '3 months'),
    ('6m', '6 months'),
    ('ytd', 'This year'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(dashboardOverviewProvider);
    final filter = ref.watch(dashboardFilterProvider);
    final user = ref.watch(currentUserProvider);

    return AdminScaffold(
      title: 'Dashboard',
      subtitle: 'Hi ${user?.name.split(' ').first ?? 'Admin'}',
      actions: [
        const StoreFilterButton(),
        IconButton(
          onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
      body: overview.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(dashboardOverviewProvider),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardOverviewProvider),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ranges.map((item) {
                  final selected = filter.range == item.$1;
                  return ChoiceChip(
                    label: Text(item.$2),
                    selected: selected,
                    selectedColor: AppColors.brandRed.withValues(alpha: 0.15),
                    onSelected: (_) => ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(range: item.$1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _KpiGrid(summary: data.summary),
              const SizedBox(height: 16),
              _ChartCard(title: 'Revenue vs expenses', child: _RevenueChart(points: data.revenueVsExpense)),
              const SizedBox(height: 16),
              _ChartCard(title: 'Expense mix', child: _Breakdown(slices: data.expenseBreakdown)),
              const SizedBox(height: 16),
              _StoreRanks(rows: data.storePerformance),
              const SizedBox(height: 16),
              _Recent(items: data.recentTransactions),
              const SizedBox(height: 16),
              _TopExpenses(items: data.topExpenses),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Revenue', money(summary.totalRevenue), growthLabel(summary.revenueGrowth)),
      ('Expenses', money(summary.totalExpenses), growthLabel(summary.expenseGrowth)),
      ('Net profit', money(summary.netProfit), growthLabel(summary.profitGrowth)),
      ('Orders', summary.totalOrders.toString(), growthLabel(summary.ordersGrowth)),
    ];
    return GridView.count(
      crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: items
          .map(
            (item) => AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.$1, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(item.$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(item.$3, style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          SizedBox(height: 220, child: child),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart({required this.points});
  final List<RevenuePoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const EmptyStateView(title: 'No chart data', message: 'Sales and expenses will appear here.');
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].revenue),
            ],
            color: AppColors.brandRed,
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: [
              for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].expenses),
            ],
            color: AppColors.brandOrange,
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.slices});
  final List<ExpenseSlice> slices;

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty) return const EmptyStateView(title: 'No expenses', message: 'Category mix will show once expenses are recorded.');
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 28,
              sections: [
                for (var i = 0; i < slices.length; i++)
                  PieChartSectionData(
                    value: slices[i].amount,
                    title: '',
                    color: [AppColors.brandRed, AppColors.brandOrange, AppColors.brandAmber, AppColors.ink][i % 4],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: slices
                .take(5)
                .map(
                  (slice) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('${slice.category} · ${money(slice.amount)}', style: const TextStyle(fontSize: 13)),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _StoreRanks extends StatelessWidget {
  const _StoreRanks({required this.rows});
  final List<StorePerformance> rows;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Store performance', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          if (rows.isEmpty) const Text('No store metrics for this range.', style: TextStyle(color: AppColors.muted)),
          ...rows.take(5).map(
                (row) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(row.storeName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${row.storeCode} · ${row.orders} orders'),
                  trailing: Text(money(row.profit), style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
        ],
      ),
    );
  }
}

class _Recent extends StatelessWidget {
  const _Recent({required this.items});
  final List<RecentTransaction> items;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent transactions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          if (items.isEmpty) const Text('No recent activity.', style: TextStyle(color: AppColors.muted)),
          ...items.take(8).map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${item.store} · ${formatDate(item.date)}'),
                  trailing: Text(
                    '${item.type == 'EXPENSE' ? '-' : '+'}${money(item.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: item.type == 'EXPENSE' ? AppColors.danger : AppColors.success,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _TopExpenses extends StatelessWidget {
  const _TopExpenses({required this.items});
  final List<TopExpense> items;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top expenses', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          if (items.isEmpty) const Text('No expenses in this range.', style: TextStyle(color: AppColors.muted)),
          ...items.take(5).map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.title),
                  subtitle: Text('${item.category} · ${item.store}'),
                  trailing: Text(money(item.amount), style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
        ],
      ),
    );
  }
}
