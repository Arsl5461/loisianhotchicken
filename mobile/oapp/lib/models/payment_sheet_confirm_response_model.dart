import 'package:OApp/models/user_model.dart';

class PaymentSheetConfirmResponseModel {
  final bool success;
  final String message;
  final PaymentSheetConfirmData data;

  PaymentSheetConfirmResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentSheetConfirmResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentSheetConfirmResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: PaymentSheetConfirmData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }
}

class PaymentSheetConfirmData {
  final String subscriptionId;
  final String subscriptionStatus;
  final String paymentStatus;
  final bool activated;
  final Subscription? subscription;

  PaymentSheetConfirmData({
    required this.subscriptionId,
    required this.subscriptionStatus,
    required this.paymentStatus,
    required this.activated,
    required this.subscription,
  });

  factory PaymentSheetConfirmData.fromJson(Map<String, dynamic> json) {
    return PaymentSheetConfirmData(
      subscriptionId: json['subscriptionId'] as String? ?? '',
      subscriptionStatus: json['subscriptionStatus'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      activated: json['activated'] as bool? ?? false,
      subscription: json['subscription'] is Map<String, dynamic>
          ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : null,
    );
  }
}
