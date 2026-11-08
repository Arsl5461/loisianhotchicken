import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _textInset = 16.25;
const double _toggleInset = 13.68;
const double _titleBaselineInRow = 23.73;
const double _subtitleBaselineInRow = 42.13;

class BubbaDisplayToggleRow extends StatelessWidget {
  const BubbaDisplayToggleRow({
    super.key,
    this.title = 'Display on profile',
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  static double get height => d(BubbaMetrics.rowHeightPart2);

  @override
  Widget build(BuildContext context) {
    final flow = BubbaFlow(context, padded: false);
    flow.copy(title, baseline: _titleBaselineInRow, style: BubbaText.toggleTitle);
    flow.copy(
      subtitle,
      baseline: _subtitleBaselineInRow,
      style: BubbaText.toggleSubtitle,
    );

    return Semantics(
      toggled: value,
      label: '$title. $subtitle',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Container(
          height: d(BubbaMetrics.rowHeightPart2),
          decoration: BoxDecoration(
            color: BubbaColors.rowBg,
            borderRadius: BorderRadius.circular(d(BubbaMetrics.fieldRadius)),
            border: Border.all(
              color: BubbaColors.border,
              width: BubbaMetrics.borderWidth,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: hd(_textInset)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: flow.children,
                ),
              ),
              _Pill(value: value),
              SizedBox(width: hd(_toggleInset)),
            ],
          ),
        ),
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
