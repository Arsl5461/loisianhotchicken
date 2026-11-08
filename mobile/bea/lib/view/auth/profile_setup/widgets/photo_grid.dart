import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_tokens.dart';

/// The 3x2 photo grid on p002 / p004 / p005.
///
/// Wider than the canonical content box on purpose: the grid runs 12.51 to
/// 377.50 where every other part 2 element stops at 26 / 362.1.
class BubbaPhotoGrid extends StatelessWidget {
  const BubbaPhotoGrid({
    super.key,
    required this.photos,
    this.onAdd,
    this.onRemove,
    this.onReorder,
    this.onEdit,
  });

  final List<ImageProvider?> photos;
  final void Function(int slot)? onAdd;
  final void Function(int slot)? onRemove;
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Tapping a filled tile opens the edit-photo screen (p014/p045).
  final void Function(int slot)? onEdit;

  static const double left = 12.51;
  static const double rightInset = 12.50;
  static const double tileWidth = 113.96;
  static const double tileHeight = 146.14;
  static const double columnGap = 11.55;
  static const double rowGap = 13.70;
  static const double radius = 6.35;
  static const int columns = 3;

  /// Design height of the whole two-row grid.
  static const double height = tileHeight * 2 + rowGap;

  @override
  Widget build(BuildContext context) {
    final rows = (photos.length / columns).ceil();
    return SizedBox(
      height: d(tileHeight * rows + rowGap * (rows - 1)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var row = 0; row < rows; row++) ...[
            if (row > 0) SizedBox(height: d(rowGap)),
            SizedBox(
              height: d(tileHeight),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      for (var col = 0; col < columns; col++) ...[
                        if (col > 0) SizedBox(width: hd(columnGap)),
                        Expanded(child: _tile(row * columns + col)),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      for (var col = 0; col < columns; col++) ...[
                        if (col > 0) SizedBox(width: hd(columnGap)),
                        Expanded(child: _badge(row * columns + col)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge(int index) {
    if (index >= photos.length ||
        photos[index] == null ||
        onRemove == null) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.topRight,
      child: _RemoveBadge(onTap: () => onRemove!(index)),
    );
  }

  Widget _tile(int index) {
    if (index >= photos.length) return const SizedBox.shrink();
    final photo = photos[index];
    final tile = photo == null
        ? _EmptyTile(onTap: onAdd == null ? null : () => onAdd!(index))
        : _FilledTile(
            onTap: onEdit == null ? null : () => onEdit!(index),
            image: photo,
          );
    if (photo == null || onReorder == null) return tile;
    return LongPressDraggable<int>(
      data: index,
      feedback: Opacity(
        opacity: 0.9,
        child: SizedBox(
          width: hd(tileWidth),
          height: d(tileHeight),
          child: _FilledTile(image: photo),
        ),
      ),
      childWhenDragging: const _EmptyTile(),
      child: DragTarget<int>(
        onAcceptWithDetails: (details) => onReorder!(details.data, index),
        builder: (context, _, __) => tile,
      ),
    );
  }
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile({this.onTap});

  final VoidCallback? onTap;

  static const double _circle = 35.28;
  static const double _glyph = 14.44;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Add a photo',
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CustomPaint(
        painter: const _DashedTilePainter(),
        child: Center(
          child: Container(
            width: d(_circle),
            height: d(_circle),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: BubbaColors.photoAddCircle,
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              size: Size(d(_glyph), d(_glyph)),
              painter: _PlusPainter(strokeWidth: d(1.4)),
            ),
          ),
        ),
      ),
    ),
  );
}

class _DashedTilePainter extends CustomPainter {
  const _DashedTilePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(d(BubbaPhotoGrid.radius)),
    );
    canvas.drawRRect(rect, Paint()..color = BubbaColors.photoTile);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..color = BubbaColors.photoTileBorder;
    final dash = d(5.0);
    final gap = d(3.5);
    for (final metric in (Path()..addRRect(rect)).computeMetrics()) {
      var pos = 0.0;
      while (pos < metric.length) {
        canvas.drawPath(
          metric.extractPath(pos, (pos + dash).clamp(0, metric.length)),
          stroke,
        );
        pos += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedTilePainter old) => false;
}

class _PlusPainter extends CustomPainter {
  const _PlusPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = BubbaColors.photoAddGlyph;
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(Offset(0, c.dy), Offset(size.width, c.dy), p);
    canvas.drawLine(Offset(c.dx, 0), Offset(c.dx, size.height), p);
  }

  @override
  bool shouldRepaint(_PlusPainter old) => old.strokeWidth != strokeWidth;
}

class _FilledTile extends StatelessWidget {
  const _FilledTile({required this.image, this.onTap});

  final ImageProvider image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Semantics(
        button: onTap != null,
        label: onTap == null ? null : 'Edit photo',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(d(BubbaPhotoGrid.radius)),
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
      ),
    ),
  );
}

class _RemoveBadge extends StatelessWidget {
  const _RemoveBadge({this.onTap});

  final VoidCallback? onTap;

  static const double _button = 17.57;
  static const double _cross = 5.63;
  static const double _cornerInset = 3.2;

  @override
  Widget build(BuildContext context) => Transform.translate(
    offset: Offset(
      BubbaMetrics.minTapTarget / 2 - hd(_cornerInset),
      d(_cornerInset) - BubbaMetrics.minTapTarget / 2,
    ),
    child: Semantics(
      button: true,
      label: 'Remove photo',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: BubbaMetrics.minTapTarget,
          height: BubbaMetrics.minTapTarget,
          child: Center(
            child: Container(
              width: d(_button),
              height: d(_button),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: BubbaColors.actionDark,
                shape: BoxShape.circle,
              ),
              child: CustomPaint(
                size: Size(d(_cross), d(_cross)),
                painter: _CrossGlyphPainter(strokeWidth: d(1.1)),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _CrossGlyphPainter extends CustomPainter {
  const _CrossGlyphPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = BubbaColors.surface;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), p);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), p);
  }

  @override
  bool shouldRepaint(_CrossGlyphPainter old) => old.strokeWidth != strokeWidth;
}
