import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import '../profileSetting/settings/controllers/settings_controller.dart';
import 'bubba_settings_controller.dart';
import 'settings_feedback.dart';
import 'widgets/settings_confirm_scaffold.dart';

const double _fieldX = 31.20;
const double _fieldY = 466.50;
const double _fieldWidth = 327.00;
const double _fieldHeight = 58.00;
const double _fieldTextX = 47.52;
const double _fieldTextBaseline = 500.41;

class BubbaDeleteAccountScreen extends StatelessWidget {
  const BubbaDeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) => DeleteAccountView(
        onBack: Get.back,
        onCancel: Get.back,
        onContinue: () => Get.to(() => const BubbaDeleteConfirmScreen()),
      );
}

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({
    super.key,
    this.onBack,
    this.onCancel,
    this.onContinue,
  });

  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) => SettingsConfirmView(
        navTitle: 'Delete Account',
        circle: const SettingsCircleMark(
          x: 149.50,
          top: 165.00,
          color: BubbaSettingsColors.deleteCircle,
          glyph: BubbaSettingsGlyphs.waveMark,
          glyphColor: BubbaSettingsColors.deleteMark,
          glyphX: 178.09,
          glyphY: 195.08,
          glyphWidth: 33.44,
          glyphHeight: 33.22,
        ),
        heading: 'Delete your account',
        headingBaseline: 328.89,
        body: 'This action is permanent and\ncannot be undone.',
        bodyBaseline: 371.84,
        card: const SettingsInfoCard(
          x: 18.00,
          y: 469.50,
          width: 354.00,
          height: 171.50,
          fill: BubbaSettingsColors.deleteCardBg,
          title: 'This will permanently delete:',
          titleX: 33.12,
          titleBaseline: 504.85,
          items: [
            SettingsCardItem(
              glyph: BubbaSettingsGlyphs.deleteProfile,
              iconX: 38.81,
              iconY: 529.92,
              iconWidth: 15.05,
              iconHeight: 15.05,
              label: 'Your profile and photos',
              labelX: 68.26,
              labelBaseline: 541.28,
            ),
            SettingsCardItem(
              glyph: BubbaSettingsGlyphs.deleteChats,
              iconX: 38.64,
              iconY: 569.34,
              iconWidth: 15.05,
              iconHeight: 14.05,
              label: 'Your matches and messages',
              labelX: 69.66,
              labelBaseline: 579.73,
            ),
            SettingsCardItem(
              glyph: BubbaSettingsGlyphs.deleteData,
              iconX: 38.80,
              iconY: 607.79,
              iconWidth: 13.89,
              iconHeight: 15.05,
              label: 'Your account data',
              labelX: 69.66,
              labelBaseline: 617.73,
            ),
          ],
        ),
        ctaLabel: 'Continue',
        ctaFill: BubbaSettingsColors.deleteCta,
        onCta: onContinue,
        onCancel: onCancel,
        onBack: onBack,
      );
}

class BubbaDeleteConfirmScreen extends StatefulWidget {
  const BubbaDeleteConfirmScreen({super.key});

  @override
  State<BubbaDeleteConfirmScreen> createState() =>
      _BubbaDeleteConfirmScreenState();
}

class _BubbaDeleteConfirmScreenState extends State<BubbaDeleteConfirmScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _armed = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final armed = _controller.text.trim().toUpperCase() == 'DELETE';
      if (armed != _armed) setState(() => _armed = armed);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The account is deleted on the server first. If that fails the screen
  /// stays put and says so, because logging out of an account that still
  /// exists is the opposite of what the user asked for.
  Future<void> _delete() async {
    if (_busy) return;
    setState(() => _busy = true);

    final bubba = BubbaSettingsController.to;
    final ok = await bubba.deleteAccount();

    if (!mounted) return;
    if (!ok) {
      showSettingsError(bubba.error.value);
      setState(() => _busy = false);
      return;
    }

    final settings = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController());
    settings.logout();
  }

  @override
  Widget build(BuildContext context) => DeleteConfirmView(
        controller: _controller,
        enabled: _armed && !_busy,
        onBack: Get.back,
        onCancel: Get.back,
        onDelete: _delete,
      );
}

class DeleteConfirmView extends StatelessWidget {
  const DeleteConfirmView({
    super.key,
    this.controller,
    this.enabled = false,
    this.onBack,
    this.onCancel,
    this.onDelete,
  });

  final TextEditingController? controller;
  final bool enabled;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final metrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.fieldPlaceholder);
    return SettingsConfirmView(
      navTitle: 'Delete Account',
      circle: const SettingsCircleMark(
        x: 149.50,
        top: 164.28,
        color: BubbaSettingsColors.deleteCircle,
        glyph: BubbaSettingsGlyphs.warningMark,
        glyphColor: BubbaSettingsColors.deleteMark,
        glyphX: 173.06,
        glyphY: 191.08,
        glyphWidth: 43.89,
        glyphHeight: 37.42,
      ),
      heading: 'This cannot be undone',
      headingBaseline: 328.89,
      body: 'Type DELETE below to confirm\n'
          'you want to permanently delete\nyour account.',
      bodyBaseline: 371.84,
      bodyLines: 3,
      middle: SettingsAnchoredBlock(
        top: _fieldY,
        height: _fieldHeight,
        child: _DeleteField(
          controller: controller,
          textTop: _fieldTextBaseline - _fieldY - metrics.baseline,
        ),
      ),
      ctaLabel: 'Delete Account',
      ctaFill: enabled
          ? BubbaSettingsColors.deleteCta
          : BubbaSettingsColors.deleteCtaDisabled,
      ctaLabelColor: enabled
          ? BubbaSettingsColors.onDark
          : BubbaSettingsColors.deleteCtaDisabledLabel
              .withValues(alpha: BubbaSettingsMetrics.disabledLabelAlpha),
      onCta: enabled ? onDelete : null,
      onCancel: onCancel,
      onBack: onBack,
    );
  }
}

class _DeleteField extends StatelessWidget {
  const _DeleteField({this.controller, required this.textTop});

  final TextEditingController? controller;
  final double textTop;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: hd(_fieldX)),
          Container(
            width: hd(_fieldWidth),
            height: d(_fieldHeight),
            decoration: BoxDecoration(
              border: Border.all(
                color: BubbaSettingsColors.fieldBorder,
                width: d(BubbaSettingsMetrics.dividerWeight),
              ),
              borderRadius:
                  BorderRadius.circular(d(BubbaSettingsMetrics.ctaRadius)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: hd(_fieldTextX - _fieldX)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: d(textTop)),
                    child: SizedBox(
                      height: d(BubbaSettingsMetrics.fieldTextHeight),
                      child: controller == null
                          ? const _DeleteFieldInput(controller: null, empty: true)
                          : ValueListenableBuilder<TextEditingValue>(
                              valueListenable: controller!,
                              builder: (context, value, _) =>
                                  _DeleteFieldInput(
                                controller: controller,
                                empty: value.text.isEmpty,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(width: hd(12)),
              ],
            ),
          ),
        ],
      );
}

class _DeleteFieldInput extends StatelessWidget {
  const _DeleteFieldInput({required this.controller, required this.empty});

  final TextEditingController? controller;
  final bool empty;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          if (empty)
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Type DELETE',
                style: BubbaSettingsText.fieldPlaceholder,
              ),
            ),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            style: BubbaSettingsText.fieldPlaceholder.copyWith(
              color: BubbaSettingsColors.rowLabel,
            ),
            cursorColor: BubbaSettingsColors.deleteCta,
            decoration: null,
          ),
        ],
      );
}
