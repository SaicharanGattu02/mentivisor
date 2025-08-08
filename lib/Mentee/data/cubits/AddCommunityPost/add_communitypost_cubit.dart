import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/AddCommunityPost/add_communitypost_states.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsRepository.dart';

class AddCommunityPostCubit extends Cubit<AddCommunityPostStates> {
  CommunityPostsRepo communityPostsRepo;
  AddCommunityPostCubit(this.communityPostsRepo) : super(AddCommunityLoading());

  Future<void> addCommunityPost(Map<String, dynamic> data) async {
    emit(AddCommunityLoading());
    try {
      final response = await communityPostsRepo.addCommunityPost(data);
      if (response != null && response.status == true) {
        emit(AddCommunityLoaded(response));
      } else {
        emit(AddCommunityFailure(response?.message ?? ""));
      }
    } catch (e) {
      AddCommunityFailure(e.toString());
    }
  }
}
