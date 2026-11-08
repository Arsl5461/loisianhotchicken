import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/choice_chip_grid.dart';
import 'widgets/step_scaffold.dart';

/// Step 2 of 12 - artboards p017 (nothing chosen) and p018 ("Man" chosen).
class ProfileGenderScreen extends StatefulWidget {
  const ProfileGenderScreen({
    super.key,
    this.firstName = 'Ron',
    this.initialGender,
    this.initialInterestedIn,
    this.onBack,
    this.onContinue,
  });

  final String firstName;
  final String? initialGender;
  final String? initialInterestedIn;
  final VoidCallback? onBack;
  final void Function(String gender, String interestedIn)? onContinue;

  static const double genderQuestionBaseline = 283.53;
  static const double genderGridTop = 305.89;
  static const double datingQuestionBaseline = 425.38;
  static const double datingGridTop = 446.89;
  static const double shieldY = 625.00;
  static const double reassuranceBaseline = 669.92;

  static const List<ChipItem> genders = [
    ChipItem('man', label: 'Man'),
    ChipItem('woman', label: 'Woman'),
    ChipItem('nonbinary', label: 'Nonbinary'),
  ];

  static const List<ChipItem> interestedIn = [
    ChipItem('men', label: 'Men'),
    ChipItem('women', label: 'Women'),
    ChipItem('nonbinary_people', label: 'Nonbinary\npeople'),
    ChipItem('everyone', label: 'Everyone'),
  ];

  @override
  State<ProfileGenderScreen> createState() => _ProfileGenderScreenState();
}

class _ProfileGenderScreenState extends State<ProfileGenderScreen> {
  late String? _gender = widget.initialGender;
  late String? _interestedIn = widget.initialInterestedIn;

  bool get _isValid => _gender != null && _interestedIn != null;

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
          step: 2,
          heading: 'Nice to meet you, ${widget.firstName}.',
          body: 'Tell us a little bit about your gender and\ndating preferences',
          continueEnabled: _isValid,
          onBack: widget.onBack,
          onContinue: () => widget.onContinue?.call(_gender!, _interestedIn!),
          content: (context, flow) {
            final genderGrid = BubbaChipGrid(
              items: ProfileGenderScreen.genders,
              columns: 3,
              isSelected: (v) => _gender == v,
              onToggle: (v) => setState(() => _gender = v),
            );
            final datingGrid = BubbaChipGrid(
              items: ProfileGenderScreen.interestedIn,
              columns: 2,
              columnGap: 11.44,
              rowGap: 11.44,
              isSelected: (v) => _interestedIn == v,
              onToggle: (v) => setState(() => _interestedIn = v),
            );

            flow.copy(
              'What is your gender?',
              baseline: ProfileGenderScreen.genderQuestionBaseline,
              style: BubbaText.question,
            );
            flow.block(
              genderGrid,
              top: ProfileGenderScreen.genderGridTop,
              height: genderGrid.measure() / BubbaScale.factor,
            );
            flow.copy(
              'Who are you interested in dating?',
              baseline: ProfileGenderScreen.datingQuestionBaseline,
              style: BubbaText.question,
            );
            flow.block(
              datingGrid,
              top: ProfileGenderScreen.datingGridTop,
              height: datingGrid.measure() / BubbaScale.factor,
            );
            flow.block(
              const Center(child: BubbaShieldOutline()),
              top: ProfileGenderScreen.shieldY,
              height: 20.18,
            );
            flow.copy(
              'Your answers help us create a better\nexperience for you',
              baseline: ProfileGenderScreen.reassuranceBaseline,
              style: BubbaText.reassurance,
              align: TextAlign.center,
              lines: 2,
            );
          },
        ),
      ),
    );
  }
}
