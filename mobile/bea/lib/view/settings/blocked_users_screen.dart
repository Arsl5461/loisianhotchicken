import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design/bubba_layout.dart';
import '../../core/design/bubba_security_tokens.dart';
import '../../core/routing/app_routes.dart';
import 'bubba_security_controller.dart';
import 'settings_feedback.dart';
import 'widgets/security_chrome.dart';

class BubbaBlockedUser {
  const BubbaBlockedUser({
    required this.id,
    required this.name,
    required this.blockedOn,
    this.photo,
  });

  final String id;
  final String name;
  final DateTime blockedOn;
  final String? photo;
}

const List<String> _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String bubbaLongDate(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}, ${date.year}';

String bubbaBlockedOnLabel(DateTime date) => 'Blocked on ${bubbaLongDate(date)}';

/// The empty state is the real one: a fresh account has nothing blocked, and
/// the list only fills once `safety/blockUser` has been called for somebody.
class BubbaBlockedUsersScreen extends StatefulWidget {
  const BubbaBlockedUsersScreen({super.key});

  @override
  State<BubbaBlockedUsersScreen> createState() =>
      _BubbaBlockedUsersScreenState();
}

class _BubbaBlockedUsersScreenState extends State<BubbaBlockedUsersScreen> {
  BubbaSecurityController get _controller => BubbaSecurityController.to;

  @override
  void initState() {
    super.initState();
    _controller.loadBlocked(force: true);
  }

  Future<void> _unblock(BubbaBlockedUser user) async {
    final done = await Get.toNamed(
      Routes.BUBBA_CONFIRM_UNBLOCK,
      arguments: {'name': user.name, 'id': user.id, 'photo': user.photo},
    );
    if (done == true) await _controller.loadBlocked(force: true);
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final error = _controller.blockedError.value;
        if (error != null && _controller.blocked.isEmpty) {
          showSettingsError(error);
        }

        return BlockedUsersView(
          users: [
            for (final user in _controller.blocked)
              BubbaBlockedUser(
                id: user.id,
                name: user.fullName,
                blockedOn: user.blockedAt ?? DateTime.now(),
                photo: user.photo,
              ),
          ],
          onBack: Get.back,
          onUnblock: _unblock,
        );
      });
}

class BlockedUsersView extends StatelessWidget {
  const BlockedUsersView({
    super.key,
    this.users = const [],
    this.onBack,
    this.onUnblock,
  });

  final List<BubbaBlockedUser> users;
  final VoidCallback? onBack;
  final ValueChanged<BubbaBlockedUser>? onUnblock;

  static const double rowPitch = 62;

  @override
  Widget build(BuildContext context) => SecurityScaffold(
        navTitle: 'Blocked Users',
        onBack: onBack,
        content: users.isEmpty ? _empty : _list,
      );

  void _empty(BuildContext context, BubbaFlow flow) {
    final m = bubbaDesignTextMetrics(context, BubbaSecurityText.emptyTitle);
    flow.block(
      Text(
        'No blocked users',
        textAlign: TextAlign.center,
        style: BubbaSecurityText.emptyTitle,
      ),
      top: 351.44 - m.baseline,
      height: m.lineHeight,
      align: Alignment.center,
    );
    securityLead(
      context,
      flow,
      const [
        'Users you block will appear here.',
        'They won’t be able to discover',
        'your profile or contact you.',
      ],
      firstBaseline: 392.28,
    );
  }

  void _list(BuildContext context, BubbaFlow flow) {
    securityLead(
      context,
      flow,
      const [
        'Manage users you’ve blocked.',
        'They can’t discover your profile',
        'or contact you',
      ],
      firstBaseline: 109.61,
    );

    for (var i = 0; i < users.length; i++) {
      flow.block(
        _BlockedUserRow(
          user: users[i],
          onUnblock: onUnblock,
        ),
        top: 189.00 + i * rowPitch,
        height: rowPitch,
      );
    }
  }
}

class _BlockedUserRow extends StatelessWidget {
  const _BlockedUserRow({required this.user, this.onUnblock});

  final BubbaBlockedUser user;
  final ValueChanged<BubbaBlockedUser>? onUnblock;

  static const double avatarX = 24.89;
  static const double avatarSize = 40.78;
  static const double top = 189.00;
  static const double nameX = 90.14;
  static const double nameBaseline = 208.03;
  static const double dateBaseline = 225.91;
  static const double actionBaseline = 215.73;
  static const double actionRightGap = 22.28;

  @override
  Widget build(BuildContext context) {
    final nameMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.blockedName);
    final dateMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.blockedDate);
    final actionMetrics =
        bubbaDesignTextMetrics(context, BubbaSecurityText.unblockAction);
    final nameTop = nameBaseline - nameMetrics.baseline;
    final dateTop = dateBaseline - dateMetrics.baseline;
    final actionTop = actionBaseline - actionMetrics.baseline;
    final actionPainted = d(actionMetrics.lineHeight);
    final actionBox = BubbaScale.tapBox(actionPainted);
    // The 44pt floor is ours, not the design's, so the label keeps its exact
    // baseline and the box takes what room it has above, the rest below.
    final wanted = (actionBox - actionPainted) / 2;
    final above = math.min(wanted, d(actionTop - top));
    final below = actionBox - actionPainted - above;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecurityAvatar(
          x: avatarX,
          size: avatarSize,
          photoUrl: user.photo,
          semanticsLabel: user.name,
        ),
        SizedBox(width: hd(nameX - avatarX - avatarSize)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: d(nameTop - top)),
              Text(user.name, style: BubbaSecurityText.blockedName),
              SizedBox(
                height: d(dateTop - (nameTop + nameMetrics.lineHeight)),
              ),
              Text(
                bubbaBlockedOnLabel(user.blockedOn),
                style: BubbaSecurityText.blockedDate,
              ),
            ],
          ),
        ),
        Column(
          children: [
            SizedBox(height: d(actionTop - top) - above),
            Semantics(
              button: true,
              label: 'Unblock ${user.name}',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onUnblock == null ? null : () => onUnblock!(user),
                child: Padding(
                  padding: EdgeInsets.only(top: above, bottom: below),
                  child: Text(
                    'Unblock',
                    style: BubbaSecurityText.unblockAction,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: hd(actionRightGap)),
      ],
    );
  }
}
