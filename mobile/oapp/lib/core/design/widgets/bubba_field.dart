import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bubba_layout.dart';
import '../bubba_text_styles.dart';
import '../bubba_tokens.dart';

/// The bordered input box both parts of the flow use: white fill, 1pt border
/// that turns [BubbaColors.actionPrimary] on focus and [BubbaColors.borderError]
/// when invalid, 10pt radius, 57.5 tall.
///
/// The box and the editable text are separate layers on purpose - the design
/// puts the text on a fixed baseline inside the box rather than centring a
/// Material field, so the box is drawn first and the [TextField] is overlaid
/// with its own inset.
class BubbaField extends StatelessWidget {
  const BubbaField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.width,
    this.height = BubbaMetrics.fieldHeight,
    this.textInset = 11.92,
    this.hasError = false,
    this.focused = false,
    this.enabled = true,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.leading,
    this.trailing,
    this.valueStyle,
    this.hintStyle,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final double? width;
  final double height;
  final double textInset;
  final bool hasError;

  /// Draws the focused border without real focus, which golden tests cannot
  /// have.
  final bool focused;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? valueStyle;
  final TextStyle? hintStyle;

  Color get _borderColor {
    if (hasError) return BubbaColors.borderError;
    if (focused || focusNode.hasFocus) return BubbaColors.actionPrimary;
    return BubbaColors.border;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: d(height),
      decoration: BoxDecoration(
        color: BubbaColors.surface,
        borderRadius: BorderRadius.circular(d(BubbaMetrics.fieldRadius)),
      ),
      // The border paints in the foreground so it costs no layout space: the
      // design measures `textInset` from the box's outer edge, and letting
      // `Border.all` inset the child shifted every value 1px right.
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(d(BubbaMetrics.fieldRadius)),
        border: Border.all(
          color: _borderColor,
          width: BubbaMetrics.borderWidth,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: hd(textInset)),
          if (leading != null) ...[leading!, SizedBox(width: hd(8))],
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              autofillHints: autofillHints,
              inputFormatters: inputFormatters,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              autocorrect: false,
              style: valueStyle ??
                  BubbaText.fieldValue.copyWith(color: BubbaColors.actionDark),
              cursorColor: BubbaColors.actionDark,
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: hintText,
                hintStyle: hintStyle ?? BubbaText.fieldPlaceholder,
              ),
            ),
          ),
          if (trailing != null) ...[trailing!, SizedBox(width: hd(textInset))],
        ],
      ),
    );
  }
}
