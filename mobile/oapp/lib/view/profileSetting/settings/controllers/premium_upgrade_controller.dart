import 'dart:async';
import 'package:OApp/view/messages/controller/chat_list_controller.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:OApp/utils/toast.dart';

import '../../../../config/app_config.dart';
import '../../../../data/repositories/payment_repository.dart';
import '../../controller/profile_display_controller.dart';

class PremiumUpgradeController extends GetxController {
  final PaymentRepository _paymentRepo = Get.find<PaymentRepository>();
  final ProfileDisplayController profileDisplayController =
      Get.find<ProfileDisplayController>();
  final ChatListController chatListController = Get.find<ChatListController>();
  final AppLinks _appLinks = AppLinks();
  RxInt selectedPlan = 0.obs;
  RxBool isLoading = false.obs;

  StreamSubscription<Uri?>? linkSub;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map && args['selectedPlan'] is int) {
      selectedPlan.value = args['selectedPlan'];
    } else if (Get.parameters['selectedPlan'] != null) {
      final p = int.tryParse(Get.parameters['selectedPlan']!);
      if (p != null) selectedPlan.value = p;
    }

    initDeepLinks();
  }

  @override
  void onClose() {
    linkSub?.cancel();
    super.onClose();
  }

  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  String? get selectedPlanType {
    switch (selectedPlan.value) {
      case 1:
        return 'standard';
      case 2:
        return 'premium';
      default:
        return null;
    }
  }

  String get ctaText {
    switch (selectedPlan.value) {
      case 0:
        return "Continue with Free";
      case 1:
        return "Subscribe to Standard";
      case 2:
        return "Subscribe to Premium";
      default:
        return "Continue";
    }
  }

  String get currentPlanLabel {
    return profileDisplayController.getPremiumTierLabel();
  }

  void initDeepLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handlePaymentUri(initialUri);
      }

      linkSub = _appLinks.uriLinkStream.listen((Uri uri) {
        _handlePaymentUri(uri);
      });
    } catch (_) {
      // Keep checkout available even if link listening is unavailable.
    }
  }

  void _handlePaymentUri(Uri uri) {
    if (uri.scheme != 'oapp' || uri.host != 'payment') {
      return;
    }

    if (uri.path.contains('success')) {
      onCheckoutSuccess();
    } else if (uri.path.contains('cancel')) {
      onCheckoutCancel();
    }
  }

  Future<void> startCheckoutFlow() async {
    final planType = selectedPlanType;
    if (planType == null) {
      Toast.info("Select a paid plan to continue.");
      return;
    }
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final sheetResult = await _paymentRepo.createPaymentSheet(planType);

      if (!sheetResult.isSuccess) {
        Toast.error(
          sheetResult.errorMessage ?? "Unable to prepare payment.",
        );
        return;
      }

      final credentials = sheetResult.credentials!;

      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            merchantDisplayName: 'OApp',
            paymentIntentClientSecret: credentials.paymentIntent,
            customerId: credentials.customerId,
            customerEphemeralKeySecret: credentials.ephemeralKey,
            returnURL: AppConfig.stripeReturnUrl,
            style: ThemeMode.light,
            applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
            googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
            ),
            billingDetailsCollectionConfiguration:
                const BillingDetailsCollectionConfiguration(
                  name: CollectionMode.automatic,
                  email: CollectionMode.automatic,
                ),
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        await _confirmPaymentSheet(credentials.subscriptionId);
      } on StripeException catch (e) {
        final errorCode = e.error.code;
        if (errorCode == FailureCode.Canceled) {
          onCheckoutCancel();
          return;
        }

        Toast.error(
          e.error.localizedMessage ?? "Unable to complete Stripe payment.",
        );
      }
    } catch (_) {
      Toast.error("Failed to start payment.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _confirmPaymentSheet(String subscriptionId) async {
    final confirmData = await _paymentRepo.confirmPaymentSheet(subscriptionId);

    if (confirmData != null) {
      final subscription = confirmData.data.subscription;
      if (subscription != null) {
        profileDisplayController.updateLocalSubscription(subscription);
        chatListController.refreshChatList();
      }

      if (confirmData.data.activated) {
        Toast.success(confirmData.message);
        await onCheckoutSuccess(showPendingMessage: false, showDialog: true);
        return;
      }

      Toast.info(
        confirmData.message.isNotEmpty
            ? confirmData.message
            : "Payment completed, but activation is pending.",
      );
      await onCheckoutSuccess(showPendingMessage: false);
      return;
    }

    Toast.error("Payment completed, but activation is pending.");
    await onCheckoutSuccess(showPendingMessage: false);
  }

  Future<void> onCheckoutSuccess({
    bool showPendingMessage = false,
    bool showDialog = false,
  }) async {
    if (showPendingMessage) {
      Toast.success("Payment submitted. Verifying your premium access...");
    }

    if (Get.isRegistered<ProfileDisplayController>()) {
      await profileDisplayController.fetchUserProfile();
      chatListController.refreshChatList();
    }

    if (showDialog || profileDisplayController.isPremiumActive) {
      showUpgradeDialog();
      return;
    }

    Toast.info(
      "Your payment was received. Premium will appear after Stripe webhook confirmation.",
    );
  }

  void onCheckoutCancel() {
    Toast.info("Payment was canceled.");
  }

  void showUpgradeDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 60),

              const SizedBox(height: 20),

              const Text(
                "Premium Activated!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              const Text(
                "Welcome to premium! You now have access to all premium features.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
