import 'dart:convert';
import 'package:flutter/material.dart';

class DatingPreferencesModel {
  final String? id;
  final RangeValues ageRange;
  final bool istraveling;
  final double maxDistance;
  final String? lookingFor;
  final List<String> interests;
  final String? height;
  final List<String> ethnicity;
  final String? education;
  final List<String> religion;
  final bool? drinking;
  final bool? smoking;
  String? gender;
  final List<String> politics;
  final List<String> languages;
  final List<String> zodiac;
  final List<String> intentions;
  final String? nationality;
  final List<String> nonNegotiable;

  DatingPreferencesModel({
    this.id,
    this.istraveling = false,
    required this.ageRange,
    required this.maxDistance,
    this.lookingFor,
    required this.interests,
    this.height,
    this.ethnicity = const [],
    this.education,
    this.religion = const [],
    this.drinking,
    this.smoking,
    this.gender,
    required this.politics,
    required this.languages,
    this.zodiac = const [],
    this.intentions = const [],
    this.nationality,
    this.nonNegotiable = const [],
  });

  DatingPreferencesModel copyWith({
    bool? istraveling,
    String? id,
    RangeValues? ageRange,
    double? maxDistance,
    String? lookingFor,
    List<String>? interests,
    String? height,
    List<String>? ethnicity,
    String? education,
    List<String>? religion,
    bool? drinking,
    bool? smoking,
    String? gender,
    List<String>? politics,
    List<String>? languages,
    List<String>? zodiac,
    List<String>? intentions,
    String? nationality,
    List<String>? nonNegotiable,
    bool clearLookingFor = false,
    bool clearHeight = false,
    bool clearEducation = false,
    bool clearGender = false,
    bool clearNationality = false,
  }) {
    return DatingPreferencesModel(
      istraveling: istraveling ?? this.istraveling,
      id: id ?? this.id,
      ageRange: ageRange ?? this.ageRange,
      maxDistance: maxDistance ?? this.maxDistance,
      lookingFor: clearLookingFor ? null : lookingFor ?? this.lookingFor,
      interests: interests ?? this.interests,
      height: clearHeight ? null : height ?? this.height,
      ethnicity: ethnicity ?? this.ethnicity,
      education: clearEducation ? null : education ?? this.education,
      religion: religion ?? this.religion,
      drinking: drinking ?? this.drinking,
      smoking: smoking ?? this.smoking,
      gender: clearGender ? null : gender ?? this.gender,
      politics: politics ?? this.politics,
      languages: languages ?? this.languages,
      zodiac: zodiac ?? this.zodiac,
      intentions: intentions ?? this.intentions,
      nationality:
          clearNationality ? null : nationality ?? this.nationality,
      nonNegotiable: nonNegotiable ?? this.nonNegotiable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "istraveling": istraveling,
      "age_min": ageRange.start,
      "age_max": ageRange.end,
      "max_distance": maxDistance,
      "looking_for": lookingFor,
      "interests": interests,
      "height": height,
      "ethnicity": ethnicity,
      "education": education,
      "religion": religion,
      "drinking": drinking,
      "smoking": smoking,
      "gender": gender,
      "politics": politics,
      "languages": languages,
      "zodiac": zodiac,
      "intentions": intentions,
      "nationality": nationality,
      "non_negotiable": nonNegotiable,
    };
  }

  factory DatingPreferencesModel.fromJson(Map<String, dynamic> json) {
    return DatingPreferencesModel(
      id: json["_id"],
      istraveling: json["istraveling"] ?? false,
      ageRange: RangeValues(
        (json["age_min"] ?? 18).toDouble(),
        (json["age_max"] ?? 50).toDouble(),
      ),
      maxDistance: (json["max_distance"] ?? 50).toDouble(),
      lookingFor: json["looking_for"],
      interests: List<String>.from(json["interests"] ?? []),
      height: json["height"],
      ethnicity: _stringList(json["ethnicity"]),
      education: json["education"],
      religion: _stringList(json["religion"]),
      drinking: json["drinking"],
      smoking: json["smoking"],
      gender: json["gender"],
      politics: _stringList(json["politics"]),
      languages: _stringList(json["languages"]),
      zodiac: _stringList(json["zodiac"]),
      intentions: _stringList(json["intentions"]),
      nationality: json["nationality"],
      nonNegotiable: _stringList(json["non_negotiable"]),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value
          .map((item) => item?.toString().trim() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    if (value is String) {
      return value
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  String toRawJson() => jsonEncode(toJson());

  factory DatingPreferencesModel.fromRawJson(String str) =>
      DatingPreferencesModel.fromJson(jsonDecode(str));

  double get completionPercentage {
    int totalFields = 14; // total fields to consider
    int filled = 0;

    if (istraveling) filled++; // always true technically
    if (ageRange.start != 0 && ageRange.end != 0) filled++;
    if (maxDistance > 0) filled++;
    if (lookingFor != null && lookingFor!.isNotEmpty) filled++;
    if (interests.isNotEmpty) filled++;
    if (height != null && height!.isNotEmpty) filled++;
    if (ethnicity.isNotEmpty) filled++;
    if (education != null && education!.isNotEmpty) filled++;
    if (religion.isNotEmpty) filled++;
    if (drinking != null) filled++;
    if (smoking != null) filled++;
    if (gender != null && gender!.isNotEmpty) filled++;
    if (politics.isNotEmpty) filled++;
    if (languages.isNotEmpty) filled++;

    return (filled / totalFields) * 100;
  }
}
