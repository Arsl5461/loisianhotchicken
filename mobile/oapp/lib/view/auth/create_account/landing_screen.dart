import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/design/bubba_layout.dart';
import '../../../core/design/bubba_text_styles.dart';
import '../../../core/design/bubba_theme.dart';
import '../../../core/design/bubba_tokens.dart';
import 'widgets/bubba_pill_button.dart';
import 'widgets/get_started_sheet.dart';

enum LandingSheet { none, getStarted, welcomeBack }

class LandingScreen extends StatelessWidget {
  const LandingScreen({
    super.key,
    this.onCreateAccount,
    this.onSignIn,
    this.onLegalTap,
    this.onProviderPicked,
    this.sheet = LandingSheet.none,
    this.onDismissSheet,
    this.statusCard,
    this.showDebugBypass = false,
    this.onDebugBypass,
  });

  final void Function(BubbaAuthProvider provider)? onProviderPicked;
  final VoidCallback? onCreateAccount;
  final VoidCallback? onSignIn;
  final void Function(String link)? onLegalTap;
  final LandingSheet sheet;
  final VoidCallback? onDismissSheet;
  final bool showDebugBypass;
  final VoidCallback? onDebugBypass;

  /// The part 3 landing states (p038 delete, p039 pause) reuse this screen and
  /// float a card over the art. The overlay list is canvas-relative, so the
  /// card positions with `dx()` and takes the notch shift itself.
  final Widget? statusCard;

  static const double wordmarkX = 123.2;
  static const double wordmarkY = 123.7;
  static const double wordmarkWidth = 143.4;
  static const double wordmarkHeight = 39.6;

  static const double dashX = 182.1;
  static const double dashY = 191.0;
  static const double dashWidth = 25.7;
  static const double dashStroke = 2;

  static const double ctaY = 676.9;

  static const double signInBaseline = 776.7;
  static const double footerDesignBottom = 825.0;

  Future<void> _openSheet(BuildContext context) async {
    final provider = await showGetStartedSheet(context);
    if (provider != null) onProviderPicked?.call(provider);
  }

  /// The footer is bottom-anchored by [BubbaPage]'s column, so it never needs
  /// moving. What the viewport height still decides is whether the art runs
  /// under the footer copy and therefore needs the scrim behind it.
  static bool _needsScrim(BuildContext context) {
    final media = MediaQuery.of(context);
    return d(footerDesignBottom) + media.padding.bottom > media.size.height;
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
            bleed: (context) => Stack(
              children: [
                const _LandingHero(),
                if (_needsScrim(context)) const _FooterScrim(),
              ],
            ),
            overlay: sheet == LandingSheet.none && statusCard == null
                ? null
                : (context) => [
                    ?statusCard,
                    if (sheet != LandingSheet.none)
                      BubbaSheetOverlay(
                        onDismiss: onDismissSheet,
                        sheet: sheet == LandingSheet.welcomeBack
                            ? GetStartedSheet(
                                title: bubbaWelcomeBackTitle,
                                subtitle: bubbaWelcomeBackSubtitle,
                                onPicked: onProviderPicked ?? (_) {},
                              )
                            : GetStartedSheet(
                                onPicked: onProviderPicked ?? (_) {},
                              ),
                      ),
                  ],
            content: (context, flow) {
              flow.raw(
                Builder(
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BubbaGap(wordmarkY),
                      Align(
                        child: Semantics(
                          label: 'Bubba',
                          child: SvgPicture.asset(
                            'assets/svg/bubba_wordmark_dark.svg',
                            width: hd(wordmarkWidth),
                            height: d(wordmarkHeight),
                          ),
                        ),
                      ),
                      BubbaGap(dashY - wordmarkY - wordmarkHeight),
                      Align(
                        child: Container(
                          width: hd(dashWidth),
                          height: d(dashStroke),
                          decoration: BoxDecoration(
                            color: BubbaColors.actionDark,
                            borderRadius: BorderRadius.circular(d(dashStroke)),
                          ),
                        ),
                      ),
                      BubbaCopy(
                        'Together,\ntoday.',
                        gapAbove: 235.3 - dashY - dashStroke,
                        style: BubbaText.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
            footer: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BubbaPillButton(
                  label: 'Create account',
                  onPressed: onCreateAccount ?? () => _openSheet(context),
                ),
                _SignInLink(onPressed: onSignIn),
                if (showDebugBypass)
                  TextButton(
                    onPressed: onDebugBypass,
                    child: const Text('Skip login (debug only)'),
                  ),
                _LegalText(onLegalTap: onLegalTap),
                BubbaGap(BubbaMetrics.designHeight - footerDesignBottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LandingHero extends StatelessWidget {
  const _LandingHero();

  static const String asset = 'assets/images/bubba_hero_landing.png';

  static const double artY = 39.3044;
  static const double artHeight = 840.72;

  static const Color edgeColor = Color(0xFFFCFCFC);
  static const Key artKey = ValueKey('bubba_landing_hero_art');

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ExcludeSemantics(
        child: ClipRect(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const SizedBox.expand(child: ColoredBox(color: edgeColor)),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (BubbaScale.isWideLayout &&
                      constraints.maxWidth > BubbaScale.availableWidth + 0.5) {
                    return SizedBox.expand(
                      child: Image.asset(asset, key: artKey, fit: BoxFit.fill),
                    );
                  }
                  return Align(
                    alignment: Alignment.topCenter,
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      maxHeight: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(top: d(artY)),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: d(artHeight),
                          child: Image.asset(
                            asset,
                            key: artKey,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterScrim extends StatelessWidget {
  const _FooterScrim();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: d(240),
        width: double.infinity,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  BubbaColors.surface.withValues(alpha: 0),
                  BubbaColors.surface.withValues(alpha: 0.85),
                  BubbaColors.surface,
                ],
                stops: const [0, 0.45, 0.75],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInLink extends StatelessWidget {
  const _SignInLink({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final height = d(
      LandingScreen.signInBaseline -
          LandingScreen.ctaY -
          BubbaPillButton.designHeight,
    );
    final m = bubbaTextMetrics(context, BubbaText.buttonLight);
    final box = BubbaScale.tapBox(m.lineHeight);
    return SizedBox(
      height: height,
      child: OverflowBox(
        maxHeight: box,
        minHeight: box,
        alignment: Alignment.bottomCenter,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: BubbaTapTarget(
            onTap: onPressed,
            label: 'Sign in',
            child: SizedBox(
              height: box,
              child: Align(
                alignment: Alignment.topCenter,
                child: Baseline(
                  baseline: box,
                  baselineType: TextBaseline.alphabetic,
                  child: Text('Sign in', style: BubbaText.buttonLight),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText({this.onLegalTap});

  final void Function(String link)? onLegalTap;

  static const double firstBaseline = 800.6;
  static const double lineHeight = 20;
  static const double measure = 240;

  @override
  Widget build(BuildContext context) {
    final base = BubbaText.legal;
    final link = base.copyWith(decoration: TextDecoration.underline);

    TextSpan tap(String text) =>
        TextSpan(text: text, style: link, recognizer: null);

    return IgnorePointer(
      child: Baseline(
        baseline: d(firstBaseline - LandingScreen.signInBaseline),
        baselineType: TextBaseline.alphabetic,
        child: Align(
          child: SizedBox(
            width: hd(measure),
            child: Text.rich(
              TextSpan(
                style: base,
                children: [
                  const TextSpan(text: 'By continuing, you agree to our '),
                  tap('Terms'),
                  const TextSpan(text: ', '),
                  tap('Privacy'),
                  const TextSpan(text: ', and '),
                  tap('Cookies'),
                  const TextSpan(text: ' Policy. '),
                ],
              ),
              textAlign: TextAlign.center,
              style: base.copyWith(height: lineHeight / (base.fontSize ?? 10)),
            ),
          ),
        ),
      ),
    );
  }
}
