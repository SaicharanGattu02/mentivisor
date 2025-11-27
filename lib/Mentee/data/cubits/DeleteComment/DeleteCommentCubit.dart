import 'package:flutter_bloc/flutter_bloc.dart';

import 'DeleteCommentRepo.dart';
import 'DeleteCommentStates.dart';

class DeleteCommentCubit extends Cubit<DeleteCommentStates> {
  final DeleteCommentRepo deleteCommentRepo;

  DeleteCommentCubit(this.deleteCommentRepo)
      : super(DeleteCommentInitial());

  Future<void> deleteComment(String commentId) async {
    try {
      emit(DeleteCommentLoading());

      final response =
      await deleteCommentRepo.deleteComment(commentId: commentId);

      if (response != null && response.status == true) {
        emit(DeleteCommentLoaded(response));
      } else {
        emit(DeleteCommentFailure(
          response?.message ?? "Failed to delete comment",
        ));
      }
    } catch (e) {
      emit(DeleteCommentFailure(
          "Something went wrong while deleting the comment"));
    }
  }
}
