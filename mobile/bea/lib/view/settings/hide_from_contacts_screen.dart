import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_glyphs.dart';
import '../../core/design/bubba_security_tokens.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'widgets/security_chrome.dart';
import 'widgets/settings_chrome.dart';

enum HideFromContactsState { idle, allSet, accessNeeded }

/// Turning it on asks the OS for contacts. Granted lands on `allSet`, refused
/// lands on `accessNeeded`, and the setting itself is only written once the
/// permission is real, so the screen never claims a protection it cannot give.
class BubbaHideFromContactsScreen extends StatefulWidget {
  const BubbaHideFromContactsScreen({super.key, this.contactsGranted});

  /// Only the golden fixtures pass this. The running screen asks the OS.
  final bool? contactsGranted;

  @override
  State<BubbaHideFromContactsScreen> createState() =>
      _BubbaHideFromContactsScreenState();
}

class _BubbaHideFromContactsScreenState
    extends State<BubbaHideFromContactsScreen> {
  BubbaSecurityController get _controller => BubbaSecurityController.to;

  HideFromContactsState _state = HideFromContactsState.idle;
  bool _busy = false;

  Future<bool> _requestContacts() async {
    final override = widget.contactsGranted;
    if (override != null) return override;

    try {
      final status =
          await FlutterContacts.permissions.request(PermissionType.read);
      return status == PermissionStatus.granted ||
          status == PermissionStatus.limited;
    } catch (error) {
      debugPrint('Contacts permission failed: $error');
      return false;
    }
  }

  Future<void> _set(bool value) async {
    if (_busy) return;
    setState(() => _busy = true);

    if (!value) {
      final ok = await _controller.setHideFromContacts(false);
      if (!mounted) return;
      if (!ok) showSettingsError(_controller.error.value);
      setState(() {
        _state = HideFromContactsState.idle;
        _busy = false;
      });
      return;
    }

    final granted = await _requestContacts();
    if (!mounted) return;

    if (!granted) {
      setState(() {
        _state = HideFromContactsState.accessNeeded;
        _busy = false;
      });
      return;
    }

    final ok = await _controller.setHideFromContacts(true);
    if (!mounted) return;
    if (!ok) showSettingsError(_controller.error.value);

    setState(() {
      _state = ok ? HideFromContactsState.allSet : HideFromContactsState.idle;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) => Obx(() => HideFromContactsView(
        hidden: _controller.privacy.value.hideFromContacts,
        state: _state,
        onChanged: _set,
        onBack: Get.back,
        onManageAccess: ph.openAppSettings,
        onOpenSettings: ph.openAppSettings,
        onNotNow: () => setState(() => _state = HideFromContactsState.idle),
      ));
}

class HideFromContactsView extends StatelessWidget {
  const HideFromContactsView({
    super.key,
    this.hidden = true,
    this.state = HideFromContactsState.idle,
    this.onChanged,
    this.onBack,
    this.onManageAccess,
    this.onOpenSettings,
    this.onNotNow,
  });

  final bool hidden;
  final HideFromContactsState state;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onBack;
  final VoidCallback? onManageAccess;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onNotNow;

  static const double cardTop = 229.93;
  static const double cardHeight = 73.85;
  static const double bannerX = BubbaSecurityMetrics.ctaX;
  static const double bannerWidth = BubbaSecurityMetrics.ctaWidth;
  static const double bannerRadius = 10.22;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Hide From Contacts',
        onBack: onBack,
        content: _content,
      );

  void _content(BuildContext context, BubbaFlow flow) {
    securityLead(
      context,
      flow,
      const [
        'People saved in your phone’s',
        'contacts won’t see your profile',
        'in discovery.',
      ],
      firstBaseline: BubbaSecurityMetrics.bareLeadBaseline,
    );

    flow.block(
      SecurityCard(
        minHeight: cardHeight,
        child: SecurityCardRow(
          top: cardTop,
          height: cardHeight,
          onTap: onChanged == null ? null : () => onChanged!(!hidden),
          semanticsValue: hidden ? 'On' : 'Off',
          spec: SecurityRowSpec(
            title: 'Hide profile from contacts',
            titleX: 45.94,
            titleBaseline: 270.35,
            trailing: SettingsToggle(
              value: hidden,
              onChanged: onChanged,
              label: 'Hide profile from contacts',
            ),
            trailingY: 254.91,
            trailingRightGap: 19.51,
          ),
        ),
      ),
      top: cardTop,
      height: cardHeight,
    );

    switch (state) {
      case HideFromContactsState.idle:
        flow.block(
          SecurityCtaButton(
            label: 'Manage contact access',
            y: 721.17,
            labelBaseline: 756.09,
            onTap: onManageAccess,
          ),
          top: 721.17,
          height: BubbaSecurityMetrics.ctaHeight,
        );
      case HideFromContactsState.allSet:
        flow.block(
          const _AllSetBanner(),
          top: 684.64,
          height: 91.11,
        );
      case HideFromContactsState.accessNeeded:
        flow.block(
          const _AccessNeededCard(),
          top: 518.46,
          height: 158.15,
        );
        flow.block(
          SecurityCtaButton(
            label: 'Open Settings',
            y: 706.56,
            labelBaseline: 741.49,
            onTap: onOpenSettings,
          ),
          top: 706.56,
          height: BubbaSecurityMetrics.ctaHeight,
        );
        securitySecondaryLink(
          context,
          flow,
          'Not now',
          baseline: 791.56,
          onTap: onNotNow,
        );
    }
  }
}

class _AllSetBanner extends StatelessWidget {
  const _AllSetBanner();

  static const double top = 684.64;
  static const double iconX = 42.92;
  static const double textX = 91.17;
  static const double titleBaseline = 719.18;
  static const double bodyBaseline = 742.90;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.rowTitle);
    final bodyStyle = BubbaSecurityText.rowSubtitle.copyWith(
      height: BubbaSecurityMetrics.subtitlePitch / 12,
    );
    final bodyMetrics = bubbaDesignTextMetrics(context, bodyStyle);
    final titleTop = titleBaseline - titleMetrics.baseline;
    final bodyTop = bodyBaseline - bodyMetrics.baseline;

    return SecurityCard(
      x: HideFromContactsView.bannerX,
      width: HideFromContactsView.bannerWidth,
      radius: HideFromContactsView.bannerRadius,
      fill: BubbaSecurityColors.successCardBg,
      border: null,
      minHeight: 91.11,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: hd(iconX - HideFromContactsView.bannerX)),
          Column(
            children: [
              SizedBox(height: d(718.05 - top)),
              const BubbaGlyphIcon(
                BubbaSecurityGlyphs.checkMark,
                color: BubbaSecurityColors.successMark,
                width: 30.70,
                height: 22.17,
              ),
            ],
          ),
          SizedBox(width: hd(textX - iconX - 30.70)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: d(titleTop - top)),
                Text('All set!', style: BubbaSecurityText.rowTitle),
                SizedBox(
                  height: d(bodyTop - (titleTop + titleMetrics.lineHeight)),
                ),
                Text(
                  'People in your contacts won’t\nsee your profile.',
                  style: bodyStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessNeededCard extends StatelessWidget {
  const _AccessNeededCard();

  static const double top = 518.46;
  static const double iconX = 49.69;
  static const double textX = 49.15;
  static const double titleBaseline = 592.28;
  static const double bodyBaseline = 616.21;

  @override
  Widget build(BuildContext context) {
    final titleMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.rowTitle);
    final bodyStyle = BubbaSecurityText.rowSubtitle.copyWith(
      height: BubbaSecurityMetrics.subtitlePitch / 12,
    );
    final bodyMetrics = bubbaDesignTextMetrics(context, bodyStyle);
    final titleTop = titleBaseline - titleMetrics.baseline;
    final bodyTop = bodyBaseline - bodyMetrics.baseline;

    return SecurityCard(
      x: HideFromContactsView.bannerX,
      width: HideFromContactsView.bannerWidth,
      radius: HideFromContactsView.bannerRadius,
      fill: BubbaSecurityColors.dangerCardBg,
      border: null,
      minHeight: 158.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: d(538.64 - top)),
          Row(
            children: [
              SizedBox(width: hd(iconX - HideFromContactsView.bannerX)),
              const BubbaGlyphIcon(
                BubbaSecurityGlyphs.lock,
                color: BubbaSecurityColors.dangerIcon,
                width: 24,
                height: 27,
              ),
            ],
          ),
          SizedBox(height: d(titleTop - 538.64 - 27)),
          Row(
            children: [
              SizedBox(width: hd(textX - HideFromContactsView.bannerX)),
              Text(
                'Contacts Access Needed',
                style: BubbaSecurityText.rowTitle,
              ),
            ],
          ),
          SizedBox(height: d(bodyTop - (titleTop + titleMetrics.lineHeight))),
          Row(
            children: [
              SizedBox(width: hd(textX - HideFromContactsView.bannerX)),
              Expanded(
                child: Text(
                  'To hide your profile from people\nin your contacts, enable Contacts\naccess in Settings',
                  style: bodyStyle,
                ),
              ),
            ],
          ),
          SizedBox(height: d(bodyMetrics.descent)),
        ],
      ),
    );
  }
}
