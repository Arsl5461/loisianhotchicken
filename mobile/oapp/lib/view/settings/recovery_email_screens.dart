import 'package:flutter/material.dart';
import '../../core/design/widgets/bubba_loading.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../core/routing/app_routes.dart';
import '../../data/repositories/settings_repository.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'security_verify_code_screen.dart';
import 'widgets/security_chrome.dart';

const SecurityHeroCircle _emailHero = SecurityHeroCircle(
  glyph: BubbaSecurityGlyphs.envelope,
  glyphX: 180.02,
  glyphY: 140.30,
  glyphWidth: 29.96,
  glyphHeight: 21.07,
);

bool bubbaIsEmail(String value) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$').hasMatch(value.trim());

class BubbaAddRecoveryEmailScreen extends StatefulWidget {
  const BubbaAddRecoveryEmailScreen({super.key});

  @override
  State<BubbaAddRecoveryEmailScreen> createState() =>
      _BubbaAddRecoveryEmailScreenState();
}

class _BubbaAddRecoveryEmailScreenState
    extends State<BubbaAddRecoveryEmailScreen> {
  final TextEditingController _email = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  final SettingsRepository _repository = Get.find<SettingsRepository>();

  Future<void> _submit() async {
    if (_busy || !bubbaIsEmail(_email.text)) return;
    setState(() => _busy = true);

    final address = _email.text.trim();
    final verified = await bubbaVerifyEmailChange(
      repository: _repository,
      email: address,
      recovery: true,
    );

    if (!mounted) return;
    setState(() => _busy = false);
    if (verified != true) return;

    await BubbaSecurityController.to.loadAccount(force: true);
    if (mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) => AddRecoveryEmailView(
        controller: _email,
        busy: _busy,
        onBack: Get.back,
        onContinue: _submit,
      );
}

class AddRecoveryEmailView extends StatelessWidget {
  const AddRecoveryEmailView({
    super.key,
    required this.controller,
    this.busy = false,
    this.onBack,
    this.onContinue,
  });

  final TextEditingController controller;
  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Add Recovery Email',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      _emailHero,
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Add recovery email');
    securityLead(
      context,
      flow,
      const [
        'Add a recovery email so you can',
        'reset your password and keep your',
        'account secure.',
      ],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityInputField(
        controller: controller,
        placeholder: 'Enter your email',
        x: 25.55,
        textX: 37.47,
        y: 356.77,
        textBaseline: 389.77,
        keyboardType: TextInputType.emailAddress,
        onSubmitted: (_) => onContinue?.call(),
      ),
      top: 356.77,
      height: BubbaSecurityMetrics.inputHeight,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Continue',
        y: 740.15,
        labelBaseline: 775.07,
        enabled: !busy,
        onTap: onContinue,
      ),
      top: 740.15,
      height: BubbaSecurityMetrics.ctaHeight,
    );
  }
}

class BubbaRecoveryEmailScreen extends StatefulWidget {
  const BubbaRecoveryEmailScreen({super.key});

  @override
  State<BubbaRecoveryEmailScreen> createState() =>
      _BubbaRecoveryEmailScreenState();
}

class _BubbaRecoveryEmailScreenState extends State<BubbaRecoveryEmailScreen> {
  BubbaSecurityController get _controller => BubbaSecurityController.to;

  @override
  void initState() {
    super.initState();
    _controller.loadAccount(force: true);
  }

  Future<void> _open(String route) async {
    await Get.toNamed(route);
    await _controller.loadAccount(force: true);
    if (!mounted) return;
    if ((_controller.recoveryEmail.value ?? '').isEmpty) Get.back();
  }

  @override
  Widget build(BuildContext context) => Obx(() => RecoveryEmailDetailView(
        email: _controller.recoveryEmail.value ?? '',
        onBack: Get.back,
        onChange: () => _open(Routes.BUBBA_CHANGE_EMAIL),
        onRemove: () => _open(Routes.BUBBA_REMOVE_EMAIL),
      ));
}

class RecoveryEmailDetailView extends StatelessWidget {
  const RecoveryEmailDetailView({
    super.key,
    this.email = 'ronssnv@gmail.com',
    this.onBack,
    this.onChange,
    this.onRemove,
  });

  final String email;
  final VoidCallback? onBack;
  final VoidCallback? onChange;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Recovery Email',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      _emailHero,
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Recovery email');
    securityLead(
      context,
      flow,
      const ['We’ll use this email to', 'help you recover your account'],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityValueCard(
        top: 356.50,
        height: 94,
        cardX: 26.97,
        pairs: [
          SecurityValuePair(
            label: 'Your email',
            labelBaseline: 395.32,
            value: email,
            valueBaseline: 417.50,
            x: 44.97,
          ),
        ],
      ),
      top: 356.50,
      height: 94,
    );

    flow.block(
      SecurityNavCard(
        top: 547.90,
        height: 66.60,
        cardX: 20.74,
        onTap: onChange,
        spec: const SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.envelope,
          iconX: 35.45,
          iconY: 571.97,
          iconWidth: 22.41,
          iconHeight: 15.75,
          title: 'Change email',
          titleX: 73.19,
          titleBaseline: 585.66,
          trailing: SecurityChevron(),
          trailingY: 576.60,
          trailingRightGap: BubbaSecurityMetrics.cardChevronRightGap,
        ),
      ),
      top: 547.90,
      height: 66.60,
    );

    flow.block(
      SecurityNavCard(
        top: 631.46,
        height: 66.60,
        cardX: 19.98,
        onTap: onRemove,
        spec: const SecurityRowSpec(
          glyph: BubbaSecurityGlyphs.trash,
          iconX: 38.92,
          iconY: 654.27,
          iconWidth: 18.52,
          iconHeight: 20.06,
          iconColor: BubbaSecurityColors.danger,
          title: 'Remove email',
          titleX: 72.44,
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

class BubbaChangeEmailScreen extends StatefulWidget {
  const BubbaChangeEmailScreen({super.key});

  @override
  State<BubbaChangeEmailScreen> createState() => _BubbaChangeEmailScreenState();
}

class _BubbaChangeEmailScreenState extends State<BubbaChangeEmailScreen> {
  final TextEditingController _email = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  final SettingsRepository _repository = Get.find<SettingsRepository>();
  BubbaSecurityController get _controller => BubbaSecurityController.to;

  Future<void> _send() async {
    if (_busy || !bubbaIsEmail(_email.text)) return;
    setState(() => _busy = true);

    final address = _email.text.trim();
    final verified = await bubbaVerifyEmailChange(
      repository: _repository,
      email: address,
      recovery: true,
    );

    if (!mounted) return;
    setState(() => _busy = false);
    if (verified != true) return;

    await _controller.loadAccount(force: true);
    if (mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final current = _controller.recoveryEmail.value ?? '';

        return ChangeEmailView(
          controller: _email,
          currentEmail: current,
          busy: _busy,
          onBack: Get.back,
          onCancel: Get.back,
          onSend: _send,
        );
      });
}

class ChangeEmailView extends StatelessWidget {
  const ChangeEmailView({
    super.key,
    required this.controller,
    this.currentEmail = 'ronssnv@gmail.com',
    this.busy = false,
    this.onBack,
    this.onCancel,
    this.onSend,
  });

  final TextEditingController controller;
  final String currentEmail;
  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Change Email',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      _emailHero,
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Change email');
    securityLead(
      context,
      flow,
      const ['Enter your new email.', 'We’ll send you a verification code.'],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityValueCard(
        top: 360.10,
        height: 94,
        cardX: 24.06,
        pairs: [
          SecurityValuePair(
            label: 'Current email',
            labelBaseline: 398.92,
            value: currentEmail,
            valueBaseline: 421.10,
            x: 43.69,
          ),
        ],
      ),
      top: 360.10,
      height: 94,
    );

    flow.block(
      SecurityInputField(
        controller: controller,
        placeholder: 'Enter new email',
        x: 27.43,
        textX: 39.35,
        y: 470.78,
        textBaseline: 503.79,
        keyboardType: TextInputType.emailAddress,
        onSubmitted: (_) => onSend?.call(),
      ),
      top: 470.78,
      height: BubbaSecurityMetrics.inputHeight,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Send code',
        y: 699.70,
        labelBaseline: 734.62,
        enabled: !busy,
        onTap: onSend,
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

class BubbaRemoveEmailScreen extends StatefulWidget {
  const BubbaRemoveEmailScreen({super.key});

  @override
  State<BubbaRemoveEmailScreen> createState() => _BubbaRemoveEmailScreenState();
}

class _BubbaRemoveEmailScreenState extends State<BubbaRemoveEmailScreen> {
  bool _busy = false;
  BubbaSecurityController get _controller => BubbaSecurityController.to;

  Future<void> _remove() async {
    if (_busy) return;
    setState(() => _busy = true);

    final ok = await _controller.removeRecoveryEmail();
    if (!mounted) return;

    if (!ok) {
      showSettingsError(_controller.error.value);
      setState(() => _busy = false);
      return;
    }

    await Get.off(() => const BubbaRecoveryEmailRemovedScreen());
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final current = _controller.recoveryEmail.value ?? '';

        return RemoveEmailView(
          email: current,
          busy: _busy,
          onBack: Get.back,
          onCancel: Get.back,
          onRemove: _remove,
        );
      });
}

class RemoveEmailView extends StatelessWidget {
  const RemoveEmailView({
    super.key,
    this.email = 'ronssnv@gmail.com',
    this.busy = false,
    this.onBack,
    this.onCancel,
    this.onRemove,
  });

  final String email;
  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Remove Email',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      const SecurityHeroCircle(
        glyph: BubbaSecurityGlyphs.envelope,
        fill: BubbaSecurityColors.heroDanger,
        glyphColor: BubbaSecurityColors.dangerIcon,
        glyphX: 180.02,
        glyphY: 140.30,
        glyphWidth: 29.96,
        glyphHeight: 21.07,
      ),
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Remove email');
    securityLead(
      context,
      flow,
      const [
        'You’ll no longer be able to use',
        'this email to recover your account.',
      ],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityValueCard(
        top: 360.10,
        height: 94,
        cardX: 24.06,
        pairs: [
          SecurityValuePair(
            label: email,
            labelBaseline: 404.10,
            labelStyle: BubbaSecurityText.fieldValue,
            value: 'Verified',
            valueBaseline: 428.88,
            valueStyle: BubbaSecurityText.verified,
            x: 43.69,
          ),
        ],
      ),
      top: 360.10,
      height: 94,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Remove email',
        y: 699.70,
        labelBaseline: 734.62,
        fill: BubbaSecurityColors.dangerCta,
        enabled: !busy,
        onTap: onRemove,
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

class BubbaRecoveryEmailRemovedScreen extends StatelessWidget {
  const BubbaRecoveryEmailRemovedScreen({super.key});

  @override
  Widget build(BuildContext context) => RecoveryEmailRemovedView(
        onBack: Get.back,
        onContinue: Get.back,
        onBackToSecurity: () => Get.until(
          (route) => Get.currentRoute == Routes.BUBBA_SECURITY_PRIVACY,
        ),
      );
}

class RecoveryEmailRemovedView extends StatelessWidget {
  const RecoveryEmailRemovedView({
    super.key,
    this.onBack,
    this.onContinue,
    this.onBackToSecurity,
  });

  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onBackToSecurity;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: '',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      const SecurityHeroCircle(
        glyph: BubbaSecurityGlyphs.checkMark,
        fill: BubbaSecurityColors.heroSuccess,
        glyphColor: BubbaSecurityColors.successMark,
        glyphX: 179.65,
        glyphY: 139.92,
        glyphWidth: 30.69,
        glyphHeight: 22.17,
      ),
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );
    securityHeading(context, flow, 'Recovery email removed');
    securityLead(
      context,
      flow,
      const ['You can add another recovery email', 'at any time.'],
      firstBaseline: BubbaSecurityMetrics.detailLeadBaseline,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Continue',
        y: 707.10,
        labelBaseline: 742.02,
        onTap: onContinue,
      ),
      top: 707.10,
      height: BubbaSecurityMetrics.ctaHeight,
    );

    securitySecondaryLink(
      context,
      flow,
      'Back to Security & Privacy',
      baseline: 794.33,
      onTap: onBackToSecurity,
    );
  }
}


/// The two-step email change, shared by Add and Change: request a code for the
/// address, then push the verify screen wired to `confirm`. Returns true only
/// when the server accepted the code.
Future<bool?> bubbaVerifyEmailChange({
  required SettingsRepository repository,
  required String email,
  bool recovery = false,
}) async {
  final requested = await repository.requestEmailChange(email, recovery: recovery);

  if (!requested.isSuccess || requested.value == null) {
    showSettingsError(requested.errorMessage);
    return false;
  }

  final token = requested.value!;

  return Get.to<bool>(
    () => BubbaVerifyEmailScreen(
      destination: email,
      onVerified: (code) async {
        final confirmed = await BubbaBusy.run(
          repository.confirmEmailChange(
            changeToken: token,
            otp: code,
            recovery: recovery,
          ),
        );
        if (!confirmed.isSuccess) {
          showSettingsError(confirmed.errorMessage);
          return false;
        }
        Get.back(result: true);
        return true;
      },
      onResend: () => repository.requestEmailChange(email, recovery: recovery),
    ),
  );
}
