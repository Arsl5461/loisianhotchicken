import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../profileSetting/settings/controllers/settings_controller.dart';
import 'bubba_settings_controller.dart';
import 'settings_feedback.dart';
import 'widgets/settings_confirm_scaffold.dart';

class BubbaPauseAccountScreen extends StatelessWidget {
  const BubbaPauseAccountScreen({super.key});

  @override
  Widget build(BuildContext context) => PauseAccountView(
        photoUrl: settingsProfilePhotoUrl(),
        onBack: Get.back,
        onCancel: Get.back,
        onPause: () => Get.to(() => const BubbaPauseConfirmScreen()),
      );
}

class PauseAccountView extends StatelessWidget {
  const PauseAccountView({
    super.key,
    this.photoUrl,
    this.onBack,
    this.onCancel,
    this.onPause,
  });

  final String? photoUrl;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onPause;

  @override
  Widget build(BuildContext context) => SettingsConfirmView(
        navTitle: 'Pause Account',
        circle: SettingsCircleMark(
          x: 147.47,
          top: 147.00,
          color: BubbaSettingsColors.pauseMarkCircle,
          photoUrl: photoUrl,
          semanticsLabel: 'Your profile photo',
        ),
        heading: 'Pause your account',
        headingBaseline: 362.89,
        body: 'Need a break? You can pause your\naccount anytime.',
        bodyBaseline: 405.84,
        card: const SettingsInfoCard(
          x: 18.00,
          y: 472.50,
          width: 354.00,
          height: 164.50,
          fill: BubbaSettingsColors.pauseCardBg,
          title: 'While paused:',
          titleX: 38.12,
          titleBaseline: 507.85,
          items: [
            SettingsCardItem(
              glyph: BubbaSettingsGlyphs.checkMark,
              iconX: 43.41,
              iconY: 534.55,
              iconWidth: 14.55,
              iconHeight: 10.50,
              label: 'You won’t appear in discovery',
              labelX: 77.26,
              labelBaseline: 544.28,
            ),
            SettingsCardItem(
              glyph: BubbaSettingsGlyphs.checkMark,
              iconX: 43.50,
              iconY: 568.59,
              iconWidth: 14.55,
              iconHeight: 10.50,
              label: 'Your matches and chats stay the same',
              labelX: 78.66,
              labelBaseline: 578.73,
            ),
            SettingsCardItem(
              glyph: BubbaSettingsGlyphs.checkMark,
              iconX: 43.92,
              iconY: 600.64,
              iconWidth: 14.55,
              iconHeight: 10.50,
              label: 'You can reactivate anytime',
              labelX: 78.66,
              labelBaseline: 610.73,
            ),
          ],
        ),
        ctaLabel: 'Pause Account',
        ctaFill: BubbaSettingsColors.pauseCta,
        onCta: onPause,
        onCancel: onCancel,
        onBack: onBack,
      );
}

/// The confirm actually sets `status: onhold` on the server before it logs
/// out. Logging out without that left the account fully live in discovery.
class BubbaPauseConfirmScreen extends StatefulWidget {
  const BubbaPauseConfirmScreen({super.key});

  @override
  State<BubbaPauseConfirmScreen> createState() =>
      _BubbaPauseConfirmScreenState();
}

class _BubbaPauseConfirmScreenState extends State<BubbaPauseConfirmScreen> {
  bool _busy = false;

  Future<void> _confirm() async {
    if (_busy) return;
    setState(() => _busy = true);

    final settings = BubbaSettingsController.to;
    final ok = await settings.pauseAccount(true);

    if (!mounted) return;
    if (!ok) {
      showSettingsError(settings.error.value);
      setState(() => _busy = false);
      return;
    }

    final controller = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController());
    controller.pauseAccountConfirm(true);
    controller.logout();
  }

  @override
  Widget build(BuildContext context) => PauseConfirmView(
        onBack: Get.back,
        onCancel: Get.back,
        onConfirm: _confirm,
      );
}

class PauseConfirmView extends StatelessWidget {
  const PauseConfirmView({
    super.key,
    this.onBack,
    this.onCancel,
    this.onConfirm,
  });

  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) => SettingsConfirmView(
        navTitle: 'Pause Account',
        circle: const SettingsCircleMark(
          x: 149.50,
          top: 160.00,
          color: BubbaSettingsColors.pauseCircle,
          glyph: BubbaSettingsGlyphs.pauseMark,
          glyphX: 179.99,
          glyphY: 187.78,
          glyphWidth: 30.02,
          glyphHeight: 32.75,
        ),
        heading: 'Are you sure?',
        headingBaseline: 359.89,
        body: 'You can reactivate your account\nwhenever you’re ready.',
        bodyBaseline: 402.84,
        ctaLabel: 'Yes, pause my account',
        ctaFill: BubbaSettingsColors.pauseCta,
        onCta: onConfirm,
        onCancel: onCancel,
        onBack: onBack,
      );
}
