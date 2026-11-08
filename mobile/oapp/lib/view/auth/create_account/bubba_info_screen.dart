import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_icons.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/bubba_cta_button.dart';

class BubbaIllustration {
  const BubbaIllustration({
    required this.asset,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final String asset;
  final double x;
  final double y;
  final double width;
  final double height;
}

class BubbaInfoScreen extends StatelessWidget {
  const BubbaInfoScreen({
    super.key,
    required this.heading,
    required this.body,
    required this.ctaLabel,
    required this.illustration,
    this.secondaryLabel,
    this.onCta,
    this.onSecondary,
    this.showBack = true,
    this.centred = false,
    this.headingBaseline = 127.7,
    this.headingLines = 1,
    this.bodyBaseline = 204.3,
    this.bodyLines = 2,
    this.secondaryBaseline = 729.6,
    this.ctaY = 747.3,
  });

  final String heading;
  final String body;
  final String ctaLabel;
  final BubbaIllustration illustration;
  final String? secondaryLabel;
  final VoidCallback? onCta;
  final VoidCallback? onSecondary;
  final bool showBack;
  final bool centred;
  final double headingBaseline;
  final int headingLines;
  final double bodyBaseline;
  final int bodyLines;
  final double secondaryBaseline;
  final double ctaY;

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
                if (secondaryLabel != null)
                  BubbaFooterLink(
                    secondaryLabel!,
                    baseline: secondaryBaseline,
                    ctaY: ctaY,
                    style: BubbaText.link,
                    onTap: onSecondary,
                  ),
                BubbaCtaButton(
                  label: ctaLabel,
                  enabled: true,
                  onPressed: onCta,
                  designY: ctaY,
                ),
              ],
            ),
            content: (context, flow) {
              if (showBack) {
                flow.block(
                  BubbaTapTarget(
                    onTap: () => Navigator.of(context).maybePop(),
                    label: 'Back',
                    child: Padding(
                      padding: EdgeInsets.all(d(18)),
                      child: const BubbaChevronLeft(),
                    ),
                  ),
                  top: 44.92 - 18,
                  height: BubbaMetrics.backIconHeight + 36,
                  left: BubbaMetrics.backChevronX - 18,
                );
              }
              flow.copy(
                heading,
                baseline: headingBaseline,
                style: BubbaText.displayLargeAlt,
                align: centred ? TextAlign.center : null,
                left: centred ? null : 15.4,
                lines: headingLines,
              );
              flow.copy(
                body,
                baseline: bodyBaseline,
                style: BubbaText.body,
                align: centred ? TextAlign.center : null,
                left: centred ? null : 19.2,
                lines: bodyLines,
              );
              flow.bleed(
                BubbaInset(
                  left: illustration.x,
                  child: SizedBox(
                    width: hd(illustration.width),
                    height: d(illustration.height),
                    child: ExcludeSemantics(
                      child: Image.asset(illustration.asset, fit: BoxFit.fill),
                    ),
                  ),
                ),
                top: illustration.y,
                height: illustration.height,
              );
            },
          ),
        ),
      ),
    );
  }
}
