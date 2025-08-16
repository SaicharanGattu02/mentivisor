import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/AddCommunityPost/add_communitypost_states.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsRepository.dart';

class AddCommunityPostCubit extends Cubit<AddCommunityPostStates> {
  CommunityPostsRepo communityPostsRepo;
  AddCommunityPostCubit(this.communityPostsRepo) : super(AddCommunityPostInitially());

  Future<void> addCommunityPost(Map<String, dynamic> data) async {
    emit(AddCommunityPostLoading());
    try {
      final response = await communityPostsRepo.addCommunityPost(data);
      if (response != null && response.status == true) {
        emit(AddCommunityPostLoaded(response));
      } else {
        emit(AddCommunityPostFailure(response?.message ?? ""));
      }
    } catch (e) {
      AddCommunityPostFailure(e.toString());
    }
  }
}
