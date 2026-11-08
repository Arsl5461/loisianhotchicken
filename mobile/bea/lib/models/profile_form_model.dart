import 'dart:convert';

import 'package:OApp/models/user_model.dart';

import '../view/profileSetting/models/ice_breaker_model.dart';

class ProfileFormModel {
  String? id;
  // =======================
  // API fields
  // =======================
  String? email;

  String? phoneNumber;
  String? fullName;
  String? dateOfBirth; // yyyy-mm-dd
  String? gender;
  String? height;
  String? religiousViews;
  String? ethnicity;
  String? education;
  String? schoolName;
  String? jobTitle;
  String? companyName;
  String? hometown;
  String? interestedIn;
  String? politicalAffiliation;
  String? drinking;
  String? smoking;
  String? socialHandle;

  List<String> hobbies;
  List<IceBreakerModel> iceBreakers;
  List<String> languages;
  List<String> photos;

  int stepsDone;
  bool initialSetup;

  bool showSchoolName;
  bool showJobTitle;
  bool showCompanyName;
  bool showHometown;
  bool showReligion;
  bool showGender;
  bool showHeight;
  bool showEthnicity;
  bool showLanguages;
  bool showDrinking;
  bool showSmoking;
  bool showPoliticalAffiliation;

  double? latitude;
  double? longitude;

  // =======================
  // UI fields

  bool isPubliclyDisplayed;
  bool displayOnProfile;
  bool displayOnProfile1;

  DateTime? selectedDate;
  int? calculatedAge;
  String? zodiacSign;

  bool isManSelected;
  bool isWomanSelected;
  bool isNonbinarySelected;

  bool isMenSelected;
  bool isWomenSelected;
  bool isNonbinaryPeopleSelected;
  bool isEveryoneSelected;

  int selectedHeightIndex;

  List<String> answers;
  List<bool> expandedStates;
  List<String> promptTitles;

  ProfileFormModel({
    this.id,
    this.phoneNumber,
    this.email,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.religiousViews,
    this.ethnicity,
    this.education,
    this.schoolName,
    this.jobTitle,
    this.companyName,
    this.hometown,
    this.interestedIn,
    this.politicalAffiliation,
    this.drinking,
    this.smoking,
    this.socialHandle,
    List<String>? hobbies,
    List<IceBreakerModel>? iceBreakers,
    List<String>? languages,
    List<String>? photos,
    this.stepsDone = 0,
    this.initialSetup = false,
    this.showSchoolName = true,
    this.showJobTitle = true,
    this.showCompanyName = true,
    this.showHometown = true,
    this.showReligion = true,
    this.showGender = true,
    this.showHeight = true,
    this.showEthnicity = true,
    this.showLanguages = true,
    this.showDrinking = true,
    this.showSmoking = true,
    this.showPoliticalAffiliation = true,
    this.latitude,
    this.longitude,

    this.isPubliclyDisplayed = false,
    this.displayOnProfile = false,
    this.displayOnProfile1 = true,
    this.selectedDate,
    this.calculatedAge,
    this.zodiacSign,
    this.isManSelected = false,
    this.isWomanSelected = false,
    this.isNonbinarySelected = false,
    this.isMenSelected = false,
    this.isWomenSelected = false,
    this.isNonbinaryPeopleSelected = false,
    this.isEveryoneSelected = false,
    this.selectedHeightIndex = 11,
    List<String>? answers,
    List<bool>? expandedStates,
    List<String>? promptTitles,
  }) : hobbies = hobbies ?? <String>[],
       iceBreakers = iceBreakers ?? <IceBreakerModel>[],
       languages = languages ?? <String>[],
       photos = photos ?? <String>[],
       answers = answers ?? <String>['', '', ''],
       expandedStates = expandedStates ?? <bool>[false, false, false],
       promptTitles = promptTitles ?? <String>['First', 'Second', 'Third'];

  // =======================
  // Helpers
  // =======================
  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static bool _bool(dynamic v, {bool fallback = false}) {
    if (v == null) return fallback;
    if (v is bool) return v;

    final s = v.toString().toLowerCase().trim();
    if (s == 'true' || s == '1' || s == 'yes') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;

    return fallback;
  }

  static double? _dbl(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static int? _int(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static DateTime? _dt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }

  static List<String> _stringList(dynamic v) {
    if (v == null) return <String>[];

    if (v is List<String>) return v;
    if (v is List) return v.map((e) => e.toString()).toList();

    if (v is String) {
      final s = v.trim();

      if (s.startsWith('[') && s.endsWith(']')) {
        try {
          final decoded = jsonDecode(s);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }

      if (s.isEmpty) return <String>[];
      return <String>[s];
    }

    return <String>[];
  }

  static List<bool> _boolList(dynamic v) {
    if (v == null) return <bool>[];
    if (v is List<bool>) return v;
    if (v is List) return v.map((e) => _bool(e)).toList();

    if (v is String) {
      final s = v.trim();
      if (s.startsWith('[') && s.endsWith(']')) {
        try {
          final decoded = jsonDecode(s);
          if (decoded is List) {
            return decoded.map((e) => _bool(e)).toList();
          }
        } catch (_) {}
      }
    }

    return <bool>[];
  }

  static List<IceBreakerModel> _iceBreakerList(dynamic v) {
    if (v == null) return <IceBreakerModel>[];

    if (v is List) {
      return v
          .map((e) => IceBreakerModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return <IceBreakerModel>[];
  }

  // =======================
  // fromJson
  // =======================
  factory ProfileFormModel.fromJson(Map<String, dynamic> json) {
    String? getStr(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k)) return _str(json[k]);
      }
      return null;
    }

    bool getBool(List<String> keys, {bool fallback = false}) {
      for (final k in keys) {
        if (json.containsKey(k)) return _bool(json[k], fallback: fallback);
      }
      return fallback;
    }

    double? getDbl(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k)) return _dbl(json[k]);
      }
      return null;
    }

    int? getInt(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k)) return _int(json[k]);
      }
      return null;
    }

    DateTime? getDt(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k)) return _dt(json[k]);
      }
      return null;
    }

    List<String> getList(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k)) return _stringList(json[k]);
      }
      return <String>[];
    }

    List<bool> getBoolArr(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k)) return _boolList(json[k]);
      }
      return <bool>[];
    }

    return ProfileFormModel(
      id: getStr(['id', '_id']),
      fullName: getStr(['fullName', 'full_name', 'name']),
      phoneNumber: getStr(json['phoneNumber']),
      email: getStr(json['email']),
      dateOfBirth: getStr(['DateOfBirth', 'dateOfBirth', 'date_of_birth']),
      gender: getStr(['Gender', 'gender']),
      height: getStr(['height']),
      religiousViews: getStr(['religious_views', 'religiousViews']),
      ethnicity: getStr(['ethnicity']),
      education: getStr(['education']),
      schoolName: getStr(['school_name', 'schoolName']),
      jobTitle: getStr(['job_title', 'jobTitle']),
      companyName: getStr(['company_name', 'companyName']),
      hometown: getStr(['hometown']),
      interestedIn: getStr(['interested_in', 'interestedIn']),
      politicalAffiliation: getStr([
        'political_affiliation',
        'politicalAffiliation',
      ]),
      drinking: getStr(['drinking']),
      smoking: getStr(['smoking']),
      socialHandle: getStr(['social_handle', 'socialHandle']),
      hobbies: getList(['hobbies']),
      iceBreakers: _iceBreakerList(json['iceBreakers'] ?? json['ice_breakers']),
      languages: getList(['languages']),
      photos: getList(['photos', 'photoUrls', 'photo_urls']),

      showSchoolName: getBool([
        'show_school_name',
        'showSchoolName',
      ], fallback: true),
      showJobTitle: getBool(['show_job_title', 'showJobTitle'], fallback: true),
      showCompanyName: getBool([
        'show_company_name',
        'showCompanyName',
      ], fallback: true),
      showHometown: getBool(['show_hometown', 'showHometown'], fallback: true),
      showReligion: getBool(['show_religion', 'showReligion'], fallback: true),
      showGender: getBool(['show_gender', 'showGender'], fallback: true),
      showHeight: getBool(['show_height', 'showHeight'], fallback: true),
      showEthnicity: getBool([
        'show_ethnicity',
        'showEthnicity',
      ], fallback: true),
      showLanguages: getBool([
        'show_languages',
        'showLanguages',
      ], fallback: true),
      showDrinking: getBool(['show_drinking', 'showDrinking'], fallback: true),
      showSmoking: getBool(['show_smoking', 'showSmoking'], fallback: true),
      showPoliticalAffiliation: getBool([
        'show_political_affiliation',
        'showPoliticalAffiliation',
      ], fallback: true),

      initialSetup: getBool(['initialSetup'], fallback: false),
      stepsDone: getInt(['steps_done']) ?? 0,

      latitude:
          getDbl(['latitude']) ??
          ((json['location'] is Map &&
                  json['location']['coordinates'] is List &&
                  (json['location']['coordinates'] as List).length > 1)
              ? _dbl((json['location']['coordinates'] as List)[1])
              : null),
      longitude:
          getDbl(['longitude']) ??
          ((json['location'] is Map &&
                  json['location']['coordinates'] is List &&
                  (json['location']['coordinates'] as List).isNotEmpty)
              ? _dbl((json['location']['coordinates'] as List)[0])
              : null),

      isPubliclyDisplayed: getBool(['isPubliclyDisplayed'], fallback: false),
      displayOnProfile: getBool(['displayOnProfile'], fallback: false),
      displayOnProfile1: getBool(['displayOnProfile1'], fallback: true),

      selectedDate: getDt(['selectedDate']),
      calculatedAge: getInt(['calculatedAge']),
      zodiacSign: getStr(['zodiacSign']),

      isManSelected: getBool(['isManSelected'], fallback: false),
      isWomanSelected: getBool(['isWomanSelected'], fallback: false),
      isNonbinarySelected: getBool(['isNonbinarySelected'], fallback: false),

      isMenSelected: getBool(['isMenSelected'], fallback: false),
      isWomenSelected: getBool(['isWomenSelected'], fallback: false),
      isNonbinaryPeopleSelected: getBool([
        'isNonbinaryPeopleSelected',
      ], fallback: false),
      isEveryoneSelected: getBool(['isEveryoneSelected'], fallback: false),

      answers: getList(['answers']).isEmpty
          ? <String>['', '', '']
          : getList(['answers']),
      expandedStates: getBoolArr(['expandedStates']).isEmpty
          ? <bool>[false, false, false]
          : getBoolArr(['expandedStates']),
      promptTitles: getList(['promptTitles']).isEmpty
          ? <String>['First', 'Second', 'Third']
          : getList(['promptTitles']),
    );
  }

  // =======================
  // fromUserModel
  // =======================
  factory ProfileFormModel.fromUserModel(UserModel user) {
    return ProfileFormModel(
      id: user.id,
      fullName: user.fullName,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      email: user.email,
      phoneNumber: user.phoneNumber,
      height: user.height,
      religiousViews: user.religiousViews,
      ethnicity: user.ethnicity,
      education: user.education,
      schoolName: user.schoolName,
      jobTitle: user.jobTitle,
      companyName: user.companyName,
      hometown: user.hometown,
      interestedIn: user.interestedIn,
      politicalAffiliation: user.politicalAffiliation,
      socialHandle: user.socialHandle,
      drinking: user.drinking,
      smoking: user.smoking,
      initialSetup: user.initialSetup ?? false,
      stepsDone: user.stepsDone ?? 0,
      hobbies: user.hobbies ?? <String>[],
      languages: user.languages ?? <String>[],
      photos: user.photos ?? <String>[],
      iceBreakers: user.iceBreakers ?? <IceBreakerModel>[],

      showSchoolName: user.showSchoolName ?? true,
      showJobTitle: user.showJobTitle ?? true,
      showCompanyName: user.showCompanyName ?? true,
      showHometown: user.showHometown ?? true,
      showReligion: user.showReligion ?? true,
      showGender: user.showGender ?? true,
      showHeight: user.showHeight ?? true,
      showEthnicity: user.showEthnicity ?? true,
      showLanguages: user.showLanguages ?? true,
      showDrinking: user.showDrinking ?? true,
      showSmoking: user.showSmoking ?? true,
      showPoliticalAffiliation: user.showPoliticalAffiliation ?? true,
    );
  }

  // =======================
  // toJson
  // =======================
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'DateOfBirth': dateOfBirth,
      'Gender': gender,
      'height': height,
      'religious_views': religiousViews,
      'ethnicity': ethnicity,
      'education': education,
      'school_name': schoolName,
      'job_title': jobTitle,
      'company_name': companyName,
      'hometown': hometown,
      'interested_in': interestedIn,
      'political_affiliation': politicalAffiliation,
      'drinking': drinking,
      'smoking': smoking,
      'social_handle': socialHandle,
      'hobbies': hobbies,
      'iceBreakers': iceBreakers.map((e) => e.toJson()).toList(),
      'languages': languages,
      'photos': photos,
      'initialSetup': initialSetup,
      'steps_done': stepsDone,
      'show_school_name': showSchoolName,
      'show_job_title': showJobTitle,
      'show_company_name': showCompanyName,
      'show_hometown': showHometown,
      'show_religion': showReligion,
      'show_gender': showGender,
      'show_height': showHeight,
      'show_ethnicity': showEthnicity,
      'show_languages': showLanguages,
      'show_drinking': showDrinking,
      'show_smoking': showSmoking,
      'show_political_affiliation': showPoliticalAffiliation,
      "latitude": latitude,
      "longitude": longitude,
      if (latitude != null && longitude != null)
        'location': {
          'type': 'Point',
          'coordinates': [longitude, latitude],
        },
    };
  }

  ProfileFormModel copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? height,
    String? religiousViews,
    String? ethnicity,
    String? education,
    String? schoolName,
    String? jobTitle,
    String? companyName,
    String? hometown,
    String? interestedIn,
    String? politicalAffiliation,
    String? drinking,
    String? smoking,
    String? socialHandle,
    List<String>? hobbies,
    List<IceBreakerModel>? iceBreakers,
    List<String>? languages,
    List<String>? photos,
    int? stepsDone,
    bool? initialSetup,
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
    double? latitude,
    double? longitude,

    bool? isPubliclyDisplayed,
    bool? displayOnProfile,
    bool? displayOnProfile1,
    DateTime? selectedDate,
    int? calculatedAge,
    String? zodiacSign,
    bool? isManSelected,
    bool? isWomanSelected,
    bool? isNonbinarySelected,
    bool? isMenSelected,
    bool? isWomenSelected,
    bool? isNonbinaryPeopleSelected,
    bool? isEveryoneSelected,
    int? selectedHeightIndex,
    List<String>? answers,
    List<bool>? expandedStates,
    List<String>? promptTitles,
  }) {
    return ProfileFormModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      religiousViews: religiousViews ?? this.religiousViews,
      ethnicity: ethnicity ?? this.ethnicity,
      education: education ?? this.education,
      schoolName: schoolName ?? this.schoolName,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      hometown: hometown ?? this.hometown,
      interestedIn: interestedIn ?? this.interestedIn,
      politicalAffiliation: politicalAffiliation ?? this.politicalAffiliation,
      drinking: drinking ?? this.drinking,
      smoking: smoking ?? this.smoking,
      socialHandle: socialHandle ?? this.socialHandle,
      hobbies: hobbies ?? this.hobbies,
      iceBreakers: iceBreakers ?? this.iceBreakers,
      languages: languages ?? this.languages,
      photos: photos ?? this.photos,
      stepsDone: stepsDone ?? this.stepsDone,
      initialSetup: initialSetup ?? this.initialSetup,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,

      isPubliclyDisplayed: isPubliclyDisplayed ?? this.isPubliclyDisplayed,
      displayOnProfile: displayOnProfile ?? this.displayOnProfile,
      displayOnProfile1: displayOnProfile1 ?? this.displayOnProfile1,
      selectedDate: selectedDate ?? this.selectedDate,
      calculatedAge: calculatedAge ?? this.calculatedAge,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      isManSelected: isManSelected ?? this.isManSelected,
      isWomanSelected: isWomanSelected ?? this.isWomanSelected,
      isNonbinarySelected: isNonbinarySelected ?? this.isNonbinarySelected,
      isMenSelected: isMenSelected ?? this.isMenSelected,
      isWomenSelected: isWomenSelected ?? this.isWomenSelected,
      isNonbinaryPeopleSelected:
          isNonbinaryPeopleSelected ?? this.isNonbinaryPeopleSelected,
      isEveryoneSelected: isEveryoneSelected ?? this.isEveryoneSelected,
      selectedHeightIndex: selectedHeightIndex ?? this.selectedHeightIndex,
      answers: answers ?? this.answers,
      expandedStates: expandedStates ?? this.expandedStates,
      promptTitles: promptTitles ?? this.promptTitles,
    );
  }
}
