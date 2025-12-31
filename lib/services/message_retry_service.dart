import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';
import '../models/message.dart';
import '../models/path_selection.dart';
import 'storage_service.dart';
import 'app_settings_service.dart';

class MessageRetryService extends ChangeNotifier {
  static const int maxRetries = 5;

  final StorageService _storage;
  final Map<String, Timer> _timeoutTimers = {};
  final Map<String, Message> _pendingMessages = {};
  final Map<String, Contact> _pendingContacts = {};
  final Map<String, PathSelection> _pendingPathSelections = {};

  Function(Contact, String, int, int)? _sendMessageCallback;
  Function(String, Message)? _addMessageCallback;
  Function(Message)? _updateMessageCallback;
  Function(Contact)? _clearContactPathCallback;
  Function(int, int)? _calculateTimeoutCallback;
  AppSettingsService? _appSettingsService;
  Function(String, PathSelection, bool, int?)? _recordPathResultCallback;

  MessageRetryService(this._storage);

  void initialize({
    required Function(Contact, String, int, int) sendMessageCallback,
    required Function(String, Message) addMessageCallback,
    required Function(Message) updateMessageCallback,
    Function(Contact)? clearContactPathCallback,
    Function(int pathLength, int messageBytes)? calculateTimeoutCallback,
    AppSettingsService? appSettingsService,
    Function(String, PathSelection, bool, int?)? recordPathResultCallback,
  }) {
    _sendMessageCallback = sendMessageCallback;
    _addMessageCallback = addMessageCallback;
    _updateMessageCallback = updateMessageCallback;
    _clearContactPathCallback = clearContactPathCallback;
    _calculateTimeoutCallback = calculateTimeoutCallback;
    _appSettingsService = appSettingsService;
    _recordPathResultCallback = recordPathResultCallback;
  }

  Future<void> sendMessageWithRetry({
    required Contact contact,
    required String text,
    bool clearPath = false,
    PathSelection? pathSelection,
    Uint8List? pathBytes,
    int? pathLength,
  }) async {
    final messageId = const Uuid().v4();
    final useClearPath = clearPath || (pathSelection?.useFlood ?? false);
    final messagePathBytes =
        pathBytes ?? _resolveMessagePathBytes(contact, useClearPath, pathSelection);
    final messagePathLength =
        pathLength ?? _resolveMessagePathLength(contact, useClearPath, pathSelection);
    final message = Message(
      senderKey: contact.publicKey,
      text: text,
      timestamp: DateTime.now(),
      isOutgoing: true,
      status: MessageStatus.pending,
      messageId: messageId,
      retryCount: 0,
      pathLength: messagePathLength,
      pathBytes: messagePathBytes,
    );

    _pendingMessages[messageId] = message;
    _pendingContacts[messageId] = contact;
    if (pathSelection != null) {
      _pendingPathSelections[messageId] = pathSelection;
    }

    if (_addMessageCallback != null) {
      _addMessageCallback!(contact.publicKeyHex, message);
    }

    await _attemptSend(messageId);
  }

  Future<void> _attemptSend(String messageId) async {
    final message = _pendingMessages[messageId];
    final contact = _pendingContacts[messageId];

    if (message == null || contact == null) return;

    final attempt = message.retryCount.clamp(0, 3);

    if (_sendMessageCallback != null) {
      final timestampSeconds = message.timestamp.millisecondsSinceEpoch ~/ 1000;
      _sendMessageCallback!(
        contact,
        message.text,
        attempt,
        timestampSeconds,
      );
    }
  }

  void updateMessageFromSent(Uint8List ackHash, int timeoutMs) {
    for (var entry in _pendingMessages.entries) {
      final message = entry.value;
      if (message.status == MessageStatus.pending) {
        final contact = _pendingContacts[entry.key];
        final selection = _pendingPathSelections[entry.key];

        // Use device-provided timeout, or calculate from radio settings if timeout is 0 or invalid
        int actualTimeout = timeoutMs;
        if (timeoutMs <= 0 && _calculateTimeoutCallback != null && contact != null) {
          int pathLengthValue;
          if (selection != null) {
            pathLengthValue = selection.useFlood ? -1 : selection.hopCount;
            if (pathLengthValue < 0) pathLengthValue = contact.pathLength;
          } else if (message.pathLength != null) {
            pathLengthValue = message.pathLength!;
          } else {
            pathLengthValue = contact.pathLength;
          }
          actualTimeout = _calculateTimeoutCallback!(pathLengthValue, message.text.length);
          debugPrint('Using calculated timeout: ${actualTimeout}ms for ${contact.pathLength} hops');
        }

        final updatedMessage = message.copyWith(
          status: MessageStatus.sent,
          expectedAckHash: ackHash,
          estimatedTimeoutMs: actualTimeout,
          sentAt: DateTime.now(),
        );

        _pendingMessages[entry.key] = updatedMessage;

        if (_updateMessageCallback != null) {
          _updateMessageCallback!(updatedMessage);
        }

        _startTimeoutTimer(entry.key, actualTimeout);
        return;
      }
    }
  }

  void _startTimeoutTimer(String messageId, int timeoutMs) {
    _timeoutTimers[messageId]?.cancel();
    _timeoutTimers[messageId] = Timer(Duration(milliseconds: timeoutMs), () {
      _handleTimeout(messageId);
    });
  }

  void _handleTimeout(String messageId) {
    final message = _pendingMessages[messageId];
    final contact = _pendingContacts[messageId];
    final selection = _pendingPathSelections[messageId];

    if (message == null || contact == null) return;

    if (message.retryCount < maxRetries - 1) {
      final backoffMs = 1000 * (1 << message.retryCount);

      final updatedMessage = message.copyWith(
        retryCount: message.retryCount + 1,
        status: MessageStatus.pending,
      );

      _pendingMessages[messageId] = updatedMessage;

      if (_updateMessageCallback != null) {
        _updateMessageCallback!(updatedMessage);
      }

      Timer(Duration(milliseconds: backoffMs), () {
        _attemptSend(messageId);
      });
    } else {
      // Max retries reached - mark as failed
      final failedMessage = message.copyWith(status: MessageStatus.failed);

      _pendingMessages.remove(messageId);
      _pendingContacts.remove(messageId);
      _pendingPathSelections.remove(messageId);
      _timeoutTimers[messageId]?.cancel();
      _timeoutTimers.remove(messageId);

      // Check if we should clear the path on max retry
      if (_appSettingsService?.settings.clearPathOnMaxRetry == true &&
          _clearContactPathCallback != null) {
        _clearContactPathCallback!(contact);
      }

      _recordPathResultFromMessage(contact.publicKeyHex, message, selection, false, null);

      if (_updateMessageCallback != null) {
        _updateMessageCallback!(failedMessage);
      }

      notifyListeners();
    }
  }

  void handleAckReceived(Uint8List ackHash, int tripTimeMs) {
    String? matchedMessageId;

    for (var entry in _pendingMessages.entries) {
      final message = entry.value;
      if (message.expectedAckHash != null &&
          listEquals(message.expectedAckHash, ackHash)) {
        matchedMessageId = entry.key;
        break;
      }
    }

    if (matchedMessageId != null) {
      final message = _pendingMessages[matchedMessageId]!;
      final contact = _pendingContacts[matchedMessageId];
      final selection = _pendingPathSelections[matchedMessageId];
      _timeoutTimers[matchedMessageId]?.cancel();
      _timeoutTimers.remove(matchedMessageId);

      final deliveredMessage = message.copyWith(
        status: MessageStatus.delivered,
        deliveredAt: DateTime.now(),
        tripTimeMs: tripTimeMs,
      );

      _pendingMessages.remove(matchedMessageId);
      _pendingContacts.remove(matchedMessageId);
      _pendingPathSelections.remove(matchedMessageId);

      if (_updateMessageCallback != null) {
        _updateMessageCallback!(deliveredMessage);
      }

      if (contact != null) {
        _recordPathResultFromMessage(contact.publicKeyHex, message, selection, true, tripTimeMs);
      }

      notifyListeners();
    }
  }

  Uint8List _resolveMessagePathBytes(
    Contact contact,
    bool forceFlood,
    PathSelection? selection,
  ) {
    if (forceFlood || contact.pathLength < 0 || selection?.useFlood == true) {
      return Uint8List(0);
    }
    if (selection != null && selection.pathBytes.isNotEmpty) {
      return Uint8List.fromList(selection.pathBytes);
    }
    return contact.path;
  }

  int? _resolveMessagePathLength(
    Contact contact,
    bool forceFlood,
    PathSelection? selection,
  ) {
    if (forceFlood || contact.pathLength < 0 || selection?.useFlood == true) {
      return -1;
    }
    if (selection != null && selection.pathBytes.isNotEmpty) {
      return selection.hopCount;
    }
    return contact.pathLength;
  }

  String? getContactKeyForAckHash(Uint8List ackHash) {
    for (var entry in _pendingMessages.entries) {
      final message = entry.value;
      if (message.expectedAckHash != null &&
          listEquals(message.expectedAckHash, ackHash)) {
        final contact = _pendingContacts[entry.key];
        return contact?.publicKeyHex;
      }
    }
    return null;
  }

  int calculateDefaultTimeout(Contact contact) {
    if (contact.pathLength < 0) {
      return 15000;
    } else {
      return 3000 + (3000 * contact.pathLength);
    }
  }

  void _recordPathResultFromMessage(
    String contactKey,
    Message message,
    PathSelection? selection,
    bool success,
    int? tripTimeMs,
  ) {
    if (_recordPathResultCallback == null) return;
    final recordSelection = selection ?? _selectionFromMessage(message);
    if (recordSelection == null) return;
    _recordPathResultCallback!(contactKey, recordSelection, success, tripTimeMs);
  }

  PathSelection? _selectionFromMessage(Message message) {
    if (message.pathLength != null && message.pathLength! < 0) {
      return const PathSelection(pathBytes: [], hopCount: -1, useFlood: true);
    }
    if (message.pathBytes.isEmpty && message.pathLength == null) {
      return null;
    }
    return PathSelection(
      pathBytes: message.pathBytes,
      hopCount: message.pathLength ?? message.pathBytes.length,
      useFlood: false,
    );
  }

  @override
  void dispose() {
    for (var timer in _timeoutTimers.values) {
      timer.cancel();
    }
    _timeoutTimers.clear();
    _pendingMessages.clear();
    _pendingContacts.clear();
    _pendingPathSelections.clear();
    super.dispose();
  }
}
