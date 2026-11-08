import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

class BubbaOtpField extends StatefulWidget {
  const BubbaOtpField({
    super.key,
    required this.controller,
    this.length = 6,
    this.hasError = false,
    this.onCompleted,
    this.y = boxY,
    this.digitBaselineOverride,
    this.focused = false,
  });

  final TextEditingController controller;
  final int length;
  final bool hasError;
  final ValueChanged<String>? onCompleted;
  final double y;
  final double? digitBaselineOverride;

  final bool focused;

  static const double boxY = 310.0;
  static const double boxWidth = BubbaMetrics.otpBoxWidth;
  static const double boxHeight = BubbaMetrics.otpBoxHeight;
  static const double boxRadius = BubbaMetrics.otpBoxRadius;
  static const double firstBoxX = 16.5;
  static const double pitch = 61.68;
  static const double digitBaseline = 345.0;
  static const double digitBaselineError = 346.8;
  static const double rowInsetRight = 14.3;

  static const double caretTop = 17.37;
  static const double caretHeight = 26.08;
  static const double caretWidth = 1;

  @override
  State<BubbaOtpField> createState() => _BubbaOtpFieldState();
}

class _BubbaOtpFieldState extends State<BubbaOtpField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focus.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
    if (widget.controller.text.length == widget.length) {
      widget.onCompleted?.call(widget.controller.text);
    }
  }

  bool get _isFocused => widget.focused || _focus.hasFocus;

  Color _borderColor(int index, int filled) {
    if (widget.hasError) return BubbaColors.borderError;
    if (index < filled) return BubbaColors.actionPrimary;
    if (_isFocused && index == filled) return BubbaColors.actionPrimary;
    return BubbaColors.border;
  }

  @override
  Widget build(BuildContext context) {
    final digits = widget.controller.text;
    final totalDesignWidth =
        BubbaOtpField.pitch * (widget.length - 1) + BubbaOtpField.boxWidth;
    final available =
        dxRight(BubbaOtpField.rowInsetRight) - dx(BubbaOtpField.firstBoxX);
    final scaleGap = available / hd(totalDesignWidth);
    final pitch = hd(BubbaOtpField.pitch) * scaleGap;

    final row = Row(
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) SizedBox(width: pitch - hd(BubbaOtpField.boxWidth)),
          Container(
            width: hd(BubbaOtpField.boxWidth),
            height: d(BubbaOtpField.boxHeight),
            decoration: BoxDecoration(
              color: BubbaColors.surfaceField,
              borderRadius:
                  BorderRadius.circular(d(BubbaOtpField.boxRadius)),
              border: Border.all(
                color: _borderColor(i, digits.length),
                width: BubbaMetrics.borderWidth,
              ),
            ),
            child: i == digits.length && _isFocused
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: d(BubbaOtpField.caretTop)),
                      child: Container(
                        width: hd(BubbaOtpField.caretWidth),
                        height: d(BubbaOtpField.caretHeight),
                        color: BubbaColors.actionDark,
                      ),
                    ),
                  )
                : i < digits.length
                ? Baseline(
                    baseline: d((widget.digitBaselineOverride ??
                            (widget.hasError
                                ? BubbaOtpField.digitBaselineError
                                : BubbaOtpField.digitBaseline)) -
                        BubbaOtpField.boxY),
                    baselineType: TextBaseline.alphabetic,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        digits[i],
                        textAlign: TextAlign.center,
                        style: BubbaText.otpDigit,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ],
    );

    return SizedBox(
      height: d(BubbaOtpField.boxHeight),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                showCursor: false,
                style: BubbaText.otpDigit,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          SizedBox.expand(child: IgnorePointer(child: row)),
          SizedBox.expand(
            child: Semantics(
              label: 'Verification code',
              textField: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _focus.requestFocus(),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
