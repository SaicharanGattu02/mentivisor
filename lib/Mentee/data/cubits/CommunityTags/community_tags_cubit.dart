import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsRepository.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityTags/community_tags_states.dart';

class CommunityTagsCubit extends Cubit<CommunityTagsStates> {
  final CommunityPostsRepo communityPostsRepo;

  CommunityTagsCubit(this.communityPostsRepo) : super(CommunityTagsInitially());

  Future<void> getCommunityTags() async {
    emit(CommunityTagsLoading());
    try {
      final response = await communityPostsRepo.getCommunityZoneTags();
      if (response != null && response.status == true) {
        emit(CommunityTagsLoaded(
          allTags: response.tags ?? [],
          selectedTags: [],
        ));
      } else {
        emit(CommunityTagsFailure("Something went wrong"));
      }
    } catch (e) {
      emit(CommunityTagsFailure(e.toString()));
    }
  }

  void toggleTag(String tag) {
    if (state is CommunityTagsLoaded) {
      final currentState = state as CommunityTagsLoaded;
      final currentSelected = List<String>.from(currentState.selectedTags);

      if (currentSelected.contains(tag)) {
        currentSelected.remove(tag);
      } else {
        currentSelected.add(tag);
      }

      debugPrint("Emitting state with selectedTags: $currentSelected");
      emit(currentState.copyWith(selectedTags: currentSelected));
    }
  }

  void addTag(String tag) {
    if (state is CommunityTagsLoaded) {
      final currentState = state as CommunityTagsLoaded;
      if (!currentState.selectedTags.contains(tag)) {
        final updated = List<String>.from(currentState.selectedTags)..add(tag);
        debugPrint("Emitting state with selectedTags: $updated");
        emit(currentState.copyWith(selectedTags: updated));
      }
    }
  }

}

