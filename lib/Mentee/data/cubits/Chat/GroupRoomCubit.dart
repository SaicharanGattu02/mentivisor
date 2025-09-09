import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../services/SocketService.dart';
import '../../../Models/GroupChatMessagesModel.dart';

// ---- State ----
class GroupRoomState {
  final List<GroupMessages> messages;
  const GroupRoomState({this.messages = const []});

  GroupRoomState copyWith({List<GroupMessages>? messages}) =>
      GroupRoomState(messages: messages ?? this.messages);
}

// ---- Cubit ----
class GroupRoomCubit extends Cubit<GroupRoomState> {
  final String currentUserId; // as string is fine
  final String collegeId;

  late final IO.Socket _socket;
  Timer? _connectDelay;

  GroupRoomCubit({required this.currentUserId, required this.collegeId})
    : super(const GroupRoomState()) {
    _socket = SocketService.connect(currentUserId); // your shared connector
    _init();
  }

  void _init() {
    // Clean old handlers (shared instance)
    _socket.off('receive_college_message', _onReceive);
    _socket.off('connect');

    // Add
    _socket.on('receive_college_message', _onReceive);
    _socket.on('connect', (_) {
      _joinRoom();
    });

    if (_socket.connected) {
      _joinRoom();
    } else {
      // safety: sometimes emit join after a tiny delay
      _connectDelay?.cancel();
      _connectDelay = Timer(const Duration(milliseconds: 400), () {
        if (_socket.connected) _joinRoom();
      });
    }
  }

  void _joinRoom() {
    final payload = {'college_id': collegeId};
    _socket.emit('join_college_room', payload);
  }

  // Convert socket payload -> GroupMessages
  GroupMessages _mapSocket(dynamic data) {
    Map<String, dynamic> map;
    if (data is Map) {
      map = data.map((k, v) => MapEntry(k.toString(), v));
    } else {
      map = {};
    }
    String? _s(dynamic v) => v?.toString();

    return GroupMessages(
      id: _toInt(map['id']),
      collegeId: _toInt(map['college_id']),
      senderId: _toInt(map['sender_id']),
      message: _s(map['message']),
      url: _s(map['url']),
      type: _s(map['type']), // "text" | "file"
      createdAt: _s(map['created_at']) ?? DateTime.now().toIso8601String(),
      updatedAt: _s(map['updated_at']),
      sender: null, // if backend sends nested sender, map it here
    );
  }

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  // Optimistic → replace with server copy (match by content + time proximity)
  void _onReceive(dynamic data) {
    try {
      final server = _mapSocket(data);
      final serverTs =
          DateTime.tryParse(server.createdAt ?? '') ?? DateTime.now();

      // Try replace temp (id < 0) with same content
      final idx = state.messages.indexWhere((m) {
        if ((m.id ?? 0) >= 0) return false; // only temps
        final sameSender = (m.senderId ?? 0) == (server.senderId ?? -1);
        final sameType = (m.type ?? '') == (server.type ?? '');
        final sameMsg = (m.message ?? '') == (server.message ?? '');
        final sameUrl = (m.url ?? '') == (server.url ?? '');
        if (!(sameSender && sameType && sameMsg && sameUrl)) return false;

        final mTs = DateTime.tryParse(m.createdAt ?? '') ?? DateTime.now();
        return (mTs.difference(serverTs).abs() <= const Duration(seconds: 5));
      });

      if (idx != -1) {
        final updated = [...state.messages];
        updated[idx] = server;
        emit(state.copyWith(messages: updated));
        return;
      }

      // Else append if not present by id
      final exists = state.messages.any(
        (m) => m.id != null && m.id == server.id,
      );
      if (!exists) {
        emit(state.copyWith(messages: [...state.messages, server]));
      }
    } catch (_) {
      // ignore
    }
  }

  void sendMessage({
    required String text,
    String type = 'text', // 'text' | 'file'
    String? url,
  }) {
    if (text.isEmpty && (url == null || url.isEmpty)) return;

    final nowIso = DateTime.now().toIso8601String();
    final tempId = -DateTime.now().microsecondsSinceEpoch;

    // optimistic local
    final local = GroupMessages(
      id: tempId,
      collegeId: int.parse(collegeId),
      senderId: int.tryParse(currentUserId),
      message: text,
      url: url ?? '',
      type: type,
      createdAt: nowIso,
      updatedAt: nowIso,
    );
    emit(state.copyWith(messages: [...state.messages, local]));

    // server payload
    final payload = {
      'sender_id': int.tryParse(currentUserId),
      'college_id': int.parse(collegeId),
      'message': text,
      'url': url ?? '',
      'type': type,
    };
    _socket.emit('send_college_message', payload);
  }

  @override
  Future<void> close() {
    _connectDelay?.cancel();
    _socket.off('receive_college_message', _onReceive);
    _socket.off('connect');
    return super.close();
  }
}
