import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';

class BubbaSplashScreen extends StatelessWidget {
  const BubbaSplashScreen({super.key});

  static const double markX = 176.4;
  static const double markY = 307.6;
  static const double markWidth = 37.0;
  static const double markHeight = 57.1;

  static const double wordmarkX = 147.3;
  static const double wordmarkY = 410.4;
  static const double wordmarkWidth = 95.4;
  static const double wordmarkHeight = 26.3;

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
          body: Semantics(
            label: 'Bubba',
            child: BubbaPage(
              background: BubbaColors.surface,
              scrollable: false,
              content: (context, flow) {
                flow.block(
                  Align(
                    child: SvgPicture.asset(
                      'assets/svg/bubba_logo_mark.svg',
                      width: hd(markWidth),
                      height: d(markHeight),
                    ),
                  ),
                  top: markY,
                  height: markHeight,
                );
                flow.block(
                  Align(
                    child: SvgPicture.asset(
                      'assets/svg/bubba_logo_wordmark.svg',
                      width: hd(wordmarkWidth),
                      height: d(wordmarkHeight),
                    ),
                  ),
                  top: wordmarkY,
                  height: wordmarkHeight,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
