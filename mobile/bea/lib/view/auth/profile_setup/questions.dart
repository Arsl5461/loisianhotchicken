import 'chip_question_screen.dart';
import 'widgets/choice_chip_grid.dart';

/// The four chip-grid questionnaire steps, with the geometry each artboard uses.
///
/// p025/p029 share one chip size and p036/p037 share another, so the numbers are
/// kept next to the options rather than pushed into shared metrics.
class ProfileQuestions {
  ProfileQuestions._();

  static const List<ChipItem> religion = [
    ChipItem('atheist', label: 'Atheist'),
    ChipItem('bahai', label: 'Bahai'),
    ChipItem('buddhist', label: 'Buddhist'),
    ChipItem('christian', label: 'Christian'),
    ChipItem('hindu', label: 'Hindu'),
    ChipItem('jewish', label: 'Jewish'),
    ChipItem('muslim', label: 'Muslim'),
    ChipItem('sikh', label: 'Sikh'),
    ChipItem('spiritual', label: 'Spiritual'),
    ChipItem('other', label: 'Other religion'),
    ChipItem('prefer_not', label: 'Prefer not to say', fullWidth: true),
  ];

  static const List<ChipItem> ethnicity = [
    ChipItem('asian', label: 'Asian'),
    ChipItem('black', label: 'Black / African\ndescent'),
    ChipItem('hispanic', label: 'Hispanic / Latino'),
    ChipItem('middle_eastern', label: 'Middle Eastern'),
    ChipItem('indigenous', label: 'Native / Indigenous'),
    ChipItem('pacific_islander', label: 'Pacific Islander'),
    ChipItem('south_asian', label: 'South Asian'),
    ChipItem('white', label: 'White'),
    ChipItem('multiracial', label: 'Multiracial'),
    ChipItem('another', label: 'Another Ethnicity'),
    ChipItem('prefer_not', label: 'Prefer not to say', fullWidth: true),
  ];

  static const List<ChipItem> lookingFor = [
    ChipItem('long_term', label: 'Long-term\nrelationship'),
    ChipItem('life_partner', label: 'Life partner'),
    ChipItem('casual', label: 'Something casual'),
    ChipItem('friends', label: 'New friends'),
    ChipItem('deciding', label: 'Still deciding'),
    ChipItem('prefer_not', label: 'Prefer not\nto say'),
  ];

  static const List<ChipItem> political = [
    ChipItem('liberal', label: 'Liberal'),
    ChipItem('moderate', label: 'Moderate'),
    ChipItem('conservative', label: 'Conservative'),
    ChipItem('libertarian', label: 'Libertarian'),
    ChipItem('not_political', label: 'Not political'),
    ChipItem('prefer_not', label: 'Prefer not\nto say'),
  ];
}

/// Step 6 of 12 - artboard p025.
ChipQuestionScreen religionScreen({
  Set<String> initialSelection = const {},
  void Function(Set<String>, bool)? onContinue,
  void Function()? onBack,
  void Function()? onSkip,
}) =>
    ChipQuestionScreen(
      step: 6,
      heading: 'What are your religious\nviews?',
      prompt: 'Select one.',
      promptStyle: ChipPromptStyle.centredBody,
      options: ProfileQuestions.religion,
      multiSelect: false,
      gridTop: 256.62,
      chipHeight: 47.85,
      columnGap: 16.35,
      rowGap: 12.5,
      toggleTop: 669.78,
      toggleSubtitle: 'Let others see your religion',
      initialSelection: initialSelection,
      onContinue: onContinue,
      onBack: onBack,
      onSkip: onSkip,
    );

/// Step 8 of 12 - artboard p029.
ChipQuestionScreen ethnicityScreen({
  Set<String> initialSelection = const {},
  void Function(Set<String>, bool)? onContinue,
  void Function()? onBack,
  void Function()? onSkip,
}) =>
    ChipQuestionScreen(
      step: 8,
      heading: 'How do you describe your\nethnicity?',
      prompt: 'Select all that apply.',
      promptStyle: ChipPromptStyle.centredBody,
      options: ProfileQuestions.ethnicity,
      multiSelect: true,
      gridTop: 235.63,
      chipHeight: 47.85,
      columnGap: 16.35,
      rowGap: 12.5,
      toggleTop: 669.78,
      toggleSubtitle: 'Let others see your ethnicity',
      initialSelection: initialSelection,
      onContinue: onContinue,
      onBack: onBack,
      onSkip: onSkip,
    );

/// Step 11 of 12 - artboard p036.
ChipQuestionScreen lookingForScreen({
  Set<String> initialSelection = const {},
  void Function(Set<String>, bool)? onContinue,
  void Function()? onBack,
  void Function()? onSkip,
}) =>
    ChipQuestionScreen(
      step: 11,
      heading: 'What are you looking for?',
      prompt: 'Select one',
      promptStyle: ChipPromptStyle.sectionLabel,
      promptBaseline: 289.49,
      body: 'Choose the intention that feels closest\nright now.',
      bodyBaseline: 181.42,
      options: ProfileQuestions.lookingFor,
      multiSelect: false,
      gridTop: 306.71,
      chipHeight: 85.42,
      columnGap: 10.42,
      rowGap: 10.25,
      toggleTop: 670.83,
      toggleSubtitle: 'Let others see what you’re looking for',
      initialSelection: initialSelection,
      onContinue: onContinue,
      onBack: onBack,
      onSkip: onSkip,
    );

/// Step 12 of 12 - artboard p037.
///
/// The design reuses p036's toggle helper line verbatim here ("what you're
/// looking for"), which reads as a copy slip on a political-views screen; the
/// design wording is kept until the user says otherwise.
ChipQuestionScreen politicalScreen({
  Set<String> initialSelection = const {},
  void Function(Set<String>, bool)? onContinue,
  void Function()? onBack,
  void Function()? onSkip,
}) =>
    ChipQuestionScreen(
      step: 12,
      heading: 'How do you describe your\npolitical views?',
      prompt: 'Select one',
      promptStyle: ChipPromptStyle.sectionLabel,
      promptBaseline: 289.49,
      body: 'Choose the intention that feels closest\nright now.',
      bodyBaseline: 207.39,
      options: ProfileQuestions.political,
      multiSelect: false,
      gridTop: 306.71,
      chipHeight: 85.42,
      columnGap: 10.42,
      rowGap: 10.25,
      toggleTop: 670.83,
      toggleSubtitle: 'Let others see what you’re looking for',
      initialSelection: initialSelection,
      onContinue: onContinue,
      onBack: onBack,
      onSkip: onSkip,
    );
