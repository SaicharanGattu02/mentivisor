import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../Models/ChatMessagesModel.dart';
import 'ChatMessagesRepository.dart';
import 'ChatMessagesStates.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesStates> {
  final ChatMessagesRepository chatMessagesRepository;

  ChatMessagesCubit(this.chatMessagesRepository) : super(ChatMessagesInitial());

  ChatMessagesModel chatMessagesModel = ChatMessagesModel();
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  // Helpers
  DateTime _parseIso(String? s) =>
      DateTime.tryParse(s ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);

  bool _isNextAvailable(Message? m) =>
      (m?.nextPageUrl != null && (m?.currentPage ?? 1) < (m?.lastPage ?? 1));

  // Fetch initial chat messages (newest-first for reverse:true lists)
  Future<void> fetchMessages(String userId, String sessionId) async {
    emit(ChatMessagesLoading());
    _currentPage = 1;
    try {
      final res = await chatMessagesRepository.getChatMessages(
        userId,
        _currentPage,
        sessionId,
      );

      if (res != null && (res.status ?? false) && res.message != null) {
        final pageAsc = res.message!.messages ?? const <Messages>[];
        final newestFirst = List<Messages>.from(pageAsc.reversed);

        // write back newest-first into the model
        chatMessagesModel = ChatMessagesModel(
          status: res.status,
          receiverDetails: res.receiverDetails,
          message: Message(
            currentPage: res.message!.currentPage,
            lastPage: res.message!.lastPage,
            nextPageUrl: res.message!.nextPageUrl,
            firstPageUrl: res.message!.firstPageUrl,
            from: res.message!.from,
            lastPageUrl: res.message!.lastPageUrl,
            links: res.message!.links,
            path: res.message!.path,
            perPage: res.message!.perPage,
            prevPageUrl: res.message!.prevPageUrl,
            to: res.message!.to,
            total: res.message!.total,
            messages: newestFirst,
          ),
        );

        _currentPage = res.message!.currentPage ?? 1;
        _hasNextPage = _isNextAvailable(res.message);
        emit(ChatMessagesLoaded(chatMessagesModel, _hasNextPage));
      } else {
        emit(ChatMessagesFailure("Failed to load chat messages"));
      }
    } catch (e) {
      emit(ChatMessagesFailure(e.toString()));
    }
  }

  // Load older messages: APPEND at end because list is newest-first
  Future<void> getMoreMessages(String userId, String sessionId) async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    emit(ChatMessagesLoadingMore(chatMessagesModel, _hasNextPage));

    try {
      final nextPage = (_currentPage) + 1;
      final newRes = await chatMessagesRepository.getChatMessages(
        userId,
        nextPage,
        sessionId,
      );

      final pageAsc = newRes?.message?.messages ?? const <Messages>[];
      if (newRes != null && (newRes.status ?? false) && pageAsc.isNotEmpty) {
        // Existing (already newest-first)
        final existing = List<Messages>.from(
          chatMessagesModel.message?.messages ?? const <Messages>[],
        );

        // Convert this page to newest-first as well
        final olderDesc = List<Messages>.from(pageAsc.reversed);

        // Append at the end (top visually in reverse list)
        existing.addAll(olderDesc);

        // De-dupe by (id) else fallback to (senderId+receiverId+message+url+createdAt second resolution)
        final seenIds = <int>{};
        final seenComposite = <String>{};
        final deduped = <Messages>[];

        for (final m in existing) {
          final mid = m.id;
          if (mid != null) {
            if (seenIds.add(mid)) deduped.add(m);
          } else {
            final key = [
              m.senderId ?? 0,
              m.receiverId ?? 0,
              m.type ?? '',
              m.message ?? '',
              m.url ?? '',
              _parseIso(m.createdAt).millisecondsSinceEpoch ~/
                  1000, // second precision
            ].join('|');
            if (seenComposite.add(key)) deduped.add(m);
          }
        }

        chatMessagesModel = ChatMessagesModel(
          status: newRes.status,
          receiverDetails: newRes.receiverDetails,
          message: Message(
            currentPage: newRes.message?.currentPage ?? nextPage,
            lastPage: newRes.message?.lastPage,
            nextPageUrl: newRes.message?.nextPageUrl,
            firstPageUrl: newRes.message?.firstPageUrl,
            from: newRes.message?.from,
            lastPageUrl: newRes.message?.lastPageUrl,
            links: newRes.message?.links,
            path: newRes.message?.path,
            perPage: newRes.message?.perPage,
            prevPageUrl: newRes.message?.prevPageUrl,
            to: newRes.message?.to,
            total: newRes.message?.total,
            messages: deduped,
          ),
        );

        _currentPage = chatMessagesModel.message?.currentPage ?? nextPage;
        _hasNextPage = _isNextAvailable(chatMessagesModel.message);
        emit(ChatMessagesLoaded(chatMessagesModel, _hasNextPage));
      } else {
        _hasNextPage = false;
        emit(ChatMessagesLoaded(chatMessagesModel, _hasNextPage));
      }
    } catch (e) {
      emit(ChatMessagesFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}
