import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../models/settings_models.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'widgets/security_chrome.dart';

const double _optionTitleX = 45.94;
const double _radioRightGap = 16.79;
const double _choiceCardTop = 197.82;

class SecurityChoiceOption {
  const SecurityChoiceOption({
    required this.value,
    required this.title,
    required this.titleBaseline,
    required this.subtitle,
    required this.subtitleBaseline,
    required this.radioY,
    required this.top,
    required this.bottom,
  });

  final String value;
  final String title;
  final double titleBaseline;
  final List<String> subtitle;
  final double subtitleBaseline;
  final double radioY;
  final double top;
  final double bottom;
}

/// p033 and p037 are the same screen with different options: a lead, then one
/// card of radio rows separated by full-width rules.
class SecurityChoiceView extends StatelessWidget {
  const SecurityChoiceView({
    super.key,
    required this.navTitle,
    required this.lead,
    required this.options,
    required this.selected,
    this.onBack,
    this.onSelect,
  });

  final String navTitle;
  final List<String> lead;
  final List<SecurityChoiceOption> options;
  final String selected;
  final VoidCallback? onBack;
  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: navTitle,
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    securityLead(
      context,
      flow,
      lead,
      firstBaseline: BubbaSecurityMetrics.bareLeadBaseline,
    );

    final rows = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      final option = options[i];
      if (i > 0) rows.add(const SecurityCardRule());
      rows.add(
        SecurityCardRow(
          top: option.top,
          height: option.bottom -
              option.top -
              (i < options.length - 1 ? BubbaSecurityMetrics.ruleWeight : 0),
          onTap: onSelect == null ? null : () => onSelect!(option.value),
          semanticsValue: option.value == selected ? 'Selected' : 'Not selected',
          spec: SecurityRowSpec(
            title: option.title,
            titleX: _optionTitleX,
            titleBaseline: option.titleBaseline,
            subtitle: option.subtitle,
            subtitleBaseline: option.subtitleBaseline,
            subtitlePitch: BubbaSecurityMetrics.subtitlePitchTight,
            trailing: SecurityRadio(selected: option.value == selected),
            trailingY: option.radioY,
            trailingRightGap: _radioRightGap,
          ),
        ),
      );
    }

    final height = options.last.bottom - _choiceCardTop;
    flow.block(
      SecurityCard(
        minHeight: height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
      ),
      top: _choiceCardTop,
      height: height,
    );
  }
}

/// The three options are the design's own vocabulary and the API field takes
/// the same three strings, so nothing is translated on the way out.
class BubbaProfileVisibilityScreen extends StatelessWidget {
  const BubbaProfileVisibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSecurityController.to;

    return Obx(() => ProfileVisibilityView(
          selected: controller.privacy.value.profileVisibility.apiValue,
          onSelect: (value) async {
            final ok = await controller.setProfileVisibility(
              ProfileVisibilityApi.parse(value),
            );
            if (!ok) showSettingsError(controller.error.value);
          },
          onBack: Get.back,
        ));
  }
}

class ProfileVisibilityView extends StatelessWidget {
  const ProfileVisibilityView({
    super.key,
    this.selected = 'filters',
    this.onSelect,
    this.onBack,
  });

  final String selected;
  final ValueChanged<String>? onSelect;
  final VoidCallback? onBack;

  static const List<SecurityChoiceOption> options = [
    SecurityChoiceOption(
      value: 'everyone',
      title: 'Everyone',
      titleBaseline: 228.34,
      subtitle: ['Who can discover you'],
      subtitleBaseline: 247.15,
      radioY: 224.16,
      top: _choiceCardTop,
      bottom: 264.25,
    ),
    SecurityChoiceOption(
      value: 'filters',
      title: 'People matching my filters',
      titleBaseline: 293.11,
      subtitle: ['Prevent people in your contacts', 'from seeing you'],
      subtitleBaseline: 311.92,
      radioY: 293.35,
      top: 264.25,
      bottom: 341.40,
    ),
    SecurityChoiceOption(
      value: 'paused',
      title: 'Pause discovery',
      titleBaseline: 370.90,
      subtitle: ['This turns on incognito mode.', 'Turn it off anytime'],
      subtitleBaseline: 389.71,
      radioY: 370.50,
      top: 341.40,
      bottom: 419.07,
    ),
  ];

  @override
  Widget build(BuildContext context) => SecurityChoiceView(
        navTitle: 'Profile Visibility',
        lead: const ['Choose who can discover', 'your profile on Bubba'],
        options: options,
        selected: selected,
        onSelect: onSelect,
        onBack: onBack,
      );
}

class BubbaLastActiveStatusScreen extends StatelessWidget {
  const BubbaLastActiveStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BubbaSecurityController.to;

    return Obx(() => LastActiveStatusView(
          selected: controller.privacy.value.lastActiveVisibility.apiValue,
          onSelect: (value) async {
            final ok = await controller.setLastActiveVisibility(
              LastActiveVisibilityApi.parse(value),
            );
            if (!ok) showSettingsError(controller.error.value);
          },
          onBack: Get.back,
        ));
  }
}

class LastActiveStatusView extends StatelessWidget {
  const LastActiveStatusView({
    super.key,
    this.selected = 'matches',
    this.onSelect,
    this.onBack,
  });

  final String selected;
  final ValueChanged<String>? onSelect;
  final VoidCallback? onBack;

  static const List<SecurityChoiceOption> options = [
    SecurityChoiceOption(
      value: 'everyone',
      title: 'Everyone',
      titleBaseline: 228.34,
      subtitle: ['Everyone can see when you’re active'],
      subtitleBaseline: 247.15,
      radioY: 224.16,
      top: _choiceCardTop,
      bottom: 264.25,
    ),
    SecurityChoiceOption(
      value: 'matches',
      title: 'Matches only',
      titleBaseline: 293.11,
      subtitle: ['Only your matches can see'],
      subtitleBaseline: 311.92,
      radioY: 288.26,
      top: 264.25,
      bottom: 331.22,
    ),
    SecurityChoiceOption(
      value: 'nobody',
      title: 'Nobody',
      titleBaseline: 362.09,
      subtitle: ['Hide your last active status'],
      subtitleBaseline: 380.90,
      radioY: 354.97,
      top: 331.22,
      bottom: 398.76,
    ),
  ];

  @override
  Widget build(BuildContext context) => SecurityChoiceView(
        navTitle: 'Last Active Status',
        lead: const ['Choose who can see', 'when you were last active.'],
        options: options,
        selected: selected,
        onSelect: onSelect,
        onBack: onBack,
      );
}
