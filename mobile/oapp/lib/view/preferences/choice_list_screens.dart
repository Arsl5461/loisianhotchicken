import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_tokens.dart';
import '../../models/dating_preferences_model.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'widgets/prefs_chrome.dart';

const double _optionFirstBaseline = 166.58;
const double _radioOffset = 15.07;
const double _checkboxOffset = 14.08;
const double _optionRuleOffset = 21.42;

/// p001 / p009 / p010 / p011 / p016 - one answer, a radio column and a single
/// `Is this non-negotiable?` switch. The artboard repeats the ethnicity list on
/// all five, so the options are a parameter and the wired screen passes the
/// real ones.
class PrefsChoiceListView extends StatelessWidget {
  const PrefsChoiceListView({
    super.key,
    required this.title,
    this.options = prefsEthnicityOptions,
    this.selected = 1,
    this.nonNegotiable = true,
    this.onSelect,
    this.onNonNegotiable,
    this.onBack,
  });

  final String title;
  final List<String> options;
  final int selected;
  final bool nonNegotiable;
  final ValueChanged<int>? onSelect;
  final ValueChanged<bool>? onNonNegotiable;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.pageBg,
          footerBand: 32,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      PrefsNavBar(
        title: title,
        titleStyle: BubbaPrefsText.navTitleBold,
        titleBaseline: 55.23,
        showBack: false,
        divider: true,
        onBack: onBack,
      ),
      top: 0,
      height: PrefsNavBar.height,
    );

    final headingMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.heading);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(21.06)),
          Text(title, style: BubbaPrefsText.heading),
        ],
      ),
      top: 120.43 - headingMetrics.baseline,
      height: headingMetrics.lineHeight,
    );

    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionLabel);
    for (var i = 0; i < options.length; i++) {
      final baseline = _optionFirstBaseline + BubbaPrefsMetrics.optionPitch * i;
      final top = baseline - labelMetrics.baseline;
      flow.block(
        _OptionRow(
          label: options[i],
          top: top,
          baseline: baseline,
          control: PrefsRadio(selected: i == selected),
          controlX: BubbaPrefsMetrics.radioX,
          controlOffset: _radioOffset,
          rule: i < options.length - 1,
          onTap: onSelect == null ? null : () => onSelect!(i),
        ),
        top: top,
        height: baseline + _optionRuleOffset + 1 - top,
      );
    }

    final lastBaseline = _optionFirstBaseline +
        BubbaPrefsMetrics.optionPitch * (options.length - 1);

    flow.block(
      const PrefsRule(
        x: 23.71,
        width: 369.58,
        colour: BubbaPrefsColors.hairline,
        weight: 0.5,
      ),
      top: lastBaseline + 48.86 - 0.25,
      height: 0.5,
    );

    flow.block(
      _SwitchRow(
        label: 'Is this non-negotiable?',
        labelX: 24.53,
        labelBaseline: lastBaseline + 95.15,
        style: BubbaPrefsText.optionLabel,
        toggleX: 323.21,
        toggleTop: lastBaseline + 78.36,
        onColour: BubbaPrefsColors.toggleOnRose,
        value: nonNegotiable,
        onChanged: onNonNegotiable,
      ),
      top: lastBaseline + 78.36,
      height: 23.87,
    );

    flow.block(
      const PrefsRule(
        x: 23.31,
        width: 369.58,
        colour: BubbaPrefsColors.hairline,
        weight: 0.5,
      ),
      top: lastBaseline + 123.30 - 0.25,
      height: 0.5,
    );
  }
}

/// p017 - p021 - many answers, a checkbox column, a `NON-NEGOTIABLE` switch and
/// the shared impact card.
class PrefsMultiChoiceView extends StatelessWidget {
  const PrefsMultiChoiceView({
    super.key,
    required this.title,
    required this.intro,
    required this.options,
    this.selected = const {1},
    this.requirePreference = true,
    this.showSwitch = true,
    this.impactTop,
    this.introX = 24.11,
    this.onToggle,
    this.onRequire,
    this.onBack,
  });

  final String title;
  final String intro;
  final List<String> options;
  final Set<int> selected;
  final bool requirePreference;
  final bool showSwitch;
  final double? impactTop;
  final double introX;
  final ValueChanged<int>? onToggle;
  final ValueChanged<bool>? onRequire;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.listBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.listBg,
          footerBand: 17,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      PrefsNavBar(title: title, onBack: onBack),
      top: 0,
      height: PrefsNavBar.height,
    );

    final introMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.introCopy);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(introX)),
          Text(intro, style: BubbaPrefsText.introCopy),
        ],
      ),
      top: 100.55 - introMetrics.baseline,
      height: introMetrics.lineHeight * 2,
    );

    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionLabel);
    for (var i = 0; i < options.length; i++) {
      final baseline = _optionFirstBaseline + BubbaPrefsMetrics.optionPitch * i;
      final top = baseline - labelMetrics.baseline;
      flow.block(
        _OptionRow(
          label: options[i],
          top: top,
          baseline: baseline,
          control: PrefsCheckbox(selected: selected.contains(i)),
          controlX: BubbaPrefsMetrics.checkboxX,
          controlOffset: _checkboxOffset,
          rule: false,
          onTap: onToggle == null ? null : () => onToggle!(i),
        ),
        top: top,
        height: BubbaPrefsMetrics.optionPitch,
      );
    }

    final lastBaseline = _optionFirstBaseline +
        BubbaPrefsMetrics.optionPitch * (options.length - 1);

    flow.block(
      const PrefsRule(
        x: 23.71,
        width: 341.64,
        colour: BubbaPrefsColors.hairline,
        weight: 0.5,
      ),
      top: lastBaseline + 36.26 - 0.25,
      height: 0.5,
    );

    if (showSwitch) {
      final eyebrowMetrics =
          bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
      final labelMetrics =
          bubbaDesignTextMetrics(context, BubbaPrefsText.optionMedium);
      final eyebrowTop = lastBaseline + 63.96 - eyebrowMetrics.baseline;
      final switchTop = math.min(eyebrowTop, lastBaseline + 59.07);
      flow.block(
        _SwitchRow(
          eyebrow: 'NON-NEGOTIABLE',
          eyebrowX: 23.37,
          eyebrowTop: eyebrowTop,
          label: 'Require this preference',
          labelX: 23.53,
          labelBaseline: lastBaseline + 88.85,
          style: BubbaPrefsText.optionMedium,
          toggleX: 312.21,
          toggleTop: lastBaseline + 59.07,
          blockTop: switchTop,
          onColour: BubbaPrefsColors.toggleOnTeal,
          value: requirePreference,
          onChanged: onRequire,
        ),
        top: switchTop,
        height: lastBaseline + 88.85 + labelMetrics.descent - switchTop,
      );
    }

    if (impactTop != null) {
      flow.block(
        const PrefsImpactCard(),
        top: impactTop!,
        height: BubbaPrefsMetrics.impactHeight,
      );
    }
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.top,
    required this.baseline,
    required this.control,
    required this.controlX,
    required this.controlOffset,
    required this.rule,
    this.onTap,
  });

  final String label;
  final double top;
  final double baseline;
  final Widget control;
  final double controlX;
  final double controlOffset;
  final bool rule;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionLabel);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(math.max(0, left)),
              top: d(math.max(0, y - top)),
            ),
            child: child,
          ),
        );

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            at(
              BubbaPrefsMetrics.optionLabelX,
              baseline - labelMetrics.baseline,
              Text(label, style: BubbaPrefsText.optionLabel),
            ),
            at(controlX, baseline - controlOffset, control),
            if (rule)
              at(
                BubbaPrefsMetrics.optionRuleX,
                baseline + _optionRuleOffset - 0.5,
                SizedBox(
                  width: hd(BubbaPrefsMetrics.optionRuleWidth),
                  height: d(1),
                  child: const BubbaHairline(color: BubbaPrefsColors.divider),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.labelX,
    required this.labelBaseline,
    required this.style,
    required this.toggleX,
    required this.toggleTop,
    required this.onColour,
    required this.value,
    this.eyebrow,
    this.eyebrowX = 0,
    this.eyebrowTop = 0,
    double? blockTop,
    this.onChanged,
  }) : blockTop = blockTop ?? toggleTop;

  final String label;
  final double labelX;
  final double labelBaseline;
  final TextStyle style;
  final double toggleX;
  final double toggleTop;
  final Color onColour;
  final bool value;
  final String? eyebrow;
  final double eyebrowX;
  final double eyebrowTop;
  final double blockTop;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, style);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: dGap(y - blockTop)),
            child: child,
          ),
        );

    return Stack(
      children: [
        if (eyebrow != null)
          at(
            eyebrowX,
            eyebrowTop,
            Text(eyebrow!, style: BubbaPrefsText.eyebrow),
          ),
        at(labelX, labelBaseline - metrics.baseline, Text(label, style: style)),
        at(
          toggleX,
          toggleTop,
          PrefsToggle(
            value: value,
            onColour: onColour,
            label: label,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

const List<String> prefsEthnicityOptions = [
  'White',
  'Black',
  'Hispanic',
  'Asian',
  'Indian',
  'Pacific Islander',
  'Open to all',
];

const List<String> prefsEthnicityMulti = [
  'White',
  'Black',
  'Hispanic / LatinX',
  'Asian',
  'Indian',
  'Pacific Islander',
  'Indigenous',
  'Middle Eastern',
  'Open to all',
];

const List<String> prefsReligionMulti = [
  'Agnostic',
  'Bahai',
  'Buddhist',
  'Christian',
  'Hindu',
  'Jewish',
  'Muslim',
  'Shinto',
  'Spiritual',
  'Zoroastrian',
  'Atheist',
  'Open to all',
];

const List<String> prefsPoliticsMulti = [
  'Conservative',
  'Liberal',
  'Moderate',
  'Green',
  'Libertarian',
  'Not political',
  'Open to all',
];

const List<String> prefsZodiacMulti = [
  'Aries',
  'Taurus',
  'Gemini',
  'Cancer',
  'Leo',
  'Virgo',
  'Libra',
  'Scorpio',
  'Sagittarius',
  'Capricorn',
  'Aquarius',
  'Pisces',
  'Open to all',
];

const List<String> prefsLanguageOptions = [
  'English',
  'Spanish',
  'French',
  'Portuguese',
  'German',
  'Italian',
  'Arabic',
  'Hindi',
  'Urdu',
  'Mandarin',
  'Japanese',
  'Open to all',
];

const List<String> prefsEducationOptions = [
  'High School',
  'Associates',
  'Bachelors',
  'Masters',
  'Doctorate',
  'Open to all',
];

const List<String> prefsNationalityOptions = [
  'American',
  'British',
  'Canadian',
  'Indian',
  'Pakistani',
  'Mexican',
  'Nigerian',
  'Filipino',
  'Open to all',
];

const List<String> prefsIntentionsMulti = [
  'Life partner',
  'Something casual',
  'Committed relationship',
  'Meet new people',
  'Meaningful Friendship',
  'Open to anything',
  'Open to all',
];

const String prefsOpenToAll = 'Open to all';

/// The list screens have no CTA in the design, so a tap is the save. The
/// controller refuses a second write while one is in flight and rolls the
/// value back if it fails, so a fast double tap cannot desync the row.
class BubbaPrefsChoiceScreen extends StatelessWidget {
  const BubbaPrefsChoiceScreen({
    super.key,
    required this.title,
    required this.kind,
    this.options = prefsEthnicityOptions,
  });

  final String title;
  final PrefsFilterKind kind;
  final List<String> options;

  List<String> _currentValues(BubbaPrefsController c) => switch (kind) {
        PrefsFilterKind.languages => c.model.languages,
        PrefsFilterKind.education =>
          c.model.education == null ? const [] : [c.model.education!],
        PrefsFilterKind.ethnicity => c.model.ethnicity,
        PrefsFilterKind.religion => c.model.religion,
        PrefsFilterKind.politics => c.model.politics,
        _ => const [],
      };

  DatingPreferencesModel _withValue(
    DatingPreferencesModel current,
    String? value,
  ) {
    final list = value == null ? <String>[] : [value];

    return switch (kind) {
      PrefsFilterKind.languages => current.copyWith(languages: list),
      PrefsFilterKind.education => current.copyWith(
          education: value,
          clearEducation: value == null,
        ),
      PrefsFilterKind.ethnicity => current.copyWith(ethnicity: list),
      PrefsFilterKind.religion => current.copyWith(religion: list),
      PrefsFilterKind.politics => current.copyWith(politics: list),
      _ => current,
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;

    return Obx(() {
      final values = _currentValues(controller);
      final selected = values.isEmpty
          ? options.indexOf(prefsOpenToAll)
          : options.indexOf(values.first);

      return PrefsChoiceListView(
        title: title,
        options: options,
        selected: selected < 0 ? options.indexOf(prefsOpenToAll) : selected,
        nonNegotiable: controller.isNonNegotiable(kind),
        onSelect: (index) async {
          final picked = options[index];
          final outcome = await controller.apply(
            (current) => _withValue(
              current,
              picked == prefsOpenToAll ? null : picked,
            ),
          );
          if (!outcome.succeeded) showPrefsError(outcome.message);
        },
        onNonNegotiable: (value) async {
          final outcome = await controller.setNonNegotiable(kind, value);
          if (!outcome.succeeded) showPrefsError(outcome.message);
        },
        onBack: Get.back,
      );
    });
  }
}

class BubbaPrefsMultiChoiceScreen extends StatelessWidget {
  const BubbaPrefsMultiChoiceScreen({
    super.key,
    required this.title,
    required this.intro,
    required this.options,
    required this.kind,
  });

  final String title;
  final String intro;
  final List<String> options;
  final PrefsFilterKind kind;

  List<String> _currentValues(BubbaPrefsController c) => switch (kind) {
        PrefsFilterKind.ethnicity => c.model.ethnicity,
        PrefsFilterKind.religion => c.model.religion,
        PrefsFilterKind.politics => c.model.politics,
        PrefsFilterKind.languages => c.model.languages,
        _ => const [],
      };

  DatingPreferencesModel _withValues(
    DatingPreferencesModel current,
    List<String> values,
  ) =>
      switch (kind) {
        PrefsFilterKind.ethnicity => current.copyWith(ethnicity: values),
        PrefsFilterKind.religion => current.copyWith(religion: values),
        PrefsFilterKind.politics => current.copyWith(politics: values),
        PrefsFilterKind.languages => current.copyWith(languages: values),
        _ => current,
      };

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;
    final openToAllIndex = options.indexOf(prefsOpenToAll);

    return Obx(() {
      final values = _currentValues(controller);
      final selected = <int>{
        for (var i = 0; i < options.length; i++)
          if (values.contains(options[i])) i,
      };
      if (selected.isEmpty && openToAllIndex >= 0) selected.add(openToAllIndex);

      return PrefsMultiChoiceView(
        title: title,
        intro: intro,
        options: options,
        selected: selected,
        requirePreference: controller.isNonNegotiable(kind),
        onToggle: (index) async {
          final picked = options[index];
          final next = values.toList();

          if (picked == prefsOpenToAll) {
            next.clear();
          } else if (!next.remove(picked)) {
            next.add(picked);
          }

          final outcome =
              await controller.apply((current) => _withValues(current, next));
          if (!outcome.succeeded) showPrefsError(outcome.message);
        },
        onRequire: (value) async {
          final outcome = await controller.setNonNegotiable(kind, value);
          if (!outcome.succeeded) showPrefsError(outcome.message);
        },
        onBack: Get.back,
      );
    });
  }
}
