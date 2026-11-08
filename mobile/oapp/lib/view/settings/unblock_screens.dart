import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_tokens.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'widgets/security_chrome.dart';

class BubbaConfirmUnblockScreen extends StatefulWidget {
  const BubbaConfirmUnblockScreen({super.key, this.name});

  final String? name;

  @override
  State<BubbaConfirmUnblockScreen> createState() =>
      _BubbaConfirmUnblockScreenState();
}

class _BubbaConfirmUnblockScreenState extends State<BubbaConfirmUnblockScreen> {
  bool _busy = false;

  Map<String, dynamic>? get _args =>
      Get.arguments is Map<String, dynamic>
          ? Get.arguments as Map<String, dynamic>
          : null;

  String get _name =>
      widget.name ?? _args?['name'] as String? ?? 'this user';

  String? get _id => _args?['id'] as String?;

  String? get _photo => _args?['photo'] as String?;

  /// `_busy` is what refuses the double tap: the second one returns before it
  /// can queue a second unblock.
  Future<void> _confirm() async {
    if (_busy) return;
    setState(() => _busy = true);

    final id = _id;
    if (id == null || id.isEmpty) {
      showSettingsError('That user is no longer in your blocked list.');
      if (mounted) setState(() => _busy = false);
      return;
    }

    final controller = BubbaSecurityController.to;
    final ok = await controller.unblock(id);

    if (!mounted) return;
    if (!ok) {
      showSettingsError(controller.blockedError.value);
      setState(() => _busy = false);
      return;
    }

    final unblocked = await Get.to<bool>(
      () => BubbaUserUnblockedScreen(name: _name, photoUrl: _photo),
    );
    if (!mounted) return;
    if (unblocked == true) {
      Get.back(result: true);
    } else {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) => ConfirmUnblockView(
        name: _name,
        photoUrl: _photo,
        busy: _busy,
        onBack: Get.back,
        onCancel: Get.back,
        onUnblock: _confirm,
      );
}

class ConfirmUnblockView extends StatelessWidget {
  const ConfirmUnblockView({
    super.key,
    required this.name,
    this.photoUrl,
    this.busy = false,
    this.onBack,
    this.onCancel,
    this.onUnblock,
  });

  final String name;
  final String? photoUrl;
  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onUnblock;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Confirm Unblock',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SecurityAvatar(x: 151.72, size: 86.57, photoUrl: photoUrl),
      top: 226.72,
      height: 86.57,
    );

    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.unblockTitle);
    flow.block(
      Text(
        'Unblock $name',
        textAlign: TextAlign.center,
        style: BubbaSecurityText.unblockTitle,
      ),
      top: 352.37 - titleMetrics.baseline,
      height: titleMetrics.lineHeight,
      align: Alignment.center,
    );

    final bodyStyle = BubbaSecurityText.unblockBody.copyWith(height: 19 / 12);
    final bodyMetrics = bubbaDesignTextMetrics(context, bodyStyle);
    flow.block(
      Text(
        'They will be able to view your profile\nand contact you again.',
        textAlign: TextAlign.center,
        style: bodyStyle,
      ),
      top: 376.23 - bodyMetrics.baseline,
      height: 38,
      align: Alignment.center,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Unblock',
        y: 684.00,
        labelBaseline: 718.92,
        enabled: !busy,
        onTap: onUnblock,
      ),
      top: 684.00,
      height: BubbaSecurityMetrics.ctaHeight,
    );

    securitySecondaryLink(
      context,
      flow,
      'Cancel',
      baseline: 771.22,
      onTap: busy ? null : onCancel,
    );
  }
}

class BubbaUserUnblockedScreen extends StatelessWidget {
  const BubbaUserUnblockedScreen({
    super.key,
    required this.name,
    this.photoUrl,
  });

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) => UserUnblockedView(
        name: name,
        photoUrl: photoUrl,
        onDone: () => Get.back(result: true),
      );
}

class UserUnblockedView extends StatelessWidget {
  const UserUnblockedView({
    super.key,
    required this.name,
    this.photoUrl,
    this.onDone,
  });

  final String name;
  final String? photoUrl;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        showNav: false,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SecurityAvatar(x: 146.32, size: 86.57, photoUrl: photoUrl),
      top: 220.27,
      height: 86.57,
    );

    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.unblockTitle);
    flow.block(
      Text(
        'User Unblocked',
        textAlign: TextAlign.center,
        style: BubbaSecurityText.unblockTitle,
      ),
      top: 349.37 - titleMetrics.baseline,
      height: titleMetrics.lineHeight,
      align: Alignment.center,
    );

    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.unblockBody);
    flow.block(
      Text(
        '$name has been unblocked.',
        textAlign: TextAlign.center,
        style: BubbaSecurityText.unblockBody,
      ),
      top: 373.23 - bodyMetrics.baseline,
      height: bodyMetrics.lineHeight,
      align: Alignment.center,
    );

    flow.block(
      SecurityCtaButton(
        label: 'Done',
        y: 681.00,
        labelBaseline: 715.92,
        onTap: onDone,
      ),
      top: 681.00,
      height: BubbaSecurityMetrics.ctaHeight,
    );
  }
}
