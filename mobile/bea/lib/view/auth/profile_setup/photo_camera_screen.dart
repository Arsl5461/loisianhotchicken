import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_loading.dart';

// p010 is a 382.57x851.66 artboard; scaled by 390/382.57 and 843/851.66.
const double _closeX = 26.46;
const double _closeY = 69.02;
const double _closeSize = 14.23;
const double _flashX = 350.85;
const double _flashY = 65.84;
const double _shutterRingX = 158.69;
const double _shutterRingY = 735.06;
const double _shutterRing = 71.24;
const double _shutterInner = 64.10;
const double _thumbX = 17.65;
const double _thumbY = 740.89;
const double _thumbWidth = 61.06;
const double _thumbHeight = 60.69;
const double _thumbRadius = 6.13;
const double _flipX = 318.38;
const double _flipY = 753.10;
const double _flipWidth = 32.88;
const double _flipHeight = 35.56;

/// Artboard p010 - the in-app camera.
///
/// The viewfinder is a full-bleed [preview] over black; every control is drawn
/// on top of it, which is why this screen does not use the page background.
class PhotoCameraScreen extends StatelessWidget {
  const PhotoCameraScreen({
    super.key,
    this.preview,
    this.previewChild,
    this.lastShot,
    this.flashOn = false,
    this.onClose,
    this.onToggleFlash,
    this.onShutter,
    this.onFlipCamera,
    this.onOpenLibrary,
  });

  /// The live camera texture. Null renders the black viewfinder.
  final ImageProvider? preview;

  /// The plugin's own viewfinder widget. Takes precedence over [preview],
  /// which the goldens use to record a still frame.
  final Widget? previewChild;

  /// The most recent photo, shown in the bottom-left corner.
  final ImageProvider? lastShot;
  final bool flashOn;
  final VoidCallback? onClose;
  final VoidCallback? onToggleFlash;
  final VoidCallback? onShutter;
  final VoidCallback? onFlipCamera;
  final VoidCallback? onOpenLibrary;

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
              child: previewChild ??
                  (preview == null
                      ? const ColoredBox(
                          color: BubbaColors.actionDark,
                          child: Center(
                            child: BubbaSpinner(size: 28, color: Colors.white),
                          ),
                        )
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: preview!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
            ),
            BubbaChromeStack(
              builder: (context) => [
                _tap(
                  left: dx(_closeX) - d(12),
                  top: d(_closeY) - d(12),
                  label: 'Close camera',
                  onTap: onClose,
                  child: Padding(
                    padding: EdgeInsets.all(d(12)),
                    child: BubbaCross(
                      size: _closeSize,
                      strokeWidth: 2.751,
                      color: BubbaColors.surface,
                    ),
                  ),
                ),
                _tap(
                  left: dx(_flashX) - d(12),
                  top: d(_flashY) - d(12),
                  label: flashOn ? 'Flash on' : 'Flash off',
                  onTap: onToggleFlash,
                  child: Padding(
                    padding: EdgeInsets.all(d(12)),
                    child: CustomPaint(
                      size: Size(d(13.78), d(20.46)),
                      painter: _FlashPainter(on: flashOn),
                    ),
                  ),
                ),
                _tap(
                  left: dx(_thumbX),
                  top: d(_thumbY),
                  label: 'Open library',
                  onTap: onOpenLibrary,
                  child: Container(
                    width: hd(_thumbWidth),
                    height: d(_thumbHeight),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(d(_thumbRadius)),
                      border: Border.all(
                        color: const Color(0xFFB7B7B7),
                        width: 1,
                      ),
                      image: lastShot == null
                          ? null
                          : DecorationImage(
                              image: lastShot!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                _tap(
                  left: dx(_shutterRingX),
                  top: d(_shutterRingY),
                  label: 'Take photo',
                  onTap: onShutter,
                  child: Container(
                    width: d(_shutterRing),
                    height: d(_shutterRing),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFECECEC),
                        width: d(2),
                      ),
                    ),
                    child: Container(
                      width: d(_shutterInner),
                      height: d(_shutterInner),
                      decoration: const BoxDecoration(
                        color: Color(0xFFECECEC),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                _tap(
                  left: dx(_flipX) - d(10),
                  top: d(_flipY) - d(10),
                  label: 'Flip camera',
                  onTap: onFlipCamera,
                  child: Padding(
                    padding: EdgeInsets.all(d(10)),
                    child: const BubbaGlyphIcon(
                      BubbaGlyphs.flipCamera,
                      color: BubbaColors.surface,
                      width: _flipWidth,
                      height: _flipHeight,
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

  Widget _tap({
    required double left,
    required double top,
    required String label,
    required Widget child,
    VoidCallback? onTap,
  }) => Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: EdgeInsets.only(left: left, top: top),
      child: BubbaTapTarget(onTap: onTap, label: label, child: child),
    ),
  );
}

class _FlashPainter extends CustomPainter {
  const _FlashPainter({required this.on});

  final bool on;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bolt = Path()
      ..moveTo(w * 0.62, 0)
      ..lineTo(w * 0.08, h * 0.56)
      ..lineTo(w * 0.44, h * 0.56)
      ..lineTo(w * 0.36, h)
      ..lineTo(w * 0.94, h * 0.42)
      ..lineTo(w * 0.56, h * 0.42)
      ..close();
    canvas.drawPath(
      bolt,
      Paint()
        ..style = on ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = w * 0.11
        ..strokeJoin = StrokeJoin.round
        ..color = BubbaColors.surface,
    );
  }

  @override
  bool shouldRepaint(_FlashPainter old) => old.on != on;
}

