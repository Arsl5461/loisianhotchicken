import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/education_level_sheet.dart';
import 'widgets/labelled_field.dart';
import 'widgets/profile_preview_card.dart';
import 'widgets/step_scaffold.dart';

const double _field1Top = 257.00;
const double _field2Top = 357.54;
const double _field3Top = 464.87;

/// Step 10 of 12 - artboards p034 (empty) and p035 (filled, preview shown).
class ProfileWorkScreen extends StatefulWidget {
  const ProfileWorkScreen({
    super.key,
    this.initialJobTitle = '',
    this.initialCompany = '',
    this.onBack,
    this.onSkip,
    this.onContinue,
  });

  final String initialJobTitle;
  final String initialCompany;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(String jobTitle, String company, bool display)? onContinue;

  static const double previewTop = 562.07;

  @override
  State<ProfileWorkScreen> createState() => _ProfileWorkScreenState();
}

class _ProfileWorkScreenState extends State<ProfileWorkScreen> {
  late final _job = TextEditingController(text: widget.initialJobTitle);
  late final _company = TextEditingController(text: widget.initialCompany);
  final _jobFocus = FocusNode();
  final _companyFocus = FocusNode();
  bool _display = true;
  late bool _hasAny = _job.text.isNotEmpty || _company.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _job.addListener(_sync);
    _company.addListener(_sync);
  }

  @override
  void dispose() {
    _job.removeListener(_sync);
    _company.removeListener(_sync);
    _job.dispose();
    _company.dispose();
    _jobFocus.dispose();
    _companyFocus.dispose();
    super.dispose();
  }

  void _sync() {
    final any = _job.text.trim().isNotEmpty || _company.text.trim().isNotEmpty;
    if (any != _hasAny) setState(() => _hasAny = any);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.screenBg,
        resizeToAvoidBottomInset: false,
        body: BubbaStepScaffold(
          step: 10,
          heading: 'Tell us about your work',
          body: 'Add as much as you’d like.',
          continueEnabled: _hasAny,
          onBack: widget.onBack,
          onSkip: widget.onSkip,
          onContinue: () => widget.onContinue
              ?.call(_job.text.trim(), _company.text.trim(), _display),
          content: (context, flow) {
            flow.block(
              BubbaLabelledField(
                label: 'Job title',
                controller: _job,
                focusNode: _jobFocus,
                hintText: 'e.g. Product designer',
              ),
              top: _field1Top - labelBlockHeight,
              height: BubbaLabelledField.blockHeight,
            );
            flow.block(
              BubbaLabelledField(
                label: 'Company',
                controller: _company,
                focusNode: _companyFocus,
                hintText: 'e.g. Spotify',
              ),
              top: _field2Top - labelBlockHeight,
              height: BubbaLabelledField.blockHeight,
            );
            if (_hasAny) {
              flow.block(
                BubbaProfilePreviewCard(
                  icon: const BubbaBriefcase(),
                  iconInset: 22.12,
                  title: _job.text.trim().isEmpty
                      ? _company.text.trim()
                      : _job.text.trim(),
                  subtitle: _company.text.trim().isEmpty
                      ? ''
                      : 'at ${_company.text.trim()}',
                  toggleSubtitle: 'Let others see your work',
                  value: _display,
                  onChanged: (v) => setState(() => _display = v),
                ),
                top: ProfileWorkScreen.previewTop,
                height: BubbaProfilePreviewCard.designHeight,
              );
            }
          },
        ),
      ),
    );
  }
}

/// Step 9 of 12 - artboards p031 (empty), p032 (filled, preview shown) and
/// p033 (education-level picker sheet open).
class ProfileEducationScreen extends StatefulWidget {
  const ProfileEducationScreen({
    super.key,
    this.initialLevel,
    this.initialField = '',
    this.initialSchool = '',
    this.onBack,
    this.onSkip,
    this.levelSheetOpen = false,
    this.onContinue,
  });

  final String? initialLevel;
  final String initialField;
  final String initialSchool;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  /// p033 - the level picker over the form. The screen opens and closes it
  /// itself; this only forces it open for a golden.
  final bool levelSheetOpen;
  final void Function(String? level, String field, String school, bool display)?
      onContinue;

  static const double previewTop = 571.64;

  static const List<String> levels = [
    'High school',
    'Trade / vocational',
    'Some college',
    'Associate degree',
    'Bachelor’s degree',
    'Master’s degree',
    'Doctoreate',
    'Other',
    'Prefer not to say',
  ];

  @override
  State<ProfileEducationScreen> createState() => _ProfileEducationScreenState();
}

class _ProfileEducationScreenState extends State<ProfileEducationScreen> {
  late final _field = TextEditingController(text: widget.initialField);
  late final _school = TextEditingController(text: widget.initialSchool);
  final _fieldFocus = FocusNode();
  final _schoolFocus = FocusNode();
  late String? _level = widget.initialLevel;
  late bool _levelSheet = widget.levelSheetOpen;
  bool _display = true;
  late bool _hasAny = _anyFilled;

  bool get _anyFilled =>
      _level != null ||
      _field.text.trim().isNotEmpty ||
      _school.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _field.addListener(_sync);
    _school.addListener(_sync);
  }

  @override
  void dispose() {
    _field.removeListener(_sync);
    _school.removeListener(_sync);
    _field.dispose();
    _school.dispose();
    _fieldFocus.dispose();
    _schoolFocus.dispose();
    super.dispose();
  }

  void _sync() {
    if (_anyFilled != _hasAny) setState(() => _hasAny = _anyFilled);
  }

  String get _previewTitle {
    final level = _level ?? '';
    final field = _field.text.trim();
    if (level.isNotEmpty && field.isNotEmpty) return '$level - $field';
    return level.isNotEmpty ? level : field;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.screenBg,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _form(),
            if (_levelSheet)
              BubbaEducationLevelSheet(
                levels: ProfileEducationScreen.levels,
                selected: _level,
                onDismiss: () => setState(() => _levelSheet = false),
                onPick: (level) => setState(() {
                  _level = level;
                  _levelSheet = false;
                  _hasAny = _anyFilled;
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _form() => BubbaStepScaffold(
          step: 9,
          heading: 'Tell us about your education',
          body: 'Add as much as you’d like.',
          continueEnabled: _hasAny,
          onBack: widget.onBack,
          onSkip: widget.onSkip,
          onContinue: () => widget.onContinue?.call(
              _level, _field.text.trim(), _school.text.trim(), _display),
          content: (context, flow) {
            flow.block(
              BubbaLabelledField(
                label: 'Education level',
                hintText: 'Select education level',
                value: _level,
                onTap: () => setState(() => _levelSheet = true),
                trailing: const BubbaChevronDown(width: 11, height: 5.5),
              ),
              top: _field1Top - labelBlockHeight,
              height: BubbaLabelledField.blockHeight,
            );
            flow.block(
              BubbaLabelledField(
                label: 'Field of study',
                controller: _field,
                focusNode: _fieldFocus,
                hintText: 'e.g. Finance',
              ),
              top: _field2Top - labelBlockHeight,
              height: BubbaLabelledField.blockHeight,
            );
            flow.block(
              BubbaLabelledField(
                label: 'School',
                controller: _school,
                focusNode: _schoolFocus,
                hintText: 'School name',
              ),
              top: _field3Top - labelBlockHeight,
              height: BubbaLabelledField.blockHeight,
            );
            if (_hasAny) {
              flow.block(
                BubbaProfilePreviewCard(
                  icon: const BubbaGraduationCap(),
                  title: _previewTitle,
                  subtitle: _school.text.trim().isEmpty
                      ? ''
                      : 'at ${_school.text.trim()}',
                  toggleSubtitle: 'Let others see your education',
                  value: _display,
                  onChanged: (v) => setState(() => _display = v),
                ),
                top: ProfileEducationScreen.previewTop,
                height: BubbaProfilePreviewCard.designHeight,
              );
            }
          },
      );

}
