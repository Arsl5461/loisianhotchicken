import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/typography/app_text_styles.dart';

class ChatMatchTimer extends StatelessWidget {
  final Duration? remaining;
  final int totalMinutes;
  final double size;
  final double strokeWidth;
  final Color normalProgressColor;
  final Color expiredProgressColor;
  final Color trackColor;
  final Color textColor;
  final double fontSize;

  /// Optional widget to display instead of the default time text
  final Widget? child;

  const ChatMatchTimer({
    super.key,
    required this.remaining,
    this.totalMinutes = 30,
    this.size = 42,
    this.strokeWidth = 3,
    required this.normalProgressColor,
    required this.expiredProgressColor,
    required this.trackColor,
    required this.textColor,
    this.fontSize = 10,
    this.child,
  });

  String _format(Duration duration) {
    final abs = duration.isNegative ? duration.abs() : duration;
    final hours = abs.inHours.toString().padLeft(2, '0');
    final minutes = (abs.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    final value = remaining ?? Duration.zero;
    final isExpired = value.isNegative;

    final totalSeconds = totalMinutes * 60;
    final remainingSeconds = value.inSeconds.abs();

    final safeProgress = isExpired
        ? 1.0
        : (remainingSeconds / totalSeconds).clamp(0.0, 1.0);

    final progress = isExpired ? 1.0 : safeProgress;
    final progressColor = isExpired
        ? expiredProgressColor
        : normalProgressColor;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _ChatMatchTimerPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              trackColor: trackColor,
              progressColor: progressColor,
            ),
          ),
          child ??
              Text(
                _format(value),
                style: AppTextStyles.verySmall(
                  fontWeight: AppFontWeight.semi,
                ).copyWith(color: textColor, fontSize: fontSize),
              ),
        ],
      ),
    );
  }
}

class _ChatMatchTimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  _ChatMatchTimerPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      -(2 * math.pi * progress),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ChatMatchTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
