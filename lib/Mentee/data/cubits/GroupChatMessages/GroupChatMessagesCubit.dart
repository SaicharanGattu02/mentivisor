import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/GroupChatMessagesModel.dart';
import 'GroupMessagesRepo.dart';
import 'GroupMessagesState.dart';

// ---- Cubit ----
class GroupChatMessagesCubit extends Cubit<GroupMessagesState> {
  final GroupMessagesRepository repo; // implement getGroupMessages(collegeId, page)

  GroupChatMessagesCubit(this.repo) : super(GroupMessagesInitial());

  GroupChatMessagesModel _model = GroupChatMessagesModel();
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  DateTime _parseIso(String? s) =>
      DateTime.tryParse(s ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);

  bool _isNextAvailable(Message? m) =>
      (m?.nextPageUrl != null && (m?.currentPage ?? 1) < (m?.lastPage ?? 1));

  // NEWEST → OLDEST list in memory (for reverse:true)
  Future<void> fetch(String Scope) async {
    emit(GroupMessagesLoading());
    _currentPage = 1;

    try {
      final res = await repo.getGroupChatMessages(_currentPage,Scope);
      if (res != null && (res.status ?? false) && res.message != null) {
        final pageAsc = res.message!.groupMessages ?? const <GroupMessages>[];
        final newestFirst = List<GroupMessages>.from(pageAsc.reversed);

        _model = GroupChatMessagesModel(
          status: res.status,
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
            groupMessages: newestFirst,
          ),
        );

        _currentPage = res.message!.currentPage ?? 1;
        _hasNextPage = _isNextAvailable(res.message);
        emit(GroupMessagesLoaded(_model, _hasNextPage));
      } else {
        emit(GroupMessagesFailure('Failed to load messages'));
      }
    } catch (e) {
      emit(GroupMessagesFailure(e.toString()));
    }
  }

  Future<void> loadMore(String Scope) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    emit(GroupMessagesLoadingMore(_model, _hasNextPage));

    try {
      final nextPage = _currentPage + 1;
      final res = await repo.getGroupChatMessages(nextPage,Scope);
      final pageAsc = res?.message?.groupMessages ?? const <GroupMessages>[];

      if (res != null && (res.status ?? false) && pageAsc.isNotEmpty) {
        final existing = List<GroupMessages>.from(
          _model.message?.groupMessages ?? const <GroupMessages>[],
        );
        final olderDesc = List<GroupMessages>.from(pageAsc.reversed);
        existing.addAll(olderDesc);

        // De-dupe by id else composite key
        final seenIds = <int>{};
        final seenComposite = <String>{};
        final deduped = <GroupMessages>[];

        for (final m in existing) {
          final id = m.id;
          if (id != null) {
            if (seenIds.add(id)) deduped.add(m);
          } else {
            final key = [
              m.senderId ?? 0,
              m.collegeId ?? 0,
              m.type ?? '',
              m.message ?? '',
              m.url ?? '',
              _parseIso(m.createdAt).millisecondsSinceEpoch ~/ 1000,
            ].join('|');
            if (seenComposite.add(key)) deduped.add(m);
          }
        }

        _model = GroupChatMessagesModel(
          status: res.status,
          message: Message(
            currentPage: res.message?.currentPage ?? nextPage,
            lastPage: res.message?.lastPage,
            nextPageUrl: res.message?.nextPageUrl,
            firstPageUrl: res.message?.firstPageUrl,
            from: res.message?.from,
            lastPageUrl: res.message?.lastPageUrl,
            links: res.message?.links,
            path: res.message?.path,
            perPage: res.message?.perPage,
            prevPageUrl: res.message?.prevPageUrl,
            to: res.message?.to,
            total: res.message?.total,
            groupMessages: deduped,
          ),
        );

        _currentPage = _model.message?.currentPage ?? nextPage;
        _hasNextPage = _isNextAvailable(_model.message);
        emit(GroupMessagesLoaded(_model, _hasNextPage));
      } else {
        _hasNextPage = false;
        emit(GroupMessagesLoaded(_model, _hasNextPage));
      }
    } catch (e) {
      emit(GroupMessagesFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}