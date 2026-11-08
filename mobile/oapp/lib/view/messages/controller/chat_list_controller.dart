import 'dart:async';

import 'package:OApp/config/error_handler.dart';
import 'package:OApp/models/chat_message_model.dart';
import 'package:OApp/data/repositories/chat_repository.dart';
import 'package:OApp/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/routing/app_routes.dart';
import '../../../services/global_service.dart';
import '../../Dashboard/dashboard_controller.dart';
import '../../../utils/toast.dart';
import '../models/contact_model.dart';
import '../models/chat_history_model.dart';

class ChatListController extends GetxController {
  static const int _previewLimit = 20;
  static const int _prefetchBatchSize = 4;

  final ChatRepository _chatRepo = Get.find<ChatRepository>();
  final SocketService _socketService = Get.find<SocketService>();
  final GlobalService _globalService = Get.find<GlobalService>();

  final String _tag = "ChatListController";
  RxList<MatchModel> matches = <MatchModel>[].obs;
  RxBool showHiddenContacts = false.obs;
  var contacts = <ContactModel>[].obs;
  var isLoading = true.obs;
  late Worker _messageWorker;
  RxBool get isConnected => _socketService.isConnected;
  Timer? _chatTimer;
  final Map<String, List<ChatMessageModel>> _chatPreviewCache = {};
  final Map<String, CursorModel?> _chatPreviewCursorCache = {};

  @override
  void onInit() {
    super.onInit();
    setupSocketListeners();
  }

  @override
  void onClose() {
    _messageWorker.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    getChatList();
  }

  void toggleHiddenContacts() {
    showHiddenContacts.value = !showHiddenContacts.value;
  }

  List<ContactModel> get hiddenContacts =>
      contacts.where((contact) => contact.isHidden).toList();

  Future<void> refreshChatList() async {
    await getChatList();
  }

  void goToHomeTab() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().changeIndex(0);
    }
  }

  Future<void> findContact(String senderId, String receiverId) async {
    try {
      var loggedInuserId = await _globalService.getUserId();
      final String currentUserId = await _globalService.getUserId() ?? '';
      final String otherUserId = senderId == currentUserId
          ? receiverId
          : senderId;

      final match = await _chatRepo.fetchSingleMatch(otherUserId);

      if (match != null) {
        matches.add(match);
        final user = match.user;
        Duration? timeRemainingMatch = DateTime.tryParse(
          match.matchedAt,
        )?.add(Duration(hours: 24)).difference(DateTime.now());

        final userId = user.id ?? '';
        final userName = user.fullName ?? 'Unknown';
        final image = (user.photos != null && user.photos!.isNotEmpty)
            ? user.photos!.first
            : '';

        final cachedPreview = getCachedMessages(userId);
        final previewMessage = _buildPreviewMessage(cachedPreview);

        final newContact = ContactModel(
          id: userId,
          name: userName,
          timeRemainingMatch: timeRemainingMatch,
          isHidden: match.isArchived.contains(loggedInuserId),
          message: previewMessage.message,
          time: previewMessage.time,
          imagePath: image,
          heroTag: 'chat_$userId',
          hasOnlineIndicator: true,
          timeLeft: 'Active now',
          isMessagesEmpty: previewMessage.isMessagesEmpty,
        );

        final existingIndex = contacts.indexWhere((c) => c.id == userId);

        if (existingIndex != -1) {
          contacts[existingIndex] = newContact;
        } else {
          contacts.insert(0, newContact);
        }

        contacts.refresh();
        unawaited(preloadChatPreview(userId));
      }
    } catch (e) {
      debugPrint('findContact error: $e');
    }
  }

  Future<void> getChatList() async {
    isLoading.value = true;
    var loggedInuserId = await _globalService.getUserId();
    try {
      final fetchedMatches = await _chatRepo.fetchMatches();

      if (fetchedMatches != null) {
        matches.value = fetchedMatches;
        List<ContactModel> tempContacts = [];

        for (var match in matches) {
          final user = match.user;
          final userId = match.userId;
          final userName = user.fullName ?? 'Unknown';
          final image = (user.photos != null && user.photos!.isNotEmpty)
              ? user.photos!.first
              : '';

          Duration? timeRemainingMatch = DateTime.tryParse(
            match.matchedAt,
          )?.add(Duration(hours: 24)).difference(DateTime.now());

          final cachedPreview = getCachedMessages(userId);
          final previewMessage = _buildPreviewMessage(cachedPreview);

          tempContacts.add(
            ContactModel(
              isReported: match.isReported,
              isMessagesEmpty: previewMessage.isMessagesEmpty,
              id: userId,
              name: userName,
              message: previewMessage.message,
              time: previewMessage.time,
              timeRemainingMatch: timeRemainingMatch,
              isHidden: match.isArchived.contains(loggedInuserId),
              imagePath: image,
              heroTag: 'chat_$userId',
              hasOnlineIndicator: true,
              timeLeft: 'Active now',
            ),
          );
        }

        contacts.value = tempContacts;
        unawaited(_prefetchChatPreviews(matches.map((match) => match.userId)));
      }
    } catch (e) {
      // handle error
    } finally {
      _startChatTimer();
      isLoading.value = false;
    }
  }

  void _startChatTimer() {
    _chatTimer?.cancel();
    _chatTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateContactTimers();
    });
  }

  void _updateContactTimers() {
    if (contacts.isEmpty) return;

    contacts.value = contacts.map((contact) {
      final current = contact.timeRemainingMatch;
      if (current == null) return contact;

      return contact.copyWith(
        timeRemainingMatch: current - const Duration(minutes: 1),
      );
    }).toList();
  }

  void setupSocketListeners() {
    _messageWorker = ever<ChatMessageModel?>(_socketService.lastMessage, (msg) {
      debugPrint('ChatListController: ever triggered -> $msg');

      if (msg == null) return;

      final index = contacts.indexWhere(
        (c) => c.id == msg.senderId || c.id == msg.receiverId,
      );

      debugPrint('ChatListController: found index -> $index');

      if (index != -1) {
        final contact = contacts[index];
        upsertCachedMessage(contact.id, msg);
        contact.message = msg.message;
        contact.time = _formatTime(msg.timestamp);
        contact.isMessagesEmpty = false;

        if (msg.senderId == contact.id) {
          contact.unreadCount++;
        }

        contacts.removeAt(index);
        contacts.insert(0, contact);
        contacts.refresh();

        debugPrint('ChatListController: contact updated');
      } else {
        debugPrint('ChatListController: contact not found, checking remaining');
        checkRemaining(msg);
      }
    });
  }

  List<ChatMessageModel> getCachedMessages(String userId) {
    return List<ChatMessageModel>.from(_chatPreviewCache[userId] ?? const []);
  }

  CursorModel? getCachedCursor(String userId) {
    return _chatPreviewCursorCache[userId];
  }

  Future<void> preloadChatPreview(String userId, {bool force = false}) async {
    if (!force && (_chatPreviewCache[userId]?.isNotEmpty ?? false)) return;

    try {
      final history = await _chatRepo.fetchChatHistory(
        userId,
        limit: _previewLimit,
      );

      if (history == null) return;
      cacheChatPreview(userId, history.messages, cursor: history.cursor);
    } catch (e) {
      debugPrint('preloadChatPreview error for $userId: $e');
    }
  }

  void cacheChatPreview(
    String userId,
    List<ChatMessageModel> newMessages, {
    CursorModel? cursor,
    bool merge = false,
  }) {
    final existing = merge ? getCachedMessages(userId) : <ChatMessageModel>[];
    final merged = [...existing, ...newMessages];
    final deduped = <String, ChatMessageModel>{};

    for (final message in merged) {
      deduped[message.id] = message;
    }

    final ordered = deduped.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final trimmed = ordered.length > _previewLimit
        ? ordered.sublist(ordered.length - _previewLimit)
        : ordered;

    _chatPreviewCache[userId] = List<ChatMessageModel>.from(trimmed);
    _chatPreviewCursorCache[userId] = cursor ?? _chatPreviewCursorCache[userId];
    _applyPreviewToContact(userId);
  }

  void upsertCachedMessage(String userId, ChatMessageModel message) {
    cacheChatPreview(userId, [message], merge: true);
  }

  Future<void> _prefetchChatPreviews(Iterable<String> userIds) async {
    final ids = userIds.where((id) => id.isNotEmpty).toList();

    for (var i = 0; i < ids.length; i += _prefetchBatchSize) {
      final batch = ids.skip(i).take(_prefetchBatchSize);
      await Future.wait(batch.map((id) => preloadChatPreview(id)));
    }
  }

  void _applyPreviewToContact(String userId) {
    final index = contacts.indexWhere((contact) => contact.id == userId);
    if (index == -1) return;

    final preview = _buildPreviewMessage(getCachedMessages(userId));
    final existing = contacts[index];
    contacts[index] = existing.copyWith(
      message: preview.message,
      time: preview.time,
      isMessagesEmpty: preview.isMessagesEmpty,
    );
  }

  ({String message, String time, bool isMessagesEmpty}) _buildPreviewMessage(
    List<ChatMessageModel> cachedPreview,
  ) {
    if (cachedPreview.isEmpty) {
      return (
        message: 'Tap to start conversation',
        time: 'Now',
        isMessagesEmpty: true,
      );
    }

    final last = cachedPreview.last;
    return (
      message: last.message,
      time: _formatTime(last.timestamp),
      isMessagesEmpty: false,
    );
  }

  String _formatTime(DateTime timestamp) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  checkRemaining(ChatMessageModel msg) {
    unawaited(findContact(msg.senderId, msg.receiverId));
  }

  Future<void> connect() async {
    _socketService.connect();
    if (contacts.isEmpty) {
      getChatList();
    }
  }

  Future<void> unMatch(String matchId) async {
    try {
      final success = await _chatRepo.unmatch(matchId);

      if (success) {
        matches.removeWhere((m) => m.userId == matchId);
        matches.refresh();
        Toast.success("Unmatched successfully");
      } else {
        debugPrint("Unmatch failed for matchId: $matchId");
      }
    } catch (e, s) {
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
    } finally {
      refreshChatList();
    }
  }

  void hideContact(int index) {
    final contact = contacts[index].copyWith(isHidden: true);
    contacts[index] = contact;
    hideContactApi(contact, "Contact hidden Succesfully");
  }

  void hideContactById(String id) {
    final index = contacts.indexWhere((c) => c.id == id);

    if (index == -1) return; // not found

    final updatedContact = contacts[index].copyWith(isHidden: true);
    contacts[index] = updatedContact;

    hideContactApi(updatedContact, "Contact hidden Succesfully");
  }

  void reportContactByApi(String id) {
    final index = contacts.indexWhere((c) => c.id == id);

    if (index == -1) return; // not found

    final updatedContact = contacts[index].copyWith(isReported: true);
    contacts[index] = updatedContact;

    reportContactAPi(updatedContact, "Contact reported successfully");
  }

  void hideContactApi(ContactModel contact, String successMessage) async {
    try {
      var userId = await _globalService.getUserId();

      for (var m in matches) {
        if (m.userId == contact.id && !m.isArchived.contains(userId ?? "")) {
          m.isArchived.add(userId ?? "");
          final statusCode = await _chatRepo.updateMatch(
            m.matchId,
            m.toJson(),
          );
          debugPrint("Hide contact response: $statusCode");
          break;
        }
      }
    } catch (e, s) {
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
    } finally {
      Toast.success(successMessage);
    }
  }

  void reportContactAPi(ContactModel contact, String successMessage) async {
    try {
      for (var m in matches) {
        if (m.userId == contact.id) {
          m.isReported = contact.isReported;
          final statusCode = await _chatRepo.updateMatch(
            m.matchId,
            m.toJson(),
          );
          debugPrint("Report contact response: $statusCode");
          break;
        }
      }
    } catch (e, s) {
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
    } finally {
      Toast.success(successMessage);
    }
  }

  void unhideContact(int index) {
    final contact = contacts[index].copyWith(isHidden: false);
    contacts[index] = contact;
    unhideContactApi(contact);
  }

  void unhideContactById(String id) {
    final index = contacts.indexWhere((c) => c.id == id);

    if (index == -1) return;

    final updatedContact = contacts[index].copyWith(isHidden: false);
    contacts[index] = updatedContact;

    unhideContactApi(updatedContact);
  }

  void unhideContactApi(ContactModel contact) async {
    try {
      final userId = await _globalService.getUserId();

      for (var i = 0; i < matches.length; i++) {
        final match = matches[i];

        if (match.userId == contact.id &&
            match.isArchived.contains(userId ?? "")) {
          final updatedArchived = List<String>.from(match.isArchived)
            ..remove(userId ?? "");

          final updatedMatch = match.copyWith(isArchived: updatedArchived);
          matches[i] = updatedMatch;

          final statusCode = await _chatRepo.updateMatch(
            match.matchId,
            updatedMatch.toJson(),
          );

          debugPrint("Unhide contact response: $statusCode");
          break;
        }
      }
    } catch (e, s) {
      handleError(tag: _tag, error: e.toString(), stack: s.toString());
    } finally {
      Toast.success("Contact unhidden successfully");
    }
  }

  void openHiddenChats() {
    Get.toNamed(Routes.HIDDEN_CHATS);
  }

  ContactModel getContactById(String id) {
    return contacts.firstWhere((c) => c.id == id);
  }

  Future<MatchModel?> getMatchById(String id) async {
    int index = matches.indexWhere((c) => c.userId == id);

    if (index == -1) {
      await findContact(id, id);
      index = matches.indexWhere((c) => c.userId == id);
      if (index == -1) {
        return null;
      }
    }

    return matches[index];
  }

  Future<String> getFormattedMatchTime(String id) async {
    final match = await getMatchById(id);

    try {
      final date = DateTime.parse(match?.matchedAt ?? "");
      return DateFormat('MM/dd/yy h:mm a').format(date);
    } catch (e) {
      return match?.matchedAt ?? "";
    }
  }

  bool isContactTimeValid(ContactModel? contact) {
    final remaining = contact?.timeRemainingMatch;
    if (remaining == null) return false;
    return !remaining.isNegative && remaining.inSeconds > 0;
  }

  bool shouldShowContactTimer(ContactModel? contact) {
    final remaining = contact?.timeRemainingMatch;
    if (remaining == null) return false;
    return remaining < const Duration(hours: 24);
  }

  bool isContactTimeValidById(String contactId) {
    final contact = contacts.firstWhereOrNull((c) => c.id == contactId);
    return isContactTimeValid(contact);
  }

  Future<bool> isValidTime({ContactModel? contact, String? contactId}) async {
    final match = await getMatchById(contact?.id ?? contactId ?? "");
    try {
      final matchTime = DateTime.parse(match?.matchedAt ?? "");
      return DateTime.now().difference(matchTime) < Duration(hours: 24);
    } catch (e) {
      return false;
    }
  }

  String selectedChatId = '';
  void openChat(ContactModel contact) {
    // bool isValid = isValidTime(contact);
    // if (!isValid) {
    //   Toast.warning(
    //     "Chat expired. Please upgrade to premium to continue chatting.",
    //   );
    //   return;
    // }
    selectedChatId = contact.id;
    Get.toNamed(
      Routes.CHAT,
      arguments: {
        'name': contact.name,
        'heroTag': contact.heroTag,
        'timeLeft': contact.timeLeft,
        'profileImageUrl': contact.imagePath,
        'targetUserId': contact.id,
      },
    );
  }
}
