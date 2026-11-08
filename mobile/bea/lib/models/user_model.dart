import '../view/profileSetting/models/ice_breaker_model.dart';

class UserModel {
  String? id;

  // Auth / account
  String? phoneNumber;
  String? email;
  bool? isVerified;
  bool? isProfileCompleted;
  bool? initialSetup;
  int? stepsDone;
  String? role;
  String? status;

  // Profile
  String? fullName;
  String? gender;
  String? dateOfBirth;
  String? height;
  String? religiousViews;
  List<String>? languages;
  String? ethnicity;
  String? education;
  String? schoolName;
  String? jobTitle;
  String? companyName;
  List<String>? photos;
  List<String>? hobbies;
  String? interestedIn;
  String? hometown;
  String? socialHandle;
  String? drinking;
  String? smoking;
  String? politicalAffiliation;

  // Ice breakers / app-specific
  List<IceBreakerModel>? iceBreakers;

  // Limits / activity / travel
  int? dailyLikesSent;
  String? lastDailyReset;
  bool? isTraveling;
  Location? location;

  String? lastActive;

  // Visibility
  bool? showSchoolName;
  bool? showJobTitle;
  bool? showCompanyName;
  bool? showHometown;
  bool? showReligion;
  bool? showGender;
  bool? showHeight;
  bool? showEthnicity;
  bool? showLanguages;
  bool? showDrinking;
  bool? showSmoking;
  bool? showPoliticalAffiliation;

  // Subscription
  String? stripeCustomerId;
  String? stripeSubscriptionId;
  String? facebookkey;
  String? googlekey;
  String? applekey;
  Subscription? subscription;

  // Timestamps / extra
  String? createdAt;
  String? updatedAt;
  String? age;
  int? matchCount;
  double? distanceInMiles;

  UserModel({
    this.id,
    this.phoneNumber,
    this.email,
    this.isVerified,
    this.isProfileCompleted,
    this.initialSetup = false,
    this.stepsDone,
    this.role,
    this.status,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.religiousViews,
    this.languages,
    this.ethnicity,
    this.education,
    this.schoolName,
    this.jobTitle,
    this.companyName,
    this.googlekey,
    this.applekey,
    this.facebookkey,
    this.photos,
    this.hobbies,
    this.interestedIn,
    this.hometown,
    this.socialHandle,
    this.drinking,
    this.smoking,
    this.politicalAffiliation,
    this.iceBreakers,
    this.dailyLikesSent,
    this.lastDailyReset,
    this.isTraveling,
    this.location,
    this.lastActive,
    this.showSchoolName,
    this.showJobTitle,
    this.showCompanyName,
    this.showHometown,
    this.showReligion,
    this.showGender,
    this.showHeight,
    this.showEthnicity,
    this.showLanguages,
    this.showDrinking,
    this.showSmoking,
    this.showPoliticalAffiliation,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.subscription,
    this.createdAt,
    this.updatedAt,
    this.age,
    this.matchCount,
    this.distanceInMiles,
  });

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;

    final s = value.toString().toLowerCase().trim();
    if (s == 'true' || s == '1' || s == 'yes') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;

    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    if (value is String) {
      return [value];
    }

    return null;
  }

  static List<String>? _parsePhotos(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : [trimmed];
    }

    if (value is List) {
      final photos = <String>[];
      for (final item in value) {
        final photo = _parsePhotoEntry(item);
        if (photo != null) {
          photos.add(photo);
        }
      }
      return photos.isEmpty ? null : photos;
    }

    return null;
  }

  static String? _parsePhotoEntry(dynamic item) {
    if (item == null) return null;

    if (item is String) {
      final trimmed = item.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    if (item is Map) {
      for (final key in const [
        'url',
        'photoUrl',
        'photo_url',
        'imageUrl',
        'image_url',
        'path',
        'src',
        'uri',
      ]) {
        final value = item[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    return null;
  }

  static List<IceBreakerModel> _parseIceBreakers(dynamic value) {
    if (value == null) return <IceBreakerModel>[];

    if (value is List) {
      return value
          .map((e) => IceBreakerModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return <IceBreakerModel>[];
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      facebookkey: _parseString(json['facebookkey']),
      googlekey: _parseString(json['googlekey']),
      applekey: _parseString(json['applekey']),
      id: _parseString(json['_id']),
      phoneNumber: _parseString(json['phoneNumber']),
      email: _parseString(json['email']),
      isVerified: _parseBool(json['isVerified']),
      isProfileCompleted: _parseBool(json['isProfileCompleted']),
      initialSetup: _parseBool(json['initialSetup']) ?? false,
      stepsDone: _parseInt(json['steps_done']),
      role: _parseString(json['role']),
      status: _parseString(json['status']),

      fullName: _parseString(json['fullName']),
      gender: _parseString(json['Gender'] ?? json['gender']),
      dateOfBirth: _parseString(json['DateOfBirth'] ?? json['dateOfBirth']),
      height: _parseString(json['height']),
      religiousViews: _parseString(
        json['religious_views'] ?? json['religiousViews'],
      ),
      languages: _parseStringList(json['languages']),
      ethnicity: _parseString(json['ethnicity']),
      education: _parseString(json['education']),
      schoolName: _parseString(json['school_name'] ?? json['schoolName']),
      jobTitle: _parseString(json['job_title'] ?? json['jobTitle']),
      companyName: _parseString(json['company_name'] ?? json['companyName']),
      photos: _parsePhotos(
        json['photos'] ?? json['photoUrls'] ?? json['photo_urls'],
      ),
      hobbies: _parseStringList(json['hobbies']),
      interestedIn: _parseString(json['interested_in'] ?? json['interestedIn']),
      hometown: _parseString(json['hometown']),
      socialHandle: _parseString(json['social_handle'] ?? json['socialHandle']),
      drinking: _parseString(json['drinking']),
      smoking: _parseString(json['smoking']),
      politicalAffiliation: _parseString(
        json['political_affiliation'] ?? json['politicalAffiliation'],
      ),

      iceBreakers: _parseIceBreakers(
        json['iceBreakers'] ?? json['ice_breakers'],
      ),

      dailyLikesSent: _parseInt(json['daily_likes_sent']),
      lastDailyReset: _parseString(json['last_daily_reset']),
      isTraveling: _parseBool(json['is_traveling']),
      location: json['location'] != null
          ? Location.fromJson(Map<String, dynamic>.from(json['location']))
          : null,

      lastActive: _parseString(json['lastActive']),

      showSchoolName: _parseBool(json['show_school_name']),
      showJobTitle: _parseBool(json['show_job_title']),
      showCompanyName: _parseBool(json['show_company_name']),
      showHometown: _parseBool(json['show_hometown']),
      showReligion: _parseBool(json['show_religion']),
      showGender: _parseBool(json['show_gender']),
      showHeight: _parseBool(json['show_height']),
      showEthnicity: _parseBool(json['show_ethnicity']),
      showLanguages: _parseBool(json['show_languages']),
      showDrinking: _parseBool(json['show_drinking']),
      showSmoking: _parseBool(json['show_smoking']),
      showPoliticalAffiliation: _parseBool(json['show_political_affiliation']),

      stripeCustomerId: _parseString(json['stripeCustomerId']),
      stripeSubscriptionId: _parseString(json['stripeSubscriptionId']),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(
              Map<String, dynamic>.from(json['subscription']),
            )
          : null,

      createdAt: _parseString(json['createdAt']),
      updatedAt: _parseString(json['updatedAt']),
      age: _parseString(json['age']),
      matchCount: _parseInt(json['matchCount']),
      distanceInMiles: _parseDouble(json['distanceInMiles']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['isVerified'] = isVerified;
    data['isProfileCompleted'] = isProfileCompleted;
    data['initialSetup'] = initialSetup;
    data['steps_done'] = stepsDone;
    data['role'] = role;
    data['status'] = status;
    data['facebookkey'] = facebookkey;
    data['googlekey'] = googlekey;
    data['applekey'] = applekey;
    data['fullName'] = fullName;
    data['Gender'] = gender;
    data['DateOfBirth'] = dateOfBirth;
    data['height'] = height;
    data['religious_views'] = religiousViews;
    data['languages'] = languages;
    data['ethnicity'] = ethnicity;
    data['education'] = education;
    data['school_name'] = schoolName;
    data['job_title'] = jobTitle;
    data['company_name'] = companyName;
    data['photos'] = photos;
    data['hobbies'] = hobbies;
    data['interested_in'] = interestedIn;
    data['hometown'] = hometown;
    data['social_handle'] = socialHandle;
    data['drinking'] = drinking;
    data['smoking'] = smoking;
    data['political_affiliation'] = politicalAffiliation;

    data['iceBreakers'] = iceBreakers?.map((e) => e.toJson()).toList();

    data['daily_likes_sent'] = dailyLikesSent;
    data['last_daily_reset'] = lastDailyReset;
    data['is_traveling'] = isTraveling;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['lastActive'] = lastActive;

    data['show_school_name'] = showSchoolName;
    data['show_job_title'] = showJobTitle;
    data['show_company_name'] = showCompanyName;
    data['show_hometown'] = showHometown;
    data['show_religion'] = showReligion;
    data['show_gender'] = showGender;
    data['show_height'] = showHeight;
    data['show_ethnicity'] = showEthnicity;
    data['show_languages'] = showLanguages;
    data['show_drinking'] = showDrinking;
    data['show_smoking'] = showSmoking;
    data['show_political_affiliation'] = showPoliticalAffiliation;

    data['stripeCustomerId'] = stripeCustomerId;
    data['stripeSubscriptionId'] = stripeSubscriptionId;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }

    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['age'] = age;
    data['matchCount'] = matchCount;
    data['distanceInMiles'] = distanceInMiles;

    return data;
  }

  // Getter to calculate age from DateOfBirth
  int? get ages {
    if (dateOfBirth == null) return null;
    try {
      final birthDate = DateTime.parse(dateOfBirth!);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return null;
    }
  }

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? facebookkey,
    String? googlekey,
    String? applekey,
    String? email,
    bool? isVerified,
    bool? isProfileCompleted,
    bool? initialSetup,
    int? stepsDone,
    String? role,
    String? status,
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? height,
    String? religiousViews,
    List<String>? languages,
    String? ethnicity,
    String? education,
    String? schoolName,
    String? jobTitle,
    String? companyName,
    List<String>? photos,
    List<String>? hobbies,
    String? interestedIn,
    String? hometown,
    String? socialHandle,
    String? drinking,
    String? smoking,
    String? politicalAffiliation,
    List<IceBreakerModel>? iceBreakers,
    IceBreakerModel? icebreaker,
    String? toUserIcebreakerAnswer,
    String? reply,
    int? dailyLikesSent,
    String? lastDailyReset,
    bool? isTraveling,
    Location? location,
    String? lastActive,
    bool? showSchoolName,
    bool? showJobTitle,
    bool? showCompanyName,
    bool? showHometown,
    bool? showReligion,
    bool? showGender,
    bool? showHeight,
    bool? showEthnicity,
    bool? showLanguages,
    bool? showDrinking,
    bool? showSmoking,
    bool? showPoliticalAffiliation,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    Subscription? subscription,
    String? createdAt,
    String? updatedAt,
    String? age,
    int? matchCount,
    double? distanceInMiles,
  }) {
    return UserModel(
      facebookkey: facebookkey ?? this.facebookkey,
      googlekey: googlekey ?? this.googlekey,
      applekey: applekey ?? this.applekey,
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      initialSetup: initialSetup ?? this.initialSetup,
      stepsDone: stepsDone ?? this.stepsDone,
      role: role ?? this.role,
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      religiousViews: religiousViews ?? this.religiousViews,
      languages: languages ?? this.languages,
      ethnicity: ethnicity ?? this.ethnicity,
      education: education ?? this.education,
      schoolName: schoolName ?? this.schoolName,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      photos: photos ?? this.photos,
      hobbies: hobbies ?? this.hobbies,
      interestedIn: interestedIn ?? this.interestedIn,
      hometown: hometown ?? this.hometown,
      socialHandle: socialHandle ?? this.socialHandle,
      drinking: drinking ?? this.drinking,
      smoking: smoking ?? this.smoking,
      politicalAffiliation: politicalAffiliation ?? this.politicalAffiliation,
      iceBreakers: iceBreakers ?? this.iceBreakers,

      dailyLikesSent: dailyLikesSent ?? this.dailyLikesSent,
      lastDailyReset: lastDailyReset ?? this.lastDailyReset,
      isTraveling: isTraveling ?? this.isTraveling,
      location: location ?? this.location,
      lastActive: lastActive ?? this.lastActive,
      showSchoolName: showSchoolName ?? this.showSchoolName,
      showJobTitle: showJobTitle ?? this.showJobTitle,
      showCompanyName: showCompanyName ?? this.showCompanyName,
      showHometown: showHometown ?? this.showHometown,
      showReligion: showReligion ?? this.showReligion,
      showGender: showGender ?? this.showGender,
      showHeight: showHeight ?? this.showHeight,
      showEthnicity: showEthnicity ?? this.showEthnicity,
      showLanguages: showLanguages ?? this.showLanguages,
      showDrinking: showDrinking ?? this.showDrinking,
      showSmoking: showSmoking ?? this.showSmoking,
      showPoliticalAffiliation:
          showPoliticalAffiliation ?? this.showPoliticalAffiliation,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      stripeSubscriptionId: stripeSubscriptionId ?? this.stripeSubscriptionId,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      age: age ?? this.age,
      matchCount: matchCount ?? this.matchCount,
      distanceInMiles: distanceInMiles ?? this.distanceInMiles,
    );
  }

  double get profileCompletion {
    int total = 18; // important fields only
    int filled = 0;

    bool isNotEmpty(String? v) => v != null && v.trim().isNotEmpty;
    bool isListNotEmpty(List? v) => v != null && v.isNotEmpty;

    // Basic profile
    if (isNotEmpty(fullName)) filled++;
    if (isNotEmpty(gender)) filled++;
    if (isNotEmpty(dateOfBirth)) filled++;
    if (isNotEmpty(height)) filled++;

    // Personal details
    if (isNotEmpty(religiousViews)) filled++;
    if (isListNotEmpty(languages)) filled++;
    if (isNotEmpty(ethnicity)) filled++;
    if (isNotEmpty(education)) filled++;

    // Work / study
    if (isNotEmpty(schoolName)) filled++;
    if (isNotEmpty(jobTitle)) filled++;
    if (isNotEmpty(companyName)) filled++;

    // Lifestyle
    if (isNotEmpty(drinking)) filled++;
    if (isNotEmpty(smoking)) filled++;
    if (isNotEmpty(politicalAffiliation)) filled++;

    // Social / identity
    if (isNotEmpty(hometown)) filled++;
    if (isNotEmpty(interestedIn)) filled++;

    // Content
    if (isListNotEmpty(photos)) filled++;
    if (isListNotEmpty(hobbies)) filled++;

    return (filled / total) * 100;
  }
}

class Subscription {
  String? tier;
  String? expiresAt;
  bool? autoRenew;

  Subscription({this.tier, this.expiresAt, this.autoRenew});

  Subscription.fromJson(Map<String, dynamic> json) {
    tier = json['tier'];
    expiresAt = json['expiresAt'];
    autoRenew = json['autoRenew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tier'] = tier;
    data['expiresAt'] = expiresAt;
    data['autoRenew'] = autoRenew;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates']?.cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }

  double? get latitude =>
      (coordinates != null && coordinates!.length > 1) ? coordinates![1] : null;

  double? get longitude =>
      (coordinates != null && coordinates!.isNotEmpty) ? coordinates![0] : null;
}
