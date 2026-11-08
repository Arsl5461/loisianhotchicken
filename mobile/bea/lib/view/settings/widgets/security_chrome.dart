import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_security_tokens.dart';
import '../../../core/design/widgets/bubba_loading.dart';
import '../../../core/design/bubba_settings_glyphs.dart';
import '../../../core/design/bubba_settings_tokens.dart';
import 'settings_chrome.dart';

class SecurityHeroCircle extends StatelessWidget {
  const SecurityHeroCircle({
    super.key,
    required this.glyph,
    this.fill = BubbaSecurityColors.heroNeutral,
    this.glyphColor = BubbaSecurityColors.icon,
    required this.glyphX,
    required this.glyphY,
    required this.glyphWidth,
    required this.glyphHeight,
  });

  final BubbaGlyph glyph;
  final Color fill;
  final Color glyphColor;
  final double glyphX;
  final double glyphY;
  final double glyphWidth;
  final double glyphHeight;

  static const double designHeight = BubbaSecurityMetrics.heroSize;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(BubbaSecurityMetrics.heroX)),
          SizedBox(
            width: d(BubbaSecurityMetrics.heroSize),
            height: d(BubbaSecurityMetrics.heroSize),
            child: DecoratedBox(
              decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: d(glyphY - BubbaSecurityMetrics.heroY)),
                  Row(
                    children: [
                      SizedBox(width: hd(glyphX - BubbaSecurityMetrics.heroX)),
                      BubbaGlyphIcon(
                        glyph,
                        color: glyphColor,
                        width: glyphWidth,
                        height: glyphHeight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

/// The 12pt centred lead paragraph. [lines] are authored, never wrapped - the
/// design's own breaks are literal.
class SecurityLead extends StatelessWidget {
  const SecurityLead({super.key, required this.lines});

  final List<String> lines;

  /// A one-line lead carries no pitch: a `height` multiplier distributes its
  /// extra leading above the first baseline as well as below it.
  static TextStyle styleFor(int lines) => lines > 1
      ? BubbaSecurityText.lead
          .copyWith(height: BubbaSecurityMetrics.leadPitch / 12)
      : BubbaSecurityText.lead;

  @override
  Widget build(BuildContext context) => Text(
        lines.join('\n'),
        textAlign: TextAlign.center,
        style: styleFor(lines.length),
      );
}

void securityLead(
  BuildContext context,
  BubbaFlow flow,
  List<String> lines, {
  required double firstBaseline,
}) {
  final m = bubbaDesignTextMetrics(context, SecurityLead.styleFor(lines.length));
  flow.block(
    SecurityLead(lines: lines),
    top: firstBaseline - m.baseline,
    height: BubbaSecurityMetrics.leadPitch * lines.length,
    align: Alignment.center,
  );
}

void securityHeading(
  BuildContext context,
  BubbaFlow flow,
  String text, {
  double baseline = BubbaSecurityMetrics.detailHeadingBaseline,
}) {
  final m = bubbaDesignTextMetrics(context, BubbaSecurityText.heading);
  flow.block(
    Text(text, textAlign: TextAlign.center, style: BubbaSecurityText.heading),
    top: baseline - m.baseline,
    height: m.lineHeight,
    align: Alignment.center,
  );
}

/// The part 5 card: 338 wide at x 22.34, r 11.16, `#FCFBFB` under a 1pt
/// `#EEEDEC` border. Never give it a fixed height around growable content -
/// pass [minHeight] and let the column size it.
class SecurityCard extends StatelessWidget {
  const SecurityCard({
    super.key,
    required this.child,
    required this.minHeight,
    this.fill = BubbaSecurityColors.cardBg,
    this.border = BubbaSecurityColors.cardBorder,
    this.x = BubbaSecurityMetrics.cardX,
    this.width = BubbaSecurityMetrics.cardWidth,
    this.radius = BubbaSecurityMetrics.cardRadius,
  });

  final Widget child;
  final double minHeight;
  final Color fill;
  final Color? border;
  final double x;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(x)),
          Container(
            width: hd(width),
            constraints: BoxConstraints(minHeight: d(minHeight)),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(d(radius)),
            ),
            foregroundDecoration: border == null
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(d(radius)),
                    border: Border.all(
                      color: border!,
                      width: BubbaSecurityMetrics.cardBorderWidth,
                    ),
                  ),
            child: child,
          ),
        ],
      );
}

/// A full-width 1pt rule inside a [SecurityCard]. The stroke is centred on its
/// design y, the same correction part 3's `SettingsDivider` makes (P3-1).
class SecurityCardRule extends StatelessWidget {
  const SecurityCardRule({
    super.key,
    this.inset = 0,
    this.cardWidth = BubbaSecurityMetrics.cardWidth,
  });

  final double inset;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final width = cardWidth - inset * 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hd(inset)),
      child: SizedBox(
        width: hd(width),
        height: d(BubbaSecurityMetrics.ruleWeight),
        child: BubbaHairline(
          color: BubbaSecurityColors.cardRule,
          width: hd(width),
          height: d(BubbaSecurityMetrics.ruleWeight),
        ),
      ),
    );
  }
}

class SecurityRowSpec {
  const SecurityRowSpec({
    this.glyph,
    this.iconX,
    this.iconY,
    this.iconWidth,
    this.iconHeight,
    this.iconColor = BubbaSecurityColors.icon,
    required this.title,
    required this.titleX,
    required this.titleBaseline,
    this.titleColor,
    this.subtitle,
    this.subtitleBaseline,
    this.subtitlePitch = BubbaSecurityMetrics.subtitlePitch,
    this.subtitleColor,
    this.subtitleStyle,
    this.trailing,
    this.trailingRightGap,
    this.trailingY,
  });

  final BubbaGlyph? glyph;
  final double? iconX;
  final double? iconY;
  final double? iconWidth;
  final double? iconHeight;
  final Color iconColor;
  final String title;
  final double titleX;
  final double titleBaseline;
  final Color? titleColor;
  final List<String>? subtitle;
  final double? subtitleBaseline;
  final double subtitlePitch;
  final Color? subtitleColor;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final double? trailingRightGap;
  final double? trailingY;
}

/// One row of a card: an optional leading glyph, a bold title with an optional
/// multi-line subtitle, and an optional trailing control. Everything is laid
/// out as Rows and Columns off the row's own [top]; nothing overlaps, so
/// nothing is positioned.
class SecurityCardRow extends StatelessWidget {
  const SecurityCardRow({
    super.key,
    required this.spec,
    required this.top,
    required this.height,
    this.cardX = BubbaSecurityMetrics.cardX,
    this.onTap,
    this.semanticsValue,
  });

  final SecurityRowSpec spec;
  final double top;
  final double height;
  final double cardX;
  final VoidCallback? onTap;
  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    final titleStyle = spec.titleColor == null
        ? BubbaSecurityText.rowTitle
        : BubbaSecurityText.rowTitle.copyWith(color: spec.titleColor);
    final titleMetrics = bubbaDesignTextMetrics(context, titleStyle);
    final titleTop = spec.titleBaseline - titleMetrics.baseline;

    final texts = <Widget>[
      SizedBox(height: d(math.max(0, titleTop - top))),
      Text(spec.title, style: titleStyle),
    ];
    if (spec.subtitle != null && spec.subtitleBaseline != null) {
      var base = spec.subtitleStyle ?? BubbaSecurityText.rowSubtitle;
      if (spec.subtitle!.length > 1) {
        base = base.copyWith(height: spec.subtitlePitch / 12);
      }
      final subStyle =
          spec.subtitleColor == null ? base : base.copyWith(color: spec.subtitleColor);
      final subMetrics = bubbaDesignTextMetrics(context, subStyle);
      final subTop = spec.subtitleBaseline! - subMetrics.baseline;
      texts
        ..add(SizedBox(
          height: d(math.max(0, subTop - (titleTop + titleMetrics.lineHeight))),
        ))
        ..add(Text(spec.subtitle!.join('\n'), style: subStyle));
    }

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (spec.glyph != null) ...[
          SizedBox(width: hd(math.max(0, spec.iconX! - cardX))),
          Column(
            children: [
              SizedBox(height: d(math.max(0, spec.iconY! - top))),
              BubbaGlyphIcon(
                spec.glyph!,
                color: spec.iconColor,
                width: spec.iconWidth,
                height: spec.iconHeight,
              ),
            ],
          ),
          SizedBox(
            width: hd(
              math.max(0, spec.titleX - spec.iconX! - spec.iconWidth!),
            ),
          ),
        ] else
          SizedBox(width: hd(math.max(0, spec.titleX - cardX))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: texts,
          ),
        ),
        if (spec.trailing != null && spec.trailingY != null) ...[
          Column(
            children: [
              SizedBox(height: d(math.max(0, spec.trailingY! - top))),
              spec.trailing!,
            ],
          ),
          SizedBox(width: hd(spec.trailingRightGap ?? 0)),
        ],
      ],
    );

    final sized = ConstrainedBox(
      constraints: BoxConstraints(minHeight: d(height)),
      child: row,
    );

    if (onTap == null) return sized;
    return Semantics(
      button: true,
      label: spec.title,
      value: semanticsValue,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: sized,
      ),
    );
  }
}

class SecurityChevron extends StatelessWidget {
  const SecurityChevron({super.key, this.color = BubbaSecurityColors.chevron});

  final Color color;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
        BubbaSettingsGlyphs.rowChevron,
        color: color,
        width: BubbaSecurityMetrics.rowChevronWidth,
        height: BubbaSecurityMetrics.rowChevronHeight,
      );
}

/// A card holding exactly one navigable row. This is part 5's most repeated
/// shape - the hub's four rows, `Change phone number`, `Change email`,
/// `Remove email`, `Disconnect Apple`.
class SecurityNavCard extends StatelessWidget {
  const SecurityNavCard({
    super.key,
    required this.spec,
    required this.top,
    required this.height,
    this.cardX = BubbaSecurityMetrics.cardX,
    this.onTap,
  });

  final SecurityRowSpec spec;
  final double top;
  final double height;

  /// The x the artboard draws this card at. Every 338-wide card is *rendered*
  /// at the normalised [BubbaSecurityMetrics.cardX], so the interior offsets,
  /// which are absolute design coordinates, are measured from the drawn x and
  /// travel with the card.
  final double cardX;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SecurityCard(
        minHeight: height,
        child: SecurityCardRow(
          spec: spec,
          top: top,
          height: height,
          cardX: cardX,
          onTap: onTap,
        ),
      );
}

class SecurityValuePair {
  const SecurityValuePair({
    required this.label,
    required this.labelBaseline,
    required this.value,
    required this.valueBaseline,
    required this.x,
    this.labelStyle,
    this.valueStyle,
    this.badge,
    this.badgeBaseline,
    this.badgeRightGap,
    this.meta,
    this.metaBaseline,
    this.metaStyle,
    this.valuePrefix,
    this.valueX,
  });

  final String label;
  final double labelBaseline;
  final String value;
  final double valueBaseline;
  final double x;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final String? badge;
  final double? badgeBaseline;
  final double? badgeRightGap;
  final String? meta;
  final double? metaBaseline;
  final TextStyle? metaStyle;

  /// p011, p019 and p022 draw the dialling `+` at [x] and start the number at
  /// [valueX], about 11pt further right than a space would give.
  final String? valuePrefix;
  final double? valueX;
}

double _prefixWidth(BuildContext context, String text, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: bubbaEffectiveStyle(context, style)),
    textDirection: TextDirection.ltr,
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  return painter.width;
}

/// A card holding one or more small-label / bold-value pairs, optionally with a
/// rule between them and a `Verified` badge on the right. p011, p019, p022,
/// p023, p026, p027 and p029 are all this shape.
class SecurityValueCard extends StatelessWidget {
  const SecurityValueCard({
    super.key,
    required this.pairs,
    required this.top,
    required this.height,
    required this.cardX,
    this.ruleBaselines = const [],
    this.ruleInset = 0,
  });

  final List<SecurityValuePair> pairs;
  final double top;
  final double height;
  final double cardX;
  final List<double> ruleBaselines;
  final double ruleInset;

  @override
  Widget build(BuildContext context) {
    // Each pair is one entry, not three. Its `Verified` badge overlaps the
    // value's own band vertically while sitting beside it horizontally, so the
    // two ride in one Row off a shared top - a Column cannot express two bands
    // that overlap.
    final entries = <(double, Widget, double)>[];

    for (final pair in pairs) {
      final labelStyle = pair.labelStyle ?? BubbaSecurityText.fieldLabel;
      final valueStyle = pair.valueStyle ?? BubbaSecurityText.fieldValue;
      final lm = bubbaDesignTextMetrics(context, labelStyle);
      final vm = bubbaDesignTextMetrics(context, valueStyle);
      final labelTop = pair.labelBaseline - lm.baseline;
      final valueTop = pair.valueBaseline - vm.baseline;
      final valueLines = '\n'.allMatches(pair.value).length + 1;

      var pairTop = labelTop;
      var pairBottom = valueTop + vm.lineHeight * valueLines;

      final left = <Widget>[
        Text(pair.label, style: labelStyle),
        SizedBox(height: dGap(valueTop - labelTop - lm.lineHeight)),
        Row(
          children: [
            if (pair.valuePrefix != null) ...[
              Text(pair.valuePrefix!, style: valueStyle),
              SizedBox(
                width: hd(math.max(0, (pair.valueX ?? pair.x) - pair.x)) -
                    _prefixWidth(context, pair.valuePrefix!, valueStyle),
              ),
            ],
            Text(pair.value, style: valueStyle),
          ],
        ),
      ];

      if (pair.meta != null && pair.metaBaseline != null) {
        final metaStyle = pair.metaStyle ?? BubbaSecurityText.appleMeta;
        final mm = bubbaDesignTextMetrics(context, metaStyle);
        final metaTop = pair.metaBaseline! - mm.baseline;
        left
          ..add(SizedBox(height: dGap(metaTop - pairBottom)))
          ..add(Text(pair.meta!, style: metaStyle));
        pairBottom = math.max(pairBottom, metaTop + mm.lineHeight);
      }

      final row = <Widget>[
        SizedBox(width: hd(math.max(0, pair.x - cardX))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: left),
      ];

      if (pair.badge != null && pair.badgeBaseline != null) {
        final bm = bubbaDesignTextMetrics(context, BubbaSecurityText.verified);
        final badgeTop = pair.badgeBaseline! - bm.baseline;
        pairTop = math.min(pairTop, badgeTop);
        pairBottom = math.max(pairBottom, badgeTop + bm.lineHeight);
        row.addAll([
          const Spacer(),
          Column(
            children: [
              SizedBox(height: dGap(badgeTop - pairTop)),
              Text(pair.badge!, style: BubbaSecurityText.verified),
            ],
          ),
          SizedBox(width: hd(pair.badgeRightGap ?? 0)),
        ]);
      }

      if (pairTop < labelTop) {
        left.insert(0, SizedBox(height: dGap(labelTop - pairTop)));
      }

      entries.add((
        pairTop,
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: row),
        pairBottom - pairTop,
      ));
    }

    for (final y in ruleBaselines) {
      entries.add((
        y - BubbaSecurityMetrics.ruleWeight / 2,
        SecurityCardRule(inset: ruleInset),
        BubbaSecurityMetrics.ruleWeight,
      ));
    }

    entries.sort((a, b) => a.$1.compareTo(b.$1));

    final children = <Widget>[];
    var cursor = top;
    for (final (y, widget, advance) in entries) {
      children
        ..add(SizedBox(height: dGap(y - cursor)))
        ..add(widget);
      cursor = math.max(cursor, y) + advance;
    }

    return SecurityCard(
      minHeight: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class SecurityRadio extends StatelessWidget {
  const SecurityRadio({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final size = d(BubbaSecurityMetrics.radioSize);
    final dot = d(BubbaSecurityMetrics.radioDotSize);
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? BubbaSecurityColors.radioOn : null,
          border: selected
              ? null
              : Border.all(
                  color: BubbaSecurityColors.radioIdle,
                  width: BubbaSecurityMetrics.radioBorderWidth,
                ),
        ),
        child: selected
            ? Center(
                child: SizedBox(
                  width: dot,
                  height: dot,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: BubbaSecurityColors.radioDot,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class SecurityCtaButton extends StatelessWidget {
  const SecurityCtaButton({
    super.key,
    required this.label,
    required this.y,
    required this.labelBaseline,
    this.fill = BubbaSecurityColors.ctaFill,
    this.leading,
    this.leadingY,
    this.leadingGap = 0,
    this.enabled = true,
    this.busy = false,
    this.onTap,
  });

  final String label;
  final double y;
  final double labelBaseline;
  final Color fill;
  final Widget? leading;
  final double? leadingY;
  final double leadingGap;
  final bool enabled;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final m = bubbaDesignTextMetrics(context, BubbaSecurityText.ctaLabel);
    final labelTop = labelBaseline - y - m.baseline;
    return Row(
      children: [
        SizedBox(width: hd(BubbaSecurityMetrics.ctaX)),
        Semantics(
          button: true,
          enabled: enabled && onTap != null,
          label: label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled && !busy ? onTap : null,
            child: Container(
              width: hd(BubbaSecurityMetrics.ctaWidth),
              height: d(BubbaSecurityMetrics.ctaHeight),
              decoration: BoxDecoration(
                color: fill,
                borderRadius:
                    BorderRadius.circular(d(BubbaSecurityMetrics.ctaRadius)),
              ),
              alignment: busy ? Alignment.center : null,
              child: busy
                  ? const BubbaSpinner(size: 22, color: Colors.white)
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[
                    Column(
                      children: [
                        SizedBox(height: dGap((leadingY ?? y) - y)),
                        leading!,
                      ],
                    ),
                    SizedBox(width: hd(leadingGap)),
                  ],
                  Column(
                    children: [
                      SizedBox(height: dGap(labelTop)),
                      Text(label, style: BubbaSecurityText.ctaLabel),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SecuritySecondaryLink extends StatelessWidget {
  const SecuritySecondaryLink({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: BubbaScale.tapBox(
              d(bubbaDesignTextMetrics(
                context,
                BubbaSecurityText.secondaryLabel,
              ).lineHeight),
            ),
            child: Center(
              child: Text(label, style: BubbaSecurityText.secondaryLabel),
            ),
          ),
        ),
      );
}

void securitySecondaryLink(
  BuildContext context,
  BubbaFlow flow,
  String label, {
  required double baseline,
  VoidCallback? onTap,
}) {
  final m = bubbaDesignTextMetrics(context, BubbaSecurityText.secondaryLabel);
  final box = BubbaScale.tapBox(d(m.lineHeight)) / BubbaScale.factor;
  flow.block(
    SecuritySecondaryLink(label: label, onTap: onTap),
    top: baseline - m.baseline - (box - m.lineHeight) / 2,
    height: box,
    align: Alignment.center,
  );
}

/// The bordered white input. Uses part 3's P3-5 idiom: no `InputDecorator` at
/// all, and the placeholder is a sibling `Text` shown while the value is empty,
/// because a Material decoration puts its text 2.5pt below where you place it.
class SecurityInputField extends StatelessWidget {
  const SecurityInputField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.y,
    required this.textBaseline,
    this.x = 27.43,
    this.width = BubbaSecurityMetrics.inputWidth,
    this.textX = 39.35,
    this.focusNode,
    this.keyboardType,
    this.onSubmitted,
    this.semanticsLabel,
  });

  final TextEditingController controller;
  final String placeholder;
  final double y;
  final double textBaseline;
  final double x;
  final double width;
  final double textX;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final m = bubbaDesignTextMetrics(context, BubbaSecurityText.inputValue);
    final textTop = textBaseline - y - m.baseline;
    return Row(
      children: [
        SizedBox(width: hd(x)),
        Container(
          width: hd(width),
          height: d(BubbaSecurityMetrics.inputHeight),
          decoration: BoxDecoration(
            color: BubbaSecurityColors.inputBg,
            borderRadius:
                BorderRadius.circular(d(BubbaSecurityMetrics.inputRadius)),
            border: Border.all(
              color: BubbaSecurityColors.inputBorder,
              width: BubbaSecurityMetrics.cardBorderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: dGap(textTop)),
              Row(
                children: [
                  SizedBox(width: hd(textX - x)),
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller,
                      builder: (context, value, _) => Stack(
                        children: [
                          if (value.text.isEmpty)
                            Text(
                              placeholder,
                              style: BubbaSecurityText.inputPlaceholder,
                            ),
                          SizedBox(
                            height: d(m.lineHeight),
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              keyboardType: keyboardType,
                              onSubmitted: onSubmitted,
                              decoration: null,
                              style: BubbaSecurityText.inputValue,
                              cursorColor: BubbaSecurityColors.rowTitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: hd(12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The blocked user's photo, clipped to the artboard's own circle. The clip
/// path in the trace is the true rect, not the larger placed-image box.
class SecurityAvatar extends StatelessWidget {
  const SecurityAvatar({
    super.key,
    required this.x,
    required this.size,
    this.image = 'assets/bubba/security/blocked_user_avatar.png',
    this.photoUrl,
    this.semanticsLabel,
  });

  final double x;
  final double size;
  final String image;
  final String? photoUrl;
  final String? semanticsLabel;

  Widget _placeholder() => Image.asset(
        image,
        width: d(size),
        height: d(size),
        fit: BoxFit.cover,
        semanticLabel: semanticsLabel,
      );

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return Row(
      children: [
        SizedBox(width: hd(x)),
        ClipOval(
          child: url == null || url.isEmpty
              ? _placeholder()
              : Image.network(
                  url,
                  width: d(size),
                  height: d(size),
                  fit: BoxFit.cover,
                  semanticLabel: semanticsLabel,
                  errorBuilder: (context, error, stack) => _placeholder(),
                  frameBuilder: (context, child, frame, wasSynchronous) =>
                      frame == null && !wasSynchronous ? _placeholder() : child,
                ),
        ),
      ],
    );
  }
}

/// The page every part 5 screen is built on: the part 3 nav bar over a
/// `BubbaPage` whose footer band is the artboard's own home-indicator
/// allowance, so a bottom-anchored CTA lands where the design puts it.
class SecurityScaffold extends StatelessWidget {
  const SecurityScaffold({
    super.key,
    this.navTitle,
    this.onBack,
    this.showNav = true,
    required this.content,
    this.footerBand = BubbaSecurityMetrics.canvasHeight - 798.15,
    this.resizeToAvoidBottomInset = true,
  });

  final String? navTitle;
  final VoidCallback? onBack;
  final bool showNav;
  final BubbaContentBuilder content;
  final double footerBand;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSecurityColors.pageBg,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: BubbaPage(
          padContent: false,
          background: BubbaSecurityColors.pageBg,
          footerBand: footerBand,
          content: (context, flow) {
            if (showNav) {
              flow.block(
                SettingsNavBar(title: navTitle ?? '', onBack: onBack),
                top: 0,
                height: BubbaSettingsMetrics.navHeight,
              );
            }
            content(context, flow);
          },
        ),
      );
}
