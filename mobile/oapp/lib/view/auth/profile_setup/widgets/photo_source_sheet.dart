import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_icons.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _sheetRadius = 25.37;
const double _grabberY = 19.61;
const double _grabberWidth = 32.76;
const double _titleBaseline = 59.18;
const double _subtitleBaseline = 81.93;
const double _firstRowY = 116.03;
const double _rowPitch = 80.94;
const double _rowHeight = 68.09;
const double _rowInset = 24.09;
const double _rowRadius = 12.54;
const double _rowIconX = 14.76;
const double _rowTextX = 61.81;
const double _rowTitleBaseline = 27.32;
const double _rowSubtitleBaseline = 49.57;
const double _rowChevronInset = 26.15;
const double _sheetBottom = 87.19;

const Color _rowBorder = Color(0xFFEFEFEF);
const Color _rowPressed = Color(0xFFF5F3F0);
const Color _scrim = Color(0x2B000000);

typedef BubbaPhotoSourceOption = ({
  BubbaPhotoSource source,
  String title,
  String subtitle,
  double iconTop,
  double chevronTop,
});

/// The "Add photos" bottom sheet from p043 (first row pressed) and p044.
///
/// p011 draws the same sheet in the stale part 1 type ramp; p043/p044 are the
/// current pair, so those are what this follows.
class BubbaPhotoSourceSheet extends StatelessWidget {
  const BubbaPhotoSourceSheet({
    super.key,
    this.pressed,
    this.onPick,
    this.onDismiss,
  });

  /// Set only to render p043's pressed row in a golden; live taps handle their
  /// own highlight.
  final BubbaPhotoSource? pressed;
  final ValueChanged<BubbaPhotoSource>? onPick;
  final VoidCallback? onDismiss;

  static const List<BubbaPhotoSourceOption> options = [
    (
      source: BubbaPhotoSource.library,
      title: 'Choose from library',
      subtitle: 'Pick photos from your camera roll',
      iconTop: 18.99,
      chevronTop: 32.15,
    ),
    (
      source: BubbaPhotoSource.camera,
      title: 'Take a photo',
      subtitle: 'Use your camera',
      iconTop: 22.63,
      chevronTop: 29.66,
    ),
    (
      source: BubbaPhotoSource.album,
      title: 'Choose album',
      subtitle: 'Select from a specific album',
      iconTop: 19.45,
      chevronTop: 28.48,
    ),
  ];

  @override
  Widget build(BuildContext context) => BubbaTextDefaults(
    child: BubbaSheetCanvas(builder: _build),
  );

  Widget _build(BuildContext context) {
    final titleMetrics = bubbaDesignTextMetrics(context, BubbaText.sheetTitle);
    final subtitleMetrics = bubbaDesignTextMetrics(context, BubbaText.body);
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onDismiss,
          child: const ColoredBox(color: _scrim),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
          decoration: BoxDecoration(
            color: BubbaColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(d(_sheetRadius)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: BubbaScale.canvasOffset),
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
              BubbaCopy(
                'Add photos',
                gapAbove: _titleBaseline - _grabberY - 3,
                style: BubbaText.sheetTitle,
                textAlign: TextAlign.center,
              ),
              BubbaCopy(
                'Choose how you\u2019d like to add photos.',
                gapAbove:
                    _subtitleBaseline - _titleBaseline - titleMetrics.descent,
                style: BubbaText.body,
                textAlign: TextAlign.center,
              ),
              BubbaGap(
                _firstRowY - _subtitleBaseline - subtitleMetrics.descent,
              ),
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const BubbaGap(_rowPitch - _rowHeight),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: d(_rowInset)),
                  child: _SourceRow(
                    option: options[i],
                    pressed: options[i].source == pressed,
                    onTap: onPick == null
                        ? null
                        : () => onPick!(options[i].source),
                  ),
                ),
              ],
              const BubbaGap(_sheetBottom),
            ],
            ),
          ),
          ),
        ),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.option,
    required this.pressed,
    this.onTap,
  });

  final BubbaPhotoSourceOption option;
  final bool pressed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaText.sheetRowTitle);
    return Semantics(
      button: true,
      label: '${option.title}. ${option.subtitle}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: d(_rowHeight)),
          decoration: BoxDecoration(
            color: pressed ? _rowPressed : BubbaColors.surface,
            borderRadius: BorderRadius.circular(d(_rowRadius)),
            border: Border.all(color: _rowBorder, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: hd(_rowIconX)),
              SizedBox(
                width: hd(_rowTextX - _rowIconX),
                child: Padding(
                  padding: EdgeInsets.only(top: d(option.iconTop)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: 1,
                    child: BubbaPhotoSourceIcon(source: option.source),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BubbaCopy(
                      option.title,
                      gapAbove: _rowTitleBaseline,
                      style: BubbaText.sheetRowTitle,
                      maxLines: 1,
                    ),
                    BubbaCopy(
                      option.subtitle,
                      gapAbove: _rowSubtitleBaseline -
                          _rowTitleBaseline -
                          titleMetrics.descent,
                      style: BubbaText.sheetRowSubtitle,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: hd(12)),
              Padding(
                padding: EdgeInsets.only(top: d(option.chevronTop)),
                child: const BubbaChevronRight(
                  width: 5.46,
                  height: 10.92,
                  strokeWidth: 2,
                  color: Color(0xFF4A4644),
                ),
              ),
              SizedBox(width: hd(_rowChevronInset)),
            ],
          ),
        ),
      ),
    );
  }
}
