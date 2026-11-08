import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bubba_tokens.dart';

class BubbaScale {
  BubbaScale._();

  static const double maxScale = 1.3;
  static const double maxScaleWide = 1.75;
  static const double minScale = 0.6;

  /// A short phone is fitted to slightly more than the artboard's own height,
  /// because a few screens carry a little more than the artboard draws - a
  /// wrapped chip row, a 1pt border, a control that cannot shrink - and without
  /// the headroom those land a handful of points past the fold.
  static const double phoneHeightHeadroom = 1.05;
  static const double tabletBreakpoint = 600;
  static const double maxTextScale = 1.15;
  static const double tabletTypeRatio = 17 / 14;

  static double? _appliedWidth;
  static double? _appliedHeight;
  static double _appliedTopInset = 0;

  /// A viewport is "short" when it is more than 3% shorter than the design's
  /// own 390:843 aspect. Only there do [factor] and [hFactor] differ: a hair of
  /// difference on a near-square device would stretch anything whose height is
  /// derived from its width - the photo grid's square tiles are the case that
  /// caught this - for no gain.
  static const double shortPhoneRatio = 0.97;

  static double get _viewportWidth {
    final applied = _appliedWidth;
    if (applied != null && applied > 0) return applied;
    return _screenUtil((u) => u.screenWidth) ?? BubbaMetrics.designWidth;
  }

  static double get _viewportHeight {
    final applied = _appliedHeight;
    if (applied != null && applied > 0) return applied;
    return _screenUtil((u) => u.screenHeight) ?? BubbaMetrics.designHeight;
  }

  /// ScreenUtil throws a `LateError` until `ScreenUtilInit` has run, and a
  /// widget can be built before that - the landing screen's sheet tests do
  /// exactly this. Fall back to the design size rather than crashing.
  static double? _screenUtil(double Function(ScreenUtil) read) {
    try {
      final value = read(ScreenUtil());
      return value > 0 ? value : null;
    } catch (_) {
      return null;
    }
  }

  static double get factor =>
      resolve(_viewportWidth, _viewportHeight, _appliedTopInset);

  /// Horizontal factor. It is the same as [factor] everywhere except a phone
  /// whose canvas is height bound: there the vertical rhythm stays at the
  /// smaller height-bound factor so the screen still fits without scrolling,
  /// while widths and x positions stretch to the window so the screen does not
  /// waste a margin either side.
  static double get hFactor {
    if (isWideLayout) return factor;
    final byWidth = _viewportWidth / BubbaMetrics.designWidth;
    return byWidth < factor ? factor : byWidth.clamp(minScale, maxScale);
  }

  static double get availableWidth =>
      math.min(_viewportWidth, BubbaMetrics.designWidth * hFactor);

  static double get canvasOffset => (_viewportWidth - availableWidth) / 2;

  static double get availableHeight => _viewportHeight;

  static bool get isWideLayout => _viewportWidth >= tabletBreakpoint;

  static bool get isHeightBound =>
      _viewportHeight / BubbaMetrics.designHeight <
      _viewportWidth / BubbaMetrics.designWidth;

  /// The 44pt floor is skipped only on a **short phone**, where the canvas is
  /// height bound and the floor would add layout height the viewport cannot
  /// afford. A tablet is height bound too but has room, so it keeps the floor.
  static double tapBox(double painted) =>
      isHeightBound && !isWideLayout && painted < BubbaMetrics.minTapTarget
          ? painted
          : math.max(painted, BubbaMetrics.minTapTarget);

  static double tapOverhang(double painted) =>
      math.max(0, BubbaMetrics.minTapTarget - painted) / 2;

  static double maxScaleFor(double availableWidth) =>
      availableWidth >= tabletBreakpoint ? maxScaleWide : maxScale;

  /// One uniform factor drives every dimension - spacing, type, icons, radii -
  /// so a screen is the artboard at a different size rather than a different
  /// layout.
  ///
  /// A phone scales by **width**, so the canvas always fills the screen edge to
  /// edge and a canvas taller than the viewport scrolls under its bottom-anchored
  /// footer. A tablet is far wider than the artboard's aspect, so scaling by
  /// width there would make every screen scroll by hundreds of points; it scales
  /// by whichever of width and height binds first, which makes the canvas fit
  /// without scrolling and centres it, with the page background filling the rest
  /// of the device.
  static double resolve(
    double availableWidth, [
    double? availableHeight,
    double topInset = 0,
  ]) {
    final byWidth = availableWidth / BubbaMetrics.designWidth;
    final byHeight = availableHeight == null
        ? double.infinity
        : byHeightFor(availableHeight, topInset);
    if (availableWidth < tabletBreakpoint) {
      if (byHeight < byWidth * shortPhoneRatio) {
        return (byHeight / phoneHeightHeadroom).clamp(minScale, maxScale);
      }
      return math.min(byWidth, byHeight).clamp(minScale, maxScale);
    }
    return math.min(byWidth, byHeight).clamp(minScale, maxScaleWide);
  }

  static void apply(
    double viewportWidth, [
    double? viewportHeight,
    double topInset = 0,
  ]) {
    _appliedWidth = viewportWidth;
    if (viewportHeight != null) _appliedHeight = viewportHeight;
    _appliedTopInset = topInset;
  }

  /// The largest factor whose canvas still fits, including the shift a notch
  /// deeper than the design's 47pt status bar forces.
  ///
  ///     canvas + topShift <= H
  ///     843f + max(0, padTop - 47f) <= H
  ///
  /// so with a deep notch `f <= (H - padTop) / (843 - 47)`, and without one
  /// `f <= H / 843`.
  static double byHeightFor(double height, double topInset) {
    final plain = height / BubbaMetrics.designHeight;
    if (topInset <= 0) return plain;
    final shifted = (height - topInset) /
        (BubbaMetrics.designHeight - BubbaMetrics.designStatusBar);
    return math.min(plain, shifted);
  }

  static double get contentWidth =>
      availableWidth -
      hd(BubbaMetrics.pagePadding) -
      hd(BubbaMetrics.pageInsetRight);

  static double get contentLeft => hd(BubbaMetrics.pagePadding);

  static double get contentRight => contentLeft + contentWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= tabletBreakpoint;
}

double d(double value) => value * BubbaScale.factor;

/// Horizontal counterpart of [d]: use it for x offsets and widths that should
/// span the window on a short phone. Identical to [d] on every other viewport.
double hd(double value) => value * BubbaScale.hFactor;

/// A design gap that can never go negative. P3-7: an offset whose design value
/// sits above (or left of) its own block's origin renders as a negative
/// padding, which is a layout assertion, not a small visual error.
double dGap(double design) => d(math.max(0, design));

double hdGap(double design) => hd(math.max(0, design));

/// Type scales with the canvas like everything else, so a tablet gets the same
/// design at a larger size rather than its own ramp. The second argument is the
/// artboard's tablet size and is kept only so the call sites still read as a
/// pair; it is deliberately unused.
double dsp(double phone, double tablet) => d(phone);

double dx(double designX) =>
    BubbaScale.contentLeft +
    (designX - BubbaMetrics.pagePadding) * BubbaScale.hFactor;

double dxRight(double designInsetFromRight) =>
    BubbaScale.contentRight -
    (designInsetFromRight - BubbaMetrics.pageInsetRight) * BubbaScale.hFactor;

double dxSpan(double designX, double designInsetFromRight) =>
    dxRight(designInsetFromRight) - dx(designX);

/// The full window height. The notch is handled by [BubbaScale.byHeightFor],
/// which folds the shift a deep notch forces into the factor itself.
///
/// The bottom inset is deliberately **not** subtracted. Every artboard already
/// leaves a band under its last control - 42.19pt on part 1 and 2, 37.19 on
/// part 3 - and that band is the home-indicator allowance. Subtracting the
/// device inset as well counted it twice and put the CTA about double the
/// design's gap above the bottom edge.
double bubbaUsableHeight(BuildContext context) =>
    MediaQuery.sizeOf(context).height;

/// What a bottom-anchored footer must clear: the keyboard, and a system inset
/// only where the design's own bottom band is too small to cover it.
///
/// The two cases are genuinely different and the old rule
/// (`max(viewInsets.bottom, padding.bottom)`, recorded in part 2's PROGRESS)
/// only served the second:
///
/// - **iOS home indicator.** The artboards draw the indicator *inside* their
///   own bottom band, so the design already budgets for it. Reserving the 34pt
///   inset on top of the band put the CTA about twice the design's gap above
///   the screen edge on an iPhone 16 Pro Max.
/// - **Android 3-button nav bar.** 48pt of opaque chrome that no artboard
///   budgets for, so whatever the band does not cover has to be reserved or the
///   button sits under it.
///
/// [designBand] defaults to the **smallest** band any Bubba footer draws - the
/// step footer's `843 - (765.07 + 50.56)` - so the rule never under-reserves.
double bubbaFooterInset(
  BuildContext context, {
  double designBand = BubbaMetrics.designHeight -
      (BubbaMetrics.footerButtonY + BubbaMetrics.footerButtonHeight),
}) {
  final media = MediaQuery.of(context);
  if (media.viewInsets.bottom > 0) return media.viewInsets.bottom;
  final band = designBand * BubbaScale.factor;
  return math.max(0, media.padding.bottom - band);
}

double bubbaTopShift(BuildContext context) {
  final top = MediaQuery.paddingOf(context).top;
  final budget = d(BubbaMetrics.designStatusBar);
  return top > budget ? top - budget : 0;
}

double bubbaBottomInset(BuildContext context) {
  final media = MediaQuery.of(context);
  return math.max(media.viewInsets.bottom, media.padding.bottom);
}
