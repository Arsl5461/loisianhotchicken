import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/widgets/bubba_loading.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/repositories/travel_repository.dart';
import '../../models/dating_preferences_model.dart';
import '../../models/travel_destination_model.dart';

enum PrefsFilterKind {
  sexuality,
  location,
  ageRange,
  maxDistance,
  height,
  politics,
  education,
  languages,
  ethnicity,
  religion,
}

extension PrefsFilterKindApi on PrefsFilterKind {
  String get label => switch (this) {
        PrefsFilterKind.sexuality => 'Sexuality',
        PrefsFilterKind.location => 'Location',
        PrefsFilterKind.ageRange => 'Age Range',
        PrefsFilterKind.maxDistance => 'Maximum Distance',
        PrefsFilterKind.height => 'Height',
        PrefsFilterKind.politics => 'Politics',
        PrefsFilterKind.education => 'Education',
        PrefsFilterKind.languages => 'Languages',
        PrefsFilterKind.ethnicity => 'Ethnicity',
        PrefsFilterKind.religion => 'Religion',
      };

  /// The API field this row writes. `non_negotiable` carries these names, so
  /// they have to be the server's spelling, not the design's.
  String? get field => switch (this) {
        PrefsFilterKind.sexuality => 'looking_for',
        PrefsFilterKind.location => null,
        PrefsFilterKind.ageRange => 'age_range',
        PrefsFilterKind.maxDistance => 'max_distance',
        PrefsFilterKind.height => 'height',
        PrefsFilterKind.politics => 'politics',
        PrefsFilterKind.education => 'education',
        PrefsFilterKind.languages => 'languages',
        PrefsFilterKind.ethnicity => 'ethnicity',
        PrefsFilterKind.religion => 'religion',
      };
}

class PrefsSaveOutcome {
  const PrefsSaveOutcome.ok()
      : succeeded = true,
        message = null;
  const PrefsSaveOutcome.failed(this.message) : succeeded = false;

  final bool succeeded;
  final String? message;
}

/// The one object every part 4 screen reads and writes. It loads the
/// preferences on open, holds them, and writes them back. A save in flight
/// refuses a second one, which is what makes the CTA double-tap safe.
class BubbaPrefsController extends GetxController {
  BubbaPrefsController({HomeRepository? home, TravelRepository? travel})
      : _home = home ?? Get.find<HomeRepository>(),
        _travel = travel ?? Get.find<TravelRepository>();

  final HomeRepository _home;
  final TravelRepository _travel;

  static DatingPreferencesModel emptyPreferences() => DatingPreferencesModel(
        ageRange: const RangeValues(22, 36),
        maxDistance: 8,
        interests: const [],
        politics: const [],
        languages: const [],
      );

  final Rx<DatingPreferencesModel> prefs = emptyPreferences().obs;
  final Rx<TravelTrip> trip = const TravelTrip().obs;

  final RxBool loading = false.obs;
  final RxBool saving = false.obs;
  final RxnString loadError = RxnString();
  final RxnString saveError = RxnString();

  bool _loadedOnce = false;

  DatingPreferencesModel get model => prefs.value;
  bool get isTravelling => trip.value.isTraveling;

  @override
  void onInit() {
    super.onInit();
    BubbaBusy.watch([loading, saving, travelSaving]);
    load();
  }

  Future<void> load({bool force = false}) async {
    if (loading.value) return;
    if (_loadedOnce && !force) return;

    loading.value = true;
    loadError.value = null;

    try {
      final loaded = await _home.fetchPreferences();
      if (loaded != null) {
        prefs.value = loaded;
      }

      final loadedTrip = await _home.fetchTravelTrip();
      if (loadedTrip != null) {
        trip.value = loadedTrip;
      }

      _loadedOnce = true;
    } catch (error) {
      loadError.value = 'Could not load your preferences. Pull to retry.';
      debugPrint('BubbaPrefsController.load failed: $error');
    } finally {
      loading.value = false;
    }
  }

  /// Applies [change] locally, writes it back, and rolls the local value back
  /// if the write fails. Returns false while another save is in flight, which
  /// is how a double tap on a CTA is refused.
  Future<PrefsSaveOutcome> apply(
    DatingPreferencesModel Function(DatingPreferencesModel current) change,
  ) async {
    if (saving.value) {
      return const PrefsSaveOutcome.failed(null);
    }

    final previous = prefs.value;
    final next = change(previous);

    saving.value = true;
    saveError.value = null;
    prefs.value = next;

    try {
      final saved = await _home.savePreferences(next);
      if (saved == null) {
        prefs.value = previous;
        saveError.value = 'Could not save that. Check your connection.';
        return PrefsSaveOutcome.failed(saveError.value);
      }

      prefs.value = saved;
      return const PrefsSaveOutcome.ok();
    } catch (error) {
      prefs.value = previous;
      saveError.value = 'Could not save that. Check your connection.';
      debugPrint('BubbaPrefsController.apply failed: $error');
      return PrefsSaveOutcome.failed(saveError.value);
    } finally {
      saving.value = false;
    }
  }

  bool isNonNegotiable(PrefsFilterKind kind) {
    final field = kind.field;
    if (field == null) return false;
    return model.nonNegotiable.contains(field);
  }

  Future<PrefsSaveOutcome> setNonNegotiable(
    PrefsFilterKind kind,
    bool value,
  ) {
    final field = kind.field;
    if (field == null) return Future.value(const PrefsSaveOutcome.ok());

    return apply((current) {
      final next = current.nonNegotiable.toList();
      if (value) {
        if (!next.contains(field)) next.add(field);
      } else {
        next.remove(field);
      }
      return current.copyWith(nonNegotiable: next);
    });
  }

  // ---- the ten hub rows, rendered from the live model ----

  static const String openToAll = 'Open to all';

  String _listValue(List<String> values) =>
      values.isEmpty ? openToAll : values.join(', ');

  String valueFor(PrefsFilterKind kind) {
    final m = model;

    return switch (kind) {
      PrefsFilterKind.sexuality => m.lookingFor?.trim().isNotEmpty == true
          ? m.lookingFor!
          : 'Everyone',
      PrefsFilterKind.location => trip.value.isTraveling
          ? (trip.value.destination?.name ?? 'Choose location')
          : (_homeCity ?? 'Current location'),
      PrefsFilterKind.ageRange =>
        '${m.ageRange.start.round()} to ${m.ageRange.end.round()}',
      PrefsFilterKind.maxDistance => '${m.maxDistance.round()} mi',
      PrefsFilterKind.height =>
        m.height?.trim().isNotEmpty == true ? m.height! : openToAll,
      PrefsFilterKind.politics => _listValue(m.politics),
      PrefsFilterKind.education =>
        m.education?.trim().isNotEmpty == true ? m.education! : openToAll,
      PrefsFilterKind.languages => _listValue(m.languages),
      PrefsFilterKind.ethnicity => _listValue(m.ethnicity),
      PrefsFilterKind.religion => _listValue(m.religion),
    };
  }

  String? _homeCity;

  set homeCity(String? value) {
    _homeCity = value;
    prefs.refresh();
  }

  // ---- travel ----

  final RxBool travelSaving = false.obs;
  final RxnString travelError = RxnString();

  Future<bool> setDestination(
    TravelDestination destination, {
    DateTime? arrivalDate,
  }) async {
    if (travelSaving.value) return false;
    if (!destination.hasCoordinates) {
      travelError.value = 'That place has no location on the map yet.';
      return false;
    }

    travelSaving.value = true;
    travelError.value = null;

    try {
      final saved = await _home.setTravelDestination(
        destination: destination,
        arrivalDate: arrivalDate ?? trip.value.arrivalDate,
      );

      if (saved == null) {
        travelError.value = 'Could not save that destination.';
        return false;
      }

      trip.value = saved;
      await apply((current) => current.copyWith(istraveling: true));
      return true;
    } catch (error) {
      travelError.value = 'Could not save that destination.';
      debugPrint('BubbaPrefsController.setDestination failed: $error');
      return false;
    } finally {
      travelSaving.value = false;
    }
  }

  Future<bool> setArrivalDate(DateTime date) async {
    final destination = trip.value.destination;
    if (destination == null) {
      travelError.value = 'Pick a destination first.';
      return false;
    }
    return setDestination(destination, arrivalDate: date);
  }

  Future<bool> setTravelMode(bool on) async {
    if (travelSaving.value) return false;

    if (on && trip.value.destination == null) {
      travelError.value = 'Pick a destination first.';
      return false;
    }

    travelSaving.value = true;
    travelError.value = null;
    final previous = trip.value;
    trip.value = previous.copyWith(isTraveling: on);

    try {
      final ok = await _home.setTravelMode(on);
      if (!ok) {
        trip.value = previous;
        travelError.value = on
            ? 'Could not turn Travel on.'
            : 'Could not turn Travel off.';
        return false;
      }

      if (!on) {
        trip.value = const TravelTrip();
      }

      await apply((current) => current.copyWith(istraveling: on));
      return true;
    } catch (error) {
      trip.value = previous;
      travelError.value = 'Could not change Travel mode.';
      debugPrint('BubbaPrefsController.setTravelMode failed: $error');
      return false;
    } finally {
      travelSaving.value = false;
    }
  }

  Future<bool> clearTrip() => setTravelMode(false);

  // ---- destination search ----

  final RxList<TravelDestination> searchResults = <TravelDestination>[].obs;
  final RxList<TravelDestination> nearbyResults = <TravelDestination>[].obs;
  final RxBool searching = false.obs;
  final RxnString searchError = RxnString();
  final RxString query = ''.obs;

  int _searchToken = 0;

  Future<void> search(String value) async {
    query.value = value;
    final trimmed = value.trim();
    final token = ++_searchToken;

    if (trimmed.isEmpty) {
      searchResults.clear();
      searchError.value = null;
      searching.value = false;
      return;
    }

    searching.value = true;
    searchError.value = null;

    try {
      final results = await _travel.searchDestinations(trimmed);
      if (token != _searchToken) return;

      if (results == null) {
        searchError.value = 'Could not search right now.';
        searchResults.clear();
        return;
      }

      searchResults.assignAll(results);
    } catch (error) {
      if (token != _searchToken) return;
      searchError.value = 'Could not search right now.';
      searchResults.clear();
      debugPrint('BubbaPrefsController.search failed: $error');
    } finally {
      if (token == _searchToken) searching.value = false;
    }
  }

  /// Resolves one exact city name, for the sheet's three placed popular cards.
  Future<TravelDestination?> searchOne(String name) async {
    try {
      final results = await _travel.searchDestinations(name, limit: 5);
      if (results == null || results.isEmpty) return null;
      for (final city in results) {
        if (city.name.toLowerCase() == name.toLowerCase()) return city;
      }
      return results.first;
    } catch (error) {
      debugPrint('BubbaPrefsController.searchOne failed: $error');
      return null;
    }
  }

  Future<void> loadNearby({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final results = await _travel.fetchNearbyDestinations(
        latitude: latitude,
        longitude: longitude,
      );
      if (results != null) nearbyResults.assignAll(results);
    } catch (error) {
      debugPrint('BubbaPrefsController.loadNearby failed: $error');
    }
  }

  static BubbaPrefsController get to {
    if (!Get.isRegistered<BubbaPrefsController>()) {
      Get.put(BubbaPrefsController(), permanent: true);
    }
    return Get.find<BubbaPrefsController>();
  }
}
