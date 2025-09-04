
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/CommentsModel.dart';
import 'CommentsRepo.dart';
import 'FetchCommentsStates.dart';

class FetchCommentsCubit extends Cubit<FetchCommentsStates> {
  final CommentsRepo repo;
  FetchCommentsCubit(this.repo) : super(FetchCommentsInitially());

  Future<CommentsModel?> getComments(int entityId) async {
    emit(FetchCommentsLoading());
    try {
      final res = await repo.getComments(entityId);
      if (res != null) {
        emit(FetchCommentsLoaded(res));
        return res;
      } else {
        emit(FetchCommentsFailure("Comments loading failed!"));
      }
    } catch (e) {
      emit(FetchCommentsFailure(e.toString()));
    }
    return null;
  }
}
