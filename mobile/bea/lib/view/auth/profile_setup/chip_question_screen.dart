import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/choice_chip_grid.dart';
import 'widgets/display_toggle_row.dart';
import 'widgets/step_scaffold.dart';

/// How the "select N of these" prompt is drawn above the grid. The design uses
/// two different treatments and they are not interchangeable.
enum ChipPromptStyle {
  /// Centred Lato 12 body copy on the shared body baseline (p025, p029).
  centredBody,

  /// Left-aligned Lato-Semibold 12 section label just above the grid
  /// (p036, p037). These artboards also draw a centred body paragraph, passed
  /// separately as [ChipQuestionScreen.body].
  sectionLabel,
}

/// Drives the four questionnaire steps that are a grid of choice chips plus a
/// "Display on profile" row: religion (6), ethnicity (8), looking for (11) and
/// political views (12).
class ChipQuestionScreen extends StatefulWidget {
  const ChipQuestionScreen({
    super.key,
    required this.step,
    required this.heading,
    required this.prompt,
    required this.promptStyle,
    this.body,
    this.bodyBaseline,
    required this.options,
    required this.multiSelect,
    required this.gridTop,
    required this.chipHeight,
    required this.columnGap,
    required this.rowGap,
    required this.toggleTop,
    required this.toggleSubtitle,
    this.promptBaseline,
    this.initialSelection = const <String>{},
    this.initialDisplayOnProfile = true,
    this.onBack,
    this.onSkip,
    this.onContinue,
  });

  final int step;
  final String heading;
  final String prompt;
  final ChipPromptStyle promptStyle;
  final String? body;
  final double? bodyBaseline;
  final List<ChipItem> options;
  final bool multiSelect;
  final double gridTop;
  final double chipHeight;
  final double columnGap;
  final double rowGap;
  final double toggleTop;
  final String toggleSubtitle;
  final double? promptBaseline;
  final Set<String> initialSelection;
  final bool initialDisplayOnProfile;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(Set<String> selection, bool displayOnProfile)? onContinue;

  @override
  State<ChipQuestionScreen> createState() => _ChipQuestionScreenState();
}

class _ChipQuestionScreenState extends State<ChipQuestionScreen> {
  late Set<String> _selected = {...widget.initialSelection};
  late bool _display = widget.initialDisplayOnProfile;

  void _toggle(String value) {
    setState(() {
      if (widget.multiSelect) {
        if (!_selected.remove(value)) _selected.add(value);
      } else {
        _selected = _selected.contains(value) ? <String>{} : {value};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final grid = BubbaChipGrid(
      items: widget.options,
      columns: 2,
      chipHeight: widget.chipHeight,
      columnGap: widget.columnGap,
      rowGap: widget.rowGap,
      isSelected: _selected.contains,
      onToggle: _toggle,
    );

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
          step: widget.step,
          heading: widget.heading,
          body: widget.promptStyle == ChipPromptStyle.centredBody
              ? widget.prompt
              : widget.body,
          bodyBaseline: widget.bodyBaseline,
          continueEnabled: _selected.isNotEmpty,
          onBack: widget.onBack,
          onSkip: widget.onSkip,
          onContinue: () => widget.onContinue?.call(_selected, _display),
          content: (context, flow) {
            if (widget.promptStyle == ChipPromptStyle.sectionLabel) {
              flow.copy(
                widget.prompt,
                baseline: widget.promptBaseline ?? widget.gridTop - 17.22,
                style: BubbaText.sectionLabel,
              );
            }
            flow.block(
              grid,
              top: widget.gridTop,
              height: grid.measure() / BubbaScale.factor,
            );
            flow.block(
              BubbaDisplayToggleRow(
                subtitle: widget.toggleSubtitle,
                value: _display,
                onChanged: (v) => setState(() => _display = v),
              ),
              top: widget.toggleTop,
              height: BubbaMetrics.rowHeightPart2,
            );
          },
        ),
      ),
    );
  }
}
