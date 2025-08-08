import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_states.dart';

class PostCommentCubit extends Cubit<PostCommentStates> {
  PostCommentRepository postCommentRepository;

  PostCommentCubit(this.postCommentRepository) : super(PostCommentInitially());

  Future<void> postComment(Map<String, dynamic> data) async {
    emit(PostCommentLoading());
    try {
      final response = await postCommentRepository.postComment(data);
      if (response != null && response.status == true) {
        emit(PostCommentLoaded(response));
      } else {
        emit(PostCommentFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(PostCommentFailure(e.toString()));
    }
  }
}
