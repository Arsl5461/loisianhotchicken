import 'package:OApp/widgets/Images/Base64OrNetworkImage.dart';
import 'package:flutter/material.dart';

class HeartWidget extends StatelessWidget {
  final Function()? onTap;
  final double heartBorderWidth;
  final double circleBorderWidth;
  final double innerCircleScale;
  final double size;
  final double? width;
  final Color circleBorderColor;
  final Color heartBorderColor;
  final Color backgroundColor;

  const HeartWidget({
    this.size = 60,
    this.width,
    super.key,
    this.onTap,
    this.heartBorderWidth = 3,
    this.circleBorderWidth = 4,
    this.innerCircleScale = 0.85,
    this.circleBorderColor = const Color(0xFFD7D1CC),
    this.heartBorderColor = Colors.white,
    this.backgroundColor = const Color(0xFFBFB8B3),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          height: size,
          width: width ?? size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(
              color: circleBorderColor,
              width: circleBorderWidth,
            ),
          ),
          child: Base64OrNetworkImage(
            imageData: 'assets/svg/heart.svg',

            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class HeartIconPainter extends CustomPainter {
  final double heartBorderWidth;
  final double circleBorderWidth;
  final double innerCircleScale;

  final Color circleBorderColor;
  final Color heartBorderColor;
  final Color backgroundColor;

  HeartIconPainter({
    required this.heartBorderWidth,
    required this.circleBorderWidth,
    required this.innerCircleScale,
    required this.circleBorderColor,
    required this.heartBorderColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    /// Outer Circle Border
    final circlePaint = Paint()
      ..color = circleBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleBorderWidth;

    canvas.drawCircle(center, radius - circleBorderWidth / 2, circlePaint);

    /// Background Circle
    final innerCirclePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * innerCircleScale, innerCirclePaint);

    /// Heart Border
    final heartPaint = Paint()
      ..color = heartBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = heartBorderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();

    path.moveTo(w * 0.5, h * 0.69);

    path.cubicTo(w * 0.2, h * 0.50, w * 0.25, h * 0.32, w * 0.4, h * 0.32);

    path.cubicTo(w * 0.5, h * 0.32, w * 0.5, h * 0.40, w * 0.5, h * 0.34);

    path.cubicTo(w * 0.5, h * 0.40, w * 0.5, h * 0.32, w * 0.6, h * 0.32);

    path.cubicTo(w * 0.75, h * 0.32, w * 0.8, h * 0.50, w * 0.5, h * 0.69);

    canvas.drawPath(path, heartPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
