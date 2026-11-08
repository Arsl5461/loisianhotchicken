import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'bubba_security_controller.dart';
import 'widgets/security_chrome.dart';

class BubbaConnectedAccountsScreen extends StatefulWidget {
  const BubbaConnectedAccountsScreen({super.key});

  @override
  State<BubbaConnectedAccountsScreen> createState() =>
      _BubbaConnectedAccountsScreenState();
}

class _BubbaConnectedAccountsScreenState
    extends State<BubbaConnectedAccountsScreen> {
  BubbaSecurityController get _controller => BubbaSecurityController.to;

  @override
  void initState() {
    super.initState();
    _controller.loadAccount(force: true);
  }

  Future<void> _open(String route) async {
    await Get.toNamed(route);
    await _controller.loadAccount(force: true);
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final connected = _controller.appleConnected;
        final recovery = _controller.recoveryEmail.value ?? '';

        return ConnectedAccountsView(
          phoneNumber: _controller.phoneNumber,
          appleConnected: connected,
          recoveryEmail: recovery,
          onBack: Get.back,
          onPhone: () => _open(Routes.BUBBA_PHONE_NUMBER),
          onApple: () => _open(
            connected
                ? Routes.BUBBA_APPLE_ACCOUNT
                : Routes.BUBBA_CONNECT_APPLE,
          ),
          onRecoveryEmail: () => _open(
            recovery.isEmpty
                ? Routes.BUBBA_ADD_RECOVERY_EMAIL
                : Routes.BUBBA_RECOVERY_EMAIL,
          ),
        );
      });
}

class ConnectedAccountsView extends StatelessWidget {
  const ConnectedAccountsView({
    super.key,
    this.phoneNumber = '+1 (860) 977 - 4286',
    this.appleConnected = true,
    this.recoveryEmail = '',
    this.onBack,
    this.onPhone,
    this.onApple,
    this.onRecoveryEmail,
  });

  final String phoneNumber;
  final bool appleConnected;
  final String recoveryEmail;
  final VoidCallback? onBack;
  final VoidCallback? onPhone;
  final VoidCallback? onApple;
  final VoidCallback? onRecoveryEmail;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Connected Accounts',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      const SecurityHeroCircle(
        glyph: BubbaSecurityGlyphs.shieldCheck,
        glyphX: 182.94,
        glyphY: 134.97,
        glyphWidth: 24.35,
        glyphHeight: 29.22,
      ),
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );

    securityLead(
      context,
      flow,
      const ['Manage how you sign in', 'and keep your account safe.'],
      firstBaseline: BubbaSecurityMetrics.hubLeadBaseline,
    );

    flow.block(
      SecurityNavCard(
        top: 291.50,
        height: 94,
        onTap: onPhone,
        spec: SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.phone,
          iconX: 37.38,
          iconY: 324.35,
          iconWidth: 18.71,
          iconHeight: 18.79,
          title: 'Phone Number',
          titleX: 75.86,
          titleBaseline: 333.26,
          subtitle: [phoneNumber],
          subtitleBaseline: 353.71,
          trailing: const SecurityChevron(),
          trailingY: 333.20,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 291.50,
      height: 94,
    );

    flow.block(
      SecurityNavCard(
        top: 395.09,
        height: 94,
        onTap: onApple,
        spec: SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.apple,
          iconX: 41.13,
          iconY: 430.72,
          iconWidth: 18.57,
          iconHeight: 22.77,
          title: 'Apple',
          titleX: 74.80,
          titleBaseline: 436.84,
          subtitle: [appleConnected ? 'Connected' : 'Not connected'],
          subtitleBaseline: 457.30,
          trailing: const SecurityChevron(),
          trailingY: 436.79,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 395.09,
      height: 94,
    );

    final hasEmail = recoveryEmail.isNotEmpty;
    flow.block(
      SecurityNavCard(
        top: 498.50,
        height: 94,
        onTap: onRecoveryEmail,
        spec: SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.envelope,
          iconX: 38.11,
          iconY: 536.57,
          iconWidth: 22.41,
          iconHeight: 15.75,
          title: 'Recovery Email',
          titleX: 74.86,
          titleBaseline: 540.26,
          subtitle: [hasEmail ? recoveryEmail : 'Add email'],
          subtitleBaseline: 560.77,
          subtitleStyle: hasEmail ? null : BubbaSecurityText.rowAction,
          trailing: const SecurityChevron(),
          trailingY: 540.20,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 498.50,
      height: 94,
    );
  }
}
