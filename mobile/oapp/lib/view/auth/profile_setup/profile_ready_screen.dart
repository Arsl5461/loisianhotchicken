import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_glyphs.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_tokens.dart';
import '../../../core/design/widgets/bubba_loading.dart';

/// p047 paints its own background rather than the usual #FAF9FA.
const Color _pageBg = Color(0xFFF8F8F8);

const String heroAsset = 'assets/images/bubba_hero_ready.png';

/// The hero is cropped from the artboard at the point its ink stops (design y
/// 484), so the asset maps onto exactly this rect.
const double _heroTop = 51.4;
const double _heroHeight = 432.6;

const double _eyebrowBaseline = 539.54;
const double _headingBaseline = 587.36;
const double _bodyFirstBaseline = 630.26;
const double _bodySecondBaseline = 651.26;

const double _ctaX = 25.15;
const double _ctaRightInset = 390 - (25.15 + 339.70);
const double _ctaY = 736.02;
const double _ctaHeight = 58.0;
const double _ctaRadius = 11.39;

const double _sparkleX = 186.43;
const double _sparkleY = 494.21;
const double _sparkleSize = 21.72;

/// The last step of "building your profile" - artboard p047.
class ProfileReadyScreen extends StatelessWidget {
  const ProfileReadyScreen({
    super.key,
    this.onEnter,
    this.hero,
    this.busy = false,
  });

  final VoidCallback? onEnter;

  /// While the profile is being saved the CTA reads "Saving..." and stops
  /// taking taps, so a second tap cannot post the profile twice.
  final bool busy;

  /// Only golden tests pass this: an asset cannot decode synchronously under
  /// `flutter_test`, so they hand in a `SyncImage` of the same file.
  final ImageProvider? hero;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        resizeToAvoidBottomInset: false,
        body: BubbaPage(
          background: _pageBg,
          bleed: (context) => BubbaCanvasBox(
            child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: d(_heroTop)),
              child: SizedBox(
                height: d(_heroHeight),
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: hero ?? const AssetImage(heroAsset),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
            ),
          ),
          overlay: (context) => const [
            BubbaOverlay(
              x: _sparkleX,
              y: _sparkleY,
              child: BubbaGlyphIcon(
                BubbaGlyphs.readySparkles,
                color: BubbaColors.actionPrimary,
                width: _sparkleSize,
              ),
            ),
          ],
          content: (context, flow) {
            flow.copy(
              'PROFILE COMPLETE',
              baseline: _eyebrowBaseline,
              style: BubbaText.readyEyebrow,
              align: TextAlign.center,
            );
            flow.copy(
              'You\u2019re ready.',
              baseline: _headingBaseline,
              style: BubbaText.readyHeading,
              align: TextAlign.center,
              header: true,
            );
            flow.copy(
              'Welcome to 24 hour dating.',
              baseline: _bodyFirstBaseline,
              style: BubbaText.readyBody,
              align: TextAlign.center,
            );
            flow.copy(
              'Our community revolves around today.',
              baseline: _bodySecondBaseline,
              style: BubbaText.readyBody,
              align: TextAlign.center,
            );
          },
          footer: (context) => Padding(
            padding: EdgeInsets.only(
              left: dx(_ctaX),
              right: BubbaScale.availableWidth - dxRight(_ctaRightInset),
              bottom: d(BubbaMetrics.designHeight - _ctaY - _ctaHeight),
            ),
            child: BubbaTapTarget(
              onTap: busy ? null : onEnter,
              enabled: !busy,
              label: 'Enter Bubba',
              designHeight: _ctaHeight,
              child: Container(
                height: d(_ctaHeight),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BubbaColors.actionDark,
                  borderRadius: BorderRadius.circular(d(_ctaRadius)),
                ),
                child: busy
                    ? const BubbaSpinner(size: 24, color: Colors.white)
                    : Text('Enter Bubba', style: BubbaText.enterBubba),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
