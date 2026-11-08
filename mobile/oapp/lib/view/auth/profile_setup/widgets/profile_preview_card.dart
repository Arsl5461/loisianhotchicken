import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _cardHeight = 148.52;
const double _labelBaseline = 22.06;
const double _titleBaseline = 54.0;
const double _subtitleBaseline = 76.93;
const double _dividerY = 92.63;
const double _toggleTitleBaseline = 114.80;
const double _toggleSubtitleBaseline = 133.21;
const double _textInset = 16.25;
const double _iconInset = 15.69;
const double _copyInset = 60.71;
const double _toggleInset = 13.68;

const double _iconTop = 49.41;

class BubbaProfilePreviewCard extends StatelessWidget {
  const BubbaProfilePreviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.toggleSubtitle,
    required this.value,
    required this.onChanged,
    this.iconInset = _iconInset,
    this.iconTop = _iconTop,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final String toggleSubtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double iconInset;
  final double iconTop;

  static const double designHeight = _cardHeight;

  static double get height => d(_cardHeight);

  @override
  Widget build(BuildContext context) {
    final head = BubbaFlow(context, padded: false);
    head.copy(
      'PROFILE PREVIEW',
      baseline: _labelBaseline,
      style: BubbaText.previewLabel,
    );

    final copy = BubbaFlow(context, startY: head.cursor, padded: false);
    copy.copy(title, baseline: _titleBaseline, style: BubbaText.previewTitle);
    copy.copy(
      subtitle,
      baseline: _subtitleBaseline,
      style: BubbaText.previewSubtitle,
    );

    final toggleText = BubbaFlow(context, startY: _dividerY + 1, padded: false);
    toggleText.copy(
      'Display on profile',
      baseline: _toggleTitleBaseline,
      style: BubbaText.toggleTitle,
    );
    toggleText.copy(
      toggleSubtitle,
      baseline: _toggleSubtitleBaseline,
      style: BubbaText.toggleSubtitle,
    );

    return Container(
      height: d(_cardHeight),
      decoration: BoxDecoration(
        color: BubbaColors.rowBg,
        borderRadius: BorderRadius.circular(d(BubbaMetrics.fieldRadius)),
        border: Border.all(
          color: BubbaColors.border,
          width: BubbaMetrics.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: hd(_textInset)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: head.children,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: hd(iconInset)),
                SizedBox(
                  width: hd(_copyInset - iconInset),
                  child: Padding(
                    padding: EdgeInsets.only(top: d(iconTop - head.cursor)),
                    child: Align(alignment: Alignment.topLeft, child: icon),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: copy.children,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: BubbaColors.border),
          SizedBox(
            height: d(_cardHeight - _dividerY - 1),
            child: Row(
              children: [
                SizedBox(width: hd(_textInset)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: toggleText.children,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(!value),
                  child: Semantics(toggled: value, child: _Pill(value: value)),
                ),
                SizedBox(width: hd(_toggleInset)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final w = d(BubbaMetrics.toggleWidth);
    final h = d(BubbaMetrics.toggleHeight);
    final knob = d(BubbaMetrics.toggleKnob);
    final inset = (h - knob) / 2;
    return Container(
      width: w,
      height: h,
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: inset),
      decoration: BoxDecoration(
        color: value ? BubbaColors.actionPrimary : BubbaColors.border,
        borderRadius: BorderRadius.circular(h / 2),
      ),
      child: Container(
        width: knob,
        height: knob,
        decoration: const BoxDecoration(
          color: BubbaColors.surface,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
