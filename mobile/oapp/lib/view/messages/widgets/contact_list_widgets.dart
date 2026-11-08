import 'package:OApp/config/app_common_sizes.dart';
import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/common_widgets/buttons.dart';
import 'package:OApp/view/messages/controller/chat_list_controller.dart';
import 'package:OApp/view/messages/models/contact_model.dart';
import 'package:OApp/view/messages/sub_widgets/circular_timer.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';

class EmptyChatWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final VoidCallback onContinueSwiping;

  const EmptyChatWidget({
    super.key,
    required this.onRefresh,
    required this.onContinueSwiping,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Divider(color: AppColors.grey[300], height: 1),
          EmptySectionHeader(title: 'Matches', count: 0),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(16),
              vertical: MediaQueryUtil.spacing(14),
            ),
            child: Text(
              'No new matches',
              style: AppTextStyles.verySmall(
                fontWeight: AppFontWeight.semiBold,
                fontFamily: AppFontFamily.playfair,
              ),
            ),
          ),

          SizedBox(height: MediaQueryUtil.spacing(40)),
          Divider(color: AppColors.grey[300], height: 1),
          EmptySectionHeader(title: 'Conversations', count: 0),
          SizedBox(height: MediaQueryUtil.height * 0.1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(24),
            ),
            child: Column(
              children: [
                Text(
                  'Conversations will appear here',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.large(
                    fontWeight: AppFontWeight.semiBold,
                    fontFamily: AppFontFamily.playfair,
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(18)),
                Text(
                  'Matches will appear here only when the conversation has been started. Start a conversation by tapping on one of your matches. You have a maximum of 60 minutes to converse.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.verySmall(
                    fontWeight: AppFontWeight.semi,
                    color: AppColors.darkGrey,
                    fontFamily: AppFontFamily.playfair,
                  ),
                ),
                SizedBox(height: MediaQueryUtil.spacing(48)),

                CommonButtons.commonButton(
                  borderRadius: 10,
                  text: 'Continue swiping',
                  onPressed: onContinueSwiping,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQueryUtil.spacing(40)),
        ],
      ),
    );
  }
}

class EmptySectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const EmptySectionHeader({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(10),
      ),
      child: Text(
        '$title ($count)',
        style: AppTextStyles.regular(fontWeight: AppFontWeight.semiBold),
      ),
    );
  }
}

class ContactDisconnectedBanner extends StatelessWidget {
  const ContactDisconnectedBanner({
    super.key,
    required this.controller,
  });

  final ChatListController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cFF006C6A,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(12),
        vertical: MediaQueryUtil.spacing(8),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: MediaQueryUtil.spacing(8),
        runSpacing: MediaQueryUtil.spacing(4),
        children: [
          Icon(
            Icons.wifi_off,
            color: AppColors.white,
            size: MediaQueryUtil.spacing(16),
          ),
          Text(
            'Please connect with stable Wi-Fi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: MediaQueryUtil.fontSize(12),
            ),
          ),
          TextButton(
            onPressed: controller.connect,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(6),
                vertical: 0,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'RETRY',
              style: TextStyle(
                color: AppColors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactMatchAvatar extends StatelessWidget {
  const ContactMatchAvatar({
    super.key,
    required this.controller,
    required this.contact,
  });

  final ChatListController controller;
  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.openChat(contact),
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.darkBrown, width: 3),
            ),
            child: ClipOval(
              child: SizedBox(
                width: AppCommonSizes.contactAvatarSize(),
                height: AppCommonSizes.contactAvatarSize(),
                child: contact.imagePath.isNotEmpty
                    ? Base64OrNetworkImage(imageData: contact.imagePath)
                    : const Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactConversationItem extends StatelessWidget {
  const ContactConversationItem({
    super.key,
    required this.controller,
    required this.contact,
  });

  final ChatListController controller;
  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    final bool isUnread = contact.unreadCount > 0;

    return InkWell(
      onTap: () {
        controller.openChat(contact);
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQueryUtil.spacing(10),
              vertical: MediaQueryUtil.spacing(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Unread dot area
                SizedBox(
                  width: MediaQueryUtil.spacing(12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: isUnread
                        ? Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                /// Profile image
                ClipOval(
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: contact.imagePath.isNotEmpty
                        ? Base64OrNetworkImage(imageData: contact.imagePath)
                        : const Icon(Icons.person),
                  ),
                ),

                SizedBox(width: MediaQueryUtil.spacing(16)),

                /// Name + message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        contact.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.small(
                          fontWeight: AppFontWeight.semi,

                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: MediaQueryUtil.spacing(4)),

                      Text(
                        contact.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.small(
                          color: isUnread
                              ? AppColors.black87
                              : AppColors.textgrey,

                          fontWeight: AppFontWeight.semi,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: MediaQueryUtil.spacing(12)),
                Visibility(
                  visible: contact.isReported,
                  child: Row(
                    children: [Icon(Icons.report, color: AppColors.dangerRed)],
                  ),
                ),

                /// KEEP EXACTLY SAME
                Builder(
                  builder: (context) {
                    final shouldShowTimer = controller.shouldShowContactTimer(
                      contact,
                    );
                    final isValid = controller.isContactTimeValid(contact);

                    if (!shouldShowTimer) {
                      return const SizedBox.shrink();
                    }

                    return ChatMatchTimer(
                      remaining: isValid
                          ? contact.timeRemainingMatch
                          : Duration.zero,
                      totalMinutes: 24 * 60,
                      size: 45,
                      strokeWidth: isValid ? 1 : 1.5,
                      normalProgressColor: isValid
                          ? AppColors.orange
                          : AppColors.dangerRed,
                      expiredProgressColor: AppColors.dangerRed.withValues(
                        alpha: 0.20,
                      ),
                      trackColor: isValid
                          ? AppColors.orange.withValues(alpha: 0.20)
                          : AppColors.dangerRed.withValues(alpha: 0.80),
                      textColor: isValid
                          ? AppColors.black87
                          : AppColors.dangerRed,
                      fontSize: MediaQueryUtil.fontSize(9),
                    );
                  },
                ),
              ],
            ),
          ),

          /// Divider starts after dot + avatar area
          Padding(
            padding: EdgeInsets.only(
              left:
                  MediaQueryUtil.spacing(26) +
                  52 + // avatar size
                  MediaQueryUtil.spacing(16), // gap after avatar
              right: MediaQueryUtil.spacing(10),
            ),
            child: Divider(height: 1, thickness: 1, color: AppColors.grey[300]),
          ),
        ],
      ),
    );
  }
}
