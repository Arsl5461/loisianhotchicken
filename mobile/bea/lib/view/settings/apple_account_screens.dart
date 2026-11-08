import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import 'blocked_users_screen.dart';
import '../../services/firebaseauth_service.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'widgets/security_chrome.dart';

const String securityAppleIdKey = 'security.apple.id';
const String securityAppleConnectedOnKey = 'security.apple.connectedOn';

const SecurityHeroCircle _appleHero = SecurityHeroCircle(
  glyph: BubbaSecurityGlyphs.apple,
  glyphX: 185.58,
  glyphY: 137.19,
  glyphWidth: 18.57,
  glyphHeight: 22.77,
);

class BubbaConnectAppleScreen extends StatefulWidget {
  const BubbaConnectAppleScreen({super.key});

  @override
  State<BubbaConnectAppleScreen> createState() => _BubbaConnectAppleScreenState();
}

class _BubbaConnectAppleScreenState extends State<BubbaConnectAppleScreen> {
  final GetStorage _box = GetStorage();
  bool _busy = false;

  /// `_busy` is the double-tap guard: the sheet takes seconds to appear and a
  /// second tap would open a second Apple flow.
  Future<void> _connect() async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      final credential =
          await Get.find<FirebaseAuthService>().signInWithApple();
      final key = credential?.user?.uid;

      if (key == null || key.isEmpty) {
        showSettingsError('Apple did not return an account.');
        if (mounted) setState(() => _busy = false);
        return;
      }

      final controller = BubbaSecurityController.to;
      final ok = await controller.setAppleKey(key);
      if (!ok) {
        showSettingsError(controller.error.value);
        if (mounted) setState(() => _busy = false);
        return;
      }

      await _box.write(
        securityAppleConnectedOnKey,
        DateTime.now().toIso8601String(),
      );
      await _box.write(
        securityAppleIdKey,
        credential?.user?.email ?? 'Apple ID',
      );
      if (mounted) Get.back();
    } catch (error) {
      showSettingsError('Could not connect Apple. Try again.');
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ConnectAppleView(
        busy: _busy,
        onBack: Get.back,
        onConnect: _connect,
      );
}

class ConnectAppleView extends StatelessWidget {
  const ConnectAppleView({
    super.key,
    this.busy = false,
    this.onBack,
    this.onConnect,
  });

  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Apple',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      _appleHero,
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Connect Apple', baseline: 230.85);
    securityLead(
      context,
      flow,
      const [
        'Connect your Apple account',
        'to sign in faster and keep your',
        'account secure.',
      ],
      firstBaseline: 262.35,
    );

    flow.block(
      SecurityValueCard(
        top: 378.50,
        height: 94,
        cardX: 28.08,
        pairs: [
          SecurityValuePair(
            label: 'More security. Less hassle.',
            labelBaseline: 417.30,
            labelStyle: BubbaSecurityText.rowTitle,
            value: 'Use your apple account to sign in\nquickly and securely.',
            valueBaseline: 440.91,
            valueStyle: BubbaSecurityText.rowSubtitle.copyWith(
              height: BubbaSecurityMetrics.subtitlePitchTight / 12,
            ),
            x: 53.23,
          ),
        ],
      ),
      top: 378.50,
      height: 94,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Connect with Apple',
        y: 737.80,
        labelBaseline: 772.72,
        leading: const BubbaGlyphIcon(
          BubbaSecurityGlyphs.apple,
          color: BubbaSecurityColors.onDark,
          width: 14.76,
          height: 18.11,
        ),
        leadingY: 756.98,
        leadingGap: 9.84,
        enabled: !busy,
        onTap: onConnect,
      ),
      top: 737.80,
      height: BubbaSecurityMetrics.ctaHeight,
    );
  }
}

class BubbaAppleAccountScreen extends StatefulWidget {
  const BubbaAppleAccountScreen({super.key});

  @override
  State<BubbaAppleAccountScreen> createState() => _BubbaAppleAccountScreenState();
}

class _BubbaAppleAccountScreenState extends State<BubbaAppleAccountScreen> {
  final GetStorage _box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSecurityController.to;
    final connectedOn = DateTime.tryParse(
      (_box.read(securityAppleConnectedOnKey) as String?) ?? '',
    );

    return Obx(() => AppleAccountView(
          appleId: (_box.read(securityAppleIdKey) as String?) ?? controller.email,
          connectedOn: connectedOn,
          connectedMeta: '',
          onBack: Get.back,
          onDisconnect: () async {
            await Get.to(() => const BubbaDisconnectAppleScreen());
            if (!mounted) return;
            if (!controller.appleConnected) Get.back();
          },
        ));
  }
}

class AppleAccountView extends StatelessWidget {
  const AppleAccountView({
    super.key,
    this.appleId = 'alex@gmail.com',
    this.connectedOn,
    this.connectedMeta = 'Connected on May 10, 2026',
    this.onBack,
    this.onDisconnect,
  });

  final String appleId;
  final DateTime? connectedOn;
  final String connectedMeta;
  final VoidCallback? onBack;
  final VoidCallback? onDisconnect;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Apple',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      _appleHero,
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Apple Account', baseline: 230.85);
    securityLead(
      context,
      flow,
      const ['You’ve signed in to Bubba', 'with Apple'],
      firstBaseline: 262.35,
    );

    final date = connectedOn;
    flow.block(
      SecurityValueCard(
        top: 378.50,
        height: 94,
        cardX: 28.08,
        pairs: [
          SecurityValuePair(
            label: 'Apple ID',
            labelBaseline: 407.15,
            value: appleId,
            valueBaseline: 430.44,
            x: 53.23,
            meta: date == null
                ? connectedMeta
                : 'Connected on ${bubbaLongDate(date)}',
            metaBaseline: 454.05,
          ),
        ],
      ),
      top: 378.50,
      height: 94,
    );

    flow.block(
      SecurityNavCard(
        top: 631.46,
        height: 66.60,
        cardX: 19.98,
        onTap: onDisconnect,
        spec: const SecurityRowSpec(
          title: 'Disconnect Apple',
          titleX: 37.50,
          titleBaseline: 669.21,
          titleColor: BubbaSecurityColors.danger,
          trailing: SecurityChevron(),
          trailingY: 660.16,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 631.46,
      height: 66.60,
    );
  }
}

class BubbaDisconnectAppleScreen extends StatefulWidget {
  const BubbaDisconnectAppleScreen({super.key});

  @override
  State<BubbaDisconnectAppleScreen> createState() =>
      _BubbaDisconnectAppleScreenState();
}

class _BubbaDisconnectAppleScreenState
    extends State<BubbaDisconnectAppleScreen> {
  bool _busy = false;

  /// The API refuses to leave an account with no login method at all, so a
  /// failure here is a real answer and the screen shows it.
  Future<void> _disconnect() async {
    if (_busy) return;
    setState(() => _busy = true);

    final controller = BubbaSecurityController.to;
    final ok = await controller.setAppleKey(null);

    if (!mounted) return;
    if (!ok) {
      showSettingsError(controller.error.value);
      setState(() => _busy = false);
      return;
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) => DisconnectAppleView(
        busy: _busy,
        onBack: Get.back,
        onCancel: Get.back,
        onDisconnect: _disconnect,
      );
}

class DisconnectAppleView extends StatelessWidget {
  const DisconnectAppleView({
    super.key,
    this.busy = false,
    this.onBack,
    this.onCancel,
    this.onDisconnect,
  });

  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onDisconnect;

  static const double _cardX = 24.06;
  static const double _titleX = 44.76;
  static const double _bodyX = 44.43;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Disconnect Apple',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      const SecurityHeroCircle(
        glyph: BubbaSecurityGlyphs.apple,
        fill: BubbaSecurityColors.heroDanger,
        glyphColor: BubbaSecurityColors.danger,
        glyphX: 185.72,
        glyphY: 139.61,
        glyphWidth: 18.57,
        glyphHeight: 22.77,
      ),
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Disconnect Apple');
    securityLead(
      context,
      flow,
      const [
        'You’ll no longer be able to sign in',
        'with your Apple account.',
      ],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    final body = BubbaSecurityText.rowSubtitle.copyWith(
      height: BubbaSecurityMetrics.subtitlePitch / 12,
    );

    flow.block(
      SecurityValueCard(
        top: 339.80,
        height: 291.66,
        cardX: _cardX,
        ruleBaselines: const [438.81, 534.82],
        ruleInset: (BubbaSecurityMetrics.cardWidth - 288.84) / 2,
        pairs: [
          SecurityValuePair(
            label: 'You’ll need another way to sign in',
            labelBaseline: 376.47,
            labelStyle: BubbaSecurityText.rowTitle,
            value: 'Make sure you have a phone number or\nrecovery email set up.',
            valueBaseline: 400.07,
            valueStyle: body,
            x: _titleX,
          ),
          SecurityValuePair(
            label: 'You can reconnect anytime',
            labelBaseline: 471.98,
            labelStyle: BubbaSecurityText.rowTitle,
            value: 'Signing in with Apple again is quick\nand easy.',
            valueBaseline: 495.59,
            valueStyle: body,
            x: _bodyX,
          ),
          SecurityValuePair(
            label: 'Your data is safe',
            labelBaseline: 567.50,
            labelStyle: BubbaSecurityText.rowTitle,
            value: 'This won’t delete your account\nor any of your data.',
            valueBaseline: 591.11,
            valueStyle: body,
            x: _bodyX,
          ),
        ],
      ),
      top: 339.80,
      height: 291.66,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Disconnect Apple',
        y: 699.70,
        labelBaseline: 734.62,
        fill: BubbaSecurityColors.dangerCta,
        enabled: !busy,
        onTap: onDisconnect,
      ),
      top: 699.70,
      height: BubbaSecurityMetrics.ctaHeight,
    );

    securitySecondaryLink(
      context,
      flow,
      'Cancel',
      baseline: 786.92,
      onTap: busy ? null : onCancel,
    );
  }
}
