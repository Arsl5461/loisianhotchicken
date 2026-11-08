import 'dart:async';

import 'package:OApp/config/app_config.dart';
import 'package:OApp/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../controller/your_likes_controller.dart';
import '../core/constants/app_keys.dart';
import 'secure_storage_service.dart';

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  IO.Socket? socket;
  final SecureStorageService _storage = Get.find<SecureStorageService>();
  YourLikesController get yourLikesController =>
      Get.find<YourLikesController>();
  final RxBool isConnected = false.obs;
  final Rx<ChatMessageModel?> lastMessage = Rx<ChatMessageModel?>(null);
  final RxMap<String, DateTime> typingUsers = <String, DateTime>{}.obs;
  final Rxn<Map<String, dynamic>> socketError = Rxn<Map<String, dynamic>>();

  final Map<String, Timer> _typingExpiryTimers = {};

  @override
  void onInit() {
    super.onInit();
    initConnection();
  }

  Future<void> initConnection() async {
    debugPrint('SocketService: Starting initialization...');
    final token = await _storage.getKey(AppKeys.authToken);

    if (token == null) {
      debugPrint('SocketService: No token found, cannot connect.');
      return;
    }

    debugPrint('SocketService: Auth token loaded, initializing connection.');

    // https://opp-backend-iooo.vercel.app
    socket = IO.io(
      AppConfig.baseUrl.replaceAll('/api/', ''), // Remove 'api/' from base URL
      IO.OptionBuilder()
          .setTransports(['websocket']) // Force WebSocket for performance
          .setAuth({'token': token})
          .build(),
    );
    debugPrint('SocketService: Socket created, attempting to connect...');
    socket?.connect();

    socket?.onConnect((_) {
      debugPrint('SocketService: Connected. ID: ${socket?.id}');
      isConnected.value = true;
    });

    socket?.onConnectError((err) {
      debugPrint('SocketService: Connection Error: $err');
      isConnected.value = false;
    });

    socket?.onDisconnect((_) {
      debugPrint('SocketService: Disconnected');
      isConnected.value = false;
    });

    socket?.on('receiveMessage', (payload) {
      debugPrint('SocketService: ========== MESSAGE RECEIVED ==========');
      debugPrint('SocketService: Raw message data: $payload');
      debugPrint('SocketService: Data type: ${payload.runtimeType}');
      try {
        final data = _extractEventData(payload);
        if (data == null) {
          debugPrint('SocketService: receiveMessage payload was empty');
          return;
        }
        final message = ChatMessageModel.fromJson(data);
        debugPrint(
          'SocketService: Parsed message successfully: ${message.toString()}',
        );
        debugPrint(
          'SocketService: Message from: ${message.senderId}, to: ${message.receiverId}',
        );
        lastMessage.value = message;
        debugPrint('SocketService: lastMessage updated');
      } catch (e) {
        debugPrint('SocketService: Error parsing message: $e');
        debugPrint('SocketService: Stack trace: ${StackTrace.current}');
      }
      debugPrint('SocketService: ======================================');
    });

    socket?.on('messageNotification', (payload) {
      debugPrint('SocketService: 🔔 MESSAGE NOTIFICATION RECEIVED');
      debugPrint('SocketService: Notification data: $payload');

      try {
        final data = _extractEventData(payload);
        if (data == null) {
          debugPrint('SocketService: messageNotification payload was empty');
          return;
        }
        debugPrint(
          'SocketService: Attempting to parse notification data into ChatMessageModel',
        );
        final message = ChatMessageModel.fromJson(data);
        debugPrint(
          'SocketService: Message from: 🔔 ${message.senderId}, to: ${message.receiverId}',
        );
        // optional: update lastMessage
        lastMessage.value = message;
        debugPrint(
          'Socket Value Aidned 🔔 ${message.senderId}, to: ${message.receiverId}',
        );
        // Example: show snackbar notification
      } catch (e) {
        debugPrint('SocketService: Notification parse error: $e');
      }
    });

    socket?.on('typing_users', (payload) {
      final data = _extractEventData(payload);
      if (data == null) return;

      final userIds = (data['userIds'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList();
      final expiresInMs = _readExpiresInMs(data['expiresInMs']);

      debugPrint(
        'SocketService: typing_users received for users=$userIds expiresInMs=$expiresInMs',
      );

      final nextTypingState = <String, DateTime>{};
      for (final userId in userIds) {
        final expiresAt = _markUserTyping(
          userId: userId,
          expiresInMs: expiresInMs,
        );
        if (expiresAt != null) {
          nextTypingState[userId] = expiresAt;
        }
      }

      final staleUsers = typingUsers.keys
          .where((userId) => !nextTypingState.containsKey(userId))
          .toList();
      for (final userId in staleUsers) {
        _clearTypingUser(userId);
      }
    });

    socket?.on('user_typing', (payload) {
      final data = _extractEventData(payload);
      if (data == null) return;

      final userId = data['userId']?.toString();
      if (userId == null || userId.isEmpty) return;

      final expiresInMs = _readExpiresInMs(data['expiresInMs']);
      debugPrint(
        'SocketService: user_typing received for $userId expiresInMs=$expiresInMs',
      );

      _markUserTyping(userId: userId, expiresInMs: expiresInMs);
    });

    socket?.on('refreshlike', (payload) {
      debugPrint('SocketService: refreshlike event received: $payload');
      unawaited(yourLikesController.fetchLiveLikes());
    });

    socket?.on('user_stop_typing', (payload) {
      final data = _extractEventData(payload);
      if (data == null) return;

      final userId = data['userId']?.toString();
      if (userId == null || userId.isEmpty) return;

      debugPrint('SocketService: user_stop_typing received for $userId');
      _clearTypingUser(userId);
    });

    socket?.on('error', (payload) {
      final data = _extractEventData(payload) ?? {};
      socketError.value = data;
      debugPrint('SocketService: Error event: $data');
    });
  }

  void leaveChat(String targetUserId) {
    socket?.emit('leaveChat', targetUserId);
  }

  Future<void> connect() async {
    if (socket == null) {
      debugPrint(
        'SocketService: Socket not initialized, calling initConnection first',
      );
      await initConnection();
      return;
    }
    if (socket!.disconnected) {
      debugPrint('SocketService: Attempting to reconnect...');
      socket!.connect();
    }
  }

  void joinChat(String targetUserId) {
    if (socket == null) {
      debugPrint('SocketService: Cannot join chat, socket not initialized.');
      return;
    }
    if (!isConnected.value) {
      debugPrint('SocketService: Cannot join chat, not connected.');
      return;
    }
    debugPrint('SocketService: Joining chat with $targetUserId');
    socket!.emit('joinChat', targetUserId);
  }

  void startTyping(String targetUserId) {
    if (!_canEmit('typing_start')) return;

    socket!.emit('typing_start', {'targetUserId': targetUserId});
  }

  void stopTyping(String targetUserId) {
    if (!_canEmit('typing_stop')) return;

    socket!.emit('typing_stop', {'targetUserId': targetUserId});
  }

  void sendMessage(String receiverId, String message) {
    if (socket == null) {
      debugPrint('SocketService: Cannot send message, socket not initialized.');
      return;
    }
    if (!isConnected.value) {
      debugPrint('SocketService: Cannot send message, not connected.');
      return;
    }
    final payload = {'receiverId': receiverId, 'message': message};
    debugPrint('SocketService: Sending message: $payload');
    socket!.emit('sendMessage', payload);
  }

  void disconnect() {
    if (socket != null) {
      debugPrint("SocketService: Disconnecting socket");

      socket!.off("receiveMessage");
      socket!.off("error");
      socket!.off("connect");
      socket!.off("disconnect");
      socket!.off("messageNotification");
      socket!.off("typing_users");
      socket!.off("user_typing");
      socket!.off("user_stop_typing");

      socket!.disconnect();
      socket!.close();

      socket = null;

      isConnected.value = false;
      _clearAllTypingUsers();

      debugPrint("SocketService: Socket fully disposed");
    }
  }

  bool _canEmit(String eventName) {
    if (socket == null) {
      debugPrint(
        'SocketService: Cannot emit $eventName, socket not initialized.',
      );
      return false;
    }
    if (!isConnected.value) {
      debugPrint('SocketService: Cannot emit $eventName, not connected.');
      return false;
    }
    return true;
  }

  Map<String, dynamic>? _extractEventData(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return payload;
    }

    if (payload is Map) {
      final normalized = Map<String, dynamic>.from(payload);
      final data = normalized['data'];
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return normalized;
    }

    return null;
  }

  int? _readExpiresInMs(dynamic rawValue) {
    if (rawValue is int) return rawValue;
    if (rawValue is String) return int.tryParse(rawValue);
    return null;
  }

  DateTime? _markUserTyping({
    required String userId,
    required int? expiresInMs,
  }) {
    final duration = Duration(milliseconds: expiresInMs ?? 3000);
    final expiresAt = DateTime.now().add(duration);

    _typingExpiryTimers[userId]?.cancel();
    _typingExpiryTimers[userId] = Timer(duration, () {
      if (typingUsers[userId] == expiresAt) {
        _clearTypingUser(userId);
      }
    });

    typingUsers[userId] = expiresAt;
    typingUsers.refresh();
    return expiresAt;
  }

  void _clearTypingUser(String userId) {
    _typingExpiryTimers.remove(userId)?.cancel();
    typingUsers.remove(userId);
    typingUsers.refresh();
  }

  void _clearAllTypingUsers() {
    for (final timer in _typingExpiryTimers.values) {
      timer.cancel();
    }
    _typingExpiryTimers.clear();
    typingUsers.clear();
    typingUsers.refresh();
  }
}
