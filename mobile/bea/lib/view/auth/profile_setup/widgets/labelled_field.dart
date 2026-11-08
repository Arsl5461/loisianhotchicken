import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';
import '../../../../core/design/widgets/bubba_field.dart';

const double labelToFieldTop = 10.04;
const double fieldTextBaseline = 32.32;
const double fieldTextInset = 15.0;
const double labelBlockHeight = 22.0;
const double _labelLeft = 3.71;

class BubbaLabelledField extends StatelessWidget {
  const BubbaLabelledField({
    super.key,
    required this.label,
    this.optional = true,
    this.controller,
    this.focusNode,
    required this.hintText,
    this.value,
    this.onTap,
    this.trailing,
    this.enabled = true,
  });

  final String label;
  final bool optional;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool enabled;

  static double get height => d(BubbaMetrics.fieldHeight);

  static double get blockHeight =>
      labelBlockHeight + BubbaMetrics.fieldHeight;

  @override
  Widget build(BuildContext context) {
    final field = controller != null && focusNode != null
        ? BubbaField(
            controller: controller!,
            focusNode: focusNode!,
            hintText: hintText,
            hintStyle: BubbaText.fieldPlaceholderPart2,
            textInset: fieldTextInset,
            enabled: enabled,
            valueStyle: BubbaText.fieldValuePart2,
            trailing: trailing,
          )
        : _ReadOnlyBox(
            hintText: hintText,
            value: value,
            trailing: trailing,
            onTap: onTap,
          );

    final metrics = bubbaDesignTextMetrics(context, BubbaText.fieldLabelPart2);
    final labelBaseline = labelBlockHeight - labelToFieldTop;
    final gapToField = labelBlockHeight - labelBaseline - metrics.descent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: hd(_labelLeft)),
          child: Align(
            alignment: Alignment.centerLeft,
            heightFactor: 1,
            child: BubbaCopy(
              label,
              gapAbove: labelBaseline,
              style: BubbaText.fieldLabelPart2,
              span: TextSpan(
                text: label,
                style: BubbaText.fieldLabelPart2,
                children: optional
                    ? [
                        TextSpan(
                          text: '  (optional)',
                          style: BubbaText.fieldLabelOptional,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
        if (gapToField > 0) BubbaGap(gapToField),
        field,
      ],
    );
  }
}

class _ReadOnlyBox extends StatelessWidget {
  const _ReadOnlyBox({
    required this.hintText,
    this.value,
    this.trailing,
    this.onTap,
  });

  final String hintText;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return Semantics(
      button: onTap != null,
      label: filled ? '$hintText, $value' : hintText,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: d(BubbaMetrics.fieldHeight),
          decoration: BoxDecoration(
            color: BubbaColors.surface,
            borderRadius: BorderRadius.circular(d(BubbaMetrics.fieldRadius)),
            border: Border.all(
              color: BubbaColors.border,
              width: BubbaMetrics.borderWidth,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: hd(fieldTextInset)),
              Expanded(
                child: Text(
                  filled ? value! : hintText,
                  style: filled
                      ? BubbaText.fieldValuePart2
                      : BubbaText.fieldPlaceholderPart2,
                ),
              ),
              if (trailing != null) ...[
                trailing!,
                SizedBox(width: hd(fieldTextInset)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
