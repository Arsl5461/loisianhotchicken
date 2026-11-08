import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/birthday_confirm_dialog.dart';
import 'widgets/bubba_wheel.dart';
import 'widgets/step_scaffold.dart';

const double _helperBaseline = 368.58;
const double _bandTop = 472.38;
const double _youAreBaseline = 271.88;
const double _ageBaseline = 304.40;
const double _errorBaseline = 334.72;
const double _ageHeadingBaseline = 155.98;
const double _ageBodyBaseline = 210.13;

/// Column geometry measured off p020: the month rows are left-aligned on 37.08,
/// the day rows centre on 188.1 and the year rows on 303.9.
const double _monthX = 37.08;
const double _monthWidth = 112.0;
const double _dayCentre = 188.1;
const double _dayWidth = 60.0;
const double _yearCentre = 303.9;
const double _yearWidth = 72.0;

const List<String> _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Step 3 of 12 - artboards p019 (empty), p020 (age shown), p021 (under 18)
/// and p022 (confirmation modal, presented separately).
class ProfileBirthdayScreen extends StatefulWidget {
  const ProfileBirthdayScreen({
    super.key,
    this.initialDate,
    this.today,
    this.onBack,
    this.onContinue,
    this.confirmOpen = false,
  });

  final DateTime? initialDate;

  /// p022 - the confirmation card. Continue opens it; this only forces it open
  /// for a golden.
  final bool confirmOpen;

  /// Injected so tests and goldens do not depend on the real clock.
  final DateTime? today;
  final VoidCallback? onBack;
  final ValueChanged<DateTime>? onContinue;

  static const int minimumAge = 18;

  @override
  State<ProfileBirthdayScreen> createState() => _ProfileBirthdayScreenState();
}

class _ProfileBirthdayScreenState extends State<ProfileBirthdayScreen> {
  late int _month = (widget.initialDate?.month ?? 1) - 1;
  late int _day = (widget.initialDate?.day ?? 1) - 1;
  late int _yearIndex = _years.indexOf(widget.initialDate?.year ?? 2000);
  bool _touched = false;
  late bool _confirming = widget.confirmOpen;

  String get _dateLabel =>
      '${_months[_month]} ${_day + 1}, ${_years[_yearIndex]}';

  static final List<int> _years =
      List.generate(101, (i) => 1925 + i);

  DateTime get _now => widget.today ?? DateTime.now();

  DateTime get _selected =>
      DateTime(_years[_yearIndex.clamp(0, _years.length - 1)], _month + 1, _day + 1);

  int get _age {
    final now = _now;
    final b = _selected;
    var age = now.year - b.year;
    if (now.month < b.month || (now.month == b.month && now.day < b.day)) age--;
    return age;
  }

  bool get _oldEnough => _age >= ProfileBirthdayScreen.minimumAge;

  int get _daysInMonth => DateTime(_years[_yearIndex], _month + 2, 0).day;

  @override
  Widget build(BuildContext context) {
    final showAge = _touched || widget.initialDate != null;
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
            _step(showAge),
            if (_confirming)
              BubbaBirthdayConfirmDialog(
                dateLabel: _dateLabel,
                age: _age,
                onConfirm: () => widget.onContinue?.call(_selected),
                onEdit: () => setState(() => _confirming = false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _step(bool showAge) => BubbaStepScaffold(
          step: 3,
          heading: 'When is your birthday?',
          headingBaseline: showAge ? _ageHeadingBaseline : null,
          bodyBaseline: showAge ? _ageBodyBaseline : null,
          body: showAge && !_oldEnough
              ? 'You must be 18 or older to join.\nYour age will also appear on your profile.'
              : 'You must be 18 years or older to join.',
          continueEnabled: showAge && _oldEnough,
          onBack: widget.onBack,
          // p022: Continue asks for confirmation rather than moving on.
          onContinue: () => setState(() => _confirming = true),
          content: (context, flow) {
            if (showAge) {
              flow.copy(
                'YOU ARE',
                baseline: _youAreBaseline,
                style: BubbaText.youAreLabel,
                align: TextAlign.center,
              );
              flow.copy(
                '$_age years old',
                baseline: _ageBaseline,
                style: BubbaText.ageValue.copyWith(
                  color: _oldEnough
                      ? const Color(0xFF0A0A0A)
                      : BubbaColors.textError,
                ),
                align: TextAlign.center,
                liveRegion: true,
              );
              if (!_oldEnough) {
                flow.copy(
                  'You must be 18 years or older to join Bubba.',
                  baseline: _errorBaseline,
                  style: BubbaText.error,
                  align: TextAlign.center,
                );
              }
            }
            if (!showAge || _oldEnough) {
              flow.copy(
                'Scroll to select your birthday',
                baseline: _helperBaseline,
                style: BubbaText.body,
                align: TextAlign.center,
              );
            }
            final wheel = BubbaWheel(
              bandTop: _bandTop,
              itemExtent: wheelItemExtentBirthday,
              visibleEachSide: 2,
              bandColor: showAge && !_oldEnough
                  ? BubbaColors.surface
                  : wheelBandColor,
              bandBorderColor:
                  showAge && !_oldEnough ? BubbaColors.borderError : null,
              columns: [
                BubbaWheelColumn(
                  x: _monthX,
                  width: _monthWidth,
                  alignment: Alignment.centerLeft,
                  looping: true,
                  items: _months,
                  selectedIndex: _month,
                  onSelected: (i) => setState(() {
                    _month = i;
                    _touched = true;
                    if (_day >= _daysInMonth) _day = _daysInMonth - 1;
                  }),
                ),
                BubbaWheelColumn(
                  x: _dayCentre - _dayWidth / 2,
                  width: _dayWidth,
                  looping: true,
                  items: [
                    for (var i = 1; i <= _daysInMonth; i++) '$i',
                  ],
                  selectedIndex: _day,
                  onSelected: (i) =>
                      setState(() { _day = i; _touched = true; }),
                ),
                BubbaWheelColumn(
                  x: _yearCentre - _yearWidth / 2,
                  width: _yearWidth,
                  items: [for (final y in _years) '$y'],
                  selectedIndex: _yearIndex,
                  onSelected: (i) =>
                      setState(() { _yearIndex = i; _touched = true; }),
                ),
              ],
            );
            flow.bleed(wheel, top: wheel.designTop, height: wheel.designHeight);
          },
      );
}
