import 'package:dio/dio.dart';

import '../../../../core/constants/api_paths.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paged_result.dart';
import '../../../../core/utils/json.dart';
import '../../domain/entities/finance_records.dart';

class SalesRepositoryImpl implements SalesRepository {
  SalesRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<PagedResult<Sale>> list({int page = 1, String? search, String? storeId}) async {
    final envelope = await _client.get(
      ApiPaths.sales,
      query: {'page': page, 'limit': 20, 'search': search, 'storeId': storeId, 'sortBy': 'saleDate', 'sortOrder': 'desc'},
    );
    return parsePaged(envelope.data, envelope.meta, Sale.fromJson);
  }

  @override
  Future<Sale> create(CreateSaleInput input) async {
    final envelope = await _client.post(ApiPaths.sales, data: {
      'storeId': input.storeId,
      'totalAmount': input.totalAmount,
      'paymentMethod': input.paymentMethod,
      'customerName': input.customerName,
    });
    return Sale.fromJson(asMap(envelope.data));
  }

  @override
  Future<void> delete(String id) => _client.delete('${ApiPaths.sales}/$id');
}

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<PagedResult<Expense>> list({int page = 1, String? search, String? storeId}) async {
    final envelope = await _client.get(
      ApiPaths.expenses,
      query: {'page': page, 'limit': 20, 'search': search, 'storeId': storeId, 'sortBy': 'expenseDate', 'sortOrder': 'desc'},
    );
    return parsePaged(envelope.data, envelope.meta, Expense.fromJson);
  }

  @override
  Future<Expense> create(CreateExpenseInput input) async {
    final envelope = await _client.post(
      ApiPaths.expenses,
      data: FormData.fromMap({
        'storeId': input.storeId,
        'title': input.title,
        'category': input.category,
        'amount': input.amount,
        'paymentMethod': input.paymentMethod,
        'expenseDate': input.expenseDate,
        if (input.description != null) 'description': input.description,
        if (input.receiptPath != null)
          'receipt': await MultipartFile.fromFile(input.receiptPath!, filename: input.receiptPath!.split('/').last),
      }),
    );
    return Expense.fromJson(asMap(envelope.data));
  }

  @override
  Future<void> delete(String id) => _client.delete('${ApiPaths.expenses}/$id');
}

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<PagedResult<NamedRecord>> expenseCategories({int page = 1, int limit = 50, String? search}) async {
    final envelope = await _client.get(
      ApiPaths.expenseCategories,
      query: {'page': page, 'limit': limit, 'search': search, 'sortBy': 'name', 'sortOrder': 'asc'},
    );
    return parsePaged(envelope.data, envelope.meta, NamedRecord.fromJson);
  }

  @override
  Future<NamedRecord> createCategory(String name, {bool isActive = true}) async {
    final envelope = await _client.post(ApiPaths.expenseCategories, data: {'name': name, 'isActive': isActive});
    return NamedRecord.fromJson(asMap(envelope.data));
  }

  @override
  Future<NamedRecord> updateCategory(String id, {String? name, bool? isActive}) async {
    final envelope = await _client.patch('${ApiPaths.expenseCategories}/$id', data: {
      if (name != null) 'name': name,
      if (isActive != null) 'isActive': isActive,
    });
    return NamedRecord.fromJson(asMap(envelope.data));
  }

  @override
  Future<void> deleteCategory(String id) => _client.delete('${ApiPaths.expenseCategories}/$id');

  @override
  Future<PagedResult<NamedRecord>> paymentMethods({int page = 1, int limit = 50, String? search, String? status}) async {
    final envelope = await _client.get(
      ApiPaths.paymentMethods,
      query: {'page': page, 'limit': limit, 'search': search, 'status': status, 'sortBy': 'name', 'sortOrder': 'asc'},
    );
    return parsePaged(envelope.data, envelope.meta, NamedRecord.fromJson);
  }

  @override
  Future<NamedRecord> createPaymentMethod(String name, {bool isActive = true}) async {
    final envelope = await _client.post(ApiPaths.paymentMethods, data: {'name': name, 'isActive': isActive});
    return NamedRecord.fromJson(asMap(envelope.data));
  }

  @override
  Future<NamedRecord> updatePaymentMethod(String id, {String? name, bool? isActive}) async {
    final envelope = await _client.patch('${ApiPaths.paymentMethods}/$id', data: {
      if (name != null) 'name': name,
      if (isActive != null) 'isActive': isActive,
    });
    return NamedRecord.fromJson(asMap(envelope.data));
  }

  @override
  Future<void> deletePaymentMethod(String id) => _client.delete('${ApiPaths.paymentMethods}/$id');
}
