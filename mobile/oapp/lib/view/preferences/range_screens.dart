import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_glyphs.dart';
import '../../core/design/bubba_prefs_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'widgets/prefs_chrome.dart';

class PrefsQuickOption {
  const PrefsQuickOption(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

const List<PrefsQuickOption> prefsDistanceOptions = [
  PrefsQuickOption('5 miles', 'Very close'),
  PrefsQuickOption('15 miles', 'Close'),
  PrefsQuickOption('25 miles', 'Moderate'),
  PrefsQuickOption('50 miles', 'Far'),
  PrefsQuickOption('100 miles', 'Very far'),
];

const List<PrefsQuickOption> prefsAgeOptions = [
  PrefsQuickOption('18 - 24', '6 year range'),
  PrefsQuickOption('22 - 28', '6 year range'),
  PrefsQuickOption('26 - 33', '7 year range'),
  PrefsQuickOption('30 - 40', '10 year range'),
  PrefsQuickOption('Custom range', 'Choose your own'),
];

const double _introBaseline = 114.16;
const double _currentEyebrow = 163.63;
const double _currentCardY = 174.50;
const double _currentCardH = 69;
const double _quickEyebrow = 271.78;
const double _firstOptionTitle = 303.28;
const double _optionPitch = 51.79;
const double _optionSubGap = 16.47;
const double _optionRadioGap = -7.23;
const double _optionRuleGap = 29.91;

/// p012 (Distance) and p014 (Age Range) - the same skeleton: the current
/// setting in a bordered card, then a radio list of quick options. p014 adds
/// the impact card and a Save preference button.
class PrefsQuickOptionsView extends StatelessWidget {
  const PrefsQuickOptionsView({
    super.key,
    required this.title,
    required this.currentValue,
    required this.currentSubtitle,
    required this.options,
    this.intro = 'Set how far away you’re open to\nseeing matches.',
    this.showCurrent = true,
    this.quickLabel = 'QUICK OPTIONS',
    this.quickEyebrow = _quickEyebrow,
    this.firstOption = _firstOptionTitle,
    this.optionBaselines,
    this.optionRuleGap = _optionRuleGap,
    this.showReset = true,
    this.currentLabel = 'CURRENT SETTING',
    this.selected,
    this.impactTop,
    this.impactNote = 'Approximately 23% of your filtered match pool',
    this.ctaLabel,
    this.ctaTop = 747,
    this.onBack,
    this.onReset,
    this.onCurrent,
    this.onSelect,
    this.onCta,
  });

  final String title;
  final String currentValue;
  final String currentSubtitle;
  final List<PrefsQuickOption> options;
  final String intro;
  final bool showCurrent;
  final String quickLabel;
  final double quickEyebrow;
  final double firstOption;
  final List<double>? optionBaselines;
  final double optionRuleGap;
  final bool showReset;
  final String currentLabel;
  final int? selected;
  final double? impactTop;
  final String impactNote;
  final String? ctaLabel;
  final double ctaTop;
  final VoidCallback? onBack;
  final VoidCallback? onReset;
  final VoidCallback? onCurrent;
  final ValueChanged<int>? onSelect;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.listBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.listBg,
          footerBand: 32,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      PrefsNavBar(
        title: title,
        titleBaseline: 68.14,
        backY: 56.48,
        resetLabel: showReset ? 'Reset' : null,
        onBack: onBack,
        onReset: onReset,
      ),
      top: 0,
      height: PrefsNavBar.height + 4,
    );

    final introMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.introCopy);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19.28)),
          Text(intro, style: BubbaPrefsText.introCopy),
        ],
      ),
      top: _introBaseline - introMetrics.baseline,
      height: introMetrics.lineHeight *
          ('\n'.allMatches(intro).length + 1),
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    flow.block(
      PrefsEyebrow(
        label: currentLabel,
        x: 19.35,
        style: BubbaPrefsText.eyebrow,
      ),
      top: _currentEyebrow - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    if (showCurrent) {
      flow.block(
        _CurrentCard(
          value: currentValue,
          subtitle: currentSubtitle,
          onTap: onCurrent,
        ),
        top: _currentCardY,
        height: _currentCardH,
      );
    }

    if (quickLabel.isNotEmpty) {
      flow.block(
        PrefsEyebrow(
          label: quickLabel,
          x: 18.69,
          style: BubbaPrefsText.eyebrow,
        ),
        top: quickEyebrow - eyebrowMetrics.baseline,
        height: eyebrowMetrics.lineHeight,
      );
    }

    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionTitle);
    for (var i = 0; i < options.length; i++) {
      final baseline = optionBaselines != null
          ? optionBaselines![i]
          : firstOption + _optionPitch * i;
      final top = baseline - titleMetrics.baseline;
      flow.block(
        _QuickOptionRow(
          option: options[i],
          top: top,
          baseline: baseline,
          ruleGap: optionRuleGap,
          selected: selected == i,
          onTap: onSelect == null ? null : () => onSelect!(i),
        ),
        top: top,
        height: baseline + optionRuleGap + 1 - top,
      );
    }

    if (impactTop != null) {
      flow.block(
        PrefsImpactCard(note: impactNote),
        top: impactTop!,
        height: BubbaPrefsMetrics.impactHeight,
      );
    }

    if (ctaLabel != null) {
      flow.block(
        _SaveButton(label: ctaLabel!, onTap: onCta),
        top: ctaTop,
        height: 58,
      );
    }
  }
}

class _CurrentCard extends StatelessWidget {
  const _CurrentCard({
    required this.value,
    required this.subtitle,
    this.onTap,
  });

  final String value;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.currentValue);
    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionSub);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - 14.47),
              top: dGap(top - _currentCardY),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(14.47)),
        Semantics(
          button: true,
          label: '$value, $subtitle',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: hd(359),
              height: d(_currentCardH),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(d(9.10)),
                border: Border.all(
                  color: BubbaPrefsColors.cardBorder,
                  width: d(1),
                ),
              ),
              child: Stack(
                children: [
                  at(
                    29.76,
                    189.37,
                    Container(
                      width: d(41),
                      height: d(41),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: BubbaPrefsColors.cardIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: const BubbaGlyphIcon(
                        BubbaPrefsGlyphs.pin,
                        color: BubbaPrefsColors.title,
                        width: 14.22,
                        height: 18.29,
                      ),
                    ),
                  ),
                  at(
                    85.94,
                    208.00 - valueMetrics.baseline,
                    Text(value, style: BubbaPrefsText.currentValue),
                  ),
                  at(
                    86.47,
                    224.47 - subMetrics.baseline,
                    Text(subtitle, style: BubbaPrefsText.optionSub),
                  ),
                  at(
                    351.41,
                    202.40,
                    const BubbaGlyphIcon(
                      BubbaPrefsGlyphs.cardChevron,
                      color: BubbaPrefsColors.chevron,
                      width: 6.00,
                      height: 14.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickOptionRow extends StatelessWidget {
  const _QuickOptionRow({
    required this.option,
    required this.top,
    required this.baseline,
    required this.ruleGap,
    required this.selected,
    this.onTap,
  });

  final PrefsQuickOption option;
  final double top;
  final double baseline;
  final double ruleGap;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionTitle);
    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionSub);

    Widget at(double left, double y, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: hd(left), top: dGap(y - top)),
            child: child,
          ),
        );

    return Semantics(
      button: true,
      label: '${option.title}, ${option.subtitle}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            at(
              23.73,
              baseline - titleMetrics.baseline,
              Text(option.title, style: BubbaPrefsText.optionTitle),
            ),
            at(
              24.26,
              baseline + _optionSubGap - subMetrics.baseline,
              Text(option.subtitle, style: BubbaPrefsText.optionSub),
            ),
            at(
              344.97,
              baseline + _optionRadioGap,
              PrefsRadio(selected: selected),
            ),
            at(
              24.41,
              baseline + ruleGap - 0.5,
              SizedBox(
                width: hd(343.06),
                height: d(1),
                child: const BubbaHairline(color: BubbaPrefsColors.cardBorder),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaPrefsText.ctaBold);
    return Row(
      children: [
        SizedBox(width: hd(23.48)),
        BubbaTapTarget(
          onTap: onTap,
          label: label,
          child: Container(
            width: hd(339.70),
            height: d(58),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: BubbaPrefsColors.ctaDark,
              borderRadius: BorderRadius.circular(d(11.39)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: d(782.20 - 747 - metrics.baseline),
              ),
              child: Text(label, style: BubbaPrefsText.ctaBold),
            ),
          ),
        ),
      ],
    );
  }
}

const List<double> prefsDistanceMiles = [5, 15, 25, 50, 100];

class BubbaPrefsDistanceScreen extends StatelessWidget {
  const BubbaPrefsDistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;

    return Obx(() {
      final miles = controller.model.maxDistance;
      final selected = prefsDistanceMiles.indexOf(miles.roundToDouble());

      return PrefsQuickOptionsView(
        title: 'Distance',
        currentValue: '${miles.round()} miles',
        currentSubtitle: controller.trip.value.isTraveling
            ? 'From your destination'
            : 'From your current location',
        options: prefsDistanceOptions,
        selected: selected < 0 ? null : selected,
        onSelect: (i) async {
          final outcome = await controller.apply(
            (current) => current.copyWith(maxDistance: prefsDistanceMiles[i]),
          );
          if (!outcome.succeeded) showPrefsError(outcome.message);
        },
        onCurrent: () => Get.toNamed(Routes.BUBBA_PREFS_ADJUST_DISTANCE),
        onReset: () async {
          final outcome = await controller.apply(
            (current) => current.copyWith(maxDistance: 25),
          );
          if (!outcome.succeeded) showPrefsError(outcome.message);
        },
        onBack: Get.back,
      );
    });
  }
}

/// p037. The one screen whose CTA is the save, so it carries the in-flight
/// guard: a second tap while the first is on the wire does nothing.
class BubbaPrefsLookingForScreen extends StatelessWidget {
  const BubbaPrefsLookingForScreen({super.key});

  static const List<PrefsQuickOption> options = [
    PrefsQuickOption('Women', 'Show me women'),
    PrefsQuickOption('Men', 'Show me men'),
    PrefsQuickOption('Non-binary', 'Show me non-binary people'),
    PrefsQuickOption('Everyone', 'Show me everyone'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;
    final pending = ValueNotifier<int?>(null);

    return Obx(() {
      final value = controller.model.lookingFor;
      final stored = options.indexWhere((o) => o.title == value);

      return ValueListenableBuilder<int?>(
        valueListenable: pending,
        builder: (context, chosen, _) => PrefsQuickOptionsView(
          title: 'Looking for',
          intro: 'Choose who you want to see',
          currentValue: '',
          currentSubtitle: '',
          showCurrent: false,
          currentLabel: 'I’M LOOKING FOR',
          quickLabel: '',
          quickEyebrow: 163.63,
          firstOption: 211.28,
          optionBaselines: const [211.28, 278.89, 346.28, 417.91],
          optionRuleGap: 38.91,
          showReset: false,
          options: options,
          selected: chosen ?? (stored < 0 ? null : stored),
          ctaLabel: 'Save preference',
          onSelect: (i) => pending.value = i,
          onCta: () async {
            final index = pending.value ?? stored;
            if (index < 0) return;
            if (controller.saving.value) return;

            final outcome = await controller.apply(
              (current) =>
                  current.copyWith(lookingFor: options[index].title),
            );
            if (outcome.succeeded) {
              Get.back();
            } else {
              showPrefsError(outcome.message);
            }
          },
          onBack: Get.back,
        ),
      );
    });
  }
}

const List<RangeValues> prefsAgeRanges = [
  RangeValues(18, 24),
  RangeValues(22, 28),
  RangeValues(26, 33),
  RangeValues(30, 40),
];

class BubbaPrefsAgeRangeScreen extends StatelessWidget {
  const BubbaPrefsAgeRangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;
    final pending = ValueNotifier<int?>(null);

    return Obx(() {
      final range = controller.model.ageRange;
      final stored = prefsAgeRanges.indexWhere(
        (r) => r.start == range.start && r.end == range.end,
      );

      return ValueListenableBuilder<int?>(
        valueListenable: pending,
        builder: (context, chosen, _) => PrefsQuickOptionsView(
          title: 'Age Range',
          currentValue: '${range.start.round()} - ${range.end.round()}',
          currentSubtitle:
              '${(range.end - range.start).round()} year range',
          options: prefsAgeOptions,
          selected: chosen ?? (stored < 0 ? null : stored),
          impactTop: 575.45,
          impactNote: 'Approximately 23% of your match pool',
          ctaLabel: 'Save preference',
          onSelect: (i) {
            if (i == prefsAgeOptions.length - 1) {
              Get.toNamed(Routes.BUBBA_PREFS_AGE_SLIDER);
              return;
            }
            pending.value = i;
          },
          onCurrent: () => Get.toNamed(Routes.BUBBA_PREFS_AGE_SLIDER),
          onReset: () async {
            final outcome = await controller.apply(
              (current) =>
                  current.copyWith(ageRange: const RangeValues(22, 36)),
            );
            if (!outcome.succeeded) showPrefsError(outcome.message);
          },
          onCta: () async {
            final index = pending.value;
            if (index == null || index >= prefsAgeRanges.length) {
              Get.back();
              return;
            }
            if (controller.saving.value) return;

            final outcome = await controller.apply(
              (current) => current.copyWith(ageRange: prefsAgeRanges[index]),
            );
            if (outcome.succeeded) {
              Get.back();
            } else {
              showPrefsError(outcome.message);
            }
          },
          onBack: Get.back,
        ),
      );
    });
  }
}

/// p015 - the two-handle Age Range slider above the same quick-options list.
class PrefsAgeSliderView extends StatelessWidget {
  const PrefsAgeSliderView({
    super.key,
    this.minAge = 22,
    this.maxAge = 36,
    this.options = const [
      PrefsQuickOption('18 - 24', '6 year range'),
      PrefsQuickOption('22 - 28', '6 year range'),
      PrefsQuickOption('26 - 33', '7 year range'),
      PrefsQuickOption('30 - 40', '10 year range'),
    ],
    this.selected,
    this.onChanged,
    this.onSelect,
    this.onBack,
  });

  final int minAge;
  final int maxAge;
  final List<PrefsQuickOption> options;
  final int? selected;
  final void Function(int min, int max)? onChanged;
  final ValueChanged<int>? onSelect;
  final VoidCallback? onBack;

  static const double cardY = 153.47;
  static const double cardH = 180;
  static const double _sliderEyebrow = 374.78;
  static const double _sliderFirstTitle = 406.28;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.listBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.listBg,
          footerBand: 32,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      PrefsNavBar(
        title: 'Age Range',
        titleBaseline: 68.14,
        backY: 56.48,
        onBack: onBack,
      ),
      top: 0,
      height: PrefsNavBar.height + 4,
    );

    final introMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.introCopy);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(19.28)),
          Text(
            'Set how far away you\u2019re open to\nseeing matches.',
            style: BubbaPrefsText.introCopy,
          ),
        ],
      ),
      top: _introBaseline - introMetrics.baseline,
      height: introMetrics.lineHeight * 2,
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);

    flow.block(
      _RangeCard(minAge: minAge, maxAge: maxAge),
      top: cardY,
      height: cardH,
    );

    flow.block(
      PrefsEyebrow(
        label: 'QUICK OPTIONS',
        x: 18.69,
        style: BubbaPrefsText.eyebrow,
      ),
      top: _sliderEyebrow - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionTitle);
    for (var i = 0; i < options.length; i++) {
      final baseline = _sliderFirstTitle + _optionPitch * i;
      final top = baseline - titleMetrics.baseline;
      flow.block(
        _QuickOptionRow(
          option: options[i],
          top: top,
          baseline: baseline,
          ruleGap: _optionRuleGap,
          selected: selected == i,
          onTap: onSelect == null ? null : () => onSelect!(i),
        ),
        top: top,
        height: baseline + _optionRuleGap + 1 - top,
      );
    }
  }
}

class _RangeCard extends StatelessWidget {
  const _RangeCard({required this.minAge, required this.maxAge});

  final int minAge;
  final int maxAge;

  static const List<(String, double)> _scale = [
    ('18', 37.55),
    ('25', 98.73),
    ('35', 159.91),
    ('45', 221.08),
    ('55', 282.26),
    ('65+', 340.55),
  ];

  @override
  Widget build(BuildContext context) {
    final captionMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderCaption);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderValue);
    final scaleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderScale);
    final pillMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.pillLabel);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - 16.57),
              top: dGap(top - PrefsAgeSliderView.cardY),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(16.57)),
        Container(
          width: hd(359),
          height: d(PrefsAgeSliderView.cardH),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.sliderCardFill,
            borderRadius: BorderRadius.circular(d(9.10)),
            border: Border.all(
              color: BubbaPrefsColors.sliderCardBorder,
              width: d(1),
            ),
          ),
          child: Stack(
            children: [
              at(
                72.62,
                186.93 - captionMetrics.baseline,
                Text('Minimum age', style: BubbaPrefsText.sliderCaption),
              ),
              at(
                250.66,
                186.93 - captionMetrics.baseline,
                Text('Maximum age', style: BubbaPrefsText.sliderCaption),
              ),
              at(
                87.09,
                210.55 - valueMetrics.baseline,
                Text('$minAge', style: BubbaPrefsText.sliderValue),
              ),
              at(
                272.71,
                212.55 - valueMetrics.baseline,
                Text('$maxAge', style: BubbaPrefsText.sliderValue),
              ),
              at(
                193.04,
                183.97,
                SizedBox(
                  width: hd(1),
                  height: d(33),
                  child: const ColoredBox(
                    color: BubbaPrefsColors.sliderCardBorder,
                  ),
                ),
              ),
              at(
                41.67,
                238.38,
                Container(
                  width: hd(311),
                  height: d(4),
                  decoration: BoxDecoration(
                    color: BubbaPrefsColors.sliderTrack,
                    borderRadius: BorderRadius.circular(d(2)),
                  ),
                ),
              ),
              at(
                118.67,
                238.38,
                Container(
                  width: hd(87),
                  height: d(4),
                  decoration: BoxDecoration(
                    color: BubbaPrefsColors.sliderActive,
                    borderRadius: BorderRadius.circular(d(2)),
                  ),
                ),
              ),
              at(103.42, 230.38, const _SliderHandle()),
              at(201.31, 231.24, const _SliderHandle()),
              for (final (label, x) in _scale)
                at(
                  x,
                  276.85 - scaleMetrics.baseline,
                  Text(label, style: BubbaPrefsText.sliderScale),
                ),
              at(
                152.04,
                299.97,
                Container(
                  width: hd(83),
                  height: d(22),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: BubbaPrefsColors.pillBg,
                    borderRadius: BorderRadius.circular(d(11)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: d(313.83 - 299.97 - pillMetrics.baseline),
                    ),
                    child: Text(
                      '${maxAge - minAge} year range',
                      style: BubbaPrefsText.pillLabel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliderHandle extends StatelessWidget {
  const _SliderHandle();

  @override
  Widget build(BuildContext context) => Container(
        width: d(18.50),
        height: d(18.50),
        decoration: BoxDecoration(
          color: BubbaPrefsColors.onDark,
          shape: BoxShape.circle,
          border: Border.all(
            color: BubbaPrefsColors.sliderActive,
            width: d(1),
          ),
        ),
      );
}

class BubbaPrefsAgeSliderScreen extends StatelessWidget {
  const BubbaPrefsAgeSliderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;

    return Obx(() {
      final range = controller.model.ageRange;
      final stored = prefsAgeRanges.indexWhere(
        (r) => r.start == range.start && r.end == range.end,
      );

      Future<void> save(RangeValues next) async {
        final outcome = await controller.apply(
          (current) => current.copyWith(ageRange: next),
        );
        if (!outcome.succeeded) showPrefsError(outcome.message);
      }

      return PrefsAgeSliderView(
        minAge: range.start.round(),
        maxAge: range.end.round(),
        selected: stored < 0 ? null : stored,
        onChanged: (min, max) =>
            save(RangeValues(min.toDouble(), max.toDouble())),
        onSelect: (i) => save(prefsAgeRanges[i]),
        onBack: Get.back,
      );
    });
  }
}
