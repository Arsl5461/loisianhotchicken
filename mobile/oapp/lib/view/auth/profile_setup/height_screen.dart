import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/bubba_wheel.dart';
import 'widgets/display_toggle_row.dart';
import 'widgets/step_scaffold.dart';

const double _segmentY = 215.88;
const double _segmentWidth = 205.14;
const double _segmentHeight = 39.26;
const double _segmentRadius = 13.12;
const double _segmentInset = 2.69;
const double _bandTop = 423.65;
const double _toggleY = 664.53;

/// Step 5 of 12 - artboard p024.
class ProfileHeightScreen extends StatefulWidget {
  const ProfileHeightScreen({
    super.key,
    this.initialCentimetres = 180,
    this.onBack,
    this.onSkip,
    this.onContinue,
  });

  final int initialCentimetres;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(int centimetres, bool display)? onContinue;

  /// 4'0" to 7'0" in whole inches, which is the range the design's wheel shows.
  static const int minInches = 48;
  static const int maxInches = 84;

  static String formatImperial(int totalInches) {
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return inches == 0 ? '$feet ft' : '$feet ft $inches in';
  }

  @override
  State<ProfileHeightScreen> createState() => _ProfileHeightScreenState();
}

class _ProfileHeightScreenState extends State<ProfileHeightScreen> {
  bool _metric = false;
  late int _inches = (widget.initialCentimetres / 2.54).round().clamp(
        ProfileHeightScreen.minInches,
        ProfileHeightScreen.maxInches,
      );
  bool _display = true;

  List<String> get _items => _metric
      ? [
          for (var i = ProfileHeightScreen.minInches;
              i <= ProfileHeightScreen.maxInches;
              i++)
            '${(i * 2.54).round()} cm',
        ]
      : [
          for (var i = ProfileHeightScreen.minInches;
              i <= ProfileHeightScreen.maxInches;
              i++)
            ProfileHeightScreen.formatImperial(i),
        ];

  int get _index => _inches - ProfileHeightScreen.minInches;

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
          step: 5,
          heading: 'How tall are you?',
          body: 'This is optional - you can update this later.',
          // The wheel always shows a value, so Continue is live from the start,
          // which is how p024 draws it.
          continueEnabled: true,
          onBack: widget.onBack,
          onSkip: widget.onSkip,
          onContinue: () => widget.onContinue
              ?.call((_inches * 2.54).round(), _display),
          content: (context, flow) {
            final wheel = BubbaWheel(
              bandTop: _bandTop,
              columns: [
                BubbaWheelColumn(
                  items: _items,
                  selectedIndex: _index,
                  onSelected: (i) => setState(
                      () => _inches = ProfileHeightScreen.minInches + i),
                ),
              ],
            );
            flow.block(
              Center(
                child: _UnitSegments(
                  metric: _metric,
                  onChanged: (v) => setState(() => _metric = v),
                ),
              ),
              top: _segmentY,
              height: _segmentHeight,
            );
            flow.bleed(
              wheel,
              top: wheel.designTop,
              height: wheel.designHeight,
            );
            flow.block(
              BubbaDisplayToggleRow(
                subtitle: 'Let others see your height',
                value: _display,
                onChanged: (v) => setState(() => _display = v),
              ),
              top: _toggleY,
              height: BubbaMetrics.rowHeightPart2,
            );
          },
        ),
      ),
    );
  }
}

class _UnitSegments extends StatelessWidget {
  const _UnitSegments({required this.metric, required this.onChanged});

  final bool metric;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final segmentWidth = (d(_segmentWidth) - d(_segmentInset) * 2) / 2;
    return Container(
      width: hd(_segmentWidth),
      height: d(_segmentHeight),
      decoration: BoxDecoration(
        color: BubbaColors.surface,
        borderRadius: BorderRadius.circular(d(_segmentRadius)),
        border: Border.all(
          color: const Color(0xFFE6E6E7),
          width: BubbaMetrics.borderWidth,
        ),
      ),
      padding: EdgeInsets.all(d(_segmentInset)),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            alignment: metric ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: segmentWidth,
              height: d(_segmentHeight - _segmentInset * 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2EE),
                borderRadius: BorderRadius.circular(d(10.69)),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: _segment('ft / in', !metric, () => onChanged(false))),
              Expanded(child: _segment('cm', metric, () => onChanged(true))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segment(String label, bool selected, VoidCallback onTap) =>
      Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: Text(
                label,
                style: selected
                    ? BubbaText.segmentSelected
                    : BubbaText.segmentUnselected,
              ),
            ),
          ),
        ),
      );
}
