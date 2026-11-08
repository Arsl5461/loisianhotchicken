import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';

class SigningInScreen extends StatefulWidget {
  const SigningInScreen({
    super.key,
    this.title = 'Signing you in..',
    this.message = 'This will only take a moment.',
    this.animate = true,
    this.duration = const Duration(milliseconds: 2400),
    this.staticProgress = 0.5,
  });

  final String title;
  final String message;
  final bool animate;
  final Duration duration;
  final double staticProgress;

  static const double ringSize = 133.3;
  static const double ringStroke = 3;

  static const double markWidth = 37.0;
  static const double markHeight = 57.1;

  static const double blockHeight = 236.4;
  static const double titleBaseline = 199.1;
  static const double messageBaseline = 233.4;
  static const double blockTopBias = 0.3823;

  @override
  State<SigningInScreen> createState() => _SigningInScreenState();
}

class _SigningInScreenState extends State<SigningInScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animate) {
      _progress.forward();
    } else {
      _progress.value = widget.staticProgress;
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: BubbaTheme.light,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: BubbaColors.surface,
          body: BubbaPage(
            background: BubbaColors.surface,
            scrollable: false,
            bleed: (context) => BubbaCanvasBox(child: _block()),
            content: (context, flow) {},
          ),
        ),
      ),
    );
  }

  Widget _block() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = d(SigningInScreen.blockHeight);
        final free = math.max(0.0, constraints.maxHeight - height);
        return Padding(
          padding: EdgeInsets.only(top: free * SigningInScreen.blockTopBias),
          child: SizedBox(
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _ring(),
                ),
                _line(
                  widget.title,
                  SigningInScreen.titleBaseline,
                  BubbaText.displayMedium,
                  liveRegion: true,
                ),
                _line(
                  widget.message,
                  SigningInScreen.messageBaseline,
                  BubbaText.bodyLarge.copyWith(color: BubbaColors.actionDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ring() {
    return SizedBox(
      width: d(SigningInScreen.ringSize),
      height: d(SigningInScreen.ringSize),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, child) => CustomPaint(
                painter: _ProgressRingPainter(
                  progress: Curves.easeInOut.transform(_progress.value),
                  strokeWidth: d(SigningInScreen.ringStroke),
                ),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/svg/bubba_logo_mark.svg',
            width: hd(SigningInScreen.markWidth),
            height: d(SigningInScreen.markHeight),
          ),
        ],
      ),
    );
  }

  Widget _line(
    String text,
    double baseline,
    TextStyle style, {
    bool liveRegion = false,
  }) {
    Widget label = Text(text, textAlign: TextAlign.center, style: style);
    if (liveRegion) {
      label = Semantics(liveRegion: true, child: label);
    }
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: BubbaScale.contentLeft),
        child: IgnorePointer(
          child: Baseline(
            baseline: d(baseline),
            baselineType: TextBaseline.alphabetic,
            child: SizedBox(width: BubbaScale.contentWidth, child: label),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
  });

  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = const Color(0xFFEAEAEA),
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      progress.clamp(0.0, 1.0) * math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = BubbaColors.brandGreenDark,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) => old.progress != progress;
}
