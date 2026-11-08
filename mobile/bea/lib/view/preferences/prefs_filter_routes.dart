import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import 'bubba_prefs_controller.dart';
import 'choice_list_screens.dart';

/// Where each of the hub's ten filter rows goes, and what it carries with it.
/// The value screens read their current value off [BubbaPrefsController], so
/// the arguments here only pick which screen and which option list to draw.
class PrefsFilterRoute {
  const PrefsFilterRoute(this.name, [this.arguments]);

  final String name;
  final Map<String, dynamic>? arguments;

  Future<T?>? open<T>() => Get.toNamed<T>(name, arguments: arguments);
}

PrefsFilterRoute prefsRouteFor(PrefsFilterKind kind) => switch (kind) {
      PrefsFilterKind.sexuality =>
        const PrefsFilterRoute(Routes.BUBBA_PREFS_LOOKING_FOR),
      PrefsFilterKind.location => const PrefsFilterRoute(
          Routes.BUBBA_PREFS_CHOOSE_LOCATION,
          {'radius': false},
        ),
      PrefsFilterKind.ageRange =>
        const PrefsFilterRoute(Routes.BUBBA_PREFS_AGE_RANGE),
      PrefsFilterKind.maxDistance =>
        const PrefsFilterRoute(Routes.BUBBA_PREFS_DISTANCE),
      PrefsFilterKind.height =>
        const PrefsFilterRoute(Routes.BUBBA_PREFS_HEIGHT),
      PrefsFilterKind.politics => const PrefsFilterRoute(
          Routes.BUBBA_PREFS_MULTI,
          {
            'kind': PrefsFilterKind.politics,
            'title': 'Politics',
            'intro': 'Select the political views you’re\nopen to in a match.',
            'options': prefsPoliticsMulti,
          },
        ),
      PrefsFilterKind.ethnicity => const PrefsFilterRoute(
          Routes.BUBBA_PREFS_MULTI,
          {
            'kind': PrefsFilterKind.ethnicity,
            'title': 'Ethnicity',
            'intro': 'Select the ethnicities you’re\nopen to in a match.',
            'options': prefsEthnicityMulti,
          },
        ),
      PrefsFilterKind.religion => const PrefsFilterRoute(
          Routes.BUBBA_PREFS_MULTI,
          {
            'kind': PrefsFilterKind.religion,
            'title': 'Religion',
            'intro': 'Select the religions you’re\nopen to in a match.',
            'options': prefsReligionMulti,
          },
        ),
      PrefsFilterKind.education => const PrefsFilterRoute(
          Routes.BUBBA_PREFS_CHOICE,
          {
            'kind': PrefsFilterKind.education,
            'title': 'Education',
            'options': prefsEducationOptions,
          },
        ),
      PrefsFilterKind.languages => const PrefsFilterRoute(
          Routes.BUBBA_PREFS_CHOICE,
          {
            'kind': PrefsFilterKind.languages,
            'title': 'Languages',
            'options': prefsLanguageOptions,
          },
        ),
    };
