import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'models/icebreaker_entry.dart';
import 'profile_setup_backend.dart';
import 'questions.dart';
import 'widgets/choice_chip_grid.dart';

/// A photo the user picked. The file is what gets uploaded; the provider is
/// what the grid draws. Keeping them in one object means a reorder or a removal
/// cannot put the two out of step.
class ProfileSetupPhoto {
  ProfileSetupPhoto(File this.file) : provider = FileImage(file);

  /// Tests hand in a provider with no file behind it.
  ProfileSetupPhoto.provider(this.provider) : file = null;

  final File? file;
  final ImageProvider provider;
}

/// Every answer the "building your profile" flow collects, in one place.
///
/// The part 2 screens are pure views driven by callbacks, so this is the only
/// object that knows the flow exists. It holds the answers; `profile_setup_pages`
/// holds the order the screens are visited in.
class ProfileSetupController extends GetxController {
  static ProfileSetupController get instance =>
      Get.isRegistered<ProfileSetupController>()
          ? Get.find<ProfileSetupController>()
          : Get.put(ProfileSetupController(), permanent: true);

  final firstName = ''.obs;
  final lastName = ''.obs;

  final gender = RxnString();
  final interestedIn = RxnString();

  final birthday = Rxn<DateTime>();

  final hometown = ''.obs;
  final hometownOnProfile = true.obs;

  final heightCentimetres = RxnInt();
  final heightOnProfile = true.obs;

  final religion = <String>{}.obs;
  final religionOnProfile = true.obs;

  final languages = <String>{}.obs;
  final languagesOnProfile = true.obs;

  final ethnicity = <String>{}.obs;
  final ethnicityOnProfile = true.obs;

  final educationLevel = RxnString();
  final fieldOfStudy = ''.obs;
  final school = ''.obs;
  final educationOnProfile = true.obs;

  final jobTitle = ''.obs;
  final company = ''.obs;
  final workOnProfile = true.obs;

  final lookingFor = <String>{}.obs;
  final lookingForOnProfile = true.obs;

  final politicalViews = <String>{}.obs;
  final politicalOnProfile = true.obs;

  final bio = ''.obs;

  final icebreakers = <IcebreakerEntry>[].obs;

  /// Six slots, null being an empty tile.
  final slots = List<ProfileSetupPhoto?>.filled(6, null).obs;

  /// What [PhotosScreen] draws.
  List<ImageProvider?> get photos =>
      [for (final slot in slots) slot?.provider];

  List<File> get photoFiles =>
      [for (final slot in slots) if (slot?.file != null) slot!.file!];

  static const int minimumPhotos = 4;

  int get photoCount => slots.where((p) => p != null).length;

  bool get hasEnoughPhotos => photoCount >= minimumPhotos;

  void setName(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    firstName.value = parts.first;
    lastName.value = parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  String get fullName =>
      [firstName.value, lastName.value].where((p) => p.isNotEmpty).join(' ');

  void addPhoto(ProfileSetupPhoto photo) {
    final slot = slots.indexWhere((p) => p == null);
    if (slot == -1) return;
    slots[slot] = photo;
    slots.refresh();
  }

  void removePhoto(int slot) {
    if (slot < 0 || slot >= slots.length) return;
    slots[slot] = null;
    slots.refresh();
  }

  void reorderPhotos(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    if (oldIndex < 0 || oldIndex >= slots.length) return;
    final moved = slots.removeAt(oldIndex);
    slots.insert(newIndex.clamp(0, slots.length), moved);
    slots.refresh();
  }

  void addIcebreaker(IcebreakerEntry entry) {
    icebreakers.add(entry);
  }

  // ===== backend =====

  /// Swapped for a fake in tests. Lazy on purpose: the live one reaches into
  /// GetX for Dio and secure storage, so constructing it eagerly would make the
  /// controller impossible to build without the whole DI graph.
  late ProfileSetupBackend backend = LiveProfileSetupBackend();

  /// The prompt catalogue, fetched once when the icebreaker flow opens.
  final prompts = <IcebreakerPrompt>[].obs;

  Future<void> loadPrompts() async {
    if (prompts.isNotEmpty) return;
    try {
      prompts.assignAll(await backend.fetchPrompts());
    } catch (_) {
      // The browse screen falls back to the design's copy. An answer made
      // against that fallback carries no id, and `_promptIdFor` registers the
      // line with the API at submit time so it is not silently dropped.
    }
  }

  /// The catalogue id for a prompt line, registering it if the catalogue does
  /// not have it yet. Returns null only when the API refused.
  Future<String?> _promptIdFor(String text) async {
    final wanted = text.trim();
    if (wanted.isEmpty) return null;
    await loadPrompts();
    for (final prompt in prompts) {
      if (prompt.text.trim().toLowerCase() == wanted.toLowerCase()) {
        return prompt.id;
      }
    }
    try {
      final id = await backend.createPrompt(wanted);
      if (id != null && id.isNotEmpty) {
        prompts.add(IcebreakerPrompt(id: id, text: wanted));
        return id;
      }
    } catch (_) {
      // Falls through to null, which `submit` turns into a readable error.
    }
    return null;
  }

  /// `iceBreakers` as `addProfile` wants it: prompt id to answer. Anything the
  /// API cannot key is left out, and [submit] refuses to post an empty list
  /// rather than letting the request 400 on the last screen of the flow.
  Future<List<Map<String, String>>> resolveIcebreakers() async {
    final resolved = <Map<String, String>>[];
    for (final entry in icebreakers) {
      final answer = answerOf(entry).trim();
      if (answer.isEmpty) continue;
      var id = entry.promptId;
      if (id == null || id.isEmpty) id = await _promptIdFor(entry.title);
      if (id == null || id.isEmpty) continue;
      resolved.add({'_id': id, 'answer': answer});
    }
    return resolved;
  }

  final submitting = false.obs;
  final submitError = RxnString();

  /// Carried over from part 1, which is where the account's email and phone
  /// were captured. Set by the flow before it submits; `addProfile` saves a
  /// profile against the account, so leaving them out drops what part 1 asked
  /// the user for.
  final email = ''.obs;
  final phoneNumber = ''.obs;

  /// `user/addProfile` rejects anything outside its own vocabulary, and the
  /// design's chip values are not it: the API takes "Men"/"Women"/"Everyone"
  /// and the flow collects "men"/"women"/"everyone", so three of the four
  /// options 400'd. Verified against the backend running locally.
  static const Map<String, String> apiInterestedIn = {
    'men': 'Men',
    'women': 'Women',
    'everyone': 'Everyone',
    // The API has no nonbinary option; it has to grow one.
    'nonbinary_people': 'Nonbinary people',
  };

  static const Map<String, String> apiGender = {
    'man': 'Man',
    'woman': 'Woman',
    'nonbinary': 'Nonbinary',
  };

  /// The API's education vocabulary differs from the design's labels in case
  /// and wording, and is missing four of them outright. Every level the design
  /// offers 400'd before this map existed.
  static const Map<String, String> apiEducation = {
    'High school': 'High School',
    'Associate degree': 'Associates',
    'Bachelor’s degree': 'Bachelors',
    'Master’s degree': 'Masters',
    // The design spells it "Doctoreate"; the API spells it correctly.
    'Doctoreate': 'Doctorate',
    // No API equivalent - these need adding on the backend.
    'Trade / vocational': 'Trade / vocational',
    'Some college': 'Some college',
    'Other': 'Other',
    'Prefer not to say': 'Prefer not to say',
  };

  /// The human label behind a chip value, joined for the API.
  ///
  /// The chips carry slugs ("life_partner", "prefer_not") because that is what
  /// the flow keys selection on, but every other screen in the app - and the
  /// profile card the answers end up on - reads these fields as prose, so the
  /// label is what gets sent. Design labels wrap on a `\n`, which is layout,
  /// not content.
  static String labelsFor(List<ChipItem> options, Iterable<String> values) => [
        for (final option in options)
          if (values.contains(option.value))
            option.label.replaceAll('\n', ' '),
      ].join(', ');

  /// Step 4 of `addProfile` requires `political_affiliation`, so a skipped
  /// political screen has to say so rather than send an empty string, which
  /// the API rejects.
  String get apiPoliticalAffiliation {
    final labels = labelsFor(ProfileQuestions.political, politicalViews);
    return labels.isEmpty ? 'Prefer not to say' : labels;
  }

  /// The body `user/addProfile` expects, built from the answers the flow
  /// collected. `show_*` are the "Display on profile" toggles.
  ///
  /// **Four of these keys have no field in `UserModel`/`ProfileFormModel`:**
  /// `bio`, `looking_for`, `field_of_study` and `show_looking_for`. The design
  /// asks all four questions and the API has nowhere to put the answers, so
  /// they are sent under these names and the backend has to grow to match.
  Map<String, dynamic> buildBody(
    List<String> photoUrls,
    List<Map<String, String>> resolvedIcebreakers,
  ) => {
        'fullName': fullName,
        if (email.value.isNotEmpty) 'email': email.value,
        if (phoneNumber.value.isNotEmpty) 'phoneNumber': phoneNumber.value,
        'DateOfBirth': birthday.value == null
            ? null
            : '${birthday.value!.year.toString().padLeft(4, '0')}-'
                '${birthday.value!.month.toString().padLeft(2, '0')}-'
                '${birthday.value!.day.toString().padLeft(2, '0')}',
        'Gender': gender.value == null ? null : apiGender[gender.value],
        'interested_in': interestedIn.value == null
            ? null
            : apiInterestedIn[interestedIn.value],
        'height': heightCentimetres.value?.toString(),
        'hometown': hometown.value,
        'religious_views': labelsFor(ProfileQuestions.religion, religion),
        'ethnicity': labelsFor(ProfileQuestions.ethnicity, ethnicity),
        'education': educationLevel.value == null
            ? null
            : (apiEducation[educationLevel.value] ?? educationLevel.value),
        'field_of_study': fieldOfStudy.value,
        'school_name': school.value,
        'job_title': jobTitle.value,
        'company_name': company.value,
        'political_affiliation': apiPoliticalAffiliation,
        'languages': languages.toList(),
        'looking_for': labelsFor(ProfileQuestions.lookingFor, lookingFor),
        'bio': bio.value,
        'photos': photoUrls,
        'iceBreakers': resolvedIcebreakers,
        'show_hometown': hometownOnProfile.value,
        'show_height': heightOnProfile.value,
        'show_religion': religionOnProfile.value,
        'show_ethnicity': ethnicityOnProfile.value,
        'show_languages': languagesOnProfile.value,
        'show_school_name': educationOnProfile.value,
        'show_job_title': workOnProfile.value,
        'show_company_name': workOnProfile.value,
        'show_political_affiliation': politicalOnProfile.value,
        'show_looking_for': lookingForOnProfile.value,
        'initialSetup': true,
        'steps_done': 4,
      };

  static String answerOf(IcebreakerEntry entry) => switch (entry) {
        PromptIcebreaker(:final answer) => answer,
        SnapIcebreaker(:final caption) => caption,
        MultipleChoiceIcebreaker(:final options) => options.join(', '),
        TwoTruthsIcebreaker(:final statements) => statements.join(', '),
        GameIcebreaker() => '',
      };

  /// Uploads the photos, then saves the profile. Returns true only when the
  /// backend accepted it, so the caller must not navigate on a false.
  Future<bool> submit() async {
    if (submitting.value) return false;
    submitting.value = true;
    submitError.value = null;
    try {
      // `addProfile` step 4 requires an icebreaker and a photo, and it answers
      // a body missing either with "Missing required fields for step 4" on the
      // very last screen of the flow. Saying which screen to go back to is the
      // difference between that and something the user can act on.
      if (icebreakers.isEmpty) {
        submitError.value = 'Add at least one icebreaker before you continue';
        return false;
      }
      if (photoFiles.isEmpty) {
        submitError.value =
            'Add at least $minimumPhotos photos before you continue';
        return false;
      }
      final resolved = await resolveIcebreakers();
      if (resolved.isEmpty) {
        submitError.value = 'Your icebreakers could not be saved. Open '
            'Icebreakers and pick them again.';
        return false;
      }
      final urls = await backend.uploadPhotos(photoFiles);
      if (urls.isEmpty) {
        submitError.value = 'Your photos could not be uploaded. Try again.';
        return false;
      }
      final result = await backend.save(buildBody(urls, resolved));
      if (!result.ok) {
        submitError.value = result.errorMessage ?? 'Could not save your profile';
        return false;
      }
      return true;
    } catch (e) {
      submitError.value = e.toString();
      return false;
    } finally {
      submitting.value = false;
    }
  }

  void replaceIcebreaker(int index, IcebreakerEntry entry) {
    if (index < 0 || index >= icebreakers.length) return;
    icebreakers[index] = entry;
  }
}
