import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/services/SocketService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Mentee/Models/GroupChatMessagesModel.dart';
import 'Mentee/data/cubits/Chat/GroupRoomCubit.dart';
import 'Mentee/data/cubits/GroupChatMessages/GroupChatMessagesCubit.dart';
import 'Mentee/data/cubits/GroupChatMessages/GroupMessagesState.dart';

// -------- Extensions ----------
extension GroupMsgX on GroupMessages {
  DateTime get createdAtDate {
    final raw = createdAt?.toString() ?? '';
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  String get timeLabel => DateFormat('hh:mm a').format(createdAtDate);

  bool get isText => (type ?? 'text') == 'text';
  bool get isFile => (type ?? '') == 'file';
  bool get isImageFile {
    final u = (url ?? '').toLowerCase();
    return isFile &&
        (u.endsWith('.png') ||
            u.endsWith('.jpg') ||
            u.endsWith('.jpeg') ||
            u.endsWith('.webp') ||
            u.endsWith('.gif'));
  }
}

// -------- Internal list item (message or date header) ----------
class _ListItem {
  final GroupMessages? msg;
  final DateTime? day;
  final bool isHeader;
  const _ListItem.message(this.msg) : day = null, isHeader = false;
  const _ListItem.header(this.day) : msg = null, isHeader = true;
}

// -------- Screen ----------
class GroupChatScreen extends StatefulWidget {
  final String currentUserId;
  final String collegeId;
  final String groupName;
  final String campus_type;

  const GroupChatScreen({
    super.key,
    required this.currentUserId,
    required this.collegeId,
    required this.groupName,
    required this.campus_type,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _controller = TextEditingController();

  // pagination helpers
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // Scroll
  final ItemScrollController _isc = ItemScrollController();
  final ItemPositionsListener _ipl = ItemPositionsListener.create();

  // sticky header on scroll
  bool _showSticky = true;
  String _stickyLabel = '';
  List<_ListItem> _cache = const [];

  // palette (no external theme)
  Color get _bg => const Color(0xFFF7F8FA);
  Color get _card => Colors.white;
  Color get _text => const Color(0xFF1F2328);
  Color get _muted => const Color(0xFF6B7280);
  Color get _me => Colors.white;
  Color get _other => const Color(0xFFDEEBFF);
  Color get _accent => const Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    getUserId();
    // history load
    if (widget.campus_type == "On Campus Chat") {
      context.read<GroupChatMessagesCubit>().fetch("same");
    } else {
      context.read<GroupChatMessagesCubit>().fetch("");
    }
    // join socket room already handled in GroupRoomCubit constructor.
    _ipl.itemPositions.addListener(() {
      final positions = _ipl.itemPositions.value;
      if (positions.isEmpty || _cache.isEmpty) return;

      final first = positions
          .where((p) => p.itemTrailingEdge > 0)
          .reduce((a, b) => a.index < b.index ? a : b);

      String _label(int idx) {
        if (idx < 0 || idx >= _cache.length) return '';
        final it = _cache[idx];
        if (it.isHeader) return _dateLabel(it.day!);
        return _dateLabel(it.msg!.createdAtDate);
      }

      final newLabel = _label(first.index);

      // if inline header with same label is near top, hide sticky
      bool topHasSame = false;
      for (final p in positions) {
        final i = p.index;
        if (i < 0 || i >= _cache.length) continue;
        final it = _cache[i];
        if (it.isHeader) {
          if (_dateLabel(it.day!) == newLabel && p.itemLeadingEdge <= 0.18) {
            topHasSame = true;
            break;
          }
        }
      }

      final nextShow = !topHasSame;
      if (nextShow != _showSticky || newLabel != _stickyLabel) {
        setState(() {
          _showSticky = nextShow;
          _stickyLabel = newLabel;
        });
      }

      // near top? (older side with reverse:true)
      final nearTop = positions.any((p) => p.index >= _cache.length - 3);
      if (nearTop && !_isLoadingMore && _hasMore) {
        setState(() => _isLoadingMore = true);
        if (widget.campus_type == "On Campus Chat") {
          context.read<GroupChatMessagesCubit>().loadMore("same");
        } else {
          context.read<GroupChatMessagesCubit>().loadMore("");
        }
      }
    });
  }

  Future<void> getUserId() async {
    final userId = await AuthService.getUSerId();
    AppLogger.info("userId: ${userId}");
    SocketService.connect(userId.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _dateLabel(DateTime d) {
    final now = DateTime.now();
    final d0 = DateTime(d.year, d.month, d.day);
    final n0 = DateTime(now.year, now.month, now.day);
    final diff = n0.difference(d0).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(d);
  }

  void _scrollToBottom() {
    if (_cache.isEmpty) return;
    if (_isc.isAttached) {
      _isc.scrollTo(
        index: 0,
        duration: const Duration(milliseconds: 240),
        alignment: 0,
      );
    }
  }

  List<_ListItem> _buildItems(List<GroupMessages> allDesc) {
    // allDesc is NEWEST → OLDEST
    final items = <_ListItem>[];
    final buffer = <GroupMessages>[];
    DateTime? dayKey;

    void flush() {
      if (buffer.isEmpty || dayKey == null) return;
      for (final m in buffer) items.add(_ListItem.message(m));
      items.add(_ListItem.header(dayKey));
      buffer.clear();
      dayKey = null;
    }

    for (final m in allDesc) {
      final d = m.createdAtDate.toLocal();
      final key = DateTime(d.year, d.month, d.day);
      if (dayKey == null || dayKey == key) {
        dayKey = key;
        buffer.add(m);
      } else {
        flush();
        dayKey = key;
        buffer.add(m);
      }
    }
    flush();
    return items;
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        titleSpacing: 8,
        title: Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: const Color(0xFFCBD5E1),
            //   radius: 18,
            //   child: const Icon(Icons.school, color: Colors.white),
            // ),
            // const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.campus_type,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _scrollToBottom,
            icon: Icon(Icons.south, color: _text),
            tooltip: 'Jump to latest',
          ),
        ],
        iconTheme: IconThemeData(color: _text),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xffEFF6FF)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<GroupRoomCubit, GroupRoomState>(
                    listenWhen: (p, c) =>
                        p.messages.length != c.messages.length,
                    listener: (_, __) => _scrollToBottom(),
                  ),
                  BlocListener<GroupChatMessagesCubit, GroupMessagesState>(
                    listener: (_, state) {
                      if (state is GroupMessagesLoaded) {
                        _hasMore = state.hasNextPage;
                        setState(() => _isLoadingMore = false);
                      } else if (state is GroupMessagesLoadingMore) {
                        _hasMore = state.hasNextPage;
                      } else if (state is GroupMessagesFailure) {
                        setState(() => _isLoadingMore = false);
                      }
                    },
                  ),
                ],
                child: BlocBuilder<GroupChatMessagesCubit, GroupMessagesState>(
                  builder: (context, histState) {
                    final history = <GroupMessages>[];
                    if (histState is GroupMessagesLoaded) {
                      history.addAll(
                        histState.chat.message?.groupMessages ?? const [],
                      );
                    } else if (histState is GroupMessagesLoadingMore) {
                      history.addAll(
                        histState.chat.message?.groupMessages ?? const [],
                      );
                    }
                    return BlocBuilder<GroupRoomCubit, GroupRoomState>(
                      builder: (context, liveState) {
                        final all = <GroupMessages>[];
                        final seen = <String>{};

                        void add(GroupMessages m) {
                          final k = (m.id != null)
                              ? 'id:${m.id}'
                              : 'ts:${m.createdAt}:${m.message}:${m.url}:${m.senderId}';
                          if (seen.add(k)) all.add(m);
                        }

                        for (final m in history) add(m);
                        for (final m in liveState.messages) add(m);

                        // NEWEST → OLDEST for reverse:true
                        all.sort(
                          (a, b) => b.createdAtDate.compareTo(a.createdAtDate),
                        );

                        final items = _buildItems(all);
                        _cache = items;

                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 44),
                              child: ScrollablePositionedList.builder(
                                itemScrollController: _isc,
                                itemPositionsListener: _ipl,
                                reverse: true,
                                itemCount:
                                    items.length +
                                    (_hasMore && _isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (_hasMore &&
                                      _isLoadingMore &&
                                      index == items.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                        ),
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
                                    final msg = it.msg!;
                                    final isMe =
                                        (msg.senderId?.toString() ?? '') ==
                                        widget.currentUserId;
                                    return _bubble(msg, isMe);
                                  }
                                },
                              ),
                            ),
                            if (_showSticky && _stickyLabel.isNotEmpty)
                              Positioned(
                                top: 6,
                                child: _dateChip(_stickyLabel),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            _inputBar(),
          ],
        ),
      ),
    );
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

  // ---------------------------------------------------------------------
  // 1. Helper – a tiny avatar widget (reuse it everywhere)
  // ---------------------------------------------------------------------
  Widget _avatar(String? url, {double size = 28}) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: const Color(0xFFE5E7EB),
      backgroundImage: url != null && url.isNotEmpty ? NetworkImage(url) : null,
      child: url == null || url.isEmpty
          ? const Icon(Icons.person, size: 16, color: Colors.grey)
          : null,
    );
  }

  // ---------------------------------------------------------------------
  // 2. Updated _bubble – matches the uploaded design 100%
  // ---------------------------------------------------------------------
  Widget _bubble(GroupMessages m, bool isMe) {
    final bg = isMe ? _me : _other; // your existing colour vars
    final textColor = _text; // your existing text colour
    final muted = _muted; // timestamp / name colour

    // -----------------------------------------------------------------
    // Content (text / image / file) – unchanged logic, just wrapped
    // -----------------------------------------------------------------
    Widget content;
    if (m.isText) {
      content = Text(
        m.message ?? '',
        style: TextStyle(color: textColor, fontSize: 15),
      );
    } else if (m.isImageFile && (m.url ?? '').isNotEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          m.url!,
          width: 220,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    } else if (m.isFile) {
      content = InkWell(
        onTap: (m.url ?? '').isEmpty ? null : () => _openUrl(m.url!),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.attach_file, size: 18),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  (m.url ?? '').isEmpty
                      ? 'Attachment'
                      : Uri.parse(m.url!).pathSegments.last,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              if ((m.url ?? '').isNotEmpty)
                Icon(Icons.open_in_new, size: 16, color: _accent),
            ],
          ),
        ),
      );
    } else {
      content = const SizedBox.shrink();
    }

    // -----------------------------------------------------------------
    // MAIN LAYOUT – avatar + name row  →  bubble  →  timestamp
    // -----------------------------------------------------------------
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // ---- Avatar + Name (outside the bubble) ----
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _avatar(m.sender?.profilePicUrl), // <-- sender image
                  const SizedBox(width: 6),
                  Text(
                    m.sender?.name ?? 'Member',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // ---- The actual bubble ----
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 24 : 0),
                    topRight: Radius.circular(isMe ? 0 : 24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: 4),
                    Text(
                      m.timeLabel,
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputBar() {
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
                  hintText: 'Write a message…',
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
                onSubmitted: (_) => _sendText(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: _accent),
              onPressed: _sendText,
              tooltip: 'Send',
            ),
          ],
        ),
      ),
    );
  }

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<GroupRoomCubit>().sendMessage(text: text);
    _controller.clear();
  }
}
