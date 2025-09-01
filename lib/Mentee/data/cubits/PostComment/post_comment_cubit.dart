import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_states.dart';
import '../../../Models/CommunityPostsModel.dart';

class PostCommentCubit extends Cubit<PostCommentStates> {
  PostCommentRepository postCommentRepository;

  PostCommentCubit(this.postCommentRepository) : super(PostCommentInitially());

  Future<void> postComment(
    Map<String, dynamic> data,
    CommunityPosts communityPosts,
  ) async {
    emit(PostCommentLoading());
    try {
      final response = await postCommentRepository.postComment(data);
      if (response != null && response.status == true) {
        communityPosts.commentsCount = (communityPosts.commentsCount ?? 0) + 1;
        emit(PostCommentLoaded(response));
      } else {
        emit(PostCommentFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(PostCommentFailure(e.toString()));
    }
  }

  Future<void> postLike(
    Map<String, dynamic> data,
    CommunityPosts communityPosts,
  ) async {
    final wasLiked = communityPosts.isLiked ?? false;
    communityPosts.isLiked = !wasLiked;

    if (communityPosts.likesCount == null) communityPosts.likesCount = 0;
    communityPosts.likesCount = wasLiked
        ? (communityPosts.likesCount! - 1)
        : (communityPosts.likesCount! + 1);

    emit(PostCommentLoading());

    try {
      final response = await postCommentRepository.postToggleLike(data);
      if (response != null && response.status == true) {
        emit(PostCommentLoaded(response));
      } else {
        // Revert changes on failure
        communityPosts.isLiked = wasLiked;
        communityPosts.likesCount = wasLiked
            ? (communityPosts.likesCount! + 1)
            : (communityPosts.likesCount! - 1);
        emit(PostCommentFailure(response?.message ?? ""));
      }
    } catch (e) {
      // Revert changes on exception
      communityPosts.isLiked = wasLiked;
      communityPosts.likesCount = wasLiked
          ? (communityPosts.likesCount! + 1)
          : (communityPosts.likesCount! - 1);
      emit(PostCommentFailure(e.toString()));
    }
  }


  Future<void> postOnCommentLike(
    Map<String, dynamic> data,
    CommunityPosts communityPosts,
  ) async {
    final wasLiked = communityPosts.isLiked ?? false;
    communityPosts.isLiked = !wasLiked;

    if (communityPosts.likesCount == null) communityPosts.likesCount = 0;
    communityPosts.likesCount = wasLiked
        ? (communityPosts.likesCount! - 1)
        : (communityPosts.likesCount! + 1);

    emit(PostCommentLoading());

    try {
      final response = await postCommentRepository.commentLike(data);
      if (response != null && response.status == true) {
        emit(PostCommentLoaded(response));
      } else {
        // Revert changes on failure
        communityPosts.isLiked = wasLiked;
        communityPosts.likesCount = wasLiked
            ? (communityPosts.likesCount! + 1)
            : (communityPosts.likesCount! - 1);
        emit(PostCommentFailure(response?.message ?? ""));
      }
    } catch (e) {
      // Revert changes on exception
      communityPosts.isLiked = wasLiked;
      communityPosts.likesCount = wasLiked
          ? (communityPosts.likesCount! + 1)
          : (communityPosts.likesCount! - 1);
      emit(PostCommentFailure(e.toString()));
    }
  }
}
