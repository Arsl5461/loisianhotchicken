import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_prefs_tokens.dart';
import 'bubba_prefs_controller.dart';
import 'prefs_feedback.dart';
import 'widgets/prefs_chrome.dart';

const double _cardY = 174;
const double _cardW = 359;
const double _cardH = 132;
const double _cardX = 15.50;

/// p032 / p038 / p040 - Height. A two-handle range slider in a filled card,
/// then the non-negotiable switch and the impact card.
class PrefsHeightView extends StatelessWidget {
  const PrefsHeightView({
    super.key,
    this.from = '5’6”',
    this.to = '6’4”',
    this.fromX = 71.52,
    this.toX = 258.15,
    this.activeStart = 109.97,
    this.activeWidth = 87,
    this.leftHandle = 94.72,
    this.rightHandle = 192.62,
    this.requirePreference = true,
    this.impactTop = 675.85,
    this.eyebrowBaseline = 158.36,
    this.nonNegotiableBaseline = 361.09,
    this.requireBaseline = 385.99,
    this.hairlineY = 333.39,
    this.toggleY = 356.20,
    this.showReset = true,
    this.onRequire,
    this.onBack,
    this.onReset,
    this.onRangeChanged,
  });

  final String from;
  final String to;
  final double fromX;
  final double toX;
  final double activeStart;
  final double activeWidth;
  final double leftHandle;
  final double rightHandle;
  final bool requirePreference;
  final double impactTop;
  final double eyebrowBaseline;
  final double nonNegotiableBaseline;
  final double requireBaseline;
  final double hairlineY;
  final double toggleY;
  final bool showReset;
  final ValueChanged<bool>? onRequire;
  final VoidCallback? onBack;
  final VoidCallback? onReset;
  final void Function(int minInches, int maxInches)? onRangeChanged;

  static const List<(String, double)> scale = [
    ('4’10”', 31.31),
    ('5’4”', 93.31),
    ('5’10”', 155.31),
    ('6’4”', 217.31),
    ('6’10”', 279.31),
    ('7’4”', 341.31),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaPrefsColors.listBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaPrefsColors.listBg,
          footerBand: 31,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.reserveBlocks = true;
    flow.block(
      PrefsNavBar(
        title: 'Height',
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
          Text(
            'Set your height preferences.',
            style: BubbaPrefsText.introCopy,
          ),
        ],
      ),
      top: 114.16 - introMetrics.baseline,
      height: introMetrics.lineHeight,
    );

    final eyebrowMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.eyebrow);
    flow.block(
      PrefsEyebrow(
        label: 'YOUR CURRENT RANGE',
        x: 23.13,
        style: BubbaPrefsText.eyebrow,
      ),
      top: eyebrowBaseline - eyebrowMetrics.baseline,
      height: eyebrowMetrics.lineHeight,
    );

    flow.block(
      _HeightCard(
        from: from,
        to: to,
        fromX: fromX,
        toX: toX,
        activeStart: activeStart,
        activeWidth: activeWidth,
        leftHandle: leftHandle,
        rightHandle: rightHandle,
        onRangeChanged: onRangeChanged,
      ),
      top: _cardY,
      height: _cardH,
    );

    flow.block(
      const PrefsRule(
        x: 26.09,
        width: 341.64,
        colour: BubbaPrefsColors.hairline,
        weight: 0.5,
      ),
      top: hairlineY - 0.25,
      height: 0.5,
    );

    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.optionMedium);
    final eyebrowTop = nonNegotiableBaseline - eyebrowMetrics.baseline;
    final requireTop = math.min(eyebrowTop, toggleY);
    flow.block(
      Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: hd(25.75),
                top: dGap(eyebrowTop - requireTop),
              ),
              child: Text('NON-NEGOTIABLE', style: BubbaPrefsText.eyebrow),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: hd(25.91),
                top: dGap(
                  requireBaseline - labelMetrics.baseline - requireTop,
                ),
              ),
              child: Text(
                'Require this preference',
                style: BubbaPrefsText.optionMedium,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: hd(314.59),
                top: dGap(toggleY - requireTop),
              ),
              child: PrefsToggle(
                value: requirePreference,
                onColour: BubbaPrefsColors.toggleOnTeal,
                label: 'Require this preference',
                onChanged: onRequire,
              ),
            ),
          ),
        ],
      ),
      top: requireTop,
      height: requireBaseline + labelMetrics.descent - requireTop,
    );

    flow.block(
      const PrefsImpactCard(),
      top: impactTop,
      height: BubbaPrefsMetrics.impactHeight,
    );
  }
}

class _HeightCard extends StatelessWidget {
  const _HeightCard({
    required this.from,
    required this.to,
    required this.fromX,
    required this.toX,
    required this.activeStart,
    required this.activeWidth,
    required this.leftHandle,
    required this.rightHandle,
    this.onRangeChanged,
  });

  final String from;
  final String to;
  final double fromX;
  final double toX;
  final double activeStart;
  final double activeWidth;
  final double leftHandle;
  final double rightHandle;
  final void Function(int minInches, int maxInches)? onRangeChanged;

  static const List<double> _majorTicks = [
    41.94,
    103.94,
    165.94,
    227.94,
    289.94,
    351.94,
  ];
  static const List<double> _minorTicks = [
    73.23,
    135.22,
    197.22,
    259.21,
    321.20,
  ];

  @override
  Widget build(BuildContext context) {
    final captionMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderCaption);
    final valueMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderValue);
    final scaleMetrics =
        bubbaDesignTextMetrics(context, BubbaPrefsText.sliderScale);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hdGap(left - _cardX),
              top: dGap(top - _cardY),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(_cardX)),
        Container(
          width: hd(_cardW),
          height: d(_cardH),
          decoration: BoxDecoration(
            color: BubbaPrefsColors.sliderCardFill,
            borderRadius: BorderRadius.circular(d(15.20)),
            border: Border.all(
              color: BubbaPrefsColors.sliderCardBorder,
              width: d(1),
            ),
          ),
          child: _HeightDragTarget(
            onRangeChanged: onRangeChanged,
            leftHandle: leftHandle,
            rightHandle: rightHandle,
            child: Stack(
            children: [
              at(
                74.05,
                203.96 - captionMetrics.baseline,
                Text('From', style: BubbaPrefsText.sliderCaption),
              ),
              at(
                267.08,
                203.96 - captionMetrics.baseline,
                Text('To', style: BubbaPrefsText.sliderCaption),
              ),
              at(
                fromX,
                227.58 - valueMetrics.baseline,
                Text(from, style: BubbaPrefsText.sliderValue),
              ),
              at(
                toX,
                229.58 - valueMetrics.baseline,
                Text(to, style: BubbaPrefsText.sliderValue),
              ),
              at(
                182.47,
                201.00,
                SizedBox(
                  width: hd(1),
                  height: d(33),
                  child: const ColoredBox(
                    color: BubbaPrefsColors.sliderCardBorder,
                  ),
                ),
              ),
              at(
                32.97,
                251.00,
                Container(
                  width: hd(325),
                  height: d(4),
                  decoration: BoxDecoration(
                    color: BubbaPrefsColors.sliderTrack,
                    borderRadius: BorderRadius.circular(d(2)),
                  ),
                ),
              ),
              at(
                activeStart,
                251.00,
                Container(
                  width: hd(activeWidth),
                  height: d(4),
                  decoration: BoxDecoration(
                    color: BubbaPrefsColors.sliderActive,
                    borderRadius: BorderRadius.circular(d(2)),
                  ),
                ),
              ),
              for (final x in _majorTicks)
                at(
                  x,
                  268.83,
                  SizedBox(
                    width: hd(1),
                    height: d(6),
                    child: const ColoredBox(color: Color(0xFFB9B7B8)),
                  ),
                ),
              for (final x in _minorTicks)
                at(
                  x,
                  270.05,
                  SizedBox(
                    width: hd(1),
                    height: d(3.68),
                    child: const ColoredBox(color: Color(0xFFE0DEDD)),
                  ),
                ),
              at(leftHandle, 243.00, const _Handle()),
              at(rightHandle, 243.87, const _Handle()),
              for (final (label, x) in PrefsHeightView.scale)
                at(
                  x,
                  289.05 - scaleMetrics.baseline,
                  Text(label, style: BubbaPrefsText.sliderScale),
                ),
            ],
          ),
          ),
        ),
      ],
    );
  }
}

/// Turns a horizontal drag over the card into a height range. The mapping is
/// the track's own tick geometry: the first major tick is 4'10" and they run
/// every six inches, so an inch is `_tickPitch / 6` design points. Nothing is
/// placed and no measured number moves; this only reads them back.
class _HeightDragTarget extends StatelessWidget {
  const _HeightDragTarget({
    required this.child,
    required this.leftHandle,
    required this.rightHandle,
    this.onRangeChanged,
  });

  final Widget child;
  final double leftHandle;
  final double rightHandle;
  final void Function(int minInches, int maxInches)? onRangeChanged;

  static const double _firstTick = 41.94;
  static const double _tickPitch = 62;
  static const double _handleRadius = 9.25;
  static const int _minInches = 58;
  static const int _maxInches = 88;

  static double xForInches(int inches) =>
      _firstTick + (inches - _minInches) * (_tickPitch / 6);

  static int inchesForX(double designX) {
    final raw = _minInches + (designX - _firstTick) / (_tickPitch / 6);
    return raw.round().clamp(_minInches, _maxInches);
  }

  int _inchesAt(Offset local, double cardPixelWidth) {
    if (cardPixelWidth <= 0) return _minInches;
    final designInCard = (local.dx / cardPixelWidth) * _cardW;
    return inchesForX(designInCard + _cardX);
  }

  @override
  Widget build(BuildContext context) {
    if (onRangeChanged == null) return child;

    final cardPixelWidth = hd(_cardW);
    var dragging = 0;

    void update(Offset local) {
      final inches = _inchesAt(local, cardPixelWidth);
      final low = inchesForX(leftHandle + _handleRadius);
      final high = inchesForX(rightHandle + _handleRadius);

      if (dragging == 0) {
        dragging = (inches - low).abs() <= (inches - high).abs() ? 1 : 2;
      }

      if (dragging == 1) {
        onRangeChanged!(inches.clamp(_minInches, high), high);
      } else {
        onRangeChanged!(low, inches.clamp(low, _maxInches));
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        dragging = 0;
        update(details.localPosition);
      },
      onHorizontalDragUpdate: (details) => update(details.localPosition),
      onHorizontalDragEnd: (_) => dragging = 0,
      onTapDown: (details) {
        dragging = 0;
        update(details.localPosition);
      },
      child: child,
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

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

/// `height` on the API is one string. The screen holds a pair, so the pair is
/// encoded as `5’6” - 6’4”` and parsed back on the way in. An empty
/// value renders the artboard's own default state, byte for byte.
class PrefsHeightRange {
  const PrefsHeightRange(this.minInches, this.maxInches);

  final int minInches;
  final int maxInches;

  static const PrefsHeightRange fallback = PrefsHeightRange(66, 76);

  static String labelFor(int inches) =>
      '${inches ~/ 12}’${inches % 12}”';

  String get label => '${labelFor(minInches)} - ${labelFor(maxInches)}';

  static PrefsHeightRange? parse(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final matches = RegExp(r"(\d+)\s*[’']\s*(\d+)")
        .allMatches(value)
        .toList();
    if (matches.length < 2) return null;

    int inches(RegExpMatch m) =>
        int.parse(m.group(1)!) * 12 + int.parse(m.group(2)!);

    final low = inches(matches[0]);
    final high = inches(matches[1]);
    if (high < low) return null;
    return PrefsHeightRange(low.clamp(58, 88), high.clamp(58, 88));
  }
}

class BubbaPrefsHeightScreen extends StatelessWidget {
  const BubbaPrefsHeightScreen({super.key});

  static const double _handleRadius = 9.25;

  @override
  Widget build(BuildContext context) {
    final controller = BubbaPrefsController.to;
    final pending = ValueNotifier<PrefsHeightRange?>(null);

    return Obx(() {
      final stored = PrefsHeightRange.parse(controller.model.height);

      return ValueListenableBuilder<PrefsHeightRange?>(
        valueListenable: pending,
        builder: (context, dragged, _) {
          final range = dragged ?? stored;

          if (range == null) {
            return PrefsHeightView(
              requirePreference:
                  controller.isNonNegotiable(PrefsFilterKind.height),
              onRequire: (v) => _saveRequire(controller, v),
              onRangeChanged: (min, max) =>
                  pending.value = PrefsHeightRange(min, max),
              onReset: () => _save(controller, null),
              onBack: Get.back,
            );
          }

          final leftCentre = _HeightDragTarget.xForInches(range.minInches);
          final rightCentre = _HeightDragTarget.xForInches(range.maxInches);

          return PrefsHeightView(
            from: PrefsHeightRange.labelFor(range.minInches),
            to: PrefsHeightRange.labelFor(range.maxInches),
            fromX: leftCentre - 19.25,
            toX: rightCentre - 19.25,
            activeStart: leftCentre,
            activeWidth: math.max(0, rightCentre - leftCentre),
            leftHandle: leftCentre - _handleRadius,
            rightHandle: rightCentre - _handleRadius,
            requirePreference:
                controller.isNonNegotiable(PrefsFilterKind.height),
            onRequire: (v) => _saveRequire(controller, v),
            onRangeChanged: (min, max) {
              pending.value = PrefsHeightRange(min, max);
            },
            onReset: () {
              pending.value = null;
              _save(controller, null);
            },
            onBack: () {
              final next = pending.value;
              if (next != null && next.label != controller.model.height) {
                _save(controller, next.label).then((_) => Get.back());
                return;
              }
              Get.back();
            },
          );
        },
      );
    });
  }

  Future<void> _save(BubbaPrefsController controller, String? label) async {
    final outcome = await controller.apply(
      (current) => current.copyWith(height: label, clearHeight: label == null),
    );
    if (!outcome.succeeded) showPrefsError(outcome.message);
  }

  Future<void> _saveRequire(BubbaPrefsController controller, bool value) async {
    final outcome =
        await controller.setNonNegotiable(PrefsFilterKind.height, value);
    if (!outcome.succeeded) showPrefsError(outcome.message);
  }
}
