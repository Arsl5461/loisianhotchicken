import 'package:OApp/core/dio_service/dio_service.dart';
import 'package:OApp/core/network/end_points.dart';
import 'package:OApp/data/repositories/settings_repository.dart';
import 'package:OApp/models/payment_sheet_confirm_response_model.dart';
import 'package:OApp/models/settings_models.dart';
import 'package:get/get.dart';

class PaymentSheetCredentials {
  final String customerId;
  final String ephemeralKey;
  final String paymentIntent;
  final String subscriptionId;

  const PaymentSheetCredentials({
    required this.customerId,
    required this.ephemeralKey,
    required this.paymentIntent,
    required this.subscriptionId,
  });

  bool get isValid =>
      customerId.isNotEmpty &&
      ephemeralKey.isNotEmpty &&
      paymentIntent.isNotEmpty &&
      subscriptionId.isNotEmpty;
}

class PaymentSheetCreateResult {
  final int? statusCode;
  final PaymentSheetCredentials? credentials;
  final String? errorMessage;

  const PaymentSheetCreateResult({
    this.statusCode,
    this.credentials,
    this.errorMessage,
  });

  bool get isSuccess => statusCode == 200 && credentials?.isValid == true;
}

class PaymentRepository {
  PaymentRepository({NetworkManager? api})
      : _api = api ?? Get.find<NetworkManager>();

  final NetworkManager _api;

  static PaymentSheetCredentials? parsePaymentSheetResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    return PaymentSheetCredentials(
      customerId: data['customer']?.toString() ?? '',
      ephemeralKey: data['ephemeralKey']?.toString() ?? '',
      paymentIntent: data['paymentIntent']?.toString() ?? '',
      subscriptionId: data['subscriptionId']?.toString() ?? '',
    );
  }

  static PaymentSheetConfirmResponseModel? parseConfirmResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    return PaymentSheetConfirmResponseModel.fromJson(data);
  }

  static String? parseErrorMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }

  static String _messageFrom(dynamic data, String fallback) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return fallback;
  }

  Future<SettingsResult<List<PaymentMethodModel>>> fetchPaymentMethods() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.paymentMethods,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load your cards'),
        response?.statusCode,
      );
    }

    final list = response!.data['methods'];
    return SettingsResult.success(
      list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(PaymentMethodModel.fromJson)
              .toList()
          : const [],
    );
  }

  Future<SettingsResult<bool>> addPaymentMethod(
    String paymentMethodId, {
    bool makeDefault = true,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.paymentMethods,
      body: {'paymentMethodId': paymentMethodId, 'makeDefault': makeDefault},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 && response?.statusCode != 201) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not add that card'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<bool>> deletePaymentMethod(String methodId) async {
    final response = await _api.callApi(
      method: HttpMethod.Delete,
      urlEndPoint: EndPoints.paymentMethod(methodId),
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not remove that card'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<bool>> setDefaultPaymentMethod(String methodId) async {
    final response = await _api.callApi(
      method: HttpMethod.Put,
      urlEndPoint: EndPoints.defaultPaymentMethod(methodId),
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not set the default card'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<List<PlanCatalogEntry>>> fetchPlans() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.paymentPlans,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load the plans'),
        response?.statusCode,
      );
    }

    final data = response?.data;
    final list = data is Map ? (data['plans'] ?? data['data']) : data;
    if (list is! List) {
      return const SettingsResult.failure('Could not read the plans');
    }

    return SettingsResult.success([
      for (final entry in list)
        if (entry is Map<String, dynamic>) PlanCatalogEntry.fromJson(entry),
    ]);
  }

  Future<SettingsResult<bool>> updatePaymentMethodBilling(
    String methodId,
    Map<String, dynamic> billingDetails,
  ) async {
    final response = await _api.callApi(
      method: HttpMethod.Put,
      urlEndPoint: '${EndPoints.paymentMethods}/$methodId',
      body: {'billingDetails': billingDetails},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not save that billing address'),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<SettingsResult<List<PurchaseModel>>> fetchPurchaseHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.purchaseHistory,
      queryParameters: {'page': page, 'limit': limit},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load your purchases'),
        response?.statusCode,
      );
    }

    final list = response!.data['transactions'];
    return SettingsResult.success(
      list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(PurchaseModel.fromJson)
              .toList()
          : const [],
    );
  }

  Future<SettingsResult<PurchaseModel>> fetchPurchase(String id) async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.purchaseDetail(id),
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load that order'),
        response?.statusCode,
      );
    }

    final payload = response!.data['transaction'];
    if (payload is! Map<String, dynamic>) {
      return const SettingsResult.failure('Could not read that order');
    }

    return SettingsResult.success(PurchaseModel.fromJson(payload));
  }

  Future<SettingsResult<SubscriptionModel>> fetchSubscription() async {
    final response = await _api.callApi(
      method: HttpMethod.Get,
      urlEndPoint: EndPoints.subscription,
      returnRawResponse: true,
    );

    if (response?.statusCode != 200 || response?.data is! Map) {
      return SettingsResult.failure(
        _messageFrom(response?.data, 'Could not load your membership'),
        response?.statusCode,
      );
    }

    final payload = response!.data['subscription'];
    return SettingsResult.success(
      SubscriptionModel.fromJson(
        payload is Map<String, dynamic> ? payload : {},
      ),
    );
  }

  Future<SettingsResult<bool>> setSubscriptionRenewal(bool autoRenew) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: autoRenew
          ? EndPoints.resumeSubscription
          : EndPoints.cancelSubscription,
      body: const {},
      returnRawResponse: true,
    );

    if (response?.statusCode != 200) {
      return SettingsResult.failure(
        _messageFrom(
          response?.data,
          autoRenew
              ? 'Could not resume your membership'
              : 'Could not cancel your membership',
        ),
        response?.statusCode,
      );
    }

    return const SettingsResult.success(true);
  }

  Future<PaymentSheetCreateResult> createPaymentSheet(String planType) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.createPaymentSheet,
      body: {'planType': planType},
      returnRawResponse: true,
    );

    if (response == null) {
      return const PaymentSheetCreateResult();
    }

    return PaymentSheetCreateResult(
      statusCode: response.statusCode,
      credentials: parsePaymentSheetResponse(response.data),
      errorMessage: parseErrorMessage(response.data),
    );
  }

  Future<PaymentSheetConfirmResponseModel?> confirmPaymentSheet(
    String subscriptionId,
  ) async {
    final response = await _api.callApi(
      method: HttpMethod.Post,
      urlEndPoint: EndPoints.confirmPaymentSheet,
      body: {'subscriptionId': subscriptionId},
      returnRawResponse: true,
    );

    if (response?.data == null) return null;

    return parseConfirmResponse(response!.data);
  }
}
