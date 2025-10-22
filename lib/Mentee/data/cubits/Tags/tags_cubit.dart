import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_states.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsRepository tagsRepository;
  TagsCubit(this.tagsRepository) : super(TagsInitially());

  Future<void> getStudyZoneTags(String searchQuery) async {
    emit(TagsLoading());
    try {
      final response = await tagsRepository.getStudyZoneTags(searchQuery);
      if (response != null && response.status == true) {
        emit(TagsLoaded(response));
      } else {
        emit(TagsFailure("Something went wrong"));
      }
    } catch (e) {
      emit(TagsFailure(e.toString()));
    }
  }
}
