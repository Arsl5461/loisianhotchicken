import '../../../../core/constants/api_paths.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/json.dart';
import '../../domain/entities/dashboard_overview.dart';

abstract class DashboardRepository {
  Future<DashboardOverview> overview(DateRangeQuery query);
}

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<DashboardOverview> overview(DateRangeQuery query) async {
    final envelope = await _client.get(ApiPaths.dashboardOverview, query: query.toQuery());
    return DashboardOverview.fromJson(asMap(envelope.data));
  }
}
