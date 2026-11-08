import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_settings_glyphs.dart';
import '../../../core/design/bubba_settings_tokens.dart';

class SettingsNavBar extends StatelessWidget {
  const SettingsNavBar({
    super.key,
    required this.title,
    this.onBack,
    this.height = BubbaSettingsMetrics.navHeight,
  });

  final String title;
  final VoidCallback? onBack;
  final double height;

  @override
  Widget build(BuildContext context) {
    final metrics = bubbaDesignTextMetrics(context, BubbaSettingsText.navTitle);
    final titleTop = BubbaSettingsMetrics.navTitleBaseline - metrics.baseline;
    final glyphHeight = d(BubbaSettingsMetrics.navBackHeight);
    final box = BubbaScale.tapBox(glyphHeight);
    final backTop = d(BubbaSettingsMetrics.navBackY) - (box - glyphHeight) / 2;
    final backLeft =
        d(BubbaSettingsMetrics.navBackX) - (box - d(BubbaSettingsMetrics.navBackWidth)) / 2;

    return SizedBox(
      height: d(height),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: math.max(0, backLeft), top: backTop),
              child: Semantics(
                button: true,
                label: 'Back',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack ?? () => Navigator.of(context).maybePop(),
                  child: SizedBox(
                    width: box,
                    height: box,
                    child: Center(
                      child: BubbaGlyphIcon(
                        BubbaSettingsGlyphs.navBack,
                        color: BubbaSettingsColors.navIcon,
                        width: BubbaSettingsMetrics.navBackWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: d(titleTop)),
              child: Semantics(
                header: true,
                child: Text(title, style: BubbaSettingsText.navTitle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({super.key, required this.text, required this.x});

  final String text;
  final double x;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: hd(x)),
        child: Semantics(
          header: true,
          child: Text(text, style: BubbaSettingsText.sectionHeader),
        ),
      );
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key, required this.x, required this.width});

  final double x;
  final double width;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(x)),
          SizedBox(
            width: hd(width),
            height: d(BubbaSettingsMetrics.dividerWeight),
            child: const BubbaHairline(color: BubbaSettingsColors.divider),
          ),
        ],
      );
}

class SettingsToggle extends StatelessWidget {
  const SettingsToggle({super.key, required this.value, this.onChanged, this.label});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final w = d(BubbaSettingsMetrics.toggleWidth);
    final h = d(BubbaSettingsMetrics.toggleHeight);
    final knobW = d(BubbaSettingsMetrics.toggleKnobWidth);
    final knobH = d(BubbaSettingsMetrics.toggleKnobHeight);
    final inset = value
        ? d(BubbaSettingsMetrics.toggleKnobInsetOn)
        : d(BubbaSettingsMetrics.toggleKnobInsetOff);

    final painted = Container(
      width: w,
      height: h,
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: inset),
      decoration: BoxDecoration(
        color: value
            ? BubbaSettingsColors.toggleTrackOn
            : BubbaSettingsColors.toggleTrackOff,
        borderRadius: BorderRadius.circular(h / 2),
      ),
      child: Container(
        width: knobW,
        height: knobH,
        decoration: BoxDecoration(
          color: BubbaSettingsColors.toggleKnob,
          borderRadius: BorderRadius.circular(knobH / 2),
        ),
      ),
    );

    return Semantics(
      toggled: value,
      label: label,
      child: painted,
    );
  }
}

class SettingsRowSpec {
  const SettingsRowSpec({
    this.glyph,
    this.iconX,
    this.iconY,
    this.iconWidth,
    this.iconHeight,
    this.iconColor = BubbaSettingsColors.rowIcon,
    required this.label,
    required this.labelX,
    required this.labelBaseline,
    this.labelStyle,
    this.subtitle,
    this.subtitleBaseline,
    this.trailingY,
    this.trailingRightGap = 35.15,
    this.dividerY,
    this.dividerX,
    this.dividerWidth,
  });

  final BubbaGlyph? glyph;
  final double? iconX;
  final double? iconY;
  final double? iconWidth;
  final double? iconHeight;
  final Color iconColor;
  final String label;
  final double labelX;
  final double labelBaseline;
  final TextStyle? labelStyle;
  final String? subtitle;
  final double? subtitleBaseline;
  final double? trailingY;
  final double? dividerY;
  final double? dividerX;
  final double? dividerWidth;
  final double trailingRightGap;
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.spec,
    required this.top,
    required this.height,
    this.onTap,
    this.trailing,
  });

  final SettingsRowSpec spec;
  final double top;
  final double height;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final labelStyle = spec.labelStyle ?? BubbaSettingsText.rowLabel;
    final labelMetrics = bubbaDesignTextMetrics(context, labelStyle);
    final labelTop = spec.labelBaseline - labelMetrics.baseline;

    final texts = <Widget>[
      SizedBox(height: d(labelTop - top)),
      Text(spec.label, style: labelStyle),
    ];
    if (spec.subtitle != null && spec.subtitleBaseline != null) {
      final subMetrics =
          bubbaDesignTextMetrics(context, BubbaSettingsText.rowSubtitle);
      final subTop = spec.subtitleBaseline! - subMetrics.baseline;
      texts
        ..add(SizedBox(
          height: d(subTop - (labelTop + labelMetrics.lineHeight)),
        ))
        ..add(Text(spec.subtitle!, style: BubbaSettingsText.rowSubtitle));
    }

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (spec.glyph != null) ...[
          SizedBox(width: hd(spec.iconX!)),
          Padding(
            padding: EdgeInsets.only(top: d(spec.iconY! - top)),
            child: BubbaGlyphIcon(
              spec.glyph!,
              color: spec.iconColor,
              width: spec.iconWidth,
              height: spec.iconHeight,
            ),
          ),
          SizedBox(width: hd(spec.labelX - spec.iconX! - spec.iconWidth!)),
        ] else
          SizedBox(width: hd(spec.labelX)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: texts,
          ),
        ),
        if (trailing != null && spec.trailingY != null) ...[
          Padding(
            padding: EdgeInsets.only(top: d(spec.trailingY! - top)),
            child: trailing,
          ),
          SizedBox(width: hd(spec.trailingRightGap)),
        ],
      ],
    );

    final hasDivider = spec.dividerY != null &&
        spec.dividerX != null &&
        spec.dividerWidth != null;
    final dividerTop = hasDivider
        ? spec.dividerY! - BubbaSettingsMetrics.dividerWeight / 2
        : null;

    final row = SizedBox(
      height: d(height),
      child: hasDivider
          ? Column(
              children: [
                SizedBox(height: d(dividerTop! - top), child: content),
                SettingsDivider(
                  x: spec.dividerX!,
                  width: spec.dividerWidth!,
                ),
              ],
            )
          : content,
    );

    if (onTap == null) return row;
    return Semantics(
      button: true,
      label: spec.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: row,
      ),
    );
  }
}

class SettingsChevron extends StatelessWidget {
  const SettingsChevron({
    super.key,
    this.color = BubbaSettingsColors.navIcon,
    this.glyph,
    this.width,
    this.height,
  });

  final Color color;
  final BubbaGlyph? glyph;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
        glyph ?? BubbaSettingsGlyphs.rowChevron,
        color: color,
        width: width ?? BubbaSettingsMetrics.chevronWidth,
        height: height ?? BubbaSettingsMetrics.chevronHeight,
      );
}

void settingsHeader(
  BuildContext context,
  BubbaFlow flow,
  String text,
  double x,
  double baseline,
) {
  final metrics =
      bubbaDesignTextMetrics(context, BubbaSettingsText.sectionHeader);
  flow.block(
    SettingsSectionHeader(text: text, x: x),
    top: baseline - metrics.baseline,
    height: metrics.lineHeight,
  );
}

void settingsRow(
  BuildContext context,
  BubbaFlow flow,
  SettingsRowSpec spec, {
  required double bandEnd,
  VoidCallback? onTap,
  Widget? trailing,
}) {
  final labelTop = spec.labelBaseline - 16;
  final top = spec.iconY == null ? labelTop : math.min(spec.iconY!, labelTop);
  final height = bandEnd - top;
  flow.block(
    SettingsRow(
      spec: spec,
      top: top,
      height: height,
      onTap: onTap,
      trailing: trailing,
    ),
    top: top,
    height: height,
  );
}

class SettingsPageSubtitle extends StatelessWidget {
  const SettingsPageSubtitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: TextAlign.center,
        style: BubbaSettingsText.pageSubtitle,
      );
}

void settingsSubtitle(
  BuildContext context,
  BubbaFlow flow,
  String text,
  double firstBaseline, {
  int lines = 1,
}) {
  final metrics = bubbaDesignTextMetrics(context, BubbaSettingsText.pageSubtitle);
  flow.block(
    SettingsPageSubtitle(text: text),
    top: firstBaseline - metrics.baseline,
    height: metrics.lineHeight * lines,
    align: Alignment.center,
  );
}
