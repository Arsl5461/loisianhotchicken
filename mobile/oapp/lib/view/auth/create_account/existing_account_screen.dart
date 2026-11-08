import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/bubba_cta_button.dart';

class ExistingAccountScreen extends StatelessWidget {
  const ExistingAccountScreen({
    super.key,
    required this.identifier,
    this.onContinue,
    this.onUseDifferent,
    this.secondaryLabel = 'Use a different number',
  });

  final String identifier;
  final VoidCallback? onContinue;
  final VoidCallback? onUseDifferent;
  final String secondaryLabel;

  static const double badgeX = 153.7;
  static const double badgeY = 220.6;
  static const double badgeSize = 21.4;

  static const double _badgeGap = 15.35;

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
          backgroundColor: BubbaColors.screenBg,
          body: BubbaPage(
            footerBand: BubbaMetrics.buttonBottomOffset,
            footer: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BubbaFooterLink(
                  secondaryLabel,
                  baseline: 720.8,
                  ctaY: 743.5,
                  style: BubbaText.link,
                  onTap: onUseDifferent,
                ),
                BubbaCtaButton(
                  label: 'Continue',
                  enabled: true,
                  onPressed: onContinue,
                  designY: 743.5,
                ),
              ],
            ),
            content: (context, flow) {
              flow.block(
                BubbaTapTarget(
                  onTap: () => Navigator.of(context).maybePop(),
                  label: 'Back',
                  child: Padding(
                    padding: EdgeInsets.all(d(18)),
                    child: const BubbaChevronLeft(),
                  ),
                ),
                top: 53.5 - 18,
                height: BubbaMetrics.backIconHeight + 36,
                left: BubbaMetrics.backChevronXContent - 18,
              );
              flow.copy(
                'Welcome back.',
                baseline: 138.9,
                style: BubbaText.displayLarge,
                left: 21.6,
              );
              flow.copy(
                'This number is connected to an existing\n'
                'Bubba account. We\u2019ll sign you in instead.',
                baseline: 178.4,
                style: BubbaText.body,
                left: 23.4,
                right: 145,
                lines: 2,
              );
              flow.block(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Baseline(
                      baseline: d(235.5 - badgeY),
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        identifier,
                        style: BubbaText.buttonLight,
                      ),
                    ),
                    SizedBox(width: hd(_badgeGap)),
                    SvgPicture.asset(
                      'assets/svg/bubba_verified.svg',
                      width: d(badgeSize),
                      height: d(badgeSize),
                    ),
                  ],
                ),
                top: badgeY,
                height: badgeSize,
                left: 25.3,
              );
            },
          ),
        ),
      ),
    );
  }
}
