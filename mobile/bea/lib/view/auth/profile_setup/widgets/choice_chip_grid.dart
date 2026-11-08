import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _gap2Up = BubbaMetrics.chipGap2Up;
const double _gap3Up = BubbaMetrics.chipGap3Up;

/// One selectable pill from the questionnaire's chip grids. Unselected chips are
/// a flat [BubbaColors.chipBg] with warm near-black text; selected chips fill
/// with the primary green and switch the label to bold white.
class BubbaChoiceChip extends StatelessWidget {
  const BubbaChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.width,
    this.height = BubbaMetrics.chipHeight,
    this.onTap,
  });

  final String label;
  final bool selected;
  final double width;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: width,
          height: d(height),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: d(6)),
          decoration: BoxDecoration(
            color: selected ? BubbaColors.actionPrimary : BubbaColors.chipBg,
            borderRadius: BorderRadius.circular(d(BubbaMetrics.chipRadius)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: selected
                ? BubbaText.chipLabelSelected
                : BubbaText.chipLabel,
          ),
        ),
      ),
    );
  }
}

/// A grid of [BubbaChoiceChip]s laid out across the content column. Chips
/// stretch to fill the column, keeping the design's gaps, so the grid stays
/// correct on a phone and on a 560pt iPad column alike.
///
/// An entry whose [ChipItem.fullWidth] is true takes a row of its own, which is
/// how the design draws the trailing "Prefer not to say" option.
class BubbaChipGrid extends StatelessWidget {
  const BubbaChipGrid({
    super.key,
    required this.items,
    required this.columns,
    required this.isSelected,
    required this.onToggle,
    this.chipHeight = BubbaMetrics.chipHeight,
    this.columnGap,
    this.rowGap,
  });

  final List<ChipItem> items;
  final int columns;
  final bool Function(String value) isSelected;
  final void Function(String value) onToggle;
  final double chipHeight;

  /// The design draws a different gap on nearly every chip screen, so both axes
  /// are per-screen rather than derived from the column count.
  final double? columnGap;
  final double? rowGap;

  double get _gap => columnGap ?? (columns == 3 ? _gap3Up : _gap2Up);

  static double chipWidthFor(int columns, {double? columnGap}) {
    final gap = columnGap ?? (columns == 3 ? _gap3Up : _gap2Up);
    return (BubbaScale.contentWidth - hd(gap) * (columns - 1)) / columns;
  }

  /// Height this grid occupies, so callers can position what follows it.
  double measure() {
    final gap = d(rowGap ?? _gap);
    var rows = 0;
    var col = 0;
    for (final item in items) {
      if (item.fullWidth) {
        if (col != 0) {
          rows++;
          col = 0;
        }
        rows++;
      } else {
        if (col == 0) rows++;
        col = (col + 1) % columns;
      }
    }
    if (rows == 0) return 0;
    return rows * d(chipHeight) + (rows - 1) * gap;
  }

  @override
  Widget build(BuildContext context) {
    final gap = d(rowGap ?? _gap);
    final chipWidth = chipWidthFor(columns, columnGap: columnGap);
    final rows = <Widget>[];
    var current = <ChipItem>[];

    void flush() {
      if (current.isEmpty) return;
      final row = <Widget>[];
      for (var i = 0; i < current.length; i++) {
        if (i > 0) {
          row.add(SizedBox(width: hd(columnGap ?? (columns == 3 ? _gap3Up : _gap2Up))));
        }
        row.add(_chip(current[i], chipWidth));
      }
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: row));
      current = <ChipItem>[];
    }

    for (final item in items) {
      if (item.fullWidth) {
        flush();
        rows.add(_chip(item, BubbaScale.contentWidth));
      } else {
        current.add(item);
        if (current.length == columns) flush();
      }
    }
    flush();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          rows[i],
        ],
      ],
    );
  }

  Widget _chip(ChipItem item, double width) => BubbaChoiceChip(
        label: item.label,
        selected: isSelected(item.value),
        width: width,
        height: chipHeight,
        onTap: () => onToggle(item.value),
      );
}

class ChipItem {
  const ChipItem(this.value, {String? label, this.fullWidth = false})
      : label = label ?? value;

  final String value;
  final String label;
  final bool fullWidth;
}
