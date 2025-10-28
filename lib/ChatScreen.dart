import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/UploadFileInChat/UploadFileInChatStates.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/services/SocketService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/ImageUtils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'Mentee/Models/ChatMessagesModel.dart';
import 'Mentee/data/cubits/Chat/private_chat_cubit.dart';
import 'Mentee/data/cubits/ChatMessages/ChatMessagesCubit.dart';
import 'Mentee/data/cubits/ChatMessages/ChatMessagesStates.dart';
import 'Mentee/data/cubits/UploadFileInChat/UploadFileInChatCubit.dart';
import 'Mentee/presentation/Widgets/UserAvatar.dart';

extension ChatScreenMessagesX on Messages {
  DateTime get createdAtDate {
    final raw = createdAt?.toString() ?? '';
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  String get formattedTime {
    return DateFormat('hh:mm a').format(createdAtDate);
  }

  bool get isImage => (type ?? '') == 'image';
  bool get isText => (type ?? '') == 'text';
}

// ====== INTERNAL LIST ITEM (message or date header) ======
class _ListItem {
  final Messages? message;
  final DateTime? day;
  final bool isHeader;
  const _ListItem.message(this.message) : day = null, isHeader = false;
  const _ListItem.header(this.day) : message = null, isHeader = true;
}

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String sessionId;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.sessionId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

enum _MenuAction { report, safetyTips }

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();

  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;
  Timer? _safetyAutoHide;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener =
      ItemPositionsListener.create();

  // Sticky header state
  bool _showStickyHeader = true;
  String _stickyDateLabel = '';
  List<_ListItem> _lastItems = const [];

  final ValueNotifier<String?> receiverName = ValueNotifier<String?>("");
  final ValueNotifier<String?> receiverID = ValueNotifier<String?>("");
  final ValueNotifier<String?> receiverProfile = ValueNotifier<String?>("");

  // "show while scrolling" state
  Timer? _scrollIdleTimer;
  bool _isScrolling = false;

  // ---- Helpers ----
  void _onScrollActivity() {
    if (!_isScrolling) setState(() => _isScrolling = true);
    _scrollIdleTimer?.cancel();
    _scrollIdleTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _isScrolling = false);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    try {
      AppLogger.info("receiverId:${widget.receiverId}");
      context.read<ChatMessagesCubit>().fetchMessages(
        widget.receiverId,
        widget.sessionId,
      );
    } catch (_) {}

    _positionsListener.itemPositions.addListener(() {
      final positions = _positionsListener.itemPositions.value;
      if (positions.isEmpty || _lastItems.isEmpty) return;

      // First visible (lowest index)
      final first = positions
          .where((p) => p.itemTrailingEdge > 0)
          .reduce((a, b) => a.index < b.index ? a : b);

      String _labelForIndex(int idx) {
        if (idx < 0 || idx >= _lastItems.length) return '';
        final it = _lastItems[idx];
        if (it.isHeader) return _dateLabel(it.day!);
        final d = it.message!.createdAtDate;
        return _dateLabel(d);
      }

      final newLabel = _labelForIndex(first.index);

      // Hide sticky if an inline header with same label is at/near top
      bool topHasSameInlineHeader = false;
      for (final p in positions) {
        final idx = p.index;
        if (idx < 0 || idx >= _lastItems.length) continue;
        final it = _lastItems[idx];
        if (it.isHeader) {
          final lbl = _dateLabel(it.day!);
          if (lbl == newLabel && p.itemLeadingEdge <= 0.18) {
            topHasSameInlineHeader = true;
            break;
          }
        }
      }

      final nextShowSticky = !topHasSameInlineHeader;
      if (nextShowSticky != _showStickyHeader || newLabel != _stickyDateLabel) {
        setState(() {
          _showStickyHeader = nextShowSticky;
          _stickyDateLabel = newLabel;
        });
      }

      // Load more when scrolled near the "top" (older) with reverse:true
      final nearTop = positions.any((p) => p.index >= _lastItems.length - 3);
      if (nearTop && !_isLoadingMore && _hasMoreMessages) {
        setState(() => _isLoadingMore = true);
        context.read<ChatMessagesCubit>().getMoreMessages(
          widget.receiverId,
          widget.sessionId,
        );
      }
    });
  }

  Future<void> getUserId() async {
    final userId = await AuthService.getUSerId();
    AppLogger.info("userId: ${userId}");
    SocketService.connect(userId.toString());
  }

  File? _file;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        setState(() {
          _file = compressedFile;
        });
      }
    }
  }

  Future<void> _pickAnyFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final file = File(path);

      // ✅ Check file size (must be ≤ 500 KB)
      final bytes = await file.length();
      final sizeInKb = bytes / 1024;

      if (sizeInKb > 500) {
        // File is too large
        CustomSnackBar1.show(context, "File size must not exceed 500 KB");
        return;
      }

      // If it's an image, compress
      final isImage = [
        '.jpg',
        '.jpeg',
        '.png',
        '.webp',
      ].any((ext) => path.toLowerCase().endsWith(ext));

      File toSend = file;
      if (isImage) {
        final compressed = await ImageUtils.compressImage(file);
        if (compressed != null) toSend = compressed;
      }

      // ✅ Assign to state for sending
      setState(() {
        _file = toSend; // or keep a generic File variable for non-image
      });
    }
  }

  @override
  void dispose() {
    _scrollIdleTimer?.cancel();
    _safetyAutoHide?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_lastItems.isEmpty) return;
    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: 0, // index 0 is newest (bottom) when reverse:true
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0, // stick to bottom
      );
    }
  }

  // Simple palette
  Color get _bg => const Color(0xFFF7F8FA);
  Color get _card => Colors.white;
  Color get _text => const Color(0xFF1F2328);
  Color get _muted => const Color(0xFF6B7280);
  Color get _meBubbleColor => const Color(0xFFDDEBFF);
  Color get _otherBubbleColor => const Color(0xFFF1F5F9);

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    final first = parts[0].characters.first.toUpperCase();
    final second = parts[1].characters.first.toUpperCase();
    return '$first$second';
  }

  Widget _avatar({
    double size = 36,
    String? profileUrl, // 👈 Add optional image URL
  }) {
    final initials = _initials(receiverName.value ?? "");
    final hasImage = profileUrl != null && profileUrl.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFCBD5E1),
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(profileUrl),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {
                  debugPrint("⚠️ Avatar image failed to load: $error");
                },
              )
            : null,
      ),
      alignment: Alignment.center,
      child: !hasImage
          ? Text(
              initials.isNotEmpty ? initials[0].toUpperCase() : "?",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 8,
        title: GestureDetector(
          onTap: () {
            context.push("/common_profile/${widget.receiverId}");
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _avatar(size: 36, profileUrl: receiverProfile.value),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: receiverName,
                      builder: (context, value, _) {
                        return Text(
                          value ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              BlocBuilder<PrivateChatCubit, PrivateChatState>(
                buildWhen: (p, c) => p.isPeerTyping != c.isPeerTyping,
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: state.isPeerTyping
                        ? Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'Typing…',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                          )
                        : const SizedBox(height: 16),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<_MenuAction>(
            icon: Icon(Icons.more_vert, color: _text, size: 26),
            onSelected: (value) {
              switch (value) {
                case _MenuAction.report:
                  // openReportSheetForChat(context, userId: int.parse(widget.receiverId));
                  break;
                case _MenuAction.safetyTips:
                  // showModalBottomSheet(... your safety tips sheet ...)
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<_MenuAction>(
                value: _MenuAction.report,
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Report user',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<_MenuAction>(
                value: _MenuAction.safetyTips,
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Safety tips',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
            color: _card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            tooltip: 'More options',
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<PrivateChatCubit, PrivateChatState>(
                    listenWhen: (p, c) =>
                        p.messages.length != c.messages.length ||
                        p.isPeerTyping != c.isPeerTyping,
                    listener: (ctx, state) => _scrollToBottom(),
                  ),
                  BlocListener<ChatMessagesCubit, ChatMessagesStates>(
                    listener: (ctx, state) {
                      if (state is ChatMessagesLoaded) {
                        setState(() {
                          _hasMoreMessages = state.hasNextPage;
                          receiverName.value =
                              state.chatMessages.receiverDetails?.name ?? "";
                          AppLogger.info(
                            "receiverName.value:${receiverName.value} ${state.chatMessages.receiverDetails?.name}",
                          );
                          receiverProfile.value =
                              state.chatMessages.receiverDetails?.profilePic ??
                              "";
                        });
                        setState(() => _isLoadingMore = false);
                      } else if (state is ChatMessagesLoadingMore) {
                        _hasMoreMessages = state.hasNextPage;
                      } else if (state is ChatMessagesFailure) {
                        setState(() => _isLoadingMore = false);
                      }
                    },
                  ),
                ],
                child: BlocBuilder<ChatMessagesCubit, ChatMessagesStates>(
                  builder: (context, historyState) {
                    final history = <Messages>[];

                    if (historyState is ChatMessagesLoaded) {
                      history.addAll(
                        historyState.chatMessages.message?.messages ?? const [],
                      );
                    } else if (historyState is ChatMessagesLoadingMore) {
                      history.addAll(
                        historyState.chatMessages.message?.messages ?? const [],
                      );
                    }

                    return BlocBuilder<PrivateChatCubit, PrivateChatState>(
                      builder: (context, liveState) {
                        final all = <Messages>[];
                        final seen = <String>{};
                        void addMsg(Messages m) {
                          final idPart = (m.id != null)
                              ? 'id:${m.id}'
                              : 'ts:${m.createdAt}:${m.message}:${m.url}';
                          if (seen.add(idPart)) all.add(m);
                        }

                        for (final m in history) addMsg(m);
                        for (final m in liveState.messages) addMsg(m);

                        // NEWEST → OLDEST for reverse:true
                        all.sort(
                          (a, b) => b.createdAtDate.compareTo(a.createdAtDate),
                        );

                        // Build flat items and cache for sticky logic
                        final items = _buildItems(all);
                        _lastItems = items;

                        final overlayVisible =
                            _isScrolling &&
                            _showStickyHeader &&
                            _stickyDateLabel.isNotEmpty;

                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            // Add top padding so inline chips don't sit under the floating chip.
                            Padding(
                              padding: const EdgeInsets.only(top: 44),
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (n) {
                                  if (n is ScrollStartNotification ||
                                      n is ScrollUpdateNotification ||
                                      n is OverscrollNotification) {
                                    _onScrollActivity();
                                  }
                                  return false;
                                },
                                child: ScrollablePositionedList.builder(
                                  itemScrollController: _itemScrollController,
                                  itemPositionsListener: _positionsListener,
                                  reverse: true,
                                  itemCount:
                                      items.length +
                                      (_hasMoreMessages && _isLoadingMore
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    // Loader at "top" (end) with reverse:true
                                    if (_hasMoreMessages &&
                                        _isLoadingMore &&
                                        index == items.length) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    final it = items[index];
                                    if (it.isHeader) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: _dateChip(_dateLabel(it.day!)),
                                      );
                                    } else {
                                      final msg = it.message!;
                                      final isMe =
                                          (msg.senderId?.toString() ?? '') ==
                                          widget.currentUserId;
                                      return _buildMessageBubble(msg, isMe);
                                    }
                                  },
                                ),
                              ),
                            ),

                            // Sticky date chip — visible ONLY while scrolling
                            if (overlayVisible)
                              Positioned(
                                top: 6,
                                child: _dateChip(_stickyDateLabel),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  String _dateLabel(DateTime day) {
    final now = DateTime.now();
    final d0 = DateTime(day.year, day.month, day.day);
    final n0 = DateTime(now.year, now.month, now.day);
    final diff = n0.difference(d0).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(day);
  }

  /// Build flat list with headers that appear ABOVE their day (works with reverse:true)
  List<_ListItem> _buildItems(List<Messages> allDesc) {
    // allDesc is NEWEST → OLDEST
    final items = <_ListItem>[];
    final buffer = <Messages>[];
    DateTime? bucketDay;

    void flush() {
      if (buffer.isEmpty || bucketDay == null) return;
      for (final m in buffer) items.add(_ListItem.message(m));
      // header after its messages so it appears above with reverse:true
      items.add(_ListItem.header(bucketDay));
      buffer.clear();
      bucketDay = null;
    }

    for (final m in allDesc) {
      if ((m.type ?? 'text') == 'typing') continue;
      final d = m.createdAtDate.toLocal();
      final key = DateTime(d.year, d.month, d.day);
      if (bucketDay == null || bucketDay == key) {
        bucketDay = key;
        buffer.add(m);
      } else {
        flush();
        bucketDay = key;
        buffer.add(m);
      }
    }
    flush();
    return items;
  }

  Widget _dateChip(String label) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _text.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _text,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Messages msg, bool isMe) {
    final bubbleColor = isMe ? _meBubbleColor : _otherBubbleColor;
    final bodyStyle = TextStyle(color: _text, fontSize: 15);
    final timeStyle = TextStyle(color: _muted, fontSize: 11);

    // You may need to adapt these getters to your model
    final senderName = msg.sender?.name ?? 'User';
    final senderPhoto = msg.sender?.profilePicUrl ?? "";
    final isImage = () {
      final u = (msg.url ?? '').toLowerCase();
      return u.endsWith('.jpg') ||
          u.endsWith('.jpeg') ||
          u.endsWith('.png') ||
          u.endsWith('.gif') ||
          u.endsWith('.webp');
    }();

    Widget content;
    if (msg.type == 'text') {
      content = Text(msg.message ?? '', style: bodyStyle);
    } else if (msg.type == 'file') {
      final url = msg.url ?? '';
      if (isImage && url.isNotEmpty) {
        content = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              padding: const EdgeInsets.all(8),
              child: Text('Image unavailable', style: bodyStyle),
            ),
          ),
        );
      } else {
        final fileName = url.split('/').isNotEmpty
            ? url.split('/').last
            : (msg.message ?? 'file');
        content = Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.insert_drive_file,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  fileName,
                  style: bodyStyle.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      content = Text("Unsupported message", style: bodyStyle);
    }

    final bubble = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show sender name (subtle) for others above the content
            if (!isMe) ...[
              Text(
                senderName,
                style: TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
            content,
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(msg.formattedTime, style: timeStyle),
            ),
          ],
        ),
      ),
    );

    // For me → no avatar, right aligned
    if (isMe) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    // For others → avatar + bubble row
    return Padding(
      padding: const EdgeInsets.only(
        right: 56,
      ), // keeps it visually balanced vs my bubbles
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 4),
          UserAvatar(imageUrl: senderPhoto, name: senderName, size: 32),
          const SizedBox(width: 6),
          Flexible(child: bubble),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  bool _isImageFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');
  }

  Widget _buildInputArea(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(36)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // === Preview when user has selected an image ===
            if (_file != null) ...[
              Container(
                margin: const EdgeInsets.fromLTRB(6, 4, 6, 10),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE3E8EF)),
                ),
                child: Row(
                  children: [
                    // check file extension
                    if (_isImageFile(_file!.path))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _file!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.insert_drive_file,
                          color: Colors.blueGrey,
                          size: 32,
                        ),
                      ),

                    const SizedBox(width: 10),

                    // filename
                    Expanded(
                      child: Text(
                        _file!.path.split('/').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // remove button
                    IconButton(
                      tooltip: 'Remove',
                      onPressed: () => setState(() => _file = null),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
            ],
            // === Controls row ===
            Row(
              children: [
                // Text Field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Say your Words...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) => _sendText(context, type: "text"),
                  ),
                ),

                const SizedBox(width: 8),

                // Attachment Button
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.black54),
                    onPressed: () {
                      _showAttachmentSheet(
                        context,
                      ); // your bottom sheet (camera/gallery/docs)
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Send Button (gradient) — unchanged logic, just kept intact
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child:
                      BlocConsumer<
                        UploadFileInChatCubit,
                        UploadFileInChatStates
                      >(
                        listener: (context, state) {
                          if (state is UploadFileInChatSuccess) {
                            _sendText(
                              context,
                              type: "file",
                              url: state.result.url,
                            );
                            setState(
                              () => _file = null,
                            ); // clear preview after sent
                          } else if (state is UploadFileInChatFailure) {
                            CustomSnackBar1.show(context, state.error);
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is UploadFileInChatLoading;
                          if (isLoading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            );
                          }
                          return IconButton(
                            icon: Image.asset("assets/icons/Vector.png"),
                            onPressed: _file != null
                                ? () {
                                    final Map<String, dynamic> data = {
                                      "file": _file,
                                    };
                                    context
                                        .read<UploadFileInChatCubit>()
                                        .uploadFileInChat(data);
                                  }
                                : () => _sendText(context),
                          );
                        },
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendText(BuildContext context, {String type = 'text', String? url}) {
    final text = _controller.text.trim();

    // if it's text message, ensure text is not empty
    if (type == 'text' && text.isEmpty) return;

    // if it's file/image/video message, ensure url is present
    if (type != 'text' && (url == null || url.isEmpty)) return;

    try {
      context.read<PrivateChatCubit>().sendMessage(text, type: type, url: url);
      _controller.clear();
      context.read<PrivateChatCubit>().stopTyping();
    } catch (_) {}
  }

  Future<void> _showAttachmentSheet(BuildContext context) async {
    final bg = const Color(0xFFF3F4F6);
    final heading = const Color(0xFF111827);
    final muted = const Color(0xFF6B7280);
    final accentRed = const Color(0xFFD92E2E);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab handle (optional)
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Send your attachment',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Options row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Upload (any file)
                  _AttachmentOption(
                    label: 'Upload',
                    icon: Icons.upload_file, // doc with up-arrow look
                    bg: bg,
                    iconColor: muted,
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickAnyFile(context);
                    },
                  ),

                  // Camera (take photo)
                  _AttachmentOption(
                    label: 'Camera',
                    icon: Icons.photo_camera_outlined,
                    bg: bg,
                    iconColor: muted,
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickImageFromCamera(); // your function
                    },
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Note
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: '***',
                        style: TextStyle(
                          color: accentRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' Please note that you can send the attachment only once, '
                            'so review it carefully before sending.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Option tile used in the row
class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.bg,
    required this.iconColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        width:
            (MediaQuery.of(context).size.width - 24 - 24 - 16) /
            2, // paddings + spacing
        child: Column(
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
