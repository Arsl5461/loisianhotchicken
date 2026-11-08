import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/user_model.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Images/base64OrNetworkImage.dart';
import '../../common_widgets/bottom_sheets.dart';
import '../models/comment_model.dart';

class RepliesBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required List<CommentModel> comments,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CommonBottomSheets.commonBottomSheet(
          centerTitle: true,
          title: 'Replies',
          child: RepliesBottomSheetContent(comments: comments),
        );
      },
    );
  }
}

class RepliesBottomSheetContent extends StatelessWidget {
  final List<CommentModel> comments;

  const RepliesBottomSheetContent({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: comments.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No replies found'),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemCount: comments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final item = comments[index];
                return ReplyItem(comment: item);
              },
            ),
    );
  }
}

class ReplyItem extends StatelessWidget {
  final CommentModel comment;

  const ReplyItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final imageUrl = comment.user?.photos?.isNotEmpty == true
        ? comment.user!.photos?.first
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: (imageUrl != null)
              ? Base64OrNetworkImage.getImageProvider(imageUrl)
              : null,
          backgroundColor: AppColors.white.withValues(alpha: 0.75),
          child: (imageUrl == null)
              ? Icon(Icons.person, color: AppColors.grey[700], size: 18)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.user?.fullName ?? 'Unknown User',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                comment.comment,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(comment.dateTime),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send_outlined, size: 22),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'pm' : 'am';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }
}

class UsersBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<UserModel> users,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return CommonBottomSheets.commonBottomSheet(
          title: title,
          centerTitle: true,
          child: UsersList(users: users),
        );
      },
    );
  }
}

class UsersList extends StatelessWidget {
  final List<UserModel> users;

  const UsersList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: users.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: MediaQueryUtil.spacing(18)),
        itemBuilder: (_, index) {
          final user = users[index];
          return UserItem(user: user);
        },
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  final UserModel user;

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final photo = (user.photos ?? []).isNotEmpty ? user.photos?.first : null;

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: (photo != null)
              ? Base64OrNetworkImage.getImageProvider(photo)
              : null,
          backgroundColor: AppColors.white.withValues(alpha: 0.75),
          child: (photo == null)
              ? Icon(Icons.person, color: AppColors.grey[700], size: 18)
              : null,
        ),

        SizedBox(width: MediaQueryUtil.spacing(14)),

        Expanded(
          child: Text(
            user.fullName ?? "",
            style: TextStyle(
              fontSize: MediaQueryUtil.fontSize(16),
              fontWeight: FontWeight.w600,
              color: AppColors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
