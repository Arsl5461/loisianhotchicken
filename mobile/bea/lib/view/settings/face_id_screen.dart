import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'widgets/security_chrome.dart';
import 'widgets/settings_chrome.dart';

/// Turning the toggle on runs the real biometric prompt, so the screen cannot
/// promise a lock the device will not perform.
class BubbaFaceIdScreen extends StatelessWidget {
  const BubbaFaceIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSecurityController.to;

    return Obx(() => FaceIdView(
          required: controller.faceId.value,
          onChanged: (value) async {
            final ok = await controller.setFaceId(value);
            if (!ok) showSettingsError(controller.error.value);
          },
          onBack: Get.back,
        ));
  }
}

class FaceIdView extends StatelessWidget {
  const FaceIdView({
    super.key,
    this.required = true,
    this.onChanged,
    this.onBack,
  });

  final bool required;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Face ID',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      const SecurityHeroCircle(
        glyph: BubbaSecurityGlyphs.faceId,
        glyphX: 178.87,
        glyphY: 134.35,
        glyphWidth: 31.76,
        glyphHeight: 31.76,
      ),
      top: BubbaSecurityMetrics.heroY,
      height: SecurityHeroCircle.designHeight,
    );

    securityLead(
      context,
      flow,
      const ['Use Face ID to quickly and', 'securely unlock Bubba'],
      firstBaseline: BubbaSecurityMetrics.hubLeadBaseline,
    );

    flow.block(
      SecurityCard(
        minHeight: 82,
        child: SecurityCardRow(
          top: 297.59,
          height: 82,
          onTap: onChanged == null ? null : () => onChanged!(!required),
          semanticsValue: required ? 'On' : 'Off',
          spec: SecurityRowSpec(
            title: 'Require Face ID',
            titleX: 47.80,
            titleBaseline: 332.85,
            subtitle: const ['When opening the app'],
            subtitleBaseline: 352.47,
            trailing: SettingsToggle(
              value: required,
              onChanged: onChanged,
              label: 'Require Face ID',
            ),
            trailingY: 327.54,
            trailingRightGap: 16.84,
          ),
        ),
      ),
      top: 297.59,
      height: 82,
    );
  }
}
