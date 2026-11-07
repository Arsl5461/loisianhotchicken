import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/paged_result.dart';
import '../../../core/utils/json.dart';

class BorrowingPayment {
  const BorrowingPayment({
    required this.amount,
    required this.paidDate,
    this.note,
  });

  final double amount;
  final DateTime? paidDate;
  final String? note;

  factory BorrowingPayment.fromJson(Map<String, dynamic> json) {
    return BorrowingPayment(
      amount: asDouble(json['amount']),
      paidDate: asDate(json['paidDate']),
      note: asString(json['note']).isEmpty ? null : asString(json['note']),
    );
  }
}

class Borrowing {
  const Borrowing({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.lender,
    required this.amount,
    required this.amountPaid,
    required this.amountOwed,
    required this.status,
    required this.borrowedDate,
    this.note,
    this.payments = const [],
  });

  final String id;
  final String storeId;
  final String storeName;
  final String lender;
  final double amount;
  final double amountPaid;
  final double amountOwed;
  final String status;
  final DateTime? borrowedDate;
  final String? note;
  final List<BorrowingPayment> payments;

  bool get isOpen => status.toUpperCase() != 'PAID';

  factory Borrowing.fromJson(Map<String, dynamic> json) {
    final store = json['storeId'];
    return Borrowing(
      id: asId(json['_id'] ?? json['id']),
      storeId: asId(store),
      storeName: store is Map ? asString(store['name']) : '',
      lender: asString(json['lender']),
      amount: asDouble(json['amount']),
      amountPaid: asDouble(json['amountPaid']),
      amountOwed: asDouble(json['amountOwed']),
      status: asString(json['status']),
      borrowedDate: asDate(json['borrowedDate']),
      note: asString(json['note']).isEmpty ? null : asString(json['note']),
      payments: asList(json['payments'])
          .whereType<Map>()
          .map((item) => BorrowingPayment.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}

class CreateBorrowingInput {
  const CreateBorrowingInput({
    required this.storeId,
    required this.lender,
    required this.amount,
    required this.borrowedDate,
    this.note,
  });

  final String storeId;
  final String lender;
  final double amount;
  final String borrowedDate;
  final String? note;
}

class RepayBorrowingInput {
  const RepayBorrowingInput({
    required this.amount,
    required this.paidDate,
    this.note,
  });

  final double amount;
  final String paidDate;
  final String? note;
}

abstract class BorrowingsRepository {
  Future<PagedResult<Borrowing>> list({int page = 1, String? search, String? storeId, String? status});
  Future<Borrowing> create(CreateBorrowingInput input);
  Future<Borrowing> repay(String id, RepayBorrowingInput input);
  Future<void> delete(String id);
}

class BorrowingsRepositoryImpl implements BorrowingsRepository {
  BorrowingsRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<PagedResult<Borrowing>> list({int page = 1, String? search, String? storeId, String? status}) async {
    final envelope = await _client.get(
      ApiPaths.borrowings,
      query: {
        'page': page,
        'limit': 20,
        'search': search,
        'storeId': storeId,
        'status': status,
        'sortBy': 'borrowedDate',
        'sortOrder': 'desc',
      },
    );
    return parsePaged(envelope.data, envelope.meta, Borrowing.fromJson);
  }

  @override
  Future<Borrowing> create(CreateBorrowingInput input) async {
    final envelope = await _client.post(
      ApiPaths.borrowings,
      data: {
        'storeId': input.storeId,
        'lender': input.lender,
        'amount': input.amount,
        'borrowedDate': input.borrowedDate,
        if (input.note != null && input.note!.isNotEmpty) 'note': input.note,
      },
    );
    return Borrowing.fromJson(asMap(envelope.data));
  }

  @override
  Future<Borrowing> repay(String id, RepayBorrowingInput input) async {
    final envelope = await _client.post(
      '${ApiPaths.borrowings}/$id/repay',
      data: {
        'amount': input.amount,
        'paidDate': input.paidDate,
        if (input.note != null && input.note!.isNotEmpty) 'note': input.note,
      },
    );
    return Borrowing.fromJson(asMap(envelope.data));
  }

  @override
  Future<void> delete(String id) => _client.delete('${ApiPaths.borrowings}/$id');
}
