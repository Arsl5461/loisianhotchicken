import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'bubba_scale.dart';
import 'bubba_tokens.dart';

export 'bubba_scale.dart'
    show
        d,
        hd,
        dGap,
        hdGap,
        bubbaUsableHeight,
        bubbaFooterInset,
        dsp,
        dx,
        dxRight,
        dxSpan,
        BubbaScale,
        bubbaBottomInset,
        bubbaTopShift;

class BubbaTextMetrics {
  const BubbaTextMetrics(this.baseline, this.lineHeight);

  final double baseline;
  final double lineHeight;

  double get descent => lineHeight - baseline;
}

final Map<String, BubbaTextMetrics> _metricsCache = {};

TextStyle bubbaEffectiveStyle(BuildContext context, TextStyle style) =>
    DefaultTextStyle.of(context).style.merge(style);

BubbaTextMetrics bubbaTextMetrics(BuildContext context, TextStyle style) {
  final effective = bubbaEffectiveStyle(context, style);
  final key = '${effective.fontFamily}|${effective.fontSize}'
      '|${effective.fontWeight}|${effective.height}|${effective.letterSpacing}'
      '|${effective.leadingDistribution}|${effective.textBaseline}'
      '|${effective.fontFamilyFallback}';
  return _metricsCache.putIfAbsent(key, () {
    final painter = TextPainter(
      text: TextSpan(text: 'Hxg', style: effective),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return BubbaTextMetrics(
      painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
      painter.height,
    );
  });
}

BubbaTextMetrics bubbaDesignTextMetrics(BuildContext context, TextStyle style) {
  final m = bubbaTextMetrics(context, style);
  final f = BubbaScale.factor;
  if (f <= 0) return m;
  return BubbaTextMetrics(m.baseline / f, m.lineHeight / f);
}

class BubbaFlow {
  BubbaFlow(this.context, {double startY = 0, this.padded = true})
      : _cursor = startY;

  final BuildContext context;

  final bool padded;

  bool reserveBlocks = false;

  final List<Widget> _out = [];
  double _cursor;

  double get cursor => _cursor;

  List<Widget> get children => List.unmodifiable(_out);

  Widget _inset(
    Widget child, {
    double? left,
    double? right,
    Alignment align = Alignment.centerLeft,
  }) {
    if (child is Expanded || child is BubbaBleedRow) return child;
    if (!padded && left == null && right == null) return child;
    return BubbaInset(
      left: left ?? (padded ? BubbaMetrics.pagePadding : null),
      right: right ?? (padded ? BubbaMetrics.pageInsetRight : null),
      align: align,
      child: child,
    );
  }

  void skipTo(double designY) {
    if (designY <= _cursor) return;
    _out.add(BubbaGap(designY - _cursor));
    _cursor = designY;
  }

  void gap(double design) {
    if (design <= 0) return;
    _out.add(BubbaGap(design));
    _cursor += design;
  }

  void copy(
    String text, {
    required double baseline,
    required TextStyle style,
    TextAlign? align,
    int lines = 1,
    double? left,
    double? right,
    bool header = false,
    bool liveRegion = false,
    InlineSpan? span,
    int? maxLines,
  }) {
    final m = bubbaDesignTextMetrics(context, style);
    _out.add(
      _inset(
        BubbaCopy(
          text,
          gapAbove: baseline - _cursor,
          style: style,
          textAlign: align,
          semanticsHeader: header,
          semanticsLiveRegion: liveRegion,
          span: span,
          maxLines: maxLines,
        ),
        left: left,
        right: right,
      ),
    );
    _cursor = baseline + m.descent + (lines - 1) * m.lineHeight;
  }

  void link(
    String text, {
    required double baseline,
    required TextStyle style,
    VoidCallback? onTap,
    Alignment align = Alignment.center,
    String? semanticsLabel,
  }) {
    final m = bubbaDesignTextMetrics(context, style);
    assert(
      baseline >= _cursor,
      'link "$text" wants baseline $baseline but the flow is already at '
      '$_cursor: a negative gap collapses the tap box and the link goes dead',
    );
    _out.add(
      _inset(
        BubbaLink(
          text,
          gapAbove: baseline - _cursor,
          style: style,
          onTap: onTap,
          align: align,
          semanticsLabel: semanticsLabel,
        ),
      ),
    );
    _cursor = baseline + m.descent;
  }

  void block(
    Widget child, {
    required double top,
    required double height,
    double? left,
    double? right,
    Alignment align = Alignment.centerLeft,
    bool reserve = false,
  }) {
    skipTo(top);
    final laid = _inset(child, left: left, right: right, align: align);
    _out.add(
      (reserve || reserveBlocks) && height > 0
          ? ConstrainedBox(
              constraints: BoxConstraints(minHeight: d(height)),
              child: laid,
            )
          : laid,
    );
    _cursor = top + height;
  }

  void bleed(Widget child, {required double top, required double height}) {
    skipTo(top);
    _out.add(BubbaBleedRow(child: child));
    _cursor = top + height;
  }

  void raw(Widget child, {double advance = 0, double? left, double? right}) {
    _out.add(_inset(child, left: left, right: right));
    _cursor += advance;
  }
}

class BubbaGap extends StatelessWidget {
  const BubbaGap(this.design, {super.key});

  final double design;

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: design <= 0 ? 0 : d(design));
}

class BubbaBleedRow extends StatelessWidget {
  const BubbaBleedRow({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class BubbaInset extends StatelessWidget {
  const BubbaInset({
    super.key,
    required this.child,
    this.left,
    this.right,
    this.align = Alignment.centerLeft,
  });

  final double? left;
  final double? right;
  final Alignment align;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final leftPad = left == null ? 0.0 : math.max(0.0, dx(left!));
    final rightPad = right == null
        ? 0.0
        : math.max(0.0, BubbaScale.availableWidth - dxRight(right!));
    return Padding(
      padding: EdgeInsets.only(left: leftPad, right: rightPad),
      child: Align(alignment: align, heightFactor: 1, child: child),
    );
  }
}

class BubbaCopy extends StatelessWidget {
  const BubbaCopy(
    this.text, {
    super.key,
    required this.gapAbove,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.semanticsHeader = false,
    this.semanticsLiveRegion = false,
    this.span,
    this.measure,
  });

  final String text;
  final double gapAbove;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? measure;
  final bool semanticsHeader;
  final bool semanticsLiveRegion;
  final InlineSpan? span;

  @override
  Widget build(BuildContext context) {
    Widget child = span == null
        ? Text(text, style: style, textAlign: textAlign, maxLines: maxLines)
        : Text.rich(
            span!,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
          );
    if (semanticsLiveRegion) {
      child = Semantics(liveRegion: true, child: child);
    }
    if (semanticsHeader) {
      child = Semantics(header: true, label: text, child: child);
    }
    return Baseline(
      baseline: d(gapAbove),
      baselineType: TextBaseline.alphabetic,
      child: SizedBox(
        width: measure == null ? double.infinity : d(measure!),
        child: child,
      ),
    );
  }
}

class BubbaMeasure extends StatelessWidget {
  const BubbaMeasure({
    super.key,
    required this.child,
    this.measure = BubbaMetrics.copyMeasure,
  });

  final Widget child;
  final double measure;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: d(measure)),
          child: child,
        ),
      );
}

class BubbaLink extends StatelessWidget {
  const BubbaLink(
    this.text, {
    super.key,
    required this.gapAbove,
    required this.style,
    this.onTap,
    this.align = Alignment.center,
    this.semanticsLabel,
  });

  final String text;
  final double gapAbove;
  final TextStyle style;
  final VoidCallback? onTap;
  final Alignment align;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final m = bubbaTextMetrics(context, style);
    final box = math.max(m.lineHeight, BubbaMetrics.minTapTarget);
    return Baseline(
      baseline: d(gapAbove),
      baselineType: TextBaseline.alphabetic,
      child: Align(
        alignment: align,
        heightFactor: 1,
        child: SizedBox(
          height: m.lineHeight,
          child: OverflowBox(
            alignment: align,
            minHeight: box,
            maxHeight: box,
            child: BubbaTapTarget(
              onTap: onTap,
              label: semanticsLabel ?? text,
              child: SizedBox(
                height: box,
                child: Center(widthFactor: 1, child: Text(text, style: style)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BubbaFooterLink extends StatelessWidget {
  const BubbaFooterLink(
    this.text, {
    super.key,
    required this.baseline,
    required this.ctaY,
    required this.style,
    this.onTap,
    this.semanticsLabel,
  });

  final String text;
  final double baseline;
  final double ctaY;
  final TextStyle style;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final m = bubbaTextMetrics(context, style);
    final gap = math.max(0.0, d(ctaY - baseline));
    final box = BubbaScale.tapBox(gap + m.lineHeight);
    final hit = math.max(box, BubbaMetrics.minTapTarget);
    return Align(
      heightFactor: 1,
      child: BubbaMinTapBox(
        painted: box,
        child: BubbaTapTarget(
          onTap: onTap,
          label: semanticsLabel ?? text,
          child: SizedBox(
            height: hit,
            child: Align(
              alignment: Alignment.topCenter,
              child: Baseline(
                baseline: hit - (hit - box) / 2 - gap,
                baselineType: TextBaseline.alphabetic,
                child: Text(text, style: style),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A one-device-pixel rule. A 0.5pt `Container` lands on a fractional device
/// pixel and antialiases to half strength, so the artboards' hairlines came out
/// visibly lighter than the design draws them; painting without antialiasing
/// snaps the line to a whole pixel at full colour.
class BubbaHairline extends StatelessWidget {
  const BubbaHairline({
    super.key,
    required this.color,
    this.width,
    this.height,
  });

  final Color color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final thin = 1 / MediaQuery.devicePixelRatioOf(context);
    return CustomPaint(
      size: Size(width ?? thin, height ?? thin),
      painter: _HairlinePainter(color),
    );
  }
}

class _HairlinePainter extends CustomPainter {
  const _HairlinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = color
        ..isAntiAlias = false,
    );
  }

  @override
  bool shouldRepaint(_HairlinePainter old) => old.color != color;
}

class BubbaTextDefaults extends StatelessWidget {
  const BubbaTextDefaults({super.key, required this.child});

  final Widget child;

  static TextStyle get style => TextStyle(
        fontFamily: BubbaFonts.body,
        fontSize: dsp(14, 17),
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: BubbaColors.textBody,
      );

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
        style: style,
        child: child,
      );
}

typedef BubbaContentBuilder = void Function(BuildContext context, BubbaFlow flow);

class BubbaChromeStack extends StatelessWidget {
  const BubbaChromeStack({super.key, required this.builder});

  final List<Widget> Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        BubbaScale.apply(constraints.maxWidth, constraints.maxHeight);
        return Builder(
          builder: (context) => BubbaCanvasBox(
            child: Stack(clipBehavior: Clip.none, children: builder(context)),
          ),
        );
      },
    );
  }
}

/// Marks an overlay that spans the whole window instead of the canvas.
///
/// Everything passed to [BubbaPage.overlay] is placed on the centred canvas by
/// default, because that is what `dx` measures against. A layer that genuinely
/// reaches the window edge - a sheet, a scrim - mixes this in to opt out.
mixin BubbaWindowOverlay on Widget {}

class BubbaOverlay extends StatelessWidget {
  const BubbaOverlay({
    super.key,
    required this.x,
    required this.y,
    required this.child,
    this.onTap,
    this.hitPadding = 0,
    this.label,
    this.right,
    this.width,
    this.topShift = false,
  });

  final double x;
  final double y;
  final Widget child;
  final VoidCallback? onTap;
  final double hitPadding;
  final String? label;
  final double? right;
  final double? width;

  /// An overlay is a Stack sibling of [BubbaPage]'s body, so it does not get
  /// the body's notch shift. Chrome placed at a design y - the back chevron -
  /// has to take it itself or it stays under the notch while the page moves.
  final bool topShift;

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (hitPadding > 0) {
      content = Padding(padding: EdgeInsets.all(d(hitPadding)), child: content);
    }
    if (onTap != null) {
      content = BubbaTapTarget(onTap: onTap, label: label, child: content);
    } else {
      content = IgnorePointer(child: content);
    }
    if (width != null) content = SizedBox(width: hd(width!), child: content);
    return Align(
      alignment: right == null ? Alignment.topLeft : Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          left: right != null ? 0 : math.max(0.0, dx(x) - d(hitPadding)),
          right: right == null
              ? 0
              : math.max(
                  0.0,
                  BubbaScale.availableWidth - dxRight(right!) - d(hitPadding),
                ),
          top: math.max(0.0, d(y) - d(hitPadding)) +
              (topShift ? bubbaTopShift(context) : 0),
        ),
        child: content,
      ),
    );
  }
}

class BubbaOverlayText extends StatelessWidget {
  const BubbaOverlayText(
    this.text, {
    super.key,
    required this.x,
    required this.baseline,
    required this.style,
    this.onTap,
    this.width,
    this.textAlign,
    this.label,
  });

  final String text;
  final double x;
  final double baseline;
  final TextStyle style;
  final VoidCallback? onTap;
  final double? width;
  final TextAlign? textAlign;
  final String? label;

  @override
  Widget build(BuildContext context) {
    Widget content = Text(text, style: style, textAlign: textAlign);
    if (width != null) {
      content = SizedBox(width: hd(width!), child: content);
    }
    if (onTap != null) {
      content = BubbaTapTarget(
        onTap: onTap,
        label: label ?? text,
        child: SizedBox(
          height: BubbaMetrics.minTapTarget,
          child: Center(widthFactor: width == null ? 1 : null, child: content),
        ),
      );
    } else {
      content = IgnorePointer(child: content);
    }
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: math.max(0.0, dx(x))),
        child: Baseline(
          baseline: d(baseline),
          baselineType: TextBaseline.alphabetic,
          child: content,
        ),
      ),
    );
  }
}

/// Centres a canvas-width child in the window.
///
/// A `bleed:` child is a Stack sibling of the page body and therefore spans the
/// whole window, so anything inside it that is placed with `dx` / `contentLeft`
/// - which are canvas-relative - lands left of the canvas on any window wider
/// than the canvas. Wrap that child in this.
class BubbaCanvasBox extends StatelessWidget {
  const BubbaCanvasBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: BubbaScale.availableWidth,
          height: double.infinity,
          child: child,
        ),
      );
}

class BubbaSheetCanvas extends StatelessWidget {
  const BubbaSheetCanvas({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth.isFinite) {
            BubbaScale.apply(
              constraints.maxWidth,
              bubbaUsableHeight(context),
              MediaQuery.paddingOf(context).top,
            );
          }
          return Builder(builder: builder);
        },
      );
}

class BubbaPage extends StatelessWidget {
  const BubbaPage({
    super.key,
    required this.content,
    this.footer,
    this.header,
    this.background,
    this.bleed,
    this.overlay,
    this.scrollable = true,
    this.padContent = true,
    this.topShift = true,
    this.fillContent = false,
    this.contentStartY = 0,
    this.footerBand,
  });

  final BubbaContentBuilder content;
  final WidgetBuilder? footer;
  final WidgetBuilder? header;
  final Color? background;
  final WidgetBuilder? bleed;
  final List<Widget> Function(BuildContext context)? overlay;
  final bool scrollable;
  final bool padContent;
  final bool topShift;
  final bool fillContent;

  final double contentStartY;

  /// The band this screen's design leaves under its last control, in design
  /// points. It is the home-indicator allowance the artboard already draws, so
  /// only the part of a system inset that the band does not cover gets
  /// reserved. Defaults to the smallest band any Bubba footer uses.
  final double? footerBand;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        BubbaScale.apply(
          constraints.maxWidth,
          bubbaUsableHeight(context),
          MediaQuery.paddingOf(context).top,
        );
        final scaler = MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: BubbaScale.maxTextScale,
        );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scaler),
          child: BubbaTextDefaults(
            child: Builder(
              builder: (context) => _build(context, constraints),
            ),
          ),
        );
      },
    );
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final canvasWidth = BubbaScale.availableWidth;

    final flow = BubbaFlow(context, startY: contentStartY, padded: padContent);
    content(context, flow);

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: fillContent ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (topShift && header == null)
          SizedBox(height: bubbaTopShift(context)),
        ...flow.children,
      ],
    );

    final scrollBody = fillContent
        ? SizedBox(width: canvasWidth, child: column)
        : Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: canvasWidth, child: column),
          );

    Widget body = Column(
      children: [
        if (header != null)
          SizedBox(width: canvasWidth, child: header!(context)),
        Expanded(
          child: scrollable
              ? SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: scrollBody,
                )
              : scrollBody,
        ),
        if (footer != null)
          SizedBox(width: canvasWidth, child: footer!(context)),
        SizedBox(
          height: footerBand == null
              ? bubbaFooterInset(context)
              : bubbaFooterInset(context, designBand: footerBand!),
        ),
      ],
    );

    if (canvasWidth < constraints.maxWidth) {
      body = Center(child: SizedBox(width: canvasWidth, child: body));
    }

    if (bleed != null || overlay != null) {
      final marks = overlay?.call(context) ?? const <Widget>[];
      final onCanvas =
          marks.where((w) => w is! BubbaWindowOverlay).toList(growable: false);
      final onWindow =
          marks.whereType<BubbaWindowOverlay>().toList(growable: false);
      body = Stack(
        fit: StackFit.expand,
        children: [
          if (bleed != null) SizedBox.expand(child: bleed!(context)),
          body,
          if (onCanvas.isNotEmpty)
            BubbaCanvasBox(child: Stack(children: onCanvas)),
          ...onWindow,
        ],
      );
    }

    return ColoredBox(color: background ?? BubbaColors.screenBg, child: body);
  }
}

class BubbaMinTapBox extends StatelessWidget {
  const BubbaMinTapBox({
    super.key,
    required this.painted,
    required this.child,
    this.width,
  });

  final double painted;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final box = math.max(painted, BubbaMetrics.minTapTarget);
    if (box <= painted) return child;
    return SizedBox(
      width: width,
      height: painted,
      child: OverflowBox(minHeight: box, maxHeight: box, child: child),
    );
  }
}

class BubbaTapTarget extends StatelessWidget {
  const BubbaTapTarget({
    super.key,
    required this.child,
    required this.onTap,
    this.enabled = true,
    this.label,
    this.designHeight,
    this.enforceMinTarget = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final String? label;
  final double? designHeight;
  final bool enforceMinTarget;

  @override
  Widget build(BuildContext context) {
    final painted = designHeight == null ? 0.0 : d(designHeight!);
    final box = enforceMinTarget
        ? math.max(painted, BubbaMetrics.minTapTarget)
        : BubbaScale.tapBox(painted);
    Widget target = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: SizedBox(
        height: designHeight == null ? null : box,
        child: designHeight == null ? child : Center(child: child),
      ),
    );
    if (label != null) {
      target = Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: target,
      );
    }
    return target;
  }
}
