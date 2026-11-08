import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'bubba_glyphs.dart';
import 'bubba_scale.dart';
import 'bubba_tokens.dart';

class BubbaChevronLeft extends StatelessWidget {
  const BubbaChevronLeft({
    super.key,
    this.width = BubbaMetrics.backIconWidth,
    this.height = BubbaMetrics.backIconHeight,
    this.strokeWidth = 1,
    this.color = BubbaColors.actionDark,
  });

  final double width;
  final double height;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(d(width), d(height)),
      painter: _PolylinePainter(
        points: const [Offset(1, 0), Offset(0, 0.5), Offset(1, 1)],
        strokeWidth: d(strokeWidth),
        color: color,
      ),
    );
  }
}

class BubbaChevronDown extends StatelessWidget {
  const BubbaChevronDown({
    super.key,
    this.width = BubbaMetrics.caretWidth,
    this.height = BubbaMetrics.caretHeight,
    this.strokeWidth = 0.845,
    this.color = BubbaColors.actionDark,
  });

  final double width;
  final double height;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(d(width), d(height)),
      painter: _PolylinePainter(
        points: const [Offset(0, 0), Offset(0.5, 1), Offset(1, 0)],
        strokeWidth: d(strokeWidth),
        color: color,
      ),
    );
  }
}

class _PolylinePainter extends CustomPainter {
  const _PolylinePainter({
    required this.points,
    required this.strokeWidth,
    required this.color,
  });

  final List<Offset> points;
  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final w = size.width - strokeWidth;
    final h = size.height - strokeWidth;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final p = Offset(inset + points[i].dx * w, inset + points[i].dy * h);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_PolylinePainter old) =>
      old.color != color || old.strokeWidth != strokeWidth || old.points != points;
}

class BubbaCross extends StatelessWidget {
  const BubbaCross({
    super.key,
    this.size = 14,
    this.strokeWidth = 1.6,
    this.color = BubbaColors.textBody,
  });

  final double size;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CrossPainter(strokeWidth: strokeWidth, color: color),
    );
  }
}

class _CrossPainter extends CustomPainter {
  const _CrossPainter({required this.strokeWidth, required this.color});

  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;
    final inset = strokeWidth / 2;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CrossPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

class BubbaPopoverPointer extends StatelessWidget {
  const BubbaPopoverPointer({
    super.key,
    this.width = 15.8,
    this.height = 9.9,
    this.fill = BubbaColors.surface,
    this.border = BubbaColors.border,
  });

  final double width;
  final double height;
  final Color fill;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _PointerPainter(fill: fill, border: border),
    );
  }
}

class _PointerPainter extends CustomPainter {
  const _PointerPainter({required this.fill, required this.border});

  final Color fill;
  final Color border;

  static const double _skirt = BubbaMetrics.borderWidth * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final legs = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height);
    final body = Path.from(legs)
      ..lineTo(size.width, size.height + _skirt)
      ..lineTo(0, size.height + _skirt)
      ..close();

    canvas.drawPath(body, Paint()..color = fill);
    canvas.drawPath(
      legs,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = BubbaMetrics.borderWidth
        ..strokeJoin = StrokeJoin.miter
        ..strokeCap = StrokeCap.butt
        ..color = border,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter old) => old.fill != fill || old.border != border;
}

/// Outlined shield used above the reassurance line on the gender step (p017).
/// Painted rather than taken from an icon font so it renders identically in
/// golden tests, where icon fonts fall back to tofu boxes.
class BubbaShieldOutline extends StatelessWidget {
  const BubbaShieldOutline({
    super.key,
    this.width = 17.01,
    this.height = 20.18,
    this.color = const Color(0xFF2A4735),
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
    BubbaGlyphs.shield,
    color: color,
    width: width,
    height: height,
  );
}

class BubbaGraduationCap extends StatelessWidget {
  const BubbaGraduationCap({super.key, this.size = 28.14, this.color = BubbaColors.actionDark});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(size), d(size * 0.74)),
        painter: _CapPainter(color: color, strokeWidth: d(1.2)),
      );
}

class _CapPainter extends CustomPainter {
  const _CapPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    final board = Path()
      ..moveTo(w / 2, strokeWidth)
      ..lineTo(w - strokeWidth, h * 0.34)
      ..lineTo(w / 2, h * 0.62)
      ..lineTo(strokeWidth, h * 0.34)
      ..close();
    canvas.drawPath(board, p);
    final body = Path()
      ..moveTo(w * 0.24, h * 0.45)
      ..lineTo(w * 0.24, h * 0.8)
      ..cubicTo(w * 0.24, h - strokeWidth, w * 0.76, h - strokeWidth, w * 0.76, h * 0.8)
      ..lineTo(w * 0.76, h * 0.45);
    canvas.drawPath(body, p);
  }

  @override
  bool shouldRepaint(_CapPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// Briefcase shown in the work step's profile-preview card (p035).
class BubbaBriefcase extends StatelessWidget {
  const BubbaBriefcase({super.key, this.size = 22.15, this.color = BubbaColors.actionDark});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(size), d(size * 0.88)),
        painter: _BriefcasePainter(color: color, strokeWidth: d(1.2)),
      );
}

class _BriefcasePainter extends CustomPainter {
  const _BriefcasePainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    final r = Radius.circular(strokeWidth * 2);
    canvas.drawRRect(
      RRect.fromLTRBR(strokeWidth, h * 0.3, w - strokeWidth, h - strokeWidth, r),
      p,
    );
    final handle = Path()
      ..moveTo(w * 0.33, h * 0.3)
      ..lineTo(w * 0.33, h * 0.12)
      ..lineTo(w * 0.67, h * 0.12)
      ..lineTo(w * 0.67, h * 0.3);
    canvas.drawPath(handle, p);
    canvas.drawLine(Offset(strokeWidth, h * 0.58), Offset(w - strokeWidth, h * 0.58), p);
  }

  @override
  bool shouldRepaint(_BriefcasePainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// Map pin shown inside the hometown field (p023).
class BubbaLocationPin extends StatelessWidget {
  const BubbaLocationPin({
    super.key,
    this.width = 14.74,
    this.height = 18.81,
    this.color = BubbaColors.actionPrimary,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(width), d(height)),
        painter: _PinPainter(color: color, strokeWidth: d(1.3)),
      );
}

class _PinPainter extends CustomPainter {
  const _PinPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    final r = w / 2 - strokeWidth / 2;
    final cx = w / 2;
    final cy = r + strokeWidth / 2;
    final body = Path()
      ..moveTo(cx, h - strokeWidth / 2)
      ..cubicTo(cx - r * 1.35, h * 0.5, cx - r, cy + r * 0.6, cx - r, cy)
      ..arcToPoint(Offset(cx + r, cy), radius: Radius.circular(r))
      ..cubicTo(cx + r, cy + r * 0.6, cx + r * 1.35, h * 0.5, cx, h - strokeWidth / 2)
      ..close();
    canvas.drawPath(body, p);
    canvas.drawCircle(Offset(cx, cy), r * 0.36, p);
  }

  @override
  bool shouldRepaint(_PinPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// Magnifier used in the part 2 search fields.
class BubbaSearchIcon extends StatelessWidget {
  const BubbaSearchIcon({super.key, this.size = 15, this.color = const Color(0xFF8A929E)});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(d(size), d(size)), painter: _SearchPainter(color, d(1.3)));
}

class _SearchPainter extends CustomPainter {
  const _SearchPainter(this.color, this.strokeWidth);

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;
    final r = size.width * 0.34;
    final c = Offset(size.width * 0.42, size.height * 0.42);
    canvas.drawCircle(c, r, p);
    canvas.drawLine(
      Offset(c.dx + r * 0.72, c.dy + r * 0.72),
      Offset(size.width - strokeWidth, size.height - strokeWidth),
      p,
    );
  }

  @override
  bool shouldRepaint(_SearchPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// Right-pointing chevron used on the icebreaker format cards (p039).
class BubbaChevronRight extends StatelessWidget {
  const BubbaChevronRight({
    super.key,
    this.width = 6,
    this.height = 10.6,
    this.strokeWidth = 1.4,
    this.color = const Color(0xFF333333),
  });

  final double width;
  final double height;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(width), d(height)),
        painter: _PolylinePainter(
          points: const [Offset(0, 0), Offset(1, 0.5), Offset(0, 1)],
          strokeWidth: d(strokeWidth),
          color: color,
        ),
      );
}

/// Camera glyph for the Snaps format badge.
class BubbaCameraGlyph extends StatelessWidget {
  const BubbaCameraGlyph({
    super.key,
    this.size = 20.19,
    this.color = BubbaColors.actionDark,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
    BubbaGlyphs.cameraMark,
    color: color,
    width: size,
  );
}

class BubbaSparkle extends StatelessWidget {
  const BubbaSparkle({
    super.key,
    this.size = 22.0,
    this.color = BubbaColors.actionDark,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
    BubbaGlyphs.sparkleMark,
    color: color,
    width: size,
  );
}

class BubbaPencil extends StatelessWidget {
  const BubbaPencil({
    super.key,
    this.size = 18.94,
    this.color = const Color(0xFF000000),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
    BubbaGlyphs.pencil,
    color: color,
    width: size,
  );
}

class BubbaStar4 extends StatelessWidget {
  const BubbaStar4({
    super.key,
    this.size = 14.99,
    this.color = BubbaColors.actionPrimary,
    this.strokeWidth,
  });

  final double size;
  final Color color;

  /// Set to draw the star as an outline. The photos heading's sparkle is
  /// filled; the "BUILDING YOUR PROFILE" eyebrow's is a hairline outline.
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(size), d(size)),
        painter: _Star4Painter(color, strokeWidth),
      );
}

class _Star4Painter extends CustomPainter {
  const _Star4Painter(this.color, [this.strokeWidth]);

  final Color color;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    const waist = 0.18;
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx + r * waist, c.dy - r * waist, c.dx + r, c.dy)
      ..quadraticBezierTo(c.dx + r * waist, c.dy + r * waist, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx - r * waist, c.dy + r * waist, c.dx - r, c.dy)
      ..quadraticBezierTo(c.dx - r * waist, c.dy - r * waist, c.dx, c.dy - r)
      ..close();
    final paint = Paint()..color = color;
    if (strokeWidth != null) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = d(strokeWidth!)
        ..strokeJoin = StrokeJoin.round;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_Star4Painter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// The lightbulb on the photos "Tips for great photos" card.
class BubbaBulb extends StatelessWidget {
  const BubbaBulb({
    super.key,
    this.width = 21.09,
    this.height = 30.47,
    this.color = const Color(0xFF2D4B39),
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(d(width), d(height)),
    painter: _BulbPainter(color),
  );
}

class _BulbPainter extends CustomPainter {
  const _BulbPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round
      ..color = color;

    final glass = Rect.fromLTWH(w * 0.22, h * 0.10, w * 0.56, h * 0.56);
    canvas.drawArc(glass, 3.4, 5.9, false, p);
    canvas.drawLine(Offset(w * 0.32, h * 0.60), Offset(w * 0.32, h * 0.74), p);
    canvas.drawLine(Offset(w * 0.68, h * 0.60), Offset(w * 0.68, h * 0.74), p);
    canvas.drawLine(Offset(w * 0.32, h * 0.80), Offset(w * 0.68, h * 0.80), p);
    canvas.drawLine(Offset(w * 0.40, h * 0.92), Offset(w * 0.60, h * 0.92), p);

    for (final a in [0.05, 0.32, 0.58]) {
      canvas.drawLine(
        Offset(w * 0.04, h * (0.16 + a * 0.5)),
        Offset(w * 0.14, h * (0.16 + a * 0.5)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_BulbPainter old) => old.color != color;
}

/// The three source glyphs on the "Add photos" sheet (p043, p044): a photo
/// frame, a camera and a folder.
enum BubbaPhotoSource { library, camera, album }

class BubbaPhotoSourceIcon extends StatelessWidget {
  const BubbaPhotoSourceIcon({
    super.key,
    required this.source,
    this.color = const Color(0xFF000000),
  });

  final BubbaPhotoSource source;
  final Color color;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
    switch (source) {
      BubbaPhotoSource.library => BubbaGlyphs.sheetLibrary,
      BubbaPhotoSource.camera => BubbaGlyphs.sheetCamera,
      BubbaPhotoSource.album => BubbaGlyphs.sheetFolder,
    },
    color: color,
  );
}

/// p027's search-result affordances: a tick when the language is already
/// chosen, a plus when it is not.
class BubbaResultTick extends StatelessWidget {
  const BubbaResultTick({super.key, this.size = 10.47, this.color = const Color(0xFF000000)});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(size), d(size * 7.56 / 10.47)),
        painter: _ResultGlyphPainter(color: color, tick: true),
      );
}

class BubbaResultPlus extends StatelessWidget {
  const BubbaResultPlus({super.key, this.size = 10.88, this.color = const Color(0xFF000000)});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(size), d(size)),
        painter: _ResultGlyphPainter(color: color, tick: false),
      );
}

class _ResultGlyphPainter extends CustomPainter {
  const _ResultGlyphPainter({required this.color, required this.tick});

  final Color color;
  final bool tick;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.square;
    if (tick) {
      canvas.drawPath(
        Path()
          ..moveTo(0, size.height * 0.45)
          ..lineTo(size.width * 0.36, size.height)
          ..lineTo(size.width, 0),
        paint,
      );
      return;
    }
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ResultGlyphPainter old) =>
      old.color != color || old.tick != tick;
}

/// p014 / p045 - the tap hand next to "Tap to see profile view".
class BubbaTapHand extends StatelessWidget {
  const BubbaTapHand({
    super.key,
    this.color = const Color(0xFF79746E),
    this.width = 13.30,
    this.height = 14.45,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => BubbaGlyphIcon(
    BubbaGlyphs.tapHand,
    color: color,
    width: width,
    height: height,
  );
}

class BubbaCropGlyph extends StatelessWidget {
  const BubbaCropGlyph({
    super.key,
    this.size = 11.92,
    this.color = const Color(0xFF000000),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(size), d(size)),
        painter: _CropPainter(color),
      );
}

class _CropPainter extends CustomPainter {
  const _CropPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.09
      ..strokeCap = StrokeCap.square;
    // Two overlapping corner brackets, the way a crop tool is always drawn.
    canvas.drawPath(
      Path()
        ..moveTo(s * 0.22, 0)
        ..lineTo(s * 0.22, s * 0.78)
        ..lineTo(s, s * 0.78),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, s * 0.22)
        ..lineTo(s * 0.78, s * 0.22)
        ..lineTo(s * 0.78, s),
      stroke,
    );
  }

  @override
  bool shouldRepaint(_CropPainter old) => old.color != color;
}

/// The plus inside an empty photo slot.
class BubbaPlusGlyph extends StatelessWidget {
  const BubbaPlusGlyph({
    super.key,
    this.size = 14.44,
    this.color = const Color(0xFF807E7D),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(d(size), d(size)),
        painter: _PlusPainter(color),
      );
}

class _PlusPainter extends CustomPainter {
  const _PlusPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_PlusPainter old) => old.color != color;
}

/// The modal close mark. p053 strokes two 1.715pt round-capped diagonals
/// across a 15.28 x 14.74 box; these are the artboard's own endpoints.
class BubbaCloseMark extends StatelessWidget {
  const BubbaCloseMark({
    super.key,
    required this.color,
    this.strokeWidth = 1.715,
    this.width = designWidth,
    this.height = designHeight,
  });

  final Color color;
  final double strokeWidth;
  final double width;
  final double height;

  static const double designWidth = 15.277;
  static const double designHeight = 14.743;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: d(width),
        height: d(height),
        child: CustomPaint(
          painter: _CloseMarkPainter(color: color, strokeWidth: d(strokeWidth)),
        ),
      );
}

class _CloseMarkPainter extends CustomPainter {
  const _CloseMarkPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final inset = strokeWidth / 2;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(size.width - inset, inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CloseMarkPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// A horizontal dashed rule. p054/p055 join their three invite dots with a
/// `dash="5 5"` stroke; the dash lengths are design points and scale with the
/// canvas.
class BubbaDashedLine extends StatelessWidget {
  const BubbaDashedLine({
    super.key,
    required this.color,
    this.dash = 5.0,
    this.gap = 5.0,
    this.strokeWidth = 1.0,
  });

  final Color color;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _DashedLinePainter(
          color: color,
          dash: dash,
          gap: gap,
          strokeWidth: strokeWidth,
        ),
      );
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({
    required this.color,
    required this.dash,
    required this.gap,
    required this.strokeWidth,
  });

  final Color color;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final on = hd(dash);
    final off = hd(gap);
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      final end = math.min(x + on, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
      x = end + off;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) =>
      old.color != color ||
      old.dash != dash ||
      old.gap != gap ||
      old.strokeWidth != strokeWidth;
}

/// The dashed outline an empty photo slot draws, shared by the photos grid
/// (p002) and the edit-photo tray (p045).
class BubbaDashedTile extends StatelessWidget {
  const BubbaDashedTile({
    super.key,
    required this.radius,
    required this.fill,
    required this.border,
    this.dash = 5.0,
    this.gap = 3.5,
    this.strokeWidth = 0.75,
    this.child,
  });

  final double radius;
  final Color fill;
  final Color border;
  final double dash;
  final double gap;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _DashedTilePainter(
          radius: radius,
          fill: fill,
          border: border,
          dash: dash,
          gap: gap,
          strokeWidth: strokeWidth,
        ),
        child: child,
      );
}

class _DashedTilePainter extends CustomPainter {
  const _DashedTilePainter({
    required this.radius,
    required this.fill,
    required this.border,
    required this.dash,
    required this.gap,
    required this.strokeWidth,
  });

  final double radius;
  final Color fill;
  final Color border;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(d(radius)),
    );
    canvas.drawRRect(rect, Paint()..color = fill);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = border;
    final on = d(dash);
    final off = d(gap);
    for (final metric in (Path()..addRRect(rect)).computeMetrics()) {
      var pos = 0.0;
      while (pos < metric.length) {
        canvas.drawPath(
          metric.extractPath(pos, (pos + on).clamp(0, metric.length)),
          stroke,
        );
        pos += on + off;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedTilePainter old) =>
      old.radius != radius || old.fill != fill || old.border != border;
}

/// p054's settings gear.
class BubbaGear extends StatelessWidget {
  const BubbaGear({
    super.key,
    this.size = 20.36,
    this.color = const Color(0xFF000000),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(d(size), d(size)), painter: _GearPainter(color));
}

class _GearPainter extends CustomPainter {
  const _GearPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.10
      ..strokeJoin = StrokeJoin.round;
    // A cog: a ring with eight stubby teeth, and a hub.
    canvas.drawCircle(c, r * 0.30, stroke);
    canvas.drawCircle(c, r * 0.66, stroke);
    final tooth = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.17
      ..strokeCap = StrokeCap.round;
    const teeth = 8;
    for (var i = 0; i < teeth; i++) {
      final a = i * 2 * math.pi / teeth;
      canvas.drawLine(
        Offset(c.dx + math.cos(a) * r * 0.70, c.dy + math.sin(a) * r * 0.70),
        Offset(c.dx + math.cos(a) * r * 0.92, c.dy + math.sin(a) * r * 0.92),
        tooth,
      );
    }
  }

  @override
  bool shouldRepaint(_GearPainter old) => old.color != color;
}
