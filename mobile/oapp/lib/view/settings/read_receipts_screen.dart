import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_tokens.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'widgets/security_chrome.dart';
import 'widgets/settings_chrome.dart';

const String securityReadReceiptsKey = 'security.privacy.readReceipts';

class BubbaReadReceiptsScreen extends StatelessWidget {
  const BubbaReadReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSecurityController.to;

    return Obx(() => ReadReceiptsView(
          showReceipts: controller.privacy.value.readReceipts,
          onChanged: (value) async {
            final ok = await controller.setReadReceipts(value);
            if (!ok) showSettingsError(controller.error.value);
          },
          onBack: Get.back,
        ));
  }
}

class ReadReceiptsView extends StatelessWidget {
  const ReadReceiptsView({
    super.key,
    this.showReceipts = true,
    this.onChanged,
    this.onBack,
  });

  final bool showReceipts;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onBack;

  static const double cardTop = 229.93;
  static const double cardHeight = 88.10;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Read Receipts',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    securityLead(
      context,
      flow,
      const ['Decide when others can see', 'if you’ve read their messages'],
      firstBaseline: BubbaSecurityMetrics.bareLeadBaseline,
    );

    flow.block(
      SecurityCard(
        minHeight: cardHeight,
        child: SecurityCardRow(
          top: cardTop,
          height: cardHeight,
          onTap: onChanged == null ? null : () => onChanged!(!showReceipts),
          semanticsValue: showReceipts ? 'On' : 'Off',
          spec: SecurityRowSpec(
            title: 'Show read receipts',
            titleX: 45.94,
            titleBaseline: 264.83,
            subtitle: const [
              'Let others see when you’ve',
              'read their messages.',
            ],
            subtitleBaseline: 283.85,
            subtitlePitch: BubbaSecurityMetrics.subtitlePitchTight,
            trailing: SettingsToggle(
              value: showReceipts,
              onChanged: onChanged,
              label: 'Show read receipts',
            ),
            trailingY: 262.72,
            trailingRightGap: 19.51,
          ),
        ),
      ),
      top: cardTop,
      height: cardHeight,
    );
  }
}
