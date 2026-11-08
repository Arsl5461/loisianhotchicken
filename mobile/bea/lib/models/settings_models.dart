/// The design's own three options on p033, not a generic visibility ladder:
/// Everyone, People matching my filters, Pause discovery.
enum ProfileVisibility { everyone, filters, paused }

extension ProfileVisibilityApi on ProfileVisibility {
  String get apiValue => switch (this) {
        ProfileVisibility.everyone => 'everyone',
        ProfileVisibility.filters => 'filters',
        ProfileVisibility.paused => 'paused',
      };

  String get label => switch (this) {
        ProfileVisibility.everyone => 'Everyone',
        ProfileVisibility.filters => 'People matching my filters',
        ProfileVisibility.paused => 'Pause discovery',
      };

  static ProfileVisibility parse(dynamic value) => switch (value) {
        'filters' => ProfileVisibility.filters,
        'paused' => ProfileVisibility.paused,
        _ => ProfileVisibility.everyone,
      };
}

/// p037's three options. `show_last_active` was a boolean and could not hold
/// the middle one, so the field is an enum.
enum LastActiveVisibility { everyone, matches, nobody }

extension LastActiveVisibilityApi on LastActiveVisibility {
  String get apiValue => switch (this) {
        LastActiveVisibility.everyone => 'everyone',
        LastActiveVisibility.matches => 'matches',
        LastActiveVisibility.nobody => 'nobody',
      };

  String get label => switch (this) {
        LastActiveVisibility.everyone => 'Everyone',
        LastActiveVisibility.matches => 'Matches only',
        LastActiveVisibility.nobody => 'Nobody',
      };

  static LastActiveVisibility parse(dynamic value) => switch (value) {
        'matches' => LastActiveVisibility.matches,
        'nobody' => LastActiveVisibility.nobody,
        _ => LastActiveVisibility.everyone,
      };
}

class PrivacySettings {
  const PrivacySettings({
    this.profileVisibility = ProfileVisibility.everyone,
    this.readReceipts = true,
    this.lastActiveVisibility = LastActiveVisibility.everyone,
    this.hideFromContacts = false,
    this.incognito = false,
  });

  final ProfileVisibility profileVisibility;
  final bool readReceipts;
  final LastActiveVisibility lastActiveVisibility;
  final bool hideFromContacts;
  final bool incognito;

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      PrivacySettings(
        profileVisibility:
            ProfileVisibilityApi.parse(json['profile_visibility']),
        readReceipts: json['read_receipts'] as bool? ?? true,
        lastActiveVisibility:
            LastActiveVisibilityApi.parse(json['last_active_visibility']),
        hideFromContacts: json['hide_from_contacts'] as bool? ?? false,
        incognito: json['incognito'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'profile_visibility': profileVisibility.apiValue,
        'read_receipts': readReceipts,
        'last_active_visibility': lastActiveVisibility.apiValue,
        'hide_from_contacts': hideFromContacts,
        'incognito': incognito,
      };

  PrivacySettings copyWith({
    ProfileVisibility? profileVisibility,
    bool? readReceipts,
    LastActiveVisibility? lastActiveVisibility,
    bool? hideFromContacts,
    bool? incognito,
  }) =>
      PrivacySettings(
        profileVisibility: profileVisibility ?? this.profileVisibility,
        readReceipts: readReceipts ?? this.readReceipts,
        lastActiveVisibility:
            lastActiveVisibility ?? this.lastActiveVisibility,
        hideFromContacts: hideFromContacts ?? this.hideFromContacts,
        incognito: incognito ?? this.incognito,
      );
}

/// The Notifications screen is a matrix: one row per category, one switch per
/// channel. The keys are the server's, and the labels are the design's.
class NotificationPreferences {
  const NotificationPreferences({this.rows = const {}});

  final Map<String, Map<String, bool>> rows;

  static const List<String> categories = [
    'new_messages',
    'expiring_conversations',
    'new_likes',
    'new_matches',
    'expiring_matches',
    'story_likes',
    'story_replies',
  ];

  static const List<String> channels = ['push', 'in_app', 'email'];

  static const Map<String, String> categoryLabels = {
    'new_messages': 'New Messages',
    'expiring_conversations': 'Expiring Conversations',
    'new_likes': 'New Likes',
    'new_matches': 'New Matches',
    'expiring_matches': 'Expiring Matches',
    'story_likes': 'Story Likes',
    'story_replies': 'Story Replies',
  };

  static const Map<String, String> channelLabels = {
    'push': 'Push Notifications',
    'in_app': 'In-App Notifications',
    'email': 'Email',
  };

  static String? categoryFor(String label) {
    for (final entry in categoryLabels.entries) {
      if (entry.value == label) return entry.key;
    }
    return null;
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final rows = <String, Map<String, bool>>{};

    for (final category in categories) {
      final row = json[category];
      rows[category] = {
        for (final channel in channels)
          channel: row is Map && row[channel] is bool
              ? row[channel] as bool
              : true,
      };
    }

    return NotificationPreferences(rows: rows);
  }

  bool valueFor(String category, String channel) =>
      rows[category]?[channel] ?? true;

  int get enabledCount => rows.values
      .expand((row) => row.values)
      .where((value) => value)
      .length;

  NotificationPreferences withValue(
    String category,
    String channel,
    bool value,
  ) {
    final next = {
      for (final entry in rows.entries)
        entry.key: Map<String, bool>.from(entry.value),
    };
    (next[category] ??= {})[channel] = value;
    return NotificationPreferences(rows: next);
  }
}

class BlockedUser {
  const BlockedUser({
    required this.id,
    required this.fullName,
    this.photo,
    this.blockedAt,
  });

  final String id;
  final String fullName;
  final String? photo;
  final DateTime? blockedAt;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    final photo = json['photo'];
    final photos = json['photos'];

    return BlockedUser(
      id: (json['_id'] ?? '').toString(),
      fullName: (json['fullName'] ?? 'Unknown').toString(),
      photo: photo is String && photo.isNotEmpty
          ? photo
          : (photos is List && photos.isNotEmpty
              ? photos.first.toString()
              : null),
      blockedAt: json['blockedAt'] == null
          ? null
          : DateTime.tryParse(json['blockedAt'].toString()),
    );
  }
}

class PaymentMethodModel {
  const PaymentMethodModel({
    required this.id,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
    this.isDefault = false,
    this.billingName = '',
    this.billingLine1 = '',
    this.billingLine2 = '',
    this.billingCity = '',
    this.billingState = '',
    this.billingPostalCode = '',
    this.billingCountry = '',
  });

  final String id;
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;
  final bool isDefault;
  final String billingName;
  final String billingLine1;
  final String billingLine2;
  final String billingCity;
  final String billingState;
  final String billingPostalCode;
  final String billingCountry;

  bool get hasBillingAddress =>
      billingLine1.isNotEmpty ||
      billingCity.isNotEmpty ||
      billingPostalCode.isNotEmpty;

  String get billingLocality {
    final locality = <String>[
      if (billingCity.isNotEmpty) billingCity,
      if (billingState.isNotEmpty) billingState,
    ].join(', ');
    if (billingPostalCode.isEmpty) return locality;
    return '$locality $billingPostalCode'.trim();
  }

  String get brandLabel {
    final value = brand;
    if (value == null || value.isEmpty) return 'Card';
    return value[0].toUpperCase() + value.substring(1);
  }

  String get maskedNumber => last4 == null ? '' : '•••• •••• •••• $last4';

  String get expiryLabel {
    if (expMonth == null || expYear == null) return '';
    final month = expMonth!.toString().padLeft(2, '0');
    final year = expYear!.toString().padLeft(4, '0').substring(2);
    return '$month/$year';
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: (json['id'] ?? '').toString(),
        brand: json['brand'] as String?,
        last4: json['last4'] as String?,
        expMonth: json['expMonth'] as int?,
        expYear: json['expYear'] as int?,
        isDefault: json['isDefault'] as bool? ?? false,
        billingName: _billingString(json, 'name'),
        billingLine1: _billingString(json, 'line1'),
        billingLine2: _billingString(json, 'line2'),
        billingCity: _billingString(json, 'city'),
        billingState: _billingString(json, 'state'),
        billingPostalCode: _billingString(json, 'postalCode', 'postal_code'),
        billingCountry: _billingString(json, 'country'),
      );

  static String _billingString(
    Map<String, dynamic> json,
    String key, [
    String? alias,
  ]) {
    final details = json['billingDetails'] ?? json['billing_details'];
    final address = details is Map ? (details['address'] ?? details) : null;
    for (final source in [address, details, json]) {
      if (source is! Map) continue;
      final value = source[key] ?? (alias == null ? null : source[alias]);
      if (value != null && value.toString().isNotEmpty) return value.toString();
    }
    return '';
  }
}

class PurchaseModel {
  const PurchaseModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.planLabel = '',
    this.description = '',
    this.receiptUrl,
    this.createdAt,
    this.refundedAt,
  });

  final String id;
  final int amount;
  final String currency;
  final String status;
  final String planLabel;
  final String description;
  final String? receiptUrl;
  final DateTime? createdAt;
  final DateTime? refundedAt;

  String get amountLabel {
    final symbol = currency.toLowerCase() == 'usd' ? '\$' : '';
    return '$symbol${(amount / 100).toStringAsFixed(2)}';
  }

  bool get isRefunded => status == 'refunded';

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: (json['_id'] ?? '').toString(),
        amount: (json['amount'] as num?)?.toInt() ?? 0,
        currency: (json['currency'] ?? 'usd').toString(),
        status: (json['status'] ?? 'pending').toString(),
        planLabel: (json['planLabel'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        receiptUrl: json['receiptUrl'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.tryParse(json['createdAt'].toString()),
        refundedAt: json['refundedAt'] == null
            ? null
            : DateTime.tryParse(json['refundedAt'].toString()),
      );
}

class SubscriptionModel {
  const SubscriptionModel({
    this.tier = 'free',
    this.planLabel = 'Free',
    this.isPaid = false,
    this.expiresAt,
    this.autoRenew = false,
    this.cancelAtPeriodEnd = false,
    this.amount,
    this.paymentDate,
  });

  final String tier;
  final String planLabel;
  final bool isPaid;
  final DateTime? expiresAt;
  final bool autoRenew;
  final bool cancelAtPeriodEnd;
  final num? amount;
  final DateTime? paymentDate;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        tier: (json['tier'] ?? 'free').toString(),
        planLabel: (json['planLabel'] ?? 'Free').toString(),
        isPaid: json['isPaid'] as bool? ?? false,
        expiresAt: json['expiresAt'] == null
            ? null
            : DateTime.tryParse(json['expiresAt'].toString()),
        autoRenew: json['autoRenew'] as bool? ?? false,
        cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool? ?? false,
        amount: json['amount'] as num?,
        paymentDate: json['paymentDate'] == null
            ? null
            : DateTime.tryParse(json['paymentDate'].toString()),
      );
}

class HelpArticle {
  const HelpArticle({required this.title, required this.body});

  final String title;
  final String body;
}


class PlanCatalogEntry {
  const PlanCatalogEntry({
    required this.id,
    required this.name,
    this.amount,
    this.currency = 'usd',
    this.interval = 'month',
    this.badge,
  });

  final String id;
  final String name;
  final num? amount;
  final String currency;
  final String interval;
  final String? badge;

  String get priceLabel {
    final value = amount;
    if (value == null) return '';
    final major = value / 100;
    final text = major == major.roundToDouble()
        ? major.round().toString()
        : major.toStringAsFixed(2);
    return '\$$text / $interval';
  }

  factory PlanCatalogEntry.fromJson(Map<String, dynamic> json) =>
      PlanCatalogEntry(
        id: (json['id'] ?? json['planType'] ?? '').toString(),
        name: (json['name'] ?? json['label'] ?? '').toString(),
        amount: json['amount'] as num?,
        currency: (json['currency'] ?? 'usd').toString(),
        interval: (json['interval'] ?? json['period'] ?? 'month').toString(),
        badge: json['badge'] as String?,
      );
}

class LegalDocument {
  const LegalDocument({
    required this.slug,
    this.lastUpdated = '',
    this.sections = const [],
  });

  final String slug;
  final String lastUpdated;
  final List<HelpArticle> sections;
}
