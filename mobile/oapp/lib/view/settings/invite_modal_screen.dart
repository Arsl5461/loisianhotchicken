import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../config/app_config.dart';

import '../../data/repositories/referral_repository.dart';

import '../../core/design/bubba_icons.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_tokens.dart';

const double _photoX = 15.46;
const double _photoY = 177.54;
const double _photoW = 356.58;
const double _photoH = 436.38;
const double _photoRadius = 2;

const double _closeX = 356.84;
const double _closeY = 56.70;

/// p053. The invite-friends modal: a full-bleed photo between the heading and
/// the invitation link, with the close mark in the top right.
class SettingsInviteModalView extends StatelessWidget {
  const SettingsInviteModalView({
    super.key,
    this.link = 'joinbubba.com/invite34182',
    this.onClose,
    this.onCopy,
  });

  final String link;
  final VoidCallback? onClose;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          footerBand: 26,
          content: _content,
          overlay: (context) => [
            BubbaOverlay(
              x: _closeX,
              y: _closeY,
              topShift: true,
              hitPadding: 10,
              label: 'Close',
              onTap: onClose,
              child: const BubbaCloseMark(
                color: BubbaSettingsColors.modalClose,
              ),
            ),
          ],
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    final headingMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.modalHeading);
    flow.block(
      Text(
        'Invite your friends!',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.modalHeading,
      ),
      top: 109.07 - headingMetrics.baseline,
      height: headingMetrics.lineHeight,
    );

    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.modalBody);
    flow.block(
      Text(
        'Right now, new members can only join though member\n'
        'invitations, originating from our initial waitlist.',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.modalBody,
      ),
      top: 141.33 - bodyMetrics.baseline,
      height: bodyMetrics.lineHeight * 2,
    );

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(_photoX)),
          ClipRRect(
            borderRadius: BorderRadius.circular(d(_photoRadius)),
            child: Image.asset(
              'assets/bubba/settings/invite_modal_photo.png',
              width: hd(_photoW),
              height: d(_photoH),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      top: _photoY,
      height: _photoH,
    );

    final subMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.modalSubheading);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(23.25)),
          Text(
            'Your invitation link:',
            style: BubbaSettingsText.modalSubheading,
          ),
        ],
      ),
      top: 666.09 - subMetrics.baseline,
      height: subMetrics.lineHeight,
    );

    final linkMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.modalLink);
    final copyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.modalCopyLink);
    flow.block(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: hd(21.91)),
          Text(link, style: BubbaSettingsText.modalLink),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              top: d(linkMetrics.baseline - copyMetrics.baseline - 0.16),
            ),
            child: BubbaTapTarget(
              onTap: onCopy,
              label: 'Copy link',
              child: Text(
                'Copy link',
                style: BubbaSettingsText.modalCopyLink,
              ),
            ),
          ),
          SizedBox(width: hd(24.25)),
        ],
      ),
      top: 691.33 - linkMetrics.baseline,
      height: linkMetrics.lineHeight,
    );

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(22.25)),
          SizedBox(
            width: hd(343.50),
            height: d(1),
            child: const BubbaHairline(color: BubbaSettingsColors.modalRule),
          ),
        ],
      ),
      top: 697.03 - 0.5,
      height: 1,
    );

    final noteMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.modalNote);
    flow.block(
      Row(
        children: [
          SizedBox(width: hd(17.91)),
          Text(
            'You can invite up to 5 friends.',
            style: BubbaSettingsText.modalNote,
          ),
        ],
      ),
      top: 720.96 - noteMetrics.baseline,
      height: noteMetrics.lineHeight,
    );

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(17.91)),
          Text(
            'Invite 3 friends to receive a free month of Premium for\n'
            'you and them.',
            style: BubbaSettingsText.modalNote,
          ),
        ],
      ),
      top: 749.76 - noteMetrics.baseline,
      height: noteMetrics.lineHeight * 2,
    );
  }
}

class BubbaInviteModalScreen extends StatefulWidget {
  const BubbaInviteModalScreen({super.key});

  @override
  State<BubbaInviteModalScreen> createState() => _BubbaInviteModalScreenState();
}

class _BubbaInviteModalScreenState extends State<BubbaInviteModalScreen> {
  String _code = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final overview = await Get.find<ReferralRepository>().fetchOverview();
    if (!mounted) return;
    setState(() => _code = overview?.referralCode ?? '');
  }

  String get _link => AppConfig.inviteLink(_code);

  @override
  Widget build(BuildContext context) => SettingsInviteModalView(
        link: _link,
        onClose: Get.back,
        onCopy: _link.isEmpty
            ? null
            : () => Clipboard.setData(ClipboardData(text: _link)),
      );
}
