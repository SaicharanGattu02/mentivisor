import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'Mentee/Models/ChatMessagesModel.dart';
import 'Mentee/data/cubits/Chat/private_chat_cubit.dart';
import 'Mentee/data/cubits/ChatMessages/ChatMessagesCubit.dart';
import 'Mentee/data/cubits/ChatMessages/ChatMessagesStates.dart';

// ====== EXTENSIONS ======
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

// ====== CHAT SCREEN ======
class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

enum _MenuAction { report, safetyTips }

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();

  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;

  bool _showSafetyBanner = true;
  bool _animSafetyBannerIn = false;
  Timer? _safetyAutoHide;

  // ScrollablePositionedList controls
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener =
      ItemPositionsListener.create();

  // Sticky header state
  bool _showStickyHeader = true;
  String _stickyDateLabel = '';
  List<_ListItem> _lastItems = const [];

  final ValueNotifier<String?> receiverName = ValueNotifier<String?>("User");

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
    // initial history load
    try {
      context.read<ChatMessagesCubit>().fetchMessages(widget.receiverId);
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
        context.read<ChatMessagesCubit>().getMoreMessages(widget.receiverId);
      }
    });
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

  Widget _avatar({double size = 36}) {
    final initials = _initials(receiverName.value ?? "User");
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFCBD5E1),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _avatar(size: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: receiverName,
                    builder: (context, value, _) {
                      return Text(
                        value ?? "User",
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
        iconTheme: IconThemeData(color: _text),
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
                        _hasMoreMessages = state.hasNextPage;
                        // receiverName.value = state.chatMessages.message?.friend?.name ?? "User";
                        // mobileNotifier.value = state.chatMessages.message?.friend?.mobile ?? "";
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
                        // Merge + dedupe
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
      if ((m.type ?? 'text') == 'typing') continue; // skip ephemeral typing
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

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
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
            children: [
              if (msg.isText) Text((msg.message ?? ''), style: bodyStyle),
              if (msg.isImage && (msg.url ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    msg.url!,
                    height: 220,
                    width: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 4),
              Text(msg.formattedTime, style: timeStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final fill = const Color(0xFFF3F4F6);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        color: _bg,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: _text, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  hintStyle: TextStyle(color: _muted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: fill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onChanged: (text) {
                  try {
                    final cubit = context.read<PrivateChatCubit>();
                    if (text.isNotEmpty) {
                      cubit.startTyping();
                    } else {
                      cubit.stopTyping();
                    }
                  } catch (_) {}
                },
                onSubmitted: (_) => _sendText(context),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: _text),
              onPressed: () => _sendText(context),
            ),
          ],
        ),
      ),
    );
  }

  void _sendText(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    try {
      context.read<PrivateChatCubit>().sendMessage(text);
      _controller.clear();
      context.read<PrivateChatCubit>().stopTyping();
    } catch (_) {}
  }
}

// ====== SIMPLE SAFETY BANNER ======
class _SafetyBanner extends StatelessWidget {
  final Color textColor;
  final Color bgColor;
  final VoidCallback onClose;

  const _SafetyBanner({
    Key? key,
    required this.textColor,
    required this.bgColor,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Please do not share personal details like bank info, OTPs, or passwords in chat. Deal safely.",
                style: TextStyle(color: textColor, fontSize: 13, height: 1.3),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: textColor.withOpacity(0.7),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
