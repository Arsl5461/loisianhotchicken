import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';

// p013 and p046 share p010's 382.57x851.66 artboard, so these are the traced
// values scaled by 390/382.57 and 843/851.66.
const double _backX = BubbaMetrics.backChevronX;
const double _backY = 58.17;
const double _backWidth = 27.88;
const double _backHeight = 19.86;
const double _barX = 20.30;
const double _barY = 720.87;
const double _barHeight = 105.19;
const double _barRadius = 12.06;
const double _barBlur = 18;
const double _barTintOpacity = 0.72;
const double _pillY = 31.01;
const double _pillWidth = 158.48;
const double _pillHeight = 44.54;
const double _retakeX = 30.55;
const double _pillRightInset = 18.58;
const double _actionBaseline = 58.03;

/// Artboards p013 and p046 - the shot you just took, with "Retake" and
/// "Add to profile".
class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({
    super.key,
    required this.photo,
    this.onBack,
    this.onRetake,
    this.onAdd,
  });

  final ImageProvider photo;
  final VoidCallback? onBack;
  final VoidCallback? onRetake;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: BubbaColors.actionDark,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(image: photo, fit: BoxFit.cover),
                ),
              ),
            ),
            BubbaChromeStack(
              builder: (context) => [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: dx(_backX) - d(12),
                      top: d(_backY) - d(12),
                    ),
                    child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onBack,
                    child: Semantics(
                      button: true,
                      label: 'Back',
                      child: Padding(
                        padding: EdgeInsets.all(d(12)),
                        child: CustomPaint(
                          size: Size(d(_backWidth), d(_backHeight)),
                          painter: const _BackArrowPainter(),
                        ),
                      ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: dx(_barX),
                      bottom:
                          d(BubbaMetrics.designHeight - _barY - _barHeight) +
                              bubbaBottomInset(context),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(d(_barRadius)),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(
                          sigmaX: d(_barBlur),
                          sigmaY: d(_barBlur),
                        ),
                        child: Container(
                    width: dxSpan(_barX, _barX),
                    height: d(_barHeight),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1A17)
                          .withValues(alpha: _barTintOpacity),
                      borderRadius: BorderRadius.circular(d(_barRadius)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hd(_retakeX),
                        right: hd(_pillRightInset),
                      ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Baseline(
                          baseline: d(_actionBaseline),
                          baselineType: TextBaseline.alphabetic,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onRetake,
                            child: Semantics(
                              button: true,
                              child: Text(
                                'Retake',
                                style: BubbaText.previewRetake,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: d(_pillY)),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onAdd,
                            child: Semantics(
                              button: true,
                              label: 'Add to profile',
                              child: Container(
                                width: hd(_pillWidth),
                                height: d(_pillHeight),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: BubbaColors.surface,
                                  borderRadius: BorderRadius.circular(
                                    d(_pillHeight / 2),
                                  ),
                                ),
                                child: Text(
                                  'Add to profile',
                                  style: BubbaText.previewAdd,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                    ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BackArrowPainter extends CustomPainter {
  const _BackArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = BubbaColors.surface;
    canvas.drawLine(Offset(w * 0.04, h / 2), Offset(w, h / 2), p);
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.30, h * 0.06)
        ..lineTo(w * 0.04, h / 2)
        ..lineTo(w * 0.30, h * 0.94),
      p,
    );
  }

  @override
  bool shouldRepaint(_BackArrowPainter old) => false;
}
