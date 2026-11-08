import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

/// Selection band shared by the birthday (p019-p022) and height (p024) wheels.
const double wheelBandHeight = 53.0;
const double wheelBandRadius = 6.15;
const double wheelBandX = 18.5;
const double wheelBandWidth = 353.0;
const Color wheelBandColor = Color(0xFFF1F2F2);

/// Row pitch. p024 measures 52.96 between row centres, p020 measures 45.15;
/// the two wheels are not the same wheel, so neither screen may change the
/// other's number.
const double wheelItemExtentHeight = 53.0;
const double wheelItemExtentBirthday = 45.15;

/// The selection band plus one or more scroll columns.
///
/// Positions itself: it takes the design y of the band and centres its rows on
/// it, so a caller can never place the band and the rows out of step.
class BubbaWheel extends StatelessWidget {
  const BubbaWheel({
    super.key,
    required this.bandTop,
    required this.columns,
    this.itemExtent = wheelItemExtentHeight,
    this.visibleEachSide = 3,
    this.bandColor = wheelBandColor,
    this.bandBorderColor,
  });

  /// Design y of the top of the selection band.
  final double bandTop;

  final List<BubbaWheelColumn> columns;

  /// Design distance between row centres.
  final double itemExtent;

  /// Rows drawn above and below the band. p020 draws 2, p024 draws 3.
  final int visibleEachSide;

  final Color bandColor;

  /// The under-18 state (p021) outlines the band in [BubbaColors.borderError].
  final Color? bandBorderColor;

  double get designHeight => itemExtent * (visibleEachSide * 2 + 1);

  double get designTop => bandTop + wheelBandHeight / 2 - designHeight / 2;

  @override
  Widget build(BuildContext context) {
    final height = d(designHeight);
    final bandInsetRight = BubbaMetrics.designWidth - wheelBandX - wheelBandWidth;
    return SizedBox(
      width: BubbaScale.availableWidth,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: dx(wheelBandX),
                right: BubbaScale.availableWidth - dxRight(bandInsetRight),
              ),
              child: SizedBox(
                width: double.infinity,
                height: d(wheelBandHeight),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: bandColor,
                    borderRadius: BorderRadius.circular(d(wheelBandRadius)),
                    border: bandBorderColor == null
                        ? null
                        : Border.all(
                            color: bandBorderColor!,
                            width: BubbaMetrics.borderWidth,
                          ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < columns.length; i++) ...[
                SizedBox(
                  width: i == 0
                      ? dx(columns[i].x)
                      : dx(columns[i].x) -
                          dx(columns[i - 1].x) -
                          d(columns[i - 1].width),
                ),
                SizedBox(
                  width: hd(columns[i].width),
                  child: _Column(column: columns[i], itemExtent: itemExtent),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class BubbaWheelColumn {
  const BubbaWheelColumn({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.x = 0,
    this.width = BubbaMetrics.designWidth,
    this.alignment = Alignment.center,
    this.looping = false,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Design x of the column's left edge and its design width.
  final double x;
  final double width;

  final Alignment alignment;

  /// Scrolls without ends. p020 draws December above January and 31 above 1,
  /// which only a cyclic column can show.
  final bool looping;
}

class _Column extends StatefulWidget {
  const _Column({required this.column, required this.itemExtent});

  final BubbaWheelColumn column;
  final double itemExtent;

  @override
  State<_Column> createState() => _ColumnState();
}

class _ColumnState extends State<_Column> {
  late final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: widget.column.selectedIndex);

  /// The scroll position's own index, which a looping column lets run past
  /// either end of [BubbaWheelColumn.items].
  late int _raw = widget.column.selectedIndex;

  int get _count => widget.column.items.length;

  int _wrap(int raw) => _count == 0 ? 0 : ((raw % _count) + _count) % _count;

  @override
  void didUpdateWidget(_Column oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wanted = widget.column.selectedIndex;
    if (_wrap(_raw) == wanted) return;
    var target = wanted;
    if (widget.column.looping) {
      var delta = wanted - _wrap(_raw);
      if (delta * 2 > _count) delta -= _count;
      if (delta * 2 < -_count) delta += _count;
      target = _raw + delta;
    }
    _raw = target;
    if (_controller.hasClients && _controller.selectedItem != target) {
      _controller.jumpToItem(target);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelected(int raw) {
    if (_raw == raw) return;
    _raw = raw;
    // `onSelectedItemChanged` fires from the scroll position, which can be
    // during layout - changing the month rebuilds the day column and the wheel
    // reports its new selection mid-build. Notifying synchronously throws
    // "setState() called during build", so the frame is allowed to finish
    // first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {});
      widget.column.onSelected(widget.column.looping ? _wrap(raw) : raw);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: d(widget.itemExtent),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 100,
      perspective: 0.001,
      onSelectedItemChanged: _onSelected,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.column.looping ? null : _count,
        builder: (context, index) {
          if (_count == 0) return null;
          return Align(
            alignment: widget.column.alignment,
            child: Text(
              widget.column.items[widget.column.looping ? _wrap(index) : index],
              style: BubbaText.wheelItem((index - _raw).abs()),
            ),
          );
        },
      ),
    );
  }
}
