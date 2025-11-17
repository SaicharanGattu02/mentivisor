import 'package:flutter_bloc/flutter_bloc.dart';

import '../CommunityPosts/CommunityPostsRepository.dart';
import 'DeletePostStates.dart';

class DeletePostCubit extends Cubit<DeletePostStates> {
  final CommunityPostsRepo communityPostsRepo;

  DeletePostCubit(this.communityPostsRepo) : super(DeletePostInitial());

  Future<void> deletePost(String postId) async {
    emit(DeletePostLoading());
    try {
      final response = await communityPostsRepo.deletePost(postId);

      if (response != null && response.status == true) {
        emit(DeletePostSuccess(response));
      } else {
        emit(DeletePostFailure(response?.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(DeletePostFailure(e.toString()));
    }
  }
}
