import '../../../../core/network/paged_result.dart';
import '../../../../core/utils/json.dart';

class Sale {
  const Sale({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.customerName,
    required this.totalAmount,
    required this.paymentMethod,
    required this.saleDate,
  });

  final String id;
  final String storeId;
  final String storeName;
  final String customerName;
  final double totalAmount;
  final String paymentMethod;
  final DateTime? saleDate;

  factory Sale.fromJson(Map<String, dynamic> json) {
    final store = json['storeId'];
    return Sale(
      id: asId(json['_id'] ?? json['id']),
      storeId: asId(store),
      storeName: store is Map ? asString(store['name']) : '',
      customerName: asString(json['customerName']).isEmpty ? 'Walk-in Guest' : asString(json['customerName']),
      totalAmount: asDouble(json['totalAmount']),
      paymentMethod: asString(json['paymentMethod']),
      saleDate: asDate(json['saleDate']),
    );
  }
}

class Expense {
  const Expense({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.title,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.expenseDate,
    this.receiptUrl,
    this.description,
  });

  final String id;
  final String storeId;
  final String storeName;
  final String title;
  final String category;
  final double amount;
  final String paymentMethod;
  final DateTime? expenseDate;
  final String? receiptUrl;
  final String? description;

  factory Expense.fromJson(Map<String, dynamic> json) {
    final store = json['storeId'];
    return Expense(
      id: asId(json['_id'] ?? json['id']),
      storeId: asId(store),
      storeName: store is Map ? asString(store['name']) : '',
      title: asString(json['title']),
      category: asString(json['category']),
      amount: asDouble(json['amount']),
      paymentMethod: asString(json['paymentMethod']),
      expenseDate: asDate(json['expenseDate']),
      receiptUrl: asString(json['receiptUrl']).isEmpty ? null : asString(json['receiptUrl']),
      description: asString(json['description']).isEmpty ? null : asString(json['description']),
    );
  }
}

class NamedRecord {
  const NamedRecord({required this.id, required this.name, this.isActive = true});

  final String id;
  final String name;
  final bool isActive;

  factory NamedRecord.fromJson(Map<String, dynamic> json) {
    return NamedRecord(
      id: asId(json['_id'] ?? json['id']),
      name: asString(json['name']),
      isActive: asBool(json['isActive'], fallback: true),
    );
  }
}

class CreateSaleInput {
  const CreateSaleInput({
    required this.storeId,
    required this.totalAmount,
    required this.paymentMethod,
    this.customerName,
  });

  final String storeId;
  final double totalAmount;
  final String paymentMethod;
  final String? customerName;
}

class CreateExpenseInput {
  const CreateExpenseInput({
    required this.storeId,
    required this.title,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.expenseDate,
    this.description,
    this.receiptPath,
  });

  final String storeId;
  final String title;
  final String category;
  final double amount;
  final String paymentMethod;
  final String expenseDate;
  final String? description;
  final String? receiptPath;
}

abstract class SalesRepository {
  Future<PagedResult<Sale>> list({int page = 1, String? search, String? storeId});
  Future<Sale> create(CreateSaleInput input);
  Future<void> delete(String id);
}

abstract class ExpensesRepository {
  Future<PagedResult<Expense>> list({int page = 1, String? search, String? storeId});
  Future<Expense> create(CreateExpenseInput input);
  Future<void> delete(String id);
}

abstract class CatalogRepository {
  Future<PagedResult<NamedRecord>> expenseCategories({int page = 1, int limit = 50, String? search});
  Future<NamedRecord> createCategory(String name, {bool isActive = true});
  Future<NamedRecord> updateCategory(String id, {String? name, bool? isActive});
  Future<void> deleteCategory(String id);

  Future<PagedResult<NamedRecord>> paymentMethods({int page = 1, int limit = 50, String? search, String? status});
  Future<NamedRecord> createPaymentMethod(String name, {bool isActive = true});
  Future<NamedRecord> updatePaymentMethod(String id, {String? name, bool? isActive});
  Future<void> deletePaymentMethod(String id);
}
