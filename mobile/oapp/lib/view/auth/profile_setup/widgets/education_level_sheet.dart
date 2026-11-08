import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _sheetRadius = 26.01;
const double _grabberY = 10.82;
const double _grabberWidth = 32.76;
const double _titleX = 21.66;
const double _titleBaseline = 45.25;

/// The chip grid keeps the sheet's own insets (17.13 -> 372.88), which are
/// wider than the canonical content box, the same exception the photo grid
/// carries.
const double _chipLeft = 17.13;
const double _chipRight = 390 - 372.88;
const double _chipHeight = 43.69;
const double _chipRadius = 4.95;
const double _firstRowY = 71.79;
const double _rowPitch = 53.51;
const double _columnGap = 10.83;
const double _sheetTop = 503.07;
const double _sheetBottom = BubbaMetrics.designHeight;

/// The "Select education level" sheet over the education step (p033).
///
/// Eight levels in a 2-up grid with "Prefer not to say" taking its own full
/// width row, which is the same shape the questionnaire's chip grids use.
class BubbaEducationLevelSheet extends StatelessWidget {
  const BubbaEducationLevelSheet({
    super.key,
    required this.levels,
    this.selected,
    this.onPick,
    this.onDismiss,
  });

  final List<String> levels;
  final String? selected;
  final ValueChanged<String>? onPick;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) => BubbaTextDefaults(
    child: BubbaSheetCanvas(builder: _build),
  );

  Widget _build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaText.levelSheetTitle);
    final pairs = <List<int>>[];
    for (var i = 0; i < levels.length - 1; i += 2) {
      pairs.add([i, if (i + 1 < levels.length - 1) i + 1]);
    }
    return Stack(
      children: [
        SizedBox.expand(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: const ColoredBox(color: Color(0x2B000000)),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: SizedBox.shrink()),
            Container(
              decoration: BoxDecoration(
                color: BubbaColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(d(_sheetRadius)),
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: BubbaScale.canvasOffset),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BubbaGap(_grabberY),
                  Center(
                    child: Container(
                      width: hd(_grabberWidth),
                      height: d(3),
                      decoration: BoxDecoration(
                        color: BubbaColors.actionDark,
                        borderRadius: BorderRadius.circular(d(1.5)),
                      ),
                    ),
                  ),
                  BubbaInset(
                    left: _titleX,
                    child: BubbaCopy(
                      'Select education level',
                      gapAbove: _titleBaseline - _grabberY - 3,
                      style: BubbaText.levelSheetTitle,
                    ),
                  ),
                  BubbaGap(
                    _firstRowY - _titleBaseline - titleMetrics.descent,
                  ),
                  for (var r = 0; r < pairs.length; r++) ...[
                    if (r > 0) const BubbaGap(_rowPitch - _chipHeight),
                    BubbaInset(
                      left: _chipLeft,
                      right: _chipRight,
                      child: Row(
                        children: [
                          for (var c = 0; c < 2; c++) ...[
                            if (c > 0) SizedBox(width: hd(_columnGap)),
                            Expanded(
                              child: c < pairs[r].length
                                  ? _LevelChip(
                                      label: levels[pairs[r][c]],
                                      selected:
                                          levels[pairs[r][c]] == selected,
                                      onTap: () =>
                                          onPick?.call(levels[pairs[r][c]]),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const BubbaGap(_rowPitch - _chipHeight),
                  BubbaInset(
                    left: _chipLeft,
                    right: _chipRight,
                    child: _LevelChip(
                      label: levels.last,
                      selected: levels.last == selected,
                      onTap: () => onPick?.call(levels.last),
                    ),
                  ),
                  BubbaGap(
                    _sheetBottom -
                        _sheetTop -
                        (_firstRowY + pairs.length * _rowPitch + _chipHeight),
                  ),
                  SizedBox(height: bubbaBottomInset(context)),
                ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: d(_chipHeight)),
            padding: EdgeInsets.symmetric(vertical: d(4)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? BubbaColors.actionPrimary
                  : const Color(0xFFF1F2F2),
              borderRadius: BorderRadius.circular(d(_chipRadius)),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: selected
                  ? BubbaText.levelChipSelected
                  : BubbaText.levelChip,
            ),
          ),
        ),
      );
}
