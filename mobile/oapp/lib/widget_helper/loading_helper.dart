import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:OApp/core/constants/app_colors.dart';

class CallLoadingHelper {
  static void show({String text = "Please wait..."}) {
    if (Get.isDialogOpen == true) Get.back();

    Get.dialog(
      Center(
        child: Material(
          color: AppColors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  color: AppColors.black.withValues(alpha: 0.15),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.cFF006C6A,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.35),
    );
  }

  static void hide() {
    if (Get.isDialogOpen == true) {
      final ctx = Get.overlayContext;
      if (ctx != null) {
        Navigator.of(ctx).pop(); // ✅ pops only dialog overlay
      } else {
        // fallback
        Get.back();
      }
    }
  }

  /// Optional: call before navigation if you want to force-close everything
  static void hideAll() {
    if (Get.isDialogOpen == true) {
      Get.back(); // for older versions
    }
  }
}

class UploadProgressDialog {
  static void show({
    required RxString title,
    required RxInt currentStep,
    required RxInt totalStep,
    required RxDouble progress,
    bool barrierDismissible = false,
    VoidCallback? onClose,
  }) {
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    Get.dialog(
      PopScope(
        canPop: barrierDismissible,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            hide();
                            onClose?.call();
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.cloud_upload,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title.value,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${currentStep.value} of ${totalStep.value}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: progress.value.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE5E5E5),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF111111),
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
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.black.withValues(alpha: 0.20),
    );
  }

  static void hide() {
    if (Get.isDialogOpen == true) {
      final ctx = Get.overlayContext;
      if (ctx != null) {
        Navigator.of(ctx).pop();
      } else {
        Get.back();
      }
    }
  }
}

class GradientIndeterminateProgressBar extends StatefulWidget {
  double height;

  GradientIndeterminateProgressBar({super.key, this.height = 10});

  @override
  State<GradientIndeterminateProgressBar> createState() =>
      _GradientIndeterminateProgressBarState();
}

class _GradientIndeterminateProgressBarState
    extends State<GradientIndeterminateProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Infinite loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Rounded edges
      child: Container(
        height: widget.height,
        color: Colors.grey[200], // Background color
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.3, // width of the moving gradient bar
              child: Transform.translate(
                offset: Offset(
                  _controller.value * MediaQuery.of(context).size.width,
                  0,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.cFF006C6A,
                        AppColors.c185755,
                        AppColors.white,
                        AppColors.white,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GradientProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double height;

  const GradientProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200], // background
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  width: constraints.maxWidth * progress,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.cFF006C6A,
                        AppColors.c185755,
                        AppColors.white,
                        AppColors.white,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final double ringWidth;
  final Color ringColor;

  ProgressRingPainter({
    required this.progress,
    required this.ringWidth,
    required this.ringColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - ringWidth) / 2;

    // Draw the progress arc
    final paint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..strokeCap = StrokeCap.round;

    // Draw 75% of the circle starting from bottom exact center
    // Start from bottom center (90° or π/2)
    // Draw 270° clockwise through left side
    // To end at top-right (315°), we calculate: 315° - 270° = 45°
    // But user wants to start at bottom (90°), so we'll start at 90° and
    // the ring will pass through left (180°) and end near right (0°)
    // Gap (0° to 90°) includes bottom-right (45°) where badge is
    final sweepAngle =
        2 * math.pi * progress; // 270 degrees in radians (75% of circle)
    final startAngle =
        math.pi / 2; // Start from bottom exact center (90 degrees)
    // Drawing 270° clockwise from 90°: 90° (bottom) → 180° (left) → 270° (top) → 0° (right)
    // This passes through left side as required
    // Gap (0° to 90°) includes bottom-right area where badge is located

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringWidth != ringWidth ||
        oldDelegate.ringColor != ringColor;
  }
}
