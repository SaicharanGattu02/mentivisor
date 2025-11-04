import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../services/SocketService.dart';
import '../../../../utils/AppLogger.dart';
import '../../../Models/ChatMessagesModel.dart';

class PrivateChatState {
  final List<Messages> messages;
  final bool isPeerTyping;

  const PrivateChatState({this.messages = const [], this.isPeerTyping = false});

  PrivateChatState copyWith({List<Messages>? messages, bool? isPeerTyping}) =>
      PrivateChatState(
        messages: messages ?? this.messages,
        isPeerTyping: isPeerTyping ?? this.isPeerTyping,
      );
}

class PrivateChatCubit extends Cubit<PrivateChatState> {
  final String currentUserId;
  final String receiverId;
  final String sessionId;

  late final IO.Socket _socket;
  late final String _room;
  Timer? _peerTypingClearTimer;
  Timer? _myTypingThrottle;

  PrivateChatCubit(this.currentUserId, this.receiverId, this.sessionId)
    : super(const PrivateChatState()) {
    _socket = SocketService.connect(currentUserId);
    _room = _getPrivateRoomName(currentUserId, receiverId);
    _init();
  }

  void _init() {
    // Remove old handlers (shared socket)
    _socket.off('receive_private_message', _onReceiveMessage);
    _socket.off('file_upload_limit', _onFileUpload);
    _socket.off('user_typing', _onUserTyping);
    _socket.off('connect');

    // Add listeners
    _socket.on('receive_private_message', _onReceiveMessage);
    _socket.on('file_upload_limit', _onFileUpload);
    _socket.on('user_typing', _onUserTyping);
    _socket.on('connect', (_) {
      AppLogger.info('[socket] connected: ${_socket.id}');
      _joinRoom();
    });

    if (_socket.connected) {
      _joinRoom();
    } else {
      AppLogger.info('[socket] not connected yet; will join on connect');
    }
  }

  void _joinRoom() {
    _socket.emit('join_private', {
      'userId1': currentUserId,
      'userId2': receiverId,
    });
    AppLogger.info(
      '[socket] join_private -> room: $_room (u1=$currentUserId, u2=$receiverId)',
    );
  }

  // Ensure we map to your Messages model (note: uses `url`, not `imageUrl`)
  Messages _mapSocketToMessages(Map<String, dynamic> map) {
    String? _s(dynamic v) => v?.toString();

    return Messages(
      id: _safeInt(map['id']),
      senderId: _safeInt(map['senderId'] ?? map['sender_id']),
      receiverId: _safeInt(map['receiverId'] ?? map['receiver_id']),
      type: _s(map['type']),
      message: _s(map['message']),
      url: _s(map['url'] ?? map['image_url']), // accept either key
      createdAt:
          _s(map['createdAt'] ?? map['created_at']) ??
          DateTime.now().toIso8601String(),
      updatedAt: _s(map['updatedAt'] ?? map['updated_at']),
      sender: null,
      receiver: null,
    );
  }

  int? _safeInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  Map<String, dynamic> _toStringKeyMap(dynamic data) {
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }

  // ---- Duplicate handling helpers ----
  bool _sameContent(Messages a, Messages b) {
    final aMsg = a.message ?? '';
    final bMsg = b.message ?? '';
    final aUrl = a.url ?? '';
    final bUrl = b.url ?? '';
    final aType = a.type ?? '';
    final bType = b.type ?? '';
    final aSender = a.senderId?.toString() ?? '';
    final bSender = b.senderId?.toString() ?? '';
    final aReceiver = a.receiverId?.toString() ?? '';
    final bReceiver = b.receiverId?.toString() ?? '';

    return aType == bType &&
        aMsg == bMsg &&
        aUrl == bUrl &&
        aSender == bSender &&
        aReceiver == bReceiver;
  }

  bool _closeInTime(
    DateTime a,
    DateTime b, {
    Duration tolerance = const Duration(seconds: 5),
  }) {
    return (a.difference(b).abs() <= tolerance);
  }

  void _replaceTempWithServer(Messages serverMsg) {
    final serverCreated =
        DateTime.tryParse(serverMsg.createdAt ?? '') ?? DateTime.now();
    final idx = state.messages.indexWhere((m) {
      if ((m.id ?? 0) >= 0) return false; // only temp messages (id < 0)
      if (!_sameContent(m, serverMsg)) return false;
      final mCreated = DateTime.tryParse(m.createdAt ?? '') ?? DateTime.now();
      return _closeInTime(mCreated, serverCreated);
    });

    if (idx != -1) {
      final updated = [...state.messages];
      updated[idx] = serverMsg; // replace temp with server copy
      emit(state.copyWith(messages: updated));
    } else {
      // Append if not already present by id
      final existsById = state.messages.any(
        (m) => m.id != null && m.id == serverMsg.id,
      );
      if (!existsById) {
        emit(state.copyWith(messages: [...state.messages, serverMsg]));
      }
    }
  }

  // ---- Listeners ----
  void _onReceiveMessage(dynamic data) {
    try {
      AppLogger.info("[socket] receive_private_message payload: $data");
      final map = _toStringKeyMap(data);
      final msg = _mapSocketToMessages(map);
      _replaceTempWithServer(msg);
    } catch (e, st) {
      AppLogger.info('[socket] malformed receive_private_message: $e\n$st');
    }
  }

  void _onFileUpload(dynamic data) {
    try {
      AppLogger.info("[socket] file_upload_limit payload: $data");

      if (data is Map) {
        final status = data['status']?.toString().toLowerCase();
        final message =
            data['message']?.toString() ?? 'Upload status received.';

        if (status == 'error') {
          // Show a snackbar, dialog, or toast to user
          // _showSnackBar(message, isError: true);
          return;
        }

        if (status == 'success') {
          // _showSnackBar(message, isError: false);
          // You could also trigger message list refresh or file list update here
          // e.g. context.read<GroupRoomCubit>().refreshFiles();
          return;
        }

        // Unknown status fallback
        AppLogger.info('[socket] Unrecognized status: $status');
      } else if (data is String) {
        // Some socket servers send JSON as string
        final parsed = jsonDecode(data);
        return _onFileUpload(parsed);
      } else {
        AppLogger.info('[socket] Unexpected payload type: ${data.runtimeType}');
      }
    } catch (e, st) {
      AppLogger.info('[socket] malformed file_upload_limit: $e\n$st');
      // _showSnackBar("Failed to handle file upload response.", isError: true);
    }
  }

  void _onUserTyping(dynamic data) {
    try {
      final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
      final senderId = map['senderId']?.toString();
      final room = map['room']?.toString();
      final sameRoom = room == _room;
      final fromPeer = senderId != null && senderId != currentUserId;

      if (!sameRoom || !fromPeer) return;

      emit(state.copyWith(isPeerTyping: true));

      // Auto-clear after a quiet period
      _peerTypingClearTimer?.cancel();
      _peerTypingClearTimer = Timer(const Duration(seconds: 3), () {
        if (!isClosed) emit(state.copyWith(isPeerTyping: false));
      });
    } catch (_) {
      /* ignore */
    }
  }

  String _getPrivateRoomName(String id1, String id2) {
    final ids = [id1, id2]..sort();
    return ids.join('_'); // must match server
  }

  /// Optimistic send (text or image/file via `url`)
  void sendMessage(String message, {String type = 'text', String? url}) {
    if (message.isEmpty && url == null) return;

    final nowIso = DateTime.now().toIso8601String();
    final tempId = -DateTime.now().microsecondsSinceEpoch;

    final local = Messages(
      id: tempId,
      senderId: int.tryParse(currentUserId),
      receiverId: int.tryParse(receiverId),
      type: type,
      message: message,
      url: url,
      createdAt: nowIso,
      updatedAt: nowIso,
    );

    emit(state.copyWith(messages: [...state.messages, local]));

    final payload = {
      'room': _room,
      'sender_id': currentUserId,
      's_id': int.parse(sessionId),
      'receiver_id': receiverId,
      'message': message,
      'type': type,
      'url': url,
      'createdAt': nowIso,
    };

    AppLogger.info('[socket] send_private_message -> $payload');
    _socket.emit('send_private_message', payload);
  }

  void startTyping() {
    // throttle to avoid spamming the server
    if (_myTypingThrottle?.isActive == true) return;
    _emitTyping();
    _myTypingThrottle = Timer(const Duration(seconds: 2), () {});
  }

  void stopTyping() {
    _myTypingThrottle?.cancel();
    _myTypingThrottle = null;
  }

  void _emitTyping() {
    final payload = {
      'room': _room,
      'senderId': currentUserId,
      'receiverId': receiverId,
    };
    AppLogger.info('[socket] typing -> $payload');
    _socket.emit('typing', payload);
  }

  @override
  Future<void> close() {
    _peerTypingClearTimer?.cancel();
    _socket.off('receive_private_message', _onReceiveMessage);
    _socket.off('user_typing', _onUserTyping);
    _socket.off('connect');
    return super.close();
  }
}
