import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/network/api_config.dart';
import '../../../../services/SocketService.dart';
import '../../../../utils/TimeHelper.dart';
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
  final String currentUserId;
  final String collegeId;

  late final IO.Socket _socket;
  Timer? _connectDelay;

  GroupRoomCubit({required this.currentUserId, required this.collegeId})
    : super(const GroupRoomState()) {
    debugPrint(
      "🟢 [INIT] GroupRoomCubit started => userId=$currentUserId | collegeId=$collegeId",
    );
    _socket = SocketService.connect(currentUserId);
    _init();
  }

  void _init() {
    debugPrint("⚙️ [SOCKET] Initializing socket handlers...");

    // Remove old listeners to prevent duplicates
    _socket.off('receive_college_message', _onReceive);
    _socket.off('connect');

    // Register listeners
    _socket.on('receive_college_message', _onReceive);
    _socket.on('connect', (_) {
      debugPrint("✅ [SOCKET] Connected. Now joining room...");
      _joinRoom();
    });

    if (_socket.connected) {
      debugPrint("🟢 [SOCKET] Already connected, joining immediately...");
      _joinRoom();
    } else {
      debugPrint("🕒 [SOCKET] Waiting for connection...");
      _connectDelay?.cancel();
      _connectDelay = Timer(const Duration(milliseconds: 400), () {
        if (_socket.connected) {
          debugPrint("🔁 [SOCKET] Delayed join triggered...");
          _joinRoom();
        } else {
          debugPrint("⚠️ [SOCKET] Still disconnected after delay.");
        }
      });
    }
  }

  void _joinRoom() {
    final payload = {'college_id': collegeId};
    debugPrint("🏫 [ROOM] Joining room with payload: $payload");
    _socket.emit('join_college_room', payload);
  }

  GroupMessages _mapSocket(dynamic data) {
    debugPrint("📥 [MAP] Raw socket data received => $data");

    Map<String, dynamic> map;
    if (data is Map) {
      map = data.map((k, v) => MapEntry(k.toString(), v));
    } else {
      map = {};
    }

    String? _s(dynamic v) => v?.toString();

    Sender? sender;
    if (map['sender'] is Map) {
      final senderMap = Map<String, dynamic>.from(map['sender']);
      final rawPic = senderMap['profile_pic'];

      // ✅ Automatically add host URL if not null or already full
      String? fullPicUrl;
      if (rawPic != null && rawPic.toString().isNotEmpty) {
        if (rawPic.toString().startsWith('http')) {
          fullPicUrl = rawPic.toString();
        } else {
          fullPicUrl = "${ApiConfig.baseUrl}storage/${rawPic.toString()}";
        }
      }

      sender = Sender(
        id: senderMap['id'],
        name: senderMap['name'],
        profilePic: rawPic,
        profilePicUrl: fullPicUrl,
      );
    }

    final msg = GroupMessages(
      id: _toInt(map['id']),
      collegeId: _toInt(map['college_id']),
      senderId: _toInt(map['sender_id']),
      message: _s(map['message']),
      url: _s(map['url']),
      type: _s(map['type']),
      createdAt: _s(map['created_at']) ?? DateTime.now().toIso8601String(),
      updatedAt: _s(map['updated_at']),
      sender: sender,
    );

    debugPrint(
      "✅ [MAP] Parsed message => id:${msg.id}, sender:${msg.senderId}, type:${msg.type}, msg:${msg.message}, senderName:${msg.sender?.name}",
    );
    return msg;
  }

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  DateTime convertUTCToIST(String utcString) {
    final utcTime = DateTime.parse(utcString).toUtc();
    return utcTime.add(const Duration(hours: 5, minutes: 30));
  }


  void _onReceive(dynamic data) {
    debugPrint("📩 [RECEIVE] Message event received => $data");
    try {
      final server = _mapSocket(data);
      final serverTs = DateTime.parse(server.createdAt!).toUtc();

      // Check if message matches an optimistic (temporary) message
      final idx = state.messages.indexWhere((m) {
        if ((m.id ?? 0) >= 0) return false; // only temps
        final sameSender = (m.senderId ?? 0) == (server.senderId ?? -1);
        final sameType = (m.type ?? '') == (server.type ?? '');
        final sameMsg = (m.message ?? '') == (server.message ?? '');
        final sameUrl = (m.url ?? '') == (server.url ?? '');
        if (!(sameSender && sameType && sameMsg && sameUrl)) return false;

        final mTs = DateTime.parse(m.createdAt!).toUtc();

        final diff = mTs.difference(serverTs).abs();
        return diff <= const Duration(seconds: 10);
      });

      // if (idx != -1) {
      //   debugPrint(
      //     "🔄 [UPDATE] Replacing temp message with server-confirmed message (id=${server.id})",
      //   );
      //   final updated = [...state.messages];
      //   updated[idx] = server;
      //   emit(state.copyWith(messages: updated));
      //   return;
      // }
      if (idx != -1) {
        debugPrint(
          "🔄 [UPDATE] Replacing temp message with server-confirmed message (id=${server.id})",
        );
        final updated = [...state.messages];
        updated[idx] = server.copyWith(
          id: server.id ?? updated[idx].id,
          sender: server.sender ?? updated[idx].sender,
        );
        emit(state.copyWith(messages: updated));
        return;
      }

      // If message is new, append
      final exists = state.messages.any(
        (m) => m.id != null && m.id == server.id,
      );
      if (!exists) {
        debugPrint("🆕 [APPEND] New message appended => ${server.message}");
        emit(state.copyWith(messages: [...state.messages, server]));
      } else {
        debugPrint("🚫 [IGNORE] Duplicate message ignored => id:${server.id}");
      }
    } catch (e, st) {
      debugPrint("❌ [ERROR] Exception in _onReceive: $e\n$st");
    }
  }

  void sendMessage({required String text, String type = 'text', String? url}) {
    if (text.isEmpty && (url == null || url.isEmpty)) {
      debugPrint("⚠️ [SEND] Empty message ignored.");
      return;
    }

    final nowUtc = DateTime.now().toUtc().toIso8601String(); // IMPORTANT
    final tempId = -DateTime.now().microsecondsSinceEpoch;

    final local = GroupMessages(
      id: tempId,
      collegeId: int.parse(collegeId),
      senderId: int.tryParse(currentUserId),
      message: text,
      url: url ?? '',
      type: type,
      createdAt: nowUtc,      // store UTC
      updatedAt: nowUtc,      // store UTC
    );

    emit(state.copyWith(messages: [...state.messages, local]));

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
    debugPrint("🧹 [CLOSE] Cleaning up socket and timers...");
    _connectDelay?.cancel();
    _socket.off('receive_college_message', _onReceive);
    _socket.off('connect');
    return super.close();
  }
}
