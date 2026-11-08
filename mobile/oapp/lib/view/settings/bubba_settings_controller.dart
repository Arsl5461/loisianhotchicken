import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'billing_address_screen.dart';

import '../../config/app_config.dart';
import '../../core/design/widgets/bubba_loading.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../models/settings_models.dart';

/// Part 3's account settings: notification preferences, pause and delete, and
/// the membership and payment reads. Kept apart from
/// `BubbaSecurityController` because the two hubs are separate flows.
class BubbaSettingsController extends GetxController {
  BubbaSettingsController({
    SettingsRepository? repository,
    PaymentRepository? payments,
  })  : _repository = repository ?? Get.find<SettingsRepository>(),
        _payments = payments ?? Get.find<PaymentRepository>();

  final SettingsRepository _repository;
  final PaymentRepository _payments;

  final Rx<NotificationPreferences> notifications =
      const NotificationPreferences().obs;

  final RxBool loading = false.obs;
  final RxBool saving = false.obs;
  final RxnString error = RxnString();

  bool _loadedOnce = false;

  @override
  void onInit() {
    super.onInit();
    BubbaBusy.watch([
      loading,
      saving,
      cardsLoading,
      purchasesLoading,
      subscriptionLoading,
      plansLoading,
    ]);
    loadNotifications();
  }

  Future<void> loadNotifications({bool force = false}) async {
    if (loading.value) return;
    if (_loadedOnce && !force) return;

    loading.value = true;
    error.value = null;

    final result = await _repository.fetchNotificationPreferences();
    if (result.isSuccess && result.value != null) {
      notifications.value = result.value!;
      _loadedOnce = true;
    } else {
      error.value = result.errorMessage;
    }

    loading.value = false;
  }

  /// Optimistic with a rollback, and a second write while one is in flight is
  /// refused, so a fast double tap on a switch cannot leave the row lying.
  Future<bool> setNotification(
    String category,
    String channel,
    bool value,
  ) async {
    if (saving.value) return false;

    final previous = notifications.value;
    saving.value = true;
    error.value = null;
    notifications.value = previous.withValue(category, channel, value);

    final result = await _repository.saveNotificationPreferences({
      category: {channel: value},
    });

    if (result.isSuccess && result.value != null) {
      notifications.value = result.value!;
    } else {
      notifications.value = previous;
      error.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  // ---- pause and delete ----

  Future<bool> pauseAccount(bool paused) async {
    if (saving.value) return false;

    saving.value = true;
    error.value = null;

    final result = await _repository.pauseAccount(paused);
    if (!result.isSuccess) error.value = result.errorMessage;

    saving.value = false;
    return result.isSuccess;
  }

  Future<bool> deleteAccount() async {
    if (saving.value) return false;

    saving.value = true;
    error.value = null;

    final result = await _repository.deleteAccount();
    if (!result.isSuccess) error.value = result.errorMessage;

    saving.value = false;
    return result.isSuccess;
  }

  // ---- payment ----

  final RxList<PaymentMethodModel> cards = <PaymentMethodModel>[].obs;
  final RxList<PurchaseModel> purchases = <PurchaseModel>[].obs;
  final Rx<SubscriptionModel> subscription = const SubscriptionModel().obs;

  final RxBool cardsLoading = false.obs;
  final RxBool purchasesLoading = false.obs;
  final RxBool subscriptionLoading = false.obs;
  final RxnString paymentError = RxnString();

  final RxList<PlanCatalogEntry> plans = <PlanCatalogEntry>[].obs;
  final RxBool plansLoading = false.obs;

  PlanCatalogEntry? planNamed(String id) =>
      plans.firstWhereOrNull((p) => p.id.toLowerCase() == id.toLowerCase());

  Future<void> loadPlans({bool force = false}) async {
    if (plansLoading.value) return;
    if (plans.isNotEmpty && !force) return;

    plansLoading.value = true;
    final result = await _payments.fetchPlans();
    if (result.isSuccess) {
      plans.assignAll(result.value ?? const []);
    } else {
      paymentError.value = result.errorMessage;
    }
    plansLoading.value = false;
  }

  Future<void> loadCards({bool force = false}) async {
    if (cardsLoading.value) return;
    if (cards.isNotEmpty && !force) return;

    cardsLoading.value = true;
    paymentError.value = null;

    final result = await _payments.fetchPaymentMethods();
    if (result.isSuccess) {
      cards.assignAll(result.value ?? const []);
    } else {
      paymentError.value = result.errorMessage;
    }

    cardsLoading.value = false;
  }

  Future<bool> removeCard(String id) async {
    if (saving.value) return false;

    saving.value = true;
    paymentError.value = null;

    final result = await _payments.deletePaymentMethod(id);
    if (result.isSuccess) {
      cards.removeWhere((card) => card.id == id);
    } else {
      paymentError.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  Future<bool> makeCardDefault(String id) async {
    if (saving.value) return false;

    saving.value = true;
    paymentError.value = null;

    final result = await _payments.setDefaultPaymentMethod(id);
    if (result.isSuccess) {
      await loadCards(force: true);
    } else {
      paymentError.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  Future<bool> updateCardBillingAddress(
    String id,
    SettingsBillingAddress address,
  ) async {
    if (saving.value) return false;

    saving.value = true;
    paymentError.value = null;

    final result = await _payments.updatePaymentMethodBilling(id, {
      'name': address.name,
      'phone': address.phone,
      'address': {
        'line1': address.street.isEmpty ? address.line1 : address.street,
        'line2': address.apt,
        'city': address.city,
        'state': address.state,
        'postalCode': address.zip,
        'country':
            address.countryCode.isEmpty ? address.country : address.countryCode,
      },
    });

    if (result.isSuccess) {
      await loadCards(force: true);
    } else {
      paymentError.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  Future<bool> addCard(String paymentMethodId) async {
    if (saving.value) return false;

    saving.value = true;
    paymentError.value = null;

    final result = await _payments.addPaymentMethod(paymentMethodId);
    if (result.isSuccess) {
      await loadCards(force: true);
    } else {
      paymentError.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  Future<void> loadPurchases({bool force = false}) async {
    if (purchasesLoading.value) return;
    if (purchases.isNotEmpty && !force) return;

    purchasesLoading.value = true;
    paymentError.value = null;

    final result = await _payments.fetchPurchaseHistory();
    if (result.isSuccess) {
      purchases.assignAll(result.value ?? const []);
    } else {
      paymentError.value = result.errorMessage;
    }

    purchasesLoading.value = false;
  }

  Future<PurchaseModel?> loadPurchase(String id) async {
    final cached = purchases.firstWhereOrNull((item) => item.id == id);
    if (cached != null) return cached;

    final result = await _payments.fetchPurchase(id);
    if (!result.isSuccess) paymentError.value = result.errorMessage;
    return result.value;
  }

  Future<void> loadSubscription({bool force = false}) async {
    if (subscriptionLoading.value) return;

    subscriptionLoading.value = true;
    paymentError.value = null;

    final result = await _payments.fetchSubscription();
    if (result.isSuccess && result.value != null) {
      subscription.value = result.value!;
    } else {
      paymentError.value = result.errorMessage;
    }

    subscriptionLoading.value = false;
  }

  Future<bool> setSubscriptionRenewal(bool autoRenew) async {
    if (saving.value) return false;

    saving.value = true;
    paymentError.value = null;

    final result = await _payments.setSubscriptionRenewal(autoRenew);
    if (result.isSuccess) {
      await loadSubscription(force: true);
    } else {
      paymentError.value = result.errorMessage;
    }

    saving.value = false;
    return result.isSuccess;
  }

  Future<bool> purchasePlan(String planType) async {
    if (saving.value) return false;

    saving.value = true;
    paymentError.value = null;

    try {
      final sheet = await _payments.createPaymentSheet(planType);
      if (!sheet.isSuccess || sheet.credentials == null) {
        paymentError.value = sheet.errorMessage ?? 'Unable to prepare payment.';
        return false;
      }

      final credentials = sheet.credentials!;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Bea',
          paymentIntentClientSecret: credentials.paymentIntent,
          customerId: credentials.customerId,
          customerEphemeralKeySecret: credentials.ephemeralKey,
          returnURL: AppConfig.stripeReturnUrl,
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      await _payments.confirmPaymentSheet(credentials.subscriptionId);
      await loadSubscription(force: true);
      return true;
    } on StripeException catch (error) {
      if (error.error.code != FailureCode.Canceled) {
        paymentError.value =
            error.error.localizedMessage ?? 'Unable to complete payment.';
      }
      return false;
    } catch (_) {
      paymentError.value = 'Failed to start payment.';
      return false;
    } finally {
      saving.value = false;
    }
  }

  static BubbaSettingsController get to {
    if (!Get.isRegistered<BubbaSettingsController>()) {
      Get.put(BubbaSettingsController(), permanent: true);
    }
    return Get.find<BubbaSettingsController>();
  }
}
