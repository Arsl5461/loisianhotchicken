import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/json.dart';
import '../../dashboard/domain/entities/dashboard_overview.dart';

class ProfitLossReport {
  const ProfitLossReport({
    required this.grossRevenue,
    required this.totalExpenses,
    required this.netProfit,
    required this.profitMargin,
    required this.series,
  });

  final double grossRevenue;
  final double totalExpenses;
  final double netProfit;
  final double profitMargin;
  final List<RevenuePoint> series;

  factory ProfitLossReport.fromJson(Map<String, dynamic> json) {
    final summary = asMap(json['summary']);
    return ProfitLossReport(
      grossRevenue: asDouble(summary['grossRevenue']),
      totalExpenses: asDouble(summary['totalExpenses']),
      netProfit: asDouble(summary['netProfit']),
      profitMargin: asDouble(summary['profitMargin']),
      series: asList(json['series']).whereType<Map>().map((item) => RevenuePoint.fromJson(Map<String, dynamic>.from(item))).toList(),
    );
  }
}

class TenderReport {
  const TenderReport({required this.month, required this.rows, required this.totals});

  final String month;
  final List<TenderRow> rows;
  final TenderRow totals;

  factory TenderReport.fromJson(Map<String, dynamic> json) {
    return TenderReport(
      month: asString(json['month']),
      rows: asList(json['rows']).whereType<Map>().map((item) => TenderRow.fromJson(Map<String, dynamic>.from(item))).toList(),
      totals: TenderRow.fromJson(asMap(json['totals'])),
    );
  }
}

class TenderRow {
  const TenderRow({required this.tenderType, required this.salesTotal, required this.refundTotal, required this.amountCollected});

  final String tenderType;
  final double salesTotal;
  final double refundTotal;
  final double amountCollected;

  factory TenderRow.fromJson(Map<String, dynamic> json) {
    return TenderRow(
      tenderType: asString(json['tenderType']).isEmpty ? 'Totals' : asString(json['tenderType']),
      salesTotal: asDouble(json['salesTotal']),
      refundTotal: asDouble(json['refundTotal']),
      amountCollected: asDouble(json['amountCollected']),
    );
  }
}

class IncomeExpenseStatement {
  const IncomeExpenseStatement({
    required this.start,
    required this.end,
    required this.totalSales,
    required this.totalExpenses,
    required this.operatingProfit,
    required this.profitMargin,
    required this.revenueSources,
    required this.expenseCategories,
  });

  final DateTime? start;
  final DateTime? end;
  final double totalSales;
  final double totalExpenses;
  final double operatingProfit;
  final double profitMargin;
  final List<NamedAmount> revenueSources;
  final List<NamedAmount> expenseCategories;

  factory IncomeExpenseStatement.fromJson(Map<String, dynamic> json) {
    return IncomeExpenseStatement(
      start: asDate(json['start']),
      end: asDate(json['end']),
      totalSales: asDouble(json['totalSales']),
      totalExpenses: asDouble(json['totalExpenses']),
      operatingProfit: asDouble(json['operatingProfit']),
      profitMargin: asDouble(json['profitMargin']),
      revenueSources: asList(json['revenueSources']).whereType<Map>().map((item) => NamedAmount.fromJson(Map<String, dynamic>.from(item))).toList(),
      expenseCategories: asList(json['expenseCategories']).whereType<Map>().map((item) => NamedAmount.fromJson(Map<String, dynamic>.from(item))).toList(),
    );
  }
}

class NamedAmount {
  const NamedAmount({required this.name, required this.amount, this.count = 0});
  final String name;
  final double amount;
  final int count;

  factory NamedAmount.fromJson(Map<String, dynamic> json) {
    return NamedAmount(
      name: asString(json['name'] ?? json['category']),
      amount: asDouble(json['amount']),
      count: asInt(json['count']),
    );
  }
}

abstract class ReportsRepository {
  Future<ProfitLossReport> profitLoss({required String range, String? storeId, String? groupBy});
  Future<TenderReport> tenderTypes({String? month, String? storeId, String? startDate, String? endDate});
  Future<IncomeExpenseStatement> statement({String? storeId, String? startDate, String? endDate, String? month});
}

class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<ProfitLossReport> profitLoss({required String range, String? storeId, String? groupBy}) async {
    final envelope = await _client.get(ApiPaths.profitLoss, query: {'range': range, 'storeId': storeId, 'groupBy': groupBy});
    return ProfitLossReport.fromJson(asMap(envelope.data));
  }

  @override
  Future<TenderReport> tenderTypes({String? month, String? storeId, String? startDate, String? endDate}) async {
    final envelope = await _client.get(ApiPaths.tenderTypes, query: {
      'month': month,
      'storeId': storeId,
      'startDate': startDate,
      'endDate': endDate,
    });
    return TenderReport.fromJson(asMap(envelope.data));
  }

  @override
  Future<IncomeExpenseStatement> statement({String? storeId, String? startDate, String? endDate, String? month}) async {
    final envelope = await _client.get(ApiPaths.incomeExpenseStatement, query: {
      'storeId': storeId,
      'startDate': startDate,
      'endDate': endDate,
      'month': month,
    });
    return IncomeExpenseStatement.fromJson(asMap(envelope.data));
  }
}
