import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/view/messages/controller/chat_list_controller.dart';
import 'package:OApp/view/messages/models/contact_model.dart';
import 'package:OApp/view/messages/sub_widgets/circular_timer.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HiddenChatsPage extends GetView<ChatListController> {
  const HiddenChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Hidden Chats',
          style: AppTextStyles.regular(fontWeight: AppFontWeight.semiBold),
        ),
      ),
      body: Obx(() {
        final hiddenContacts = controller.hiddenContacts;

        if (hiddenContacts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryUtil.spacing(24),
              ),
              child: Text(
                'No hidden chats right now.',
                textAlign: TextAlign.center,
                style: AppTextStyles.small(color: AppColors.grey[700]),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(top: MediaQueryUtil.spacing(12)),
          itemCount: hiddenContacts.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            thickness: 1,
            color: AppColors.grey[300],
            indent:
                MediaQueryUtil.spacing(26) + 52 + MediaQueryUtil.spacing(16),
            endIndent: MediaQueryUtil.spacing(20),
          ),
          itemBuilder: (_, index) {
            final contact = hiddenContacts[index];

            return Dismissible(
              key: Key('hidden_${contact.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: MediaQueryUtil.spacing(20)),
                color: AppColors.darkBrown,
                child: Text(
                  'Unhide',
                  style: AppTextStyles.small(
                    color: AppColors.white,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
              onDismissed: (_) {
                controller.unhideContactById(contact.id);
              },
              child: _HiddenChatTile(contact: contact),
            );
          },
        );
      }),
    );
  }
}

class _HiddenChatTile extends GetView<ChatListController> {
  final ContactModel contact;

  const _HiddenChatTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = (contact.unreadCount) > 0;

    return Opacity(
      opacity: 0.72,
      child: InkWell(
        onTap: () => controller.openChat(contact),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.spacing(10),
            vertical: MediaQueryUtil.spacing(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    // SizedBox(height: MediaQueryUtil.spacing(10)),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: OutlinedButton(
                    //     onPressed: () {
                    //       controller.unhideContactById(contact.id);
                    //       Toast.info('${contact.name} moved back to chats');
                    //     },
                    //     style: OutlinedButton.styleFrom(
                    //       foregroundColor: AppColors.cFF006C6A,
                    //       side: const BorderSide(color: AppColors.cFF006C6A),
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: MediaQueryUtil.spacing(12),
                    //         vertical: MediaQueryUtil.spacing(8),
                    //       ),
                    //       minimumSize: Size.zero,
                    //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //     ),
                    //     child: const Text('Unhide'),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(width: MediaQueryUtil.spacing(12)),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                        expiredProgressColor: AppColors.dangerRed,
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
                  SizedBox(height: MediaQueryUtil.spacing(8)),
                  Text(
                    'Swipe to unhide',
                    style: AppTextStyles.extraSmall(color: AppColors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
