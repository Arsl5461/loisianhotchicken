import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../auth/create_account/bubba_flow_pages.dart' as flow;
import '../auth/create_account/landing_screen.dart';
import 'bubba_settings_controller.dart';
import 'settings_feedback.dart';

const double _cardW = 354;
const double _cardH = 244;
const double _cardRadius = 14.91;
const double _ctaW = 327;
const double _ctaH = 58;
const double _ctaRadius = 7.33;

const double _deletedCardX = 15.81;
const double _deletedCardY = 591.23;

const double _pausedCardX = 16.39;
const double _pausedCardY = 564.73;

const List<String> settingsPausedAssurances = [
  'You won’t appear in discovery',
  'Your matches and chats are safe',
  'Return whenever you’re ready',
];

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.x,
    required this.y,
    required this.children,
  });

  final double x;
  final double y;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: dx(x),
            top: d(y) + bubbaTopShift(context),
          ),
          child: Container(
            width: hd(_cardW),
            height: d(_cardH),
            decoration: BoxDecoration(
              color: BubbaSettingsColors.pageBg,
              borderRadius: BorderRadius.circular(d(_cardRadius)),
              boxShadow: [
                BoxShadow(
                  color: BubbaSettingsColors.rowLabel.withValues(alpha: 0.12),
                  blurRadius: d(18),
                ),
              ],
            ),
            child: Stack(children: children),
          ),
        ),
      );
}

Widget _at(double left, double top, Widget child) => Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: hd(left), top: d(top)),
        child: child,
      ),
    );

Widget _cta({
  required String label,
  required double left,
  required double top,
  required double labelTop,
  required Color fill,
  VoidCallback? onTap,
}) =>
    _at(
      left,
      top,
      BubbaTapTarget(
        onTap: onTap,
        label: label,
        child: Container(
          width: hd(_ctaW),
          height: d(_ctaH),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(d(_ctaRadius)),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: d(labelTop)),
            child: Text(label, style: BubbaSettingsText.landingCardCta),
          ),
        ),
      ),
    );

/// p037. The logged-out landing is part 2's landing screen unchanged.
class SettingsLandingView extends StatelessWidget {
  const SettingsLandingView({super.key, this.onCreateAccount, this.onSignIn});

  final VoidCallback? onCreateAccount;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) => LandingScreen(
        onCreateAccount: onCreateAccount,
        onSignIn: onSignIn,
      );
}

/// p038. Shown after the account is deleted.
class SettingsDeletedLandingView extends StatelessWidget {
  const SettingsDeletedLandingView({
    super.key,
    this.onDone,
    this.onCreateAccount,
    this.onSignIn,
  });

  final VoidCallback? onDone;
  final VoidCallback? onCreateAccount;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.landingCardTitle);
    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.landingCardBody);
    final ctaMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.landingCardCta);

    return LandingScreen(
      onCreateAccount: onCreateAccount,
      onSignIn: onSignIn,
      statusCard: _StatusCard(
        x: _deletedCardX,
        y: _deletedCardY,
        children: [
          _at(
            54.66 - _deletedCardX,
            632.18 - _deletedCardY - titleMetrics.baseline,
            Text(
              'Thank you for being part of our community',
              style: BubbaSettingsText.landingCardTitle,
            ),
          ),
          _at(
            83.43 - _deletedCardX,
            675.29 - _deletedCardY - bodyMetrics.baseline,
            Text(
              'We hope you met someone special',
              style: BubbaSettingsText.landingCardBody,
            ),
          ),
          _at(
            51.45 - _deletedCardX,
            699.29 - _deletedCardY - bodyMetrics.baseline,
            Text(
              'and are always here if you change your mind.',
              style: BubbaSettingsText.landingCardBody,
            ),
          ),
          _cta(
            label: 'Done',
            left: 29.98 - _deletedCardX,
            top: 761.23 - _deletedCardY,
            labelTop: 796.15 - 761.23 - ctaMetrics.baseline,
            fill: BubbaSettingsColors.rowLabel,
            onTap: onDone,
          ),
        ],
      ),
    );
  }
}

/// p039. Shown while the account is paused.
class SettingsPausedLandingView extends StatelessWidget {
  const SettingsPausedLandingView({
    super.key,
    this.onResume,
    this.onLogout,
    this.onCreateAccount,
    this.onSignIn,
  });

  final VoidCallback? onResume;
  final VoidCallback? onLogout;
  final VoidCallback? onCreateAccount;
  final VoidCallback? onSignIn;

  static const List<double> _checkY = [599.72, 631.99, 663.99];
  static const List<double> _checkX = [47.20, 46.88, 45.88];
  static const List<double> _rowBaseline = [610.00, 642.45, 673.45];
  static const List<double> _rowX = [70.32, 71.72, 71.72];

  @override
  Widget build(BuildContext context) {
    final rowMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.landingCardRow);
    final ctaMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.landingCardCta);
    final linkMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.landingCardLink);

    final layers = <Widget>[];
    for (var i = 0; i < settingsPausedAssurances.length; i++) {
      layers.add(_at(
        _checkX[i] - _pausedCardX,
        _checkY[i] - _pausedCardY,
        const BubbaGlyphIcon(
          BubbaSettingsGlyphs.resumeCheck,
          color: BubbaSettingsColors.landingCheck,
          width: 12.32,
          height: 8.82,
        ),
      ));
      layers.add(_at(
        _rowX[i] - _pausedCardX,
        _rowBaseline[i] - _pausedCardY - rowMetrics.baseline,
        Text(
          settingsPausedAssurances[i],
          style: BubbaSettingsText.landingCardRow,
        ),
      ));
    }

    layers.add(_cta(
      label: 'Resume Account',
      left: 30.39 - _pausedCardX,
      top: 703.73 - _pausedCardY,
      labelTop: 738.65 - 703.73 - ctaMetrics.baseline,
      fill: BubbaSettingsColors.resumeFill,
      onTap: onResume,
    ));

    layers.add(_at(
      161.03 - _pausedCardX,
      790.06 - _pausedCardY - linkMetrics.baseline,
      BubbaTapTarget(
        onTap: onLogout,
        label: 'Log out',
        child: Text('Log out', style: BubbaSettingsText.landingCardLink),
      ),
    ));

    return LandingScreen(
      onCreateAccount: onCreateAccount,
      onSignIn: onSignIn,
      statusCard: _StatusCard(
        x: _pausedCardX,
        y: _pausedCardY,
        children: layers,
      ),
    );
  }
}

class BubbaLoggedOutLandingScreen extends StatelessWidget {
  const BubbaLoggedOutLandingScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsLandingView(
        onCreateAccount: _startCreateAccount,
        onSignIn: () => _openSignIn(context),
      );
}

class BubbaDeletedLandingScreen extends StatelessWidget {
  const BubbaDeletedLandingScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsDeletedLandingView(
        onDone: _startCreateAccount,
        onCreateAccount: _startCreateAccount,
        onSignIn: () => _openSignIn(context),
      );
}

class BubbaPausedLandingScreen extends StatelessWidget {
  const BubbaPausedLandingScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsPausedLandingView(
        onResume: () => _resume(),
        onLogout: _startCreateAccount,
        onCreateAccount: _startCreateAccount,
        onSignIn: () => _openSignIn(context),
      );
}

void _startCreateAccount() =>
    Get.offAllNamed(Routes.OPTION_SCREEN);

void _openSignIn(BuildContext context) {
  Get.offAllNamed(Routes.OPTION_SCREEN);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final next = Get.context;
    if (next != null) flow.BubbaFlow.openSignInSheet(next);
  });
}

Future<void> _resume() async {
  final ok = await BubbaSettingsController.to.pauseAccount(false);
  if (!ok) {
    showSettingsError(BubbaSettingsController.to.error.value);
    return;
  }
  Get.offAllNamed(Routes.OPTION_SCREEN);
}
