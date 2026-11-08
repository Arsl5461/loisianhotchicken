import 'dart:convert';

import 'package:OApp/config/error_handler.dart';
import 'package:OApp/models/dating_preferences_model.dart';
import 'package:OApp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/toast.dart';
import 'home_controller_base.dart';

mixin HomePreferencesMixin on HomeControllerBase {
  static const String datingPreferencesKey = 'dating_preferences';

  final Rx<DatingPreferencesModel> datingPreferences = DatingPreferencesModel(
    ageRange: const RangeValues(22, 36),
    maxDistance: 8,
    lookingFor: null,
    interests: const [],
    height: null,
    ethnicity: const [],
    education: null,
    religion: const [],
    drinking: null,
    smoking: null,
    gender: null,
    politics: const [],
    languages: const [],
  ).obs;

  RxBool isSavingPreferences = false.obs;

  DatingPreferencesModel get prefs => datingPreferences.value;

  double calculateProfileCompletion(UserModel? user) {
    if (user == null) return 0.0;

    final datingPercentage = datingPreferences.value.completionPercentage;
    final profileInfoPercentage = user.profileCompletion;

    return ((profileInfoPercentage * 0.5) + (datingPercentage * 0.5)).clamp(
      0,
      100,
    );
  }

  Future<void> loadPreferenceSelectionsFromStorage() async {
    try {
      final raw = await storage.getKey(datingPreferencesKey);

      if (raw == null || raw.isEmpty) return;

      final Map<String, dynamic> json = jsonDecode(raw);
      datingPreferences.value = DatingPreferencesModel.fromJson(json);
    } catch (e) {
      debugPrint('Load preferences error: $e');
    }
  }

  Future<void> savePreferenceSelectionsToStorage() async {
    try {
      savePreferencesToApi();
      isSavingPreferences.value = true;
    } catch (e) {
      debugPrint('Save preferences error: $e');
    } finally {
      isSavingPreferences.value = false;
      Toast.success('Dating Preference Updated');
    }
  }

  Future<void> savePreferencesToApi() async {
    try {
      final updated = await homeRepository.savePreferences(
        datingPreferences.value,
      );
      if (updated != null) {
        datingPreferences.value = updated;
      }
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
    }
  }

  @override
  Future<void> getPrefrencesfromApi() async {
    try {
      final preferences = await homeRepository.fetchPreferences();
      if (preferences != null) {
        datingPreferences.value = preferences;
      }
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
    }
  }

  Future<void> clearAllPreferenceSelections() async {
    await storage.deleteKey(datingPreferencesKey);

    datingPreferences.value = DatingPreferencesModel(
      ageRange: const RangeValues(22, 36),
      maxDistance: 8,
      lookingFor: null,
      interests: const [],
      height: null,
      ethnicity: const [],
      education: null,
      religion: const [],
      drinking: null,
      smoking: null,
      gender: null,
      politics: const [],
      languages: const [],
    );

    await loadPosts();
  }
}
