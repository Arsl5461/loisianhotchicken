import 'package:flutter/material.dart';

import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';

const double _pillX = 72.67;
const double _pillY = 97.59;
const double _pillWidth = 267.38;
const double _pillHeight = 46.25;
const double _pillRadius = 16.67;
const double _iconX = 26.12;
const double _labelX = 48.27;
const double _labelBaseline = 20.18;
const double _barY = 28.84;
const double _barWidth = 191.25;
const double _barStroke = 3.0;

/// The "Uploading photos - 2 of 6" toast from p003.
///
/// The artboard dims the whole screen behind it, which is why this covers the
/// page rather than sitting inside the canvas.
class BubbaUploadToast extends StatelessWidget {
  const BubbaUploadToast({
    super.key,
    required this.uploaded,
    required this.total,
  });

  final int uploaded;
  final int total;

  @override
  Widget build(BuildContext context) => BubbaTextDefaults(
    child: BubbaSheetCanvas(builder: _build),
  );

  Widget _build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (uploaded / total).clamp(0.0, 1.0);
    final labelMetrics = bubbaDesignTextMetrics(context, BubbaText.uploadLabel);
    return IgnorePointer(
      child: Stack(
        children: [
          const SizedBox.expand(child: ColoredBox(color: Color(0x33000000))),
          BubbaCanvasBox(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BubbaGap(_pillY),
              Padding(
                padding: EdgeInsets.only(left: dx(_pillX)),
                child: Semantics(
                  liveRegion: true,
                  label: 'Uploading photos, $uploaded of $total',
                  child: Container(
                    width: dxSpan(_pillX, 390 - _pillX - _pillWidth),
                    height: d(_pillHeight),
                    decoration: BoxDecoration(
                      color: BubbaColors.surface,
                      borderRadius: BorderRadius.circular(d(_pillRadius)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: hd(_iconX)),
                        Padding(
                          padding: EdgeInsets.only(
                            top: d(_pillHeight / 2) - d(8),
                          ),
                          child: CustomPaint(
                            size: Size(d(13), d(16)),
                            painter: const _UploadGlyphPainter(),
                          ),
                        ),
                        SizedBox(width: hd(_labelX - _iconX - 13)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Baseline(
                                baseline: d(_labelBaseline),
                                baselineType: TextBaseline.alphabetic,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      'Uploading photos',
                                      style: BubbaText.uploadLabel,
                                    ),
                                    Text(
                                      '$uploaded of $total',
                                      style: BubbaText.uploadCount,
                                    ),
                                  ],
                                ),
                              ),
                              BubbaGap(
                                _barY - _labelBaseline - labelMetrics.descent,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: hd(_barWidth),
                                  height: d(_barStroke),
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      const SizedBox.expand(
                                        child: ColoredBox(
                                          color: BubbaColors.progressTrack,
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: progress,
                                        heightFactor: 1,
                                        child: const ColoredBox(
                                          color: BubbaColors.actionDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: hd(12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadGlyphPainter extends CustomPainter {
  const _UploadGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.115
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = BubbaColors.actionDark;

    canvas.drawLine(Offset(w / 2, h * 0.06), Offset(w / 2, h * 0.60), p);
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.22, h * 0.30)
        ..lineTo(w / 2, h * 0.06)
        ..lineTo(w * 0.78, h * 0.30),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.08, h * 0.62)
        ..lineTo(w * 0.08, h * 0.94)
        ..lineTo(w * 0.92, h * 0.94)
        ..lineTo(w * 0.92, h * 0.62),
      p,
    );
  }

  @override
  bool shouldRepaint(_UploadGlyphPainter old) => false;
}
