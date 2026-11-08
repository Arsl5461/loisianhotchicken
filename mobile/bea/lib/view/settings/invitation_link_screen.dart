import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../config/app_config.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/repositories/referral_repository.dart';

import '../../core/design/bubba_glyphs.dart';
import '../../core/design/bubba_icons.dart';
import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_settings_glyphs.dart';
import '../../core/design/bubba_settings_tokens.dart';
import 'widgets/settings_chrome.dart';

const double _artX = 1.3;
const double _artY = 86.0;
const double _artW = 388.7;
const double _artH = 289.0;
const List<double> _dotX = [66.32, 186.16, 306.01];

class SettingsInvitationLinkView extends StatelessWidget {
  const SettingsInvitationLinkView({
    super.key,
    this.link = 'joinbubba.com/invite34182',
    this.joined = 0,
    this.onBack,
    this.onCopy,
    this.onShare,
  });

  final String link;
  final int joined;
  final VoidCallback? onBack;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BubbaSettingsColors.pageBg,
        body: BubbaPage(
          padContent: false,
          background: BubbaSettingsColors.pageBg,
          footerBand: 26,
          content: _content,
        ),
      );

  void _content(BuildContext context, BubbaFlow flow) {
    flow.block(
      SettingsNavBar(title: 'Invitation Link', onBack: onBack),
      top: 0,
      height: BubbaSettingsMetrics.navHeight,
    );

    final headingMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.displayHeading);
    final artFlowH = 383.88 - headingMetrics.baseline - _artY;

    flow.block(
      Row(
        children: [
          SizedBox(width: hd(_artX)),
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: artFlowH / _artH,
              child: Image.asset(
                'assets/bubba/settings/invite_illustration.png',
                width: hd(_artW),
                height: d(_artH),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
      top: _artY,
      height: artFlowH,
    );

    flow.block(
      Text(
        'Invite 3 friends',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.displayHeading,
      ),
      top: 383.88 - headingMetrics.baseline,
      height: headingMetrics.lineHeight,
    );

    final accentMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.uiMedium);
    flow.block(
      Text(
        'Everyone gets Premium.',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.uiMedium
            .copyWith(color: BubbaSettingsColors.inviteAccent),
      ),
      top: 414.68 - accentMetrics.baseline,
      height: accentMetrics.lineHeight,
    );

    final bodyMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.pageSubtitle);
    flow.block(
      Text(
        'Invite three friends to join Bubba using your\n'
        'personal invitation link. Once each joins, both you\n'
        'and they receive one month of Bubba Premium.',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.pageSubtitle,
      ),
      top: 450.18 - bodyMetrics.baseline,
      height: bodyMetrics.lineHeight * 3,
    );

    flow.block(_ProgressCard(joined: joined), top: 524.50, height: 89);
    flow.block(
      _LinkCard(link: link, onCopy: onCopy, onShare: onShare),
      top: 625.50,
      height: 166,
    );

    final footMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.legalNote);
    flow.block(
      Text(
        'Rewards are automatically applied when each friend joins.',
        textAlign: TextAlign.center,
        style: BubbaSettingsText.legalNote,
      ),
      top: 811.84 - footMetrics.baseline,
      height: footMetrics.lineHeight,
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.joined});

  final int joined;

  @override
  Widget build(BuildContext context) {
    final metrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.purchaseSubtitle);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(left - 16.82),
              top: d(top - 524.50),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(16.82)),
        Container(
          width: hd(354),
          height: d(89),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(0.5),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(
            children: [
              at(
                33.77,
                542.54,
                const BubbaGlyphIcon(
                  BubbaSettingsGlyphs.friendsMark,
                  color: BubbaSettingsColors.inviteInk,
                  width: 18.20,
                  height: 12.15,
                ),
              ),
              at(
                66.15,
                555.24 - metrics.baseline,
                Text(
                  '$joined of 3 friends joined',
                  style: BubbaSettingsText.purchaseSubtitle
                      .copyWith(color: BubbaSettingsColors.inviteInk),
                ),
              ),
              for (var i = 0; i < 2; i++)
                at(
                  95.82 + i * 119.5,
                  580.50 - 0.5,
                  SizedBox(
                    width: hd(77.50),
                    height: d(BubbaSettingsMetrics.dividerWeight),
                    child: const BubbaDashedLine(
                      color: BubbaSettingsColors.inviteDot,
                    ),
                  ),
                ),
              for (var i = 0; i < 3; i++)
                at(
                  _dotX[i],
                  571.36,
                  Container(
                    width: d(18.50),
                    height: d(18.50),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: BubbaSettingsColors.pageBg,
                      border: Border.all(
                        color: i < joined
                            ? BubbaSettingsColors.rowLabel
                            : BubbaSettingsColors.inviteDot,
                        width: d(BubbaSettingsMetrics.dividerWeight),
                      ),
                    ),
                    child: i < joined
                        ? Container(
                            width: d(10),
                            height: d(10),
                            decoration: const BoxDecoration(
                              color: BubbaSettingsColors.rowLabel,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.link, this.onCopy, this.onShare});

  final String link;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final labelMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.uiMedium);
    final linkMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.purchaseSubtitle);
    final ctaMetrics =
        bubbaDesignTextMetrics(context, BubbaSettingsText.ctaLabel);

    Widget at(double left, double top, Widget child) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: hd(left - 16.82),
              top: d(top - 625.50),
            ),
            child: child,
          ),
        );

    return Row(
      children: [
        SizedBox(width: hd(16.82)),
        Container(
          width: hd(354),
          height: d(166),
          decoration: BoxDecoration(
            color: BubbaSettingsColors.pageBg,
            border: Border.all(
              color: BubbaSettingsColors.cardBorder,
              width: d(0.5),
            ),
            borderRadius:
                BorderRadius.circular(d(BubbaSettingsMetrics.cardRadius)),
          ),
          child: Stack(
            children: [
              at(
                34.95,
                655.51 - labelMetrics.baseline,
                Text(
                  'Your invitation link',
                  style: BubbaSettingsText.uiMedium
                      .copyWith(color: BubbaSettingsColors.inviteInk),
                ),
              ),
              at(
                35.32,
                674,
                Container(
                  width: hd(213),
                  height: d(43),
                  decoration: BoxDecoration(
                    color: BubbaSettingsColors.inviteField,
                    borderRadius: BorderRadius.circular(d(9.42)),
                  ),
                ),
              ),
              at(
                50.02,
                699.96 - linkMetrics.baseline,
                Text(link, style: BubbaSettingsText.purchaseSubtitle
                    .copyWith(color: BubbaSettingsColors.rowLabel)),
              ),
              at(
                257.32,
                674,
                Semantics(
                  button: true,
                  label: 'Copy link',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onCopy,
                    child: Container(
                      width: hd(90),
                      height: d(43),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF010101),
                        borderRadius: BorderRadius.circular(d(9.42)),
                      ),
                      child: Text('Copy Link', style: BubbaSettingsText.ctaLabel),
                    ),
                  ),
                ),
              ),
              at(
                35.32,
                729,
                Semantics(
                  button: true,
                  label: 'Share invitation',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onShare,
                    child: Container(
                      width: hd(312),
                      height: d(43),
                      decoration: BoxDecoration(
                        color: const Color(0xFF010101),
                        borderRadius: BorderRadius.circular(d(9.42)),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: hd(120.29 - 35.32),
                                top: d(742.90 - 729),
                              ),
                              child: const BubbaGlyphIcon(
                                BubbaSettingsGlyphs.shareMark,
                                color: BubbaSettingsColors.onDark,
                                width: 13.50,
                                height: 16.01,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: hd(147.95 - 35.32),
                                top: d(756.42 - 729 - ctaMetrics.baseline),
                              ),
                              child: Text(
                                'Share invitation',
                                style: BubbaSettingsText.ctaLabel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BubbaInvitationLinkScreen extends StatefulWidget {
  const BubbaInvitationLinkScreen({super.key});

  @override
  State<BubbaInvitationLinkScreen> createState() =>
      _BubbaInvitationLinkScreenState();
}

class _BubbaInvitationLinkScreenState extends State<BubbaInvitationLinkScreen> {
  String? _code;
  int _joined = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final overview = await Get.find<ReferralRepository>().fetchOverview();
    if (!mounted) return;
    setState(() {
      _code = overview?.referralCode;
      _joined = overview?.referredUsersCount ?? 0;
    });
  }

  String get _link =>
      AppConfig.inviteLink(_code ?? '');

  @override
  Widget build(BuildContext context) => SettingsInvitationLinkView(
        link: _link,
        joined: _joined,
        onBack: Get.back,
        onCopy: _link.isEmpty
            ? null
            : () {
                Clipboard.setData(ClipboardData(text: _link));
              },
        onShare: _link.isEmpty
            ? null
            : () => SharePlus.instance.share(
                  ShareParams(text: 'Join me on Bubba: $_link'),
                ),
      );
}
