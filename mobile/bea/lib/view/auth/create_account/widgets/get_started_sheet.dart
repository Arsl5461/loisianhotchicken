import 'package:flutter/material.dart';

import '../../../../utils/platform_support.dart';
import '../../../../core/design/bubba_layout.dart';
import '../../../../core/design/bubba_text_styles.dart';
import '../../../../core/design/bubba_tokens.dart';
import 'bubba_provider_row.dart';

enum BubbaAuthProvider { phone, email, apple, google }

const String bubbaWelcomeBackTitle = 'Welcome back';
const String bubbaWelcomeBackSubtitle = 'Continue where you left off.';

Future<BubbaAuthProvider?> showGetStartedSheet(
  BuildContext context, {
  String title = 'Let’s get started',
  String subtitle = 'Select the easiest way to get started',
  Set<BubbaAuthProvider> exclude = const {},
  String? footerLabel,
  String? footerCaption,
  VoidCallback? onFooter,
}) {
  return showModalBottomSheet<BubbaAuthProvider>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: BubbaColors.scrim,
    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
    builder: (context) => GetStartedSheet(
      title: title,
      subtitle: subtitle,
      exclude: exclude,
      footerLabel: footerLabel,
      footerCaption: footerCaption,
      onFooter: onFooter,
    ),
  );
}

class BubbaSheetOverlay extends StatelessWidget with BubbaWindowOverlay {
  const BubbaSheetOverlay({super.key, required this.sheet, this.onDismiss});

  final GetStartedSheet sheet;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SizedBox.expand(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: const ColoredBox(color: BubbaColors.scrim),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: sheet),
        ],
      );
}

Future<BubbaAuthProvider?> showSignInAnotherWaySheet(
  BuildContext context, {
  required BubbaAuthProvider current,
  Set<BubbaAuthProvider> exclude = const {},
  VoidCallback? onRecover,
}) {
  return showGetStartedSheet(
    context,
    title: 'Sign in another way',
    subtitle: 'Choose a method connected to your account.',
    exclude: {current, ...exclude},
    footerLabel: 'Recover your account',
    footerCaption: 'Use this if you can’t access any linked method',
    onFooter: onRecover,
  );
}

class GetStartedSheet extends StatelessWidget {
  const GetStartedSheet({
    super.key,
    this.title = 'Let’s get started',
    this.subtitle = 'Select the easiest way to get started',
    this.exclude = const {},
    this.footerLabel,
    this.footerCaption,
    this.onFooter,
    this.onPicked,
  });

  final String title;
  final String subtitle;
  final Set<BubbaAuthProvider> exclude;
  final String? footerLabel;
  final String? footerCaption;
  final VoidCallback? onFooter;

  final ValueChanged<BubbaAuthProvider>? onPicked;

  static const double sheetTop = 371.8;
  static const double footerSheetTop = 359.75;
  static const double footerSheetBottom = BubbaMetrics.designHeight;
  static const double sheetRadius = 20;
  static const double grabberWidth = 32.8;
  static const double grabberHeight = 3;
  static const double grabberInset = 13.5;
  static const double footerGrabberInset = 15.1;

  static const double titleInset = 79.2;
  static const double subtitleInset = 113.5;
  static const double firstRowInset = 141.5;
  static const double footerFirstRowInset = 157.4;
  static const double rowGap = 18.43;
  static const double firstRowGap = 13.62;
  static const double bottomPadding = 51.17;

  static const double footerLinkInset = 405.5;
  static const double footerCaptionInset = 430.9;

  bool get _hasFooter => footerLabel != null || footerCaption != null;

  double get _firstRowInset => _hasFooter ? footerFirstRowInset : firstRowInset;

  @override
  Widget build(BuildContext context) => BubbaTextDefaults(
    child: BubbaSheetCanvas(builder: _build),
  );

  Widget _build(BuildContext context) {
    final rows = <({String label, String asset, double w, double h, bool filled, bool tint, BubbaAuthProvider value})>[
      (
        label: 'Continue with phone',
        asset: 'assets/svg/bubba_phone.svg',
        w: 14.8,
        h: 14.9,
        filled: true,
        tint: true,
        value: BubbaAuthProvider.phone,
      ),
      (
        label: 'Continue with email',
        asset: 'assets/svg/bubba_email.svg',
        w: 13.6,
        h: 10.2,
        filled: false,
        tint: true,
        value: BubbaAuthProvider.email,
      ),
      (
        label: 'Continue with apple',
        asset: 'assets/svg/bubba_apple.svg',
        w: 13.05,
        h: 16.0,
        filled: false,
        tint: true,
        value: BubbaAuthProvider.apple,
      ),
      (
        label: 'Continue with Google',
        asset: 'assets/svg/bubba_google.svg',
        w: 14.7,
        h: 14.7,
        filled: false,
        tint: false,
        value: BubbaAuthProvider.google,
      ),
    ]
        .where((row) => !exclude.contains(row.value))
        .where(
          (row) =>
              row.value != BubbaAuthProvider.apple || appleSignInSupported,
        )
        .toList();

    final leadGap = rows.first.filled ? firstRowGap : rowGap;
    double rowTop(int index) =>
        _firstRowInset +
        index * BubbaProviderRow.height +
        (index > 0 ? leadGap + (index - 1) * rowGap : 0);

    final lastRowBottom =
        rowTop(rows.length - 1) + BubbaProviderRow.height;
    final sheetHeight = _hasFooter
        ? footerSheetBottom - footerSheetTop
        : lastRowBottom + bottomPadding;

    return SizedBox(
      height: d(sheetHeight) + bubbaBottomInset(context),
      child: Container(
        decoration: BoxDecoration(
          color: BubbaColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(d(sheetRadius)),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: BubbaScale.canvasOffset),
          child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: d(_hasFooter ? footerGrabberInset : grabberInset),
                ),
                child: Container(
                  width: hd(grabberWidth),
                  height: d(grabberHeight),
                  decoration: BoxDecoration(
                    color: BubbaColors.actionDark,
                    borderRadius: BorderRadius.circular(d(grabberHeight)),
                  ),
                ),
              ),
            ),
            BubbaOverlayText(
              title,
              x: 23.7,
              baseline: titleInset,
              style: BubbaText.displayMedium,
            ),
            BubbaOverlayText(
              subtitle,
              x: 29.3,
              baseline: subtitleInset,
              style: BubbaText.bodyLarge.copyWith(color: BubbaColors.actionDark),
            ),
            for (var i = 0; i < rows.length; i++)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: dx(29.9),
                    right: BubbaScale.availableWidth -
                        dxRight(BubbaMetrics.pageInsetRight - 6.2),
                    top: d(rowTop(i)),
                  ),
                  child: BubbaProviderRow(
                  label: rows[i].label,
                  iconAsset: rows[i].asset,
                  iconWidth: rows[i].w,
                  iconHeight: rows[i].h,
                  filled: rows[i].filled,
                  tintIcon: rows[i].tint,
                    onPressed: onPicked != null
                        ? () => onPicked!(rows[i].value)
                        : () => Navigator.of(context).pop(rows[i].value),
                  ),
                ),
              ),
            if (footerLabel != null)
              _SheetCentredText(
                text: footerLabel!,
                baseline: footerLinkInset,
                style: BubbaText.link,
                onTap: () {
                  if (onPicked == null) Navigator.of(context).pop();
                  onFooter?.call();
                },
              ),
            if (footerCaption != null)
              _SheetCentredText(
                text: footerCaption!,
                baseline: footerCaptionInset,
                style: BubbaText.body,
              ),
          ],
          ),
        ),
      ),
    );
  }
}

class _SheetCentredText extends StatelessWidget {
  const _SheetCentredText({
    required this.text,
    required this.baseline,
    required this.style,
    this.onTap,
  });

  final String text;
  final double baseline;
  final TextStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      width: BubbaScale.availableWidth,
      child: Text(text, textAlign: TextAlign.center, style: style),
    );
    if (onTap != null) {
      content = Semantics(
        button: true,
        label: text,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: d(12)),
            child: content,
          ),
        ),
      );
    } else {
      content = IgnorePointer(child: content);
    }
    return Align(
      alignment: Alignment.topLeft,
      child: Baseline(
        baseline: d(baseline),
        baselineType: TextBaseline.alphabetic,
        child: content,
      ),
    );
  }
}
