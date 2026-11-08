import 'dart:async';

import 'package:OApp/extenshions/duration_extenshion.dart';
import 'package:OApp/models/chat_message_model.dart';
import 'package:OApp/core/constants/app_keys.dart';
import 'package:OApp/data/repositories/chat_repository.dart';
import 'package:OApp/services/dailog_service.dart';
import 'package:OApp/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ProfileMaking/profile_making_controller/profile_controller.dart';
import '../../../services/secure_storage_service.dart';
import '../models/chat_history_model.dart';
import 'chat_list_controller.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepo = Get.find<ChatRepository>();
  final SocketService _socketService = Get.find<SocketService>();
  ChatListController get chatlistController => Get.find<ChatListController>();
  final SecureStorageService _storage = Get.find<SecureStorageService>();
  ProfileController get profileController => Get.find<ProfileController>();
  DialogService get dialogService => Get.find<DialogService>();

  /// -------- Chat target --------
  Rx<String> targetUserId = ''.obs;
  final Rx<ChatHistoryResponse?> chatHistoryResponse = Rx<ChatHistoryResponse?>(
    null,
  );
  final RxString name = ''.obs;
  final RxString heroTag = ''.obs;
  final RxString timeLeft = ''.obs;
  final RxnString profileImageUrl = RxnString();
  RxBool isValidTimeRx = false.obs;

  /// -------- UI controllers --------
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  /// -------- State --------
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isOtherUserTyping = false.obs;

  RxBool get isConnected => _socketService.isConnected;

  final Rxn<ChatMessageModel> replyingTo = Rxn<ChatMessageModel>();

  String? currentUserId;

  Worker? _msgWorker;
  Worker? _typingWorker;
  Worker? _contactWorker;

  int _lastMessageCount = 0;

  /// current joined room
  String? _currentRoom;
  Timer? _typingDebounce;
  bool _hasSentTypingStart = false;
  final RxBool isLoadingMore = false.obs;

  String durationMatch() {
    if (targetUserId.isEmpty) return "";
    final duration = chatlistController
        .getContactById(targetUserId.value)
        .timeRemainingMatch;
    return duration?.toHoursMinutesColon() ?? "";
  }

  Future<String> getmatchedAt() async {
    if (targetUserId.isEmpty) return "";
    return await chatlistController.getFormattedMatchTime(targetUserId.value);
  }

  /// --------------------------------------------------
  /// INIT
  /// --------------------------------------------------

  @override
  Future<void> onInit() async {
    super.onInit();

    currentUserId = await _storage.getKey(AppKeys.userID);

    await _readArgs();

    /// listen for incoming messages
    _msgWorker = ever<ChatMessageModel?>(
      _socketService.lastMessage,
      _handleIncomingMessage,
    );

    _typingWorker = ever<Map<String, DateTime>>(
      _socketService.typingUsers,
      (_) => _syncTypingIndicator(),
    );
    _contactWorker = ever(
      chatlistController.contacts,
      (_) => _refreshMatchValidity(),
    );
    scrollController.addListener(_onScroll);
    messageController.addListener(_handleMessageInputChanged);
  }

  Future<bool> isValidTime() async {
    if (targetUserId.value.isEmpty) return true;
    return await chatlistController.isValidTime(contactId: targetUserId.value);
  }

  void _refreshMatchValidity() {
    if (targetUserId.value.isEmpty) {
      isValidTimeRx.value = true;
      return;
    }

    isValidTimeRx.value = chatlistController.isContactTimeValidById(
      targetUserId.value,
    );
  }

  DateTime? _lastScrollTrigger;

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final now = DateTime.now();

    if (_lastScrollTrigger != null &&
        now.difference(_lastScrollTrigger!) <
            const Duration(milliseconds: 800)) {
      return;
    }

    final position = scrollController.position;

    if (position.pixels <= 100 &&
        chatHistoryResponse.value?.cursor?.hasMore == true &&
        !isLoadingMore.value) {
      _lastScrollTrigger = now;

      isLoadingMore.value = true;

      loadHistory(
        nextId: chatHistoryResponse.value?.cursor?.nextId,
        nextCursor: chatHistoryResponse.value?.cursor?.nextCursor
            ?.toIso8601String(),
      );
    }
  }

  void showCupertinoDialog() {
    dialogService.showMatchActionSheet(
      context: Get.context!,
      onUnmatch: () async {
        var res = await dialogService.selectionDialog(
          message: DialogMessage(
            title: 'Are you sure you want to unmatch?',
            subheading:
                'Unmatching will permantley remove this member from your matches and any ability to communnicate',
            okText: 'Unmatch',
            cancelText: 'Cancel',
          ),
        );
        debugPrint("res= $res");
        MatchModel? match = await chatlistController.getMatchById(
          targetUserId.value,
        );
        if (res == true && match != null) {
          await chatlistController.unMatch(match.matchId);
        }
      },
      onHide: () {
        chatlistController.hideContactById(targetUserId.value);
      },
      onReport: () {
        chatlistController.reportContactByApi(targetUserId.value);
      },
    );
  }

  /// --------------------------------------------------
  /// READ ROUTE ARGUMENTS
  /// --------------------------------------------------

  Future<void> _readArgs() async {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) return;

    targetUserId.value = args['targetUserId'];

    if (targetUserId.value.isEmpty || currentUserId == null) return;

    /// prevent self chat
    if (targetUserId.value == currentUserId) {
      debugPrint("Prevented self chat");
      return;
    }

    name.value = args['name'] ?? '';
    heroTag.value = args['heroTag'] ?? '';
    timeLeft.value = args['timeLeft'] ?? '';
    profileImageUrl.value = args['profileImageUrl'];
    targetUserId.value = args['targetUserId'];
    debugPrint("Opening chat with $targetUserId");

    checkContactExists(targetUserId.value);

    final cachedMessages = chatlistController.getCachedMessages(
      targetUserId.value,
    );
    final cachedCursor = chatlistController.getCachedCursor(targetUserId.value);

    if (cachedMessages.isNotEmpty) {
      messages.value = cachedMessages;
      chatHistoryResponse.value = ChatHistoryResponse(
        messages: cachedMessages,
        cursor: cachedCursor,
      );
      _lastMessageCount = cachedMessages.length;
    } else {
      messages.clear();
    }

    _refreshMatchValidity();

    await _joinRoom();

    /// send message if passed
    if (args['message'] != null && args['message'].toString().isNotEmpty) {
      sendMessage(args['message']);
    }

    await loadHistory(isInitial: true, silent: cachedMessages.isNotEmpty);
    _syncTypingIndicator();
  }

  /// --------------------------------------------------
  /// JOIN SOCKET ROOM
  /// --------------------------------------------------

  Future<void> _joinRoom() async {
    if (currentUserId == null) return;

    final roomId = _buildRoomId(currentUserId!, targetUserId.value);

    if (_currentRoom == roomId) {
      debugPrint("Already in room $roomId");
      return;
    }

    debugPrint("Joining room with $targetUserId");

    await _socketService.connect();

    if (!_socketService.isConnected.value) {
      await _socketService.isConnected.stream.firstWhere((v) => v);
    }

    _socketService.joinChat(targetUserId.value);

    _currentRoom = roomId;

    await Future.delayed(const Duration(milliseconds: 150));

    debugPrint("Room joined successfully: $_currentRoom");
  }

  void connect() => _socketService.connect();

  void _handleMessageInputChanged() {
    final text = messageController.text.trim();

    if (targetUserId.value.isEmpty) return;

    if (text.isEmpty) {
      _cancelTypingDebounce();
      _sendTypingStop();
      return;
    }

    if (!_hasSentTypingStart) {
      _socketService.startTyping(targetUserId.value);
      _hasSentTypingStart = true;
    }

    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(seconds: 2), _sendTypingStop);
  }

  /// --------------------------------------------------
  /// HANDLE INCOMING MESSAGE
  /// --------------------------------------------------
  // checkRemaining(ChatMessageModel msg) {
  //   bool isContactFound = false;
  //   chatlistController.contacts.forEach((contact) {
  //     if (contact.id == msg.senderId || contact.id == msg.receiverId) {
  //       contact.time = DateTime.now().toString().substring(11, 16);
  //       contact.message = msg.message;
  //       contact.unreadCount++;
  //       chatlistController.contacts.refresh();
  //       isContactFound = true;
  //     }
  //   });
  //   if (!isContactFound) {
  //     unawaited(chatlistController.findContact(msg.senderId));
  //   }
  // }

  void _handleIncomingMessage(ChatMessageModel? msg) {
    if (msg == null) return;

    debugPrint("CurrentUserId: $currentUserId");
    debugPrint("TargetUserId: $targetUserId");
    debugPrint("Message SenderId: ${msg.senderId}");
    debugPrint("Message ReceiverId: ${msg.receiverId}");

    final belongsToChat =
        (msg.senderId == targetUserId.value &&
            msg.receiverId == currentUserId) ||
        (msg.senderId == currentUserId && msg.receiverId == targetUserId.value);

    debugPrint("BelongsToChat Result: $belongsToChat");

    if (!belongsToChat) {
      //   checkRemaining(msg);
      return;
    }

    if (messages.any((m) => m.id == msg.id)) return;

    messages.add(msg);
    chatlistController.upsertCachedMessage(targetUserId.value, msg);

    _autoScrollIfNeeded();
  }

  void _syncTypingIndicator() {
    final targetId = targetUserId.value;
    if (targetId.isEmpty) {
      isOtherUserTyping.value = false;
      return;
    }

    isOtherUserTyping.value = _socketService.typingUsers.containsKey(targetId);
  }

  /// --------------------------------------------------
  /// LOAD HISTORY
  /// --------------------------------------------------
  int limit = 25;
  Future<void> loadHistory({
    String? nextCursor,
    bool isInitial = false,
    String? nextId,
    bool silent = false,
  }) async {
    if (isInitial && !silent) {
      isLoading.value = true;
    }

    try {
      final history = await _chatRepo.fetchChatHistory(
        targetUserId.value,
        limit: limit,
        cursor: nextCursor,
        id: nextId,
      );
      debugPrint("Chat history nextCursor: $nextCursor Next Id  $nextId");
      if (history != null) {
        chatHistoryResponse.value = history;

        final newMessages = history.messages;

        if (isInitial) {
          messages.value = newMessages;
          chatlistController.cacheChatPreview(
            targetUserId.value,
            newMessages,
            cursor: chatHistoryResponse.value?.cursor,
          );
        } else {
          final newMessages = chatHistoryResponse.value?.messages ?? [];

          // Remove duplicates (important during pagination)
          final filtered = newMessages.where((newMsg) {
            return !messages.any((m) => m.id == newMsg.id);
          }).toList();

          debugPrint(
            "Chat history: newMessages ${newMessages.length}- after filtering duplicates ${filtered.length} ",
          );

          // Insert at top
          messages.insertAll(0, filtered);

          // Ensure correct order
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          messages.refresh();
          chatlistController.cacheChatPreview(
            targetUserId.value,
            messages,
            cursor: chatHistoryResponse.value?.cursor,
          );
        }
        checkIfPrompt();
        // update cursor

        if (isInitial || silent) {
          _autoScrollIfNeeded(force: isInitial, forceJump: isInitial);
        }
      }
    } catch (e) {
      debugPrint("Chat history error: $e");
    } finally {
      if (isInitial && !silent) {
        isLoading.value = false;
      } else if (!isInitial) {
        isLoading.value = false;
      }
      isLoadingMore.value = false;
    }
  }

  void checkIfPrompt() {
    for (var msg in messages) {
      final like = msg.initiatedFromLike;

      if (like != null && like.isReply == true && like.icebreakerId != null) {
        final prompt = profileController.getPrompt(like.icebreakerId!);

        if (prompt.isNotEmpty) {
          msg.initiatedFromLike = like.copyWith(prompt: prompt);
        }
      }
    }
  }

  /// --------------------------------------------------
  /// REPLY
  /// --------------------------------------------------

  void setReply(ChatMessageModel msg) => replyingTo.value = msg;

  void cancelReply() => replyingTo.value = null;

  /// --------------------------------------------------
  /// SEND MESSAGE
  /// --------------------------------------------------

  void sendFromInput() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    _sendTypingStop();
    sendMessage(text);

    messageController.clear();

    cancelReply();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    if (!_socketService.isConnected.value) {
      await _socketService.connect();
      await _socketService.isConnected.stream.firstWhere((v) => v);
    }

    if (_currentRoom == null) {
      await _joinRoom();
    }

    debugPrint("Sending message to $targetUserId");

    _socketService.sendMessage(targetUserId.value, text);
  }

  /// --------------------------------------------------
  /// SCROLL
  /// --------------------------------------------------

  void _autoScrollIfNeeded({bool force = false, bool forceJump = false}) {
    final currentCount = messages.length;

    if (!force && currentCount == _lastMessageCount) return;

    _lastMessageCount = currentCount;

    scrollToBottom(forceJump: forceJump);
  }

  String _buildRoomId(String a, String b) {
    final ids = [a, b]..sort();
    return "${ids[0]}_${ids[1]}";
  }

  void scrollToBottom({bool forceJump = false}) {
    void scrollAttempt(int remainingAttempts) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!scrollController.hasClients) return;

        final position = scrollController.position;
        final target = position.maxScrollExtent.clamp(
          position.minScrollExtent,
          double.infinity,
        );

        if (forceJump) {
          scrollController.jumpTo(target);
        } else {
          await scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }

        if (remainingAttempts <= 0 || !scrollController.hasClients) return;

        final updatedMax = scrollController.position.maxScrollExtent;
        final distanceFromBottom = updatedMax - scrollController.offset;

        if (distanceFromBottom > 8) {
          scrollAttempt(remainingAttempts - 1);
        }
      });
    }

    scrollAttempt(3);
  }

  /// --------------------------------------------------
  /// CLEANUP
  /// --------------------------------------------------

  @override
  void onClose() {
    _msgWorker?.dispose();
    _typingWorker?.dispose();
    _contactWorker?.dispose();
    messageController.removeListener(_handleMessageInputChanged);
    _cancelTypingDebounce();
    _sendTypingStop();

    if (targetUserId.value.isNotEmpty) {
      _socketService.leaveChat(targetUserId.value);
    }

    messageController.dispose();
    scrollController.dispose();

    super.onClose();
  }

  void checkContactExists(String value) {
    int index = chatlistController.contacts.indexWhere((c) => c.id == value);
    if (index == -1 ||
        (chatlistController.contacts[index].timeRemainingMatch == null)) {
      unawaited(chatlistController.findContact(value, value));
    }
  }

  void _cancelTypingDebounce() {
    _typingDebounce?.cancel();
    _typingDebounce = null;
  }

  void _sendTypingStop() {
    if (!_hasSentTypingStart || targetUserId.value.isEmpty) return;

    _socketService.stopTyping(targetUserId.value);
    _hasSentTypingStart = false;
    _cancelTypingDebounce();
  }
}
