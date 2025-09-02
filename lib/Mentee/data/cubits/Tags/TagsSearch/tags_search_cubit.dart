import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/TagsSearch/tags_search_states.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_repository.dart';

class TagsSearchCubit extends Cubit<TagsSearchState> {
  final TagsRepository tagsRepository;

  TagsSearchCubit(this.tagsRepository) : super(TagsSearchInitially());

  Future<void> getTagsSearch(String query) async {
    emit(TagsSearchLoading());
    try {
      final response = await tagsRepository.getTagSearch(query);
      if (response != null && response.status == true) {
        emit(TagsSearchLoaded(response));
      } else {
        emit(TagsSearchFailure("Something went wrong"));
      }
    } catch (e) {
      emit(TagsSearchFailure(e.toString()));
    }
  }

  void reset() {
    emit(TagsSearchInitially());
  }
}
