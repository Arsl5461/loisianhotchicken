import '../../../../core/utils/json.dart';

class DashboardOverview {
  const DashboardOverview({
    required this.summary,
    required this.revenueVsExpense,
    required this.profitLossData,
    required this.expenseBreakdown,
    required this.storePerformance,
    required this.recentTransactions,
    required this.topExpenses,
  });

  final DashboardSummary summary;
  final List<RevenuePoint> revenueVsExpense;
  final List<RevenuePoint> profitLossData;
  final List<ExpenseSlice> expenseBreakdown;
  final List<StorePerformance> storePerformance;
  final List<RecentTransaction> recentTransactions;
  final List<TopExpense> topExpenses;

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      summary: DashboardSummary.fromJson(asMap(json['summary'])),
      revenueVsExpense: asList(json['revenueVsExpense']).whereType<Map>().map((item) => RevenuePoint.fromJson(Map<String, dynamic>.from(item))).toList(),
      profitLossData: asList(json['profitLossData']).whereType<Map>().map((item) => RevenuePoint.fromJson(Map<String, dynamic>.from(item))).toList(),
      expenseBreakdown: asList(json['expenseBreakdown']).whereType<Map>().map((item) => ExpenseSlice.fromJson(Map<String, dynamic>.from(item))).toList(),
      storePerformance: asList(json['storePerformance']).whereType<Map>().map((item) => StorePerformance.fromJson(Map<String, dynamic>.from(item))).toList(),
      recentTransactions: asList(json['recentTransactions']).whereType<Map>().map((item) => RecentTransaction.fromJson(Map<String, dynamic>.from(item))).toList(),
      topExpenses: asList(json['topExpenses']).whereType<Map>().map((item) => TopExpense.fromJson(Map<String, dynamic>.from(item))).toList(),
    );
  }
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netProfit,
    required this.totalOrders,
    required this.activeStores,
    required this.profitMargin,
    required this.revenueGrowth,
    required this.expenseGrowth,
    required this.profitGrowth,
    required this.ordersGrowth,
  });

  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;
  final int totalOrders;
  final int activeStores;
  final double profitMargin;
  final double revenueGrowth;
  final double expenseGrowth;
  final double profitGrowth;
  final double ordersGrowth;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalRevenue: asDouble(json['totalRevenue']),
      totalExpenses: asDouble(json['totalExpenses']),
      netProfit: asDouble(json['netProfit']),
      totalOrders: asInt(json['totalOrders']),
      activeStores: asInt(json['activeStores']),
      profitMargin: asDouble(json['profitMargin']),
      revenueGrowth: asDouble(json['revenueGrowth']),
      expenseGrowth: asDouble(json['expenseGrowth']),
      profitGrowth: asDouble(json['profitGrowth']),
      ordersGrowth: asDouble(json['ordersGrowth']),
    );
  }
}

class RevenuePoint {
  const RevenuePoint({required this.label, required this.revenue, required this.expenses, required this.netProfit});

  final String label;
  final double revenue;
  final double expenses;
  final double netProfit;

  factory RevenuePoint.fromJson(Map<String, dynamic> json) {
    return RevenuePoint(
      label: asString(json['date'] ?? json['period']),
      revenue: asDouble(json['revenue']),
      expenses: asDouble(json['expenses']),
      netProfit: asDouble(json['netProfit']),
    );
  }
}

class ExpenseSlice {
  const ExpenseSlice({required this.category, required this.amount, required this.percentage});
  final String category;
  final double amount;
  final double percentage;

  factory ExpenseSlice.fromJson(Map<String, dynamic> json) {
    return ExpenseSlice(
      category: asString(json['category']),
      amount: asDouble(json['amount']),
      percentage: asDouble(json['percentage']),
    );
  }
}

class StorePerformance {
  const StorePerformance({
    required this.storeId,
    required this.storeName,
    required this.storeCode,
    required this.revenue,
    required this.expenses,
    required this.profit,
    required this.orders,
    required this.rank,
  });

  final String storeId;
  final String storeName;
  final String storeCode;
  final double revenue;
  final double expenses;
  final double profit;
  final int orders;
  final int rank;

  factory StorePerformance.fromJson(Map<String, dynamic> json) {
    return StorePerformance(
      storeId: asId(json['storeId']),
      storeName: asString(json['storeName']),
      storeCode: asString(json['storeCode']),
      revenue: asDouble(json['revenue']),
      expenses: asDouble(json['expenses']),
      profit: asDouble(json['profit']),
      orders: asInt(json['orders']),
      rank: asInt(json['rank']),
    );
  }
}

class RecentTransaction {
  const RecentTransaction({
    required this.id,
    required this.store,
    required this.description,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
  });

  final String id;
  final String store;
  final String description;
  final String category;
  final String type;
  final double amount;
  final DateTime? date;
  final String status;

  factory RecentTransaction.fromJson(Map<String, dynamic> json) {
    return RecentTransaction(
      id: asId(json['id'] ?? json['_id']),
      store: asString(json['store']),
      description: asString(json['description']),
      category: asString(json['category']),
      type: asString(json['type']),
      amount: asDouble(json['amount']),
      date: asDate(json['date']),
      status: asString(json['status']),
    );
  }
}

class TopExpense {
  const TopExpense({
    required this.id,
    required this.title,
    required this.category,
    required this.store,
    required this.amount,
    required this.date,
  });

  final String id;
  final String title;
  final String category;
  final String store;
  final double amount;
  final DateTime? date;

  factory TopExpense.fromJson(Map<String, dynamic> json) {
    return TopExpense(
      id: asId(json['id'] ?? json['_id']),
      title: asString(json['title']),
      category: asString(json['category']),
      store: asString(json['store']),
      amount: asDouble(json['amount']),
      date: asDate(json['date']),
    );
  }
}

class DateRangeQuery {
  const DateRangeQuery({this.range = '30d', this.groupBy = 'day', this.startDate, this.endDate, this.storeId});

  final String range;
  final String groupBy;
  final String? startDate;
  final String? endDate;
  final String? storeId;

  Map<String, dynamic> toQuery() => {
        'range': range,
        'groupBy': groupBy,
        'startDate': startDate,
        'endDate': endDate,
        'storeId': storeId,
      };
}
