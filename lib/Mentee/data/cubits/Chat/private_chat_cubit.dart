// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:indiclassifieds/utils/AppLogger.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// import '../../../../services/SocketService.dart';
// import '../../../../utils/AppLogger.dart';
// import '../../../model/ChatMessagesModel.dart';
//
// class PrivateChatState {
//   final List<Messages> messages;
//   final bool isPeerTyping;
//
//   const PrivateChatState({this.messages = const [], this.isPeerTyping = false});
//
//   PrivateChatState copyWith({List<Messages>? messages, bool? isPeerTyping}) =>
//       PrivateChatState(
//         messages: messages ?? this.messages,
//         isPeerTyping: isPeerTyping ?? this.isPeerTyping,
//       );
// }
//
// class PrivateChatCubit extends Cubit<PrivateChatState> {
//   final String currentUserId;
//   final String receiverId;
//
//   late final IO.Socket _socket;
//   late final String _room;
//   Timer? _typingDebounce;
//
//   Timer? _peerTypingClearTimer; // clears peer typing after a quiet period
//   Timer? _myTypingThrottle; // throttles how often we emit 'typing'
//
//   PrivateChatCubit(this.currentUserId, this.receiverId)
//     : super(const PrivateChatState()) {
//     _socket = SocketService.connect(currentUserId); // shared instance
//     _room = _getPrivateRoomName(currentUserId, receiverId);
//     _init();
//   }
//
//   void _init() {
//     // Remove old handlers (shared socket)
//     _socket.off('receive_private_message', _onReceiveMessage);
//     _socket.off('user_typing', _onUserTyping);
//     _socket.off('connect');
//
//     // Add listeners
//     _socket.on('receive_private_message', _onReceiveMessage);
//     _socket.on('user_typing', _onUserTyping); // ← only this for typing status
//     _socket.on('connection', (_) {
//       AppLogger.info('[socket] connected: ${_socket.id}');
//       _joinRoom();
//     });
//
//     if (_socket.connected) {
//       _joinRoom();
//     } else {
//       AppLogger.info('[socket] not connected yet; will join on connect');
//     }
//   }
//
//   void _joinRoom() {
//     // Send whatever your server expects. Common patterns:
//     // 1) join with a room name
//     _socket.emit('join_private', {
//       'userId1': currentUserId,
//       'userId2': receiverId,
//     });
//     AppLogger.info(
//       '[socket] join_private -> room: $_room '
//       '(u1=$currentUserId, u2=$receiverId)',
//     );
//   }
//
//   // Map a generic socket map to your Messages model
//   Messages _mapSocketToMessages(Map<String, dynamic> map) {
//     return Messages(
//       id: _safeInt(map['id']),
//       senderId: _safeInt(map['senderId'] ?? map['sender_id']),
//       receiverId: _safeInt(map['receiverId'] ?? map['receiver_id']),
//       type: map['type']?.toString(),
//       message: map['message']?.toString(),
//       imageUrl: (map['image_url'] ?? map['imageUrl'])?.toString(),
//       createdAt:
//           (map['createdAt'] ?? map['created_at'])?.toString() ??
//           DateTime.now().toIso8601String(),
//       updatedAt: (map['updatedAt'] ?? map['updated_at'])?.toString(),
//     );
//   }
//
//   int? _safeInt(dynamic v) {
//     if (v == null) return null;
//     if (v is int) return v;
//     return int.tryParse(v.toString());
//   }
//
//   Map<String, dynamic> _toStringKeyMap(dynamic data) {
//     if (data is Map) {
//       return data.map((k, v) => MapEntry(k.toString(), v));
//     }
//     return <String, dynamic>{};
//   }
//
//   // ---- Helper Methods for Duplicate Check ----
//   bool _sameContent(Messages a, Messages b) {
//     final aMsg = a.message ?? '';
//     final bMsg = b.message ?? '';
//     final aImg = a.imageUrl ?? '';
//     final bImg = b.imageUrl ?? '';
//     final aType = (a.type ?? '');
//     final bType = (b.type ?? '');
//     final aSender = a.senderId?.toString() ?? '';
//     final bSender = b.senderId?.toString() ?? '';
//     final aReceiver = a.receiverId?.toString() ?? '';
//     final bReceiver = b.receiverId?.toString() ?? '';
//
//     return aType == bType &&
//         aMsg == bMsg &&
//         aImg == bImg &&
//         aSender == bSender &&
//         aReceiver == bReceiver;
//   }
//
//   bool _closeInTime(
//     DateTime a,
//     DateTime b, {
//     Duration tolerance = const Duration(seconds: 5),
//   }) {
//     return (a.difference(b).abs() <= tolerance);
//   }
//
//   void _replaceTempWithServer(Messages serverMsg) {
//     // Find a temp message (id < 0) with same content and close timestamps
//     final serverCreated =
//         DateTime.tryParse(serverMsg.createdAt ?? '') ?? DateTime.now();
//     final idx = state.messages.indexWhere((m) {
//       if ((m.id ?? 0) >= 0) return false; // only temp
//       if (!_sameContent(m, serverMsg)) return false;
//       final mCreated = DateTime.tryParse(m.createdAt ?? '') ?? DateTime.now();
//       return _closeInTime(mCreated, serverCreated);
//     });
//
//     if (idx != -1) {
//       final updated = [...state.messages];
//       updated[idx] = serverMsg; // replace temp with server copy
//       emit(state.copyWith(messages: updated));
//     } else {
//       // No temp found — proceed to append if not already present by id
//       final existsById = state.messages.any(
//         (m) => m.id != null && m.id == serverMsg.id,
//       );
//       if (!existsById) {
//         emit(state.copyWith(messages: [...state.messages, serverMsg]));
//       }
//     }
//   }
//
//   void _onUserTyping(dynamic data) {
//     try {
//       final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
//       final senderId = map['senderId']?.toString();
//       final room = map['room']?.toString();
//       final sameRoom = room == _room;
//       final fromPeer = senderId != null && senderId != currentUserId;
//
//       if (!sameRoom || !fromPeer) return;
//
//       // Mark peer as typing now
//       emit(state.copyWith(isPeerTyping: true));
//
//       // Safety: auto-clear after 3s of silence
//       _peerTypingClearTimer?.cancel();
//       _peerTypingClearTimer = Timer(const Duration(seconds: 3), () {
//         if (!isClosed) emit(state.copyWith(isPeerTyping: false));
//       });
//     } catch (e) {
//       AppLogger.info("[socket] error in _onUserTyping: $e");
//     }
//   }
//
//   // ---- Listeners ----
//   void _onReceiveMessage(dynamic data) {
//     try {
//       AppLogger.info("[socket] receive_private_message payload: $data");
//       final map = _toStringKeyMap(data);
//       final msg = _mapSocketToMessages(map);
//
//       // Prefer replacing the temp optimistic message with the server message
//       _replaceTempWithServer(msg);
//     } catch (e, st) {
//       AppLogger.info('[socket] malformed receive_private_message: $e\n$st');
//     }
//   }
//
//   void _onPeerTyping(dynamic data) {
//     try {
//       final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
//       final senderId = map['senderId']?.toString();
//       final isTyping = map['isTyping'] == true;
//       final sameRoom = (map['room']?.toString() ?? '') == _room;
//
//       if (sameRoom && senderId != null && senderId != currentUserId) {
//         emit(state.copyWith(isPeerTyping: isTyping));
//       }
//     } catch (e) {
//       // ignore
//     }
//   }
//
//   String _getPrivateRoomName(String id1, String id2) {
//     final ids = [id1, id2]..sort();
//     return ids.join('_'); // must match server
//   }
//
//   /// Optimistic send (text or image)
//   void sendMessage(String message, {String type = 'text', String? imageUrl}) {
//     if (message.isEmpty && imageUrl == null) return;
//
//     final nowIso = DateTime.now().toIso8601String();
//     final tempId = -DateTime.now().microsecondsSinceEpoch;
//
//     final local = Messages(
//       id: tempId,
//       senderId: int.tryParse(currentUserId),
//       receiverId: int.tryParse(receiverId),
//       type: type,
//       message: message,
//       imageUrl: imageUrl,
//       createdAt: nowIso,
//       updatedAt: nowIso,
//     );
//
//     emit(state.copyWith(messages: [...state.messages, local]));
//
//     final payload = {
//       'room': _room,
//       'senderId': currentUserId,
//       'receiverId': receiverId,
//       'message': message,
//       'type': type,
//       'image_url': imageUrl,
//       'createdAt': nowIso,
//     };
//
//     AppLogger.info('[socket] send_private_message -> $payload');
//     _socket.emit('send_private_message', payload);
//   }
//
//   void startTyping() {
//     // throttle to avoid spamming the server
//     if (_myTypingThrottle?.isActive == true) return;
//     _emitTyping(); // no payload boolean needed if server doesn't use it
//     _myTypingThrottle = Timer(
//       const Duration(seconds: 2),
//       () {},
//     ); // reopen window
//   }
//
//   void stopTyping() {
//     // optional: emit one more 'typing' if your server treats it as a ping
//     // _emitTyping();
//     _myTypingThrottle?.cancel();
//     _myTypingThrottle = null;
//   }
//
//   void _emitTyping() {
//     final payload = {
//       'room': _room,
//       'senderId': currentUserId,
//       'receiverId': receiverId,
//     };
//     AppLogger.info('[socket] typing -> $payload');
//     _socket.emit('typing', payload);
//   }
//
//   @override
//   Future<void> close() {
//     _typingDebounce?.cancel();
//     _socket.off('receive_private_message', _onReceiveMessage);
//     _socket.off('typing', _onPeerTyping);
//     _socket.off('user_typing', _onUserTyping); // Remove listener on close
//     _socket.off('connect');
//     return super.close();
//   }
// }
