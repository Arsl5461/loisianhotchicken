import 'package:OApp/config/app_common_sizes.dart';
import 'package:OApp/core/constants/app_colors.dart';
import 'package:OApp/core/typography/app_text_styles.dart';
import 'package:OApp/utils/media_query.dart';
import 'package:OApp/utils/toast.dart';
import 'package:OApp/view/messages/controller/chat_list_controller.dart';
import 'package:OApp/view/messages/widgets/contact_list_widgets.dart';
import 'package:OApp/widgets/Images/base64OrNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chatlist extends GetView<ChatListController> {
  const Chatlist({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Connections',

          style: AppTextStyles.text(
            customSize: MediaQueryUtil.fontSize(18),

            fontWeight: AppFontWeight.semiBold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: BlurShimmerPlaceholder());
        }

        final matchesContacts = controller.contacts
            .where((c) => !c.isHidden)
            .toList();

        final conversationContacts = controller.contacts
            .where((c) => !c.isHidden && !c.isMessagesEmpty)
            .toList();

        final hiddenContacts = controller.contacts
            .where((c) => c.isHidden)
            .toList();

        if (controller.contacts.isEmpty) {
          return EmptyChatWidget(
            onRefresh: controller.refreshChatList,
            onContinueSwiping: controller.goToHomeTab,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshChatList,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              if (!controller.isConnected.value)
                ContactDisconnectedBanner(controller: controller),

              Divider(color: AppColors.grey[300], height: 1),

              EmptySectionHeader(
                title: 'Matches',
                count: matchesContacts.length,
              ),
              if (matchesContacts.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                    vertical: MediaQueryUtil.spacing(20),
                  ),
                  child: Text(
                    'No matches available',
                    style: AppTextStyles.small(color: AppColors.grey),
                  ),
                )
              else
                SizedBox(
                  height: AppCommonSizes.getContactListHeaderHeight(),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.spacing(16),
                      vertical: MediaQueryUtil.spacing(10),
                    ),
                    itemBuilder: (_, index) {
                      final contact = matchesContacts[index];
                      return ContactMatchAvatar(
                        controller: controller,
                        contact: contact,
                      );
                    },
                    separatorBuilder: (_, __) =>
                        SizedBox(width: MediaQueryUtil.spacing(16)),
                    itemCount: matchesContacts.length,
                  ),
                ),

              Divider(color: AppColors.grey[300], height: 1),

              EmptySectionHeader(
                title: 'Conversations',
                count: conversationContacts.length,
              ),

              if (conversationContacts.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                    vertical: MediaQueryUtil.spacing(20),
                  ),
                  child: Text(
                    'No conversations yet',
                    style: AppTextStyles.small(color: AppColors.grey),
                  ),
                )
              else
                ...conversationContacts.map((contact) {
                  final index = controller.contacts.indexOf(contact);

                  return Dismissible(
                    key: Key(contact.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(
                        right: MediaQueryUtil.spacing(20),
                      ),
                      color: AppColors.darkBrown,
                      child: Text(
                        "Hide",
                        style: AppTextStyles.small(
                          color: AppColors.white,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                    onDismissed: (_) {
                      controller.hideContact(index);
                      Toast.info("${contact.name} moved to hidden chats");
                    },
                    child: Column(
                      children: [
                        ContactConversationItem(
                          controller: controller,
                          contact: contact,
                        ),
                      ],
                    ),
                  );
                }),

              if (hiddenContacts.isNotEmpty) ...[
                Container(
                  margin: EdgeInsets.only(left: MediaQueryUtil.spacing(78)),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQueryUtil.spacing(16),
                    vertical: MediaQueryUtil.spacing(14),
                  ),
                  child: InkWell(
                    onTap: controller.openHiddenChats,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Hidden (${hiddenContacts.length})',
                                style: AppTextStyles.verySmall(
                                  color: AppColors.black,
                                  fontWeight: AppFontWeight.semiBold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // SizedBox(width: MediaQueryUtil.spacing(8)),
                            // Icon(
                            //   Icons.keyboard_arrow_right,
                            //   color: AppColors.grey,
                            //   size: MediaQueryUtil.spacing(20),
                            // ),
                          ],
                        ),
                        SizedBox(height: MediaQueryUtil.spacing(12)),
                        Divider(color: AppColors.grey[300], height: 1),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: MediaQueryUtil.spacing(20)),
            ],
          ),
        );
      }),
    );
  }
}
