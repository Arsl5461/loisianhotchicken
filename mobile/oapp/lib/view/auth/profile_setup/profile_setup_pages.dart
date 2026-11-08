import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/design/bubba_icons.dart';
import '../../../core/routing/app_routes.dart';
import '../../../utils/toast.dart';
import 'bio_screen.dart';
import 'birthday_screen.dart';
import 'edit_profile_screen.dart';
import 'gender_screen.dart';
import 'height_screen.dart';
import 'hometown_screen.dart';
import 'icebreaker_answer_screen.dart';
import 'icebreaker_browse_screen.dart';
import 'icebreaker_format_screen.dart';
import 'icebreakers_screen.dart';
import 'languages_screen.dart';
import 'models/icebreaker_entry.dart';
import 'name_screen.dart';
import 'photo_edit_screen.dart';
import 'photos_screen.dart';
import 'profile_ready_screen.dart';
import 'photo_gallery_pages.dart';
import 'profile_setup_controller.dart';
import 'profile_setup_routes.dart';
import 'questions.dart';
import 'work_education_screens.dart';

ProfileSetupController get _c => ProfileSetupController.instance;

void _next(String from) {
  final route = ProfileSetupRoutes.after(from);
  if (route != null) Get.toNamed(route);
}

/// Holds the flow in portrait.
///
/// The design has no landscape artboards, so there is nothing to build against;
/// locking is the decision rather than inventing a layout. The lock is scoped to
/// this flow - a counter releases it once the last profile-setup page is gone,
/// so the rest of the app keeps whatever orientations it allows.
class _PortraitOnly extends StatefulWidget {
  const _PortraitOnly({required this.child});

  final Widget child;

  static int _mounted = 0;

  @override
  State<_PortraitOnly> createState() => _PortraitOnlyState();
}

class _PortraitOnlyState extends State<_PortraitOnly> {
  @override
  void initState() {
    super.initState();
    if (_PortraitOnly._mounted++ == 0) {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  void dispose() {
    if (--_PortraitOnly._mounted == 0) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Wraps a flow page in the portrait lock.
GetPage _step(String name, Widget Function() page) =>
    GetPage(name: name, page: () => _PortraitOnly(child: page()));

List<GetPage> _locked(List<GetPage> pages) => [
      for (final page in pages) _step(page.name, page.page),
    ];

/// What the answer editor is being opened for.
class IcebreakerDraft {
  const IcebreakerDraft({
    required this.format,
    required this.prompt,
    this.promptId,
    this.initialValue = '',
    this.editIndex,
  });

  final IcebreakerFormat format;
  final String prompt;

  /// The API keys an answer by its prompt's id and drops anything without one.
  final String? promptId;
  final String initialValue;

  /// Set when an existing entry is being edited rather than a new one added.
  final int? editIndex;
}

/// Turns a typed answer into the entry the "Your icebreakers" cards render.
///
/// The design's browse screen shows the same nine prompt lines under all three
/// tabs and gives no authoring screen for a game's options, so a pick made on
/// the Games tab is stored as a prompt until that screen exists.
IcebreakerEntry _entryFor(
  IcebreakerFormat format,
  String prompt,
  String text,
  String? promptId,
) {
  switch (format) {
    case IcebreakerFormat.snaps:
      return SnapIcebreaker(
        title: prompt,
        caption: text,
        promptId: promptId,
      );
    case IcebreakerFormat.prompts:
    case IcebreakerFormat.games:
      return PromptIcebreaker(
        title: prompt,
        answer: text,
        promptId: promptId,
      );
  }
}

final List<GetPage> profileSetupPages = _locked(_pages);

final List<GetPage> _pages = [
  GetPage(
    name: ProfileSetupRoutes.name,
    page: () => ProfileNameScreen(
      initialValue: _c.fullName,
      onContinue: (value) {
        _c.setName(value);
        _next(ProfileSetupRoutes.name);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.gender,
    page: () => ProfileGenderScreen(
      firstName: _c.firstName.value,
      initialGender: _c.gender.value,
      initialInterestedIn: _c.interestedIn.value,
      onBack: Get.back,
      onContinue: (gender, interestedIn) {
        _c.gender.value = gender;
        _c.interestedIn.value = interestedIn;
        _next(ProfileSetupRoutes.gender);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.birthday,
    page: () => ProfileBirthdayScreen(
      initialDate: _c.birthday.value,
      onBack: Get.back,
      onContinue: (date) {
        _c.birthday.value = date;
        _next(ProfileSetupRoutes.birthday);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.hometown,
    page: () => ProfileHometownScreen(
      initialValue: _c.hometown.value,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.hometown),
      onContinue: (hometown, display) {
        _c.hometown.value = hometown;
        _c.hometownOnProfile.value = display;
        _next(ProfileSetupRoutes.hometown);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.height,
    page: () => ProfileHeightScreen(
      initialCentimetres: _c.heightCentimetres.value ?? 180,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.height),
      onContinue: (centimetres, display) {
        _c.heightCentimetres.value = centimetres;
        _c.heightOnProfile.value = display;
        _next(ProfileSetupRoutes.height);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.religion,
    page: () => religionScreen(
      initialSelection: _c.religion,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.religion),
      onContinue: (selection, display) {
        _c.religion
          ..clear()
          ..addAll(selection);
        _c.religionOnProfile.value = display;
        _next(ProfileSetupRoutes.religion);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.languages,
    page: () => ProfileLanguagesScreen(
      initialSelection: _c.languages,
      showSelectedSummary: true,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.languages),
      onContinue: (selection, display) {
        _c.languages
          ..clear()
          ..addAll(selection);
        _c.languagesOnProfile.value = display;
        _next(ProfileSetupRoutes.languages);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.ethnicity,
    page: () => ethnicityScreen(
      initialSelection: _c.ethnicity,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.ethnicity),
      onContinue: (selection, display) {
        _c.ethnicity
          ..clear()
          ..addAll(selection);
        _c.ethnicityOnProfile.value = display;
        _next(ProfileSetupRoutes.ethnicity);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.education,
    page: () => ProfileEducationScreen(
      initialLevel: _c.educationLevel.value,
      initialField: _c.fieldOfStudy.value,
      initialSchool: _c.school.value,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.education),
      onContinue: (level, field, school, display) {
        _c.educationLevel.value = level;
        _c.fieldOfStudy.value = field;
        _c.school.value = school;
        _c.educationOnProfile.value = display;
        _next(ProfileSetupRoutes.education);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.work,
    page: () => ProfileWorkScreen(
      initialJobTitle: _c.jobTitle.value,
      initialCompany: _c.company.value,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.work),
      onContinue: (jobTitle, company, display) {
        _c.jobTitle.value = jobTitle;
        _c.company.value = company;
        _c.workOnProfile.value = display;
        _next(ProfileSetupRoutes.work);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.lookingFor,
    page: () => lookingForScreen(
      initialSelection: _c.lookingFor,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.lookingFor),
      onContinue: (selection, display) {
        _c.lookingFor
          ..clear()
          ..addAll(selection);
        _c.lookingForOnProfile.value = display;
        _next(ProfileSetupRoutes.lookingFor);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.political,
    page: () => politicalScreen(
      initialSelection: _c.politicalViews,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.political),
      onContinue: (selection, display) {
        _c.politicalViews
          ..clear()
          ..addAll(selection);
        _c.politicalOnProfile.value = display;
        _next(ProfileSetupRoutes.political);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.bio,
    page: () => ProfileBioScreen(
      initialValue: _c.bio.value,
      onBack: Get.back,
      onSkip: () => _next(ProfileSetupRoutes.bio),
      onContinue: (value) {
        _c.bio.value = value;
        _next(ProfileSetupRoutes.bio);
      },
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.icebreakers,
    page: () => Obx(
      () => IcebreakersScreen(
        entries: _c.icebreakers.toList(),
        onBack: Get.back,
        onAdd: (_) => Get.toNamed(ProfileSetupRoutes.icebreakerFormat),
        onEdit: (index) {
          final entry = _c.icebreakers[index];
          Get.toNamed(
            ProfileSetupRoutes.icebreakerAnswer,
            arguments: IcebreakerDraft(
              format: entry is SnapIcebreaker
                  ? IcebreakerFormat.snaps
                  : IcebreakerFormat.prompts,
              prompt: entry.title,
              promptId: entry.promptId,
              initialValue: switch (entry) {
                PromptIcebreaker(:final answer) => answer,
                SnapIcebreaker(:final caption) => caption,
                GameIcebreaker() => '',
              },
              editIndex: index,
            ),
          );
        },
        onContinue: () => _next(ProfileSetupRoutes.icebreakers),
      ),
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.icebreakerFormat,
    page: () {
      // The browse list is keyed by prompt id on the API, so the catalogue is
      // fetched as soon as the icebreaker flow is entered.
      _c.loadPrompts();
      return IcebreakerFormatScreen(
        onBack: Get.back,
        onPick: (format) => Get.toNamed(
          ProfileSetupRoutes.icebreakerBrowse,
          arguments: format,
        ),
      );
    },
  ),
  GetPage(
    name: ProfileSetupRoutes.icebreakerBrowse,
    // The catalogue is fetched on the screen before this one, so the list has
    // to rebuild when it lands - otherwise a slow request means the design's
    // fallback copy for the whole visit, and every pick made against it comes
    // back without an id.
    page: () {
      final arguments = Get.arguments;
      final editing =
          arguments is IcebreakerDraft && arguments.editIndex != null
              ? arguments
              : null;
      final format = editing?.format ??
          (arguments is IcebreakerFormat ? arguments : IcebreakerFormat.prompts);

      return Obx(
        () => IcebreakerBrowseScreen(
          initialFormat: format,
          onBack: editing == null
              ? Get.back
              : () => Get.offNamed(
                    ProfileSetupRoutes.icebreakerAnswer,
                    arguments: editing,
                  ),
          items: _c.prompts.isEmpty
              ? null
              : [for (final p in _c.prompts) (id: p.id, text: p.text)],
          onPick: (format, item, promptId) {
            final next = IcebreakerDraft(
              format: format,
              prompt: item,
              promptId: promptId,
              initialValue: editing?.initialValue ?? '',
              editIndex: editing?.editIndex,
            );
            if (editing == null) {
              Get.toNamed(
                ProfileSetupRoutes.icebreakerAnswer,
                arguments: next,
              );
            } else {
              Get.offNamed(
                ProfileSetupRoutes.icebreakerAnswer,
                arguments: next,
              );
            }
          },
        ),
      );
    },
  ),
  GetPage(
    name: ProfileSetupRoutes.icebreakerAnswer,
    page: () {
      final draft = Get.arguments as IcebreakerDraft;
      return IcebreakerAnswerScreen(
        prompt: draft.prompt,
        initialValue: draft.initialValue,
        editing: draft.editIndex != null,
        onBack: Get.back,
        onChangePrompt: (text) {
          if (draft.editIndex == null) {
            Get.back();
            return;
          }
          Get.offNamed(
            ProfileSetupRoutes.icebreakerBrowse,
            arguments: IcebreakerDraft(
              format: draft.format,
              prompt: draft.prompt,
              promptId: draft.promptId,
              initialValue: text,
              editIndex: draft.editIndex,
            ),
          );
        },
        onSubmit: (text) {
          final entry =
              _entryFor(draft.format, draft.prompt, text, draft.promptId);
          if (draft.editIndex != null) {
            _c.replaceIcebreaker(draft.editIndex!, entry);
          } else {
            _c.addIcebreaker(entry);
          }
          Get.until(
            (route) => route.settings.name == ProfileSetupRoutes.icebreakers,
          );
        },
      );
    },
  ),
  GetPage(
    name: ProfileSetupRoutes.photos,
    page: () => const _PhotosStep(),
  ),
  GetPage(
    name: ProfileSetupRoutes.photoEdit,
    page: () {
      final opened = Get.arguments as int? ?? 0;
      final selected = opened.obs;
      return Obx(() {
        final photos = _c.photos.whereType<ImageProvider>().toList();
        return PhotoEditScreen(
          photos: photos,
          selected: selected.value
              .clamp(0, photos.isEmpty ? 0 : photos.length - 1),
          onBack: Get.back,
          onDone: Get.back,
          // Crop is not in the design beyond the affordance: p014/p045 draw the
          // pill but there is no crop artboard, so there is nothing to build.
          onSelect: (i) => selected.value = i,
          onAdd: (_) => Get.back(),
        );
      });
    },
  ),
  GetPage(
    name: ProfileSetupRoutes.editProfile,
    page: () => Obx(
      () => EditProfileScreen(
        entries: _c.icebreakers.toList(),
        basics: [
          ProfileBasic(label: 'NAME', value: _c.fullName, visibility: 'Public'),
          ProfileBasic(label: 'HOMETOWN', value: _c.hometown.value),
          ProfileBasic(label: 'EDUCATION', value: _c.educationLevel.value ?? ''),
          ProfileBasic(label: 'WORK', value: _c.jobTitle.value),
          ProfileBasic(
            label: 'BIRTHDAY',
            value: _c.birthday.value == null
                ? ''
                : '${_c.birthday.value!.day}/${_c.birthday.value!.month}/${_c.birthday.value!.year}',
            visibility: 'Private',
          ),
          ProfileBasic(
            label: 'LANGUAGE',
            value: _c.languages.join(', '),
            visibility: 'Public',
          ),
        ],
        onBack: Get.back,
        onSettings: () => Get.toNamed(Routes.SETTINGS),
        onEditIcebreaker: (index) {
          final entry = _c.icebreakers[index];
          Get.toNamed(
            ProfileSetupRoutes.icebreakerAnswer,
            arguments: IcebreakerDraft(
              format: entry is SnapIcebreaker
                  ? IcebreakerFormat.snaps
                  : IcebreakerFormat.prompts,
              prompt: entry.title,
              promptId: entry.promptId,
              initialValue: ProfileSetupController.answerOf(entry),
              editIndex: index,
            ),
          );
        },
        // Each Basics row jumps back to the step that owns it.
        onEditBasic: (index) => Get.toNamed(const [
          ProfileSetupRoutes.name,
          ProfileSetupRoutes.hometown,
          ProfileSetupRoutes.education,
          ProfileSetupRoutes.work,
          ProfileSetupRoutes.birthday,
          ProfileSetupRoutes.languages,
        ][index]),
      ),
    ),
  ),
  GetPage(
    name: ProfileSetupRoutes.ready,
    page: () => Obx(
      () => ProfileReadyScreen(
        busy: _c.submitting.value,
        // Nothing was saved until now: the flow only ever held the answers in
        // memory. "Enter Bubba" is what uploads the photos and posts the
        // profile, and it only leaves the flow once the backend accepted it.
        onEnter: () async {
          if (_c.submitting.value) return;
          final ok = await _c.submit();
          if (!ok) {
            Toast.error(_c.submitError.value ?? 'Could not save your profile');
            return;
          }
          Get.offAllNamed(Routes.HOME);
        },
      ),
    ),
  ),
];

/// [PhotosScreen] is a pure view, so the "Add photos" sheet and the "add at
/// least four" error live here rather than inside it.
class _PhotosStep extends StatefulWidget {
  const _PhotosStep();

  @override
  State<_PhotosStep> createState() => _PhotosStepState();
}

class _PhotosStepState extends State<_PhotosStep> {
  bool _sheet = false;
  String? _error;

  Future<void> _pick(BubbaPhotoSource source) async {
    setState(() => _sheet = false);
    final free = _c.photos.where((p) => p == null).length;
    if (free == 0) return;

    switch (source) {
      case BubbaPhotoSource.camera:
        await Get.to(() => const BubbaPhotoCameraPage());
      case BubbaPhotoSource.library:
        await Get.to(() => BubbaPhotoLibraryPage(maxSelection: free));
      case BubbaPhotoSource.album:
        final album = await Get.to<AssetPathEntity>(
          () => const BubbaPhotoAlbumPage(),
        );
        if (album == null) return;
        await Get.to(
          () => BubbaPhotoLibraryPage(album: album, maxSelection: free),
        );
    }
    if (mounted && _c.photoCount >= ProfileSetupController.minimumPhotos) {
      setState(() => _error = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PhotosScreen(
        photos: _c.photos.toList(),
        errorText: _error,
        sourceSheet: _sheet,
        onPickSource: _pick,
        onDismissSheet: () => setState(() => _sheet = false),
        onAdd: (_) => setState(() => _sheet = true),
        onRemove: _c.removePhoto,
        onReorder: _c.reorderPhotos,
        onEdit: (slot) =>
            Get.toNamed(ProfileSetupRoutes.photoEdit, arguments: slot),
        onBack: Get.back,
        onContinue: () {
          // p005: the CTA is never disabled, the count is checked on tap.
          if (_c.hasEnoughPhotos) {
            _next(ProfileSetupRoutes.photos);
            return;
          }
          setState(() => _error =
              'Please add at least ${ProfileSetupController.minimumPhotos} photos to continue');
        },
      ),
    );
  }
}
