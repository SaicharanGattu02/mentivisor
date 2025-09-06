import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_states.dart';
import '../../../Models/CommentsModel.dart';
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

  // in PostCommentCubit

  Future<void> likeParentComment(CommunityOnComments comment) async {
    final prevLiked = comment.isLiked ?? false;
    final prevCount = comment.likesCount ?? 0;

    // optimistic update
    comment.isLiked = !prevLiked;
    comment.likesCount = prevLiked ? (prevCount - 1) : (prevCount + 1);
    emit(PostCommentOnLikeLoading());

    try {
      final response = await postCommentRepository.commentLike(comment.id!);
      if (response != null && response.status == true) {
        emit(PostCommentOnLikeSuccess(response));
      } else {
        // rollback
        comment.isLiked = prevLiked;
        comment.likesCount = prevCount;
        emit(PostCommentFailure(response?.message ?? "Failed to like comment"));
      }
    } catch (e) {
      // rollback
      comment.isLiked = prevLiked;
      comment.likesCount = prevCount;
      emit(PostCommentFailure(e.toString()));
    }
  }

  Future<void> likeReply({
    required CommunityOnComments parent,
    required Replies reply,
  }) async {
    final prevLiked = reply.isLiked ?? false;
    final prevCount = reply.likesCount ?? 0;

    // optimistic update for the REPLY object (not the parent)
    reply.isLiked = !prevLiked;
    reply.likesCount = prevLiked ? (prevCount - 1) : (prevCount + 1);
    emit(PostCommentOnLikeLoading());

    try {
      final response = await postCommentRepository.commentLike(reply.id!);
      if (response != null && response.status == true) {
        emit(PostCommentOnLikeSuccess(response));
      } else {
        // rollback
        reply.isLiked = prevLiked;
        reply.likesCount = prevCount;
        emit(PostCommentFailure(response?.message ?? "Failed to like reply"));
      }
    } catch (e) {
      // rollback
      reply.isLiked = prevLiked;
      reply.likesCount = prevCount;
      emit(PostCommentFailure(e.toString()));
    }
  }
}
