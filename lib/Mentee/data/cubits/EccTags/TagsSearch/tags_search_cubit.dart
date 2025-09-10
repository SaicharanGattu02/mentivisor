import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/EccTags/TagsSearch/tags_search_states.dart';
import '../tags_repository.dart';

class EccTagsSearchCubit extends Cubit<EccTagsSearchState> {
  final EccTagsRepository eccTagsRepository;

  EccTagsSearchCubit(this.eccTagsRepository) : super(EccTagsSearchInitially());

  Future<void> getEccTagsSearch(String query) async {
    emit(EccTagsSearchLoading());
    try {
      final response = await eccTagsRepository.getEccTagSearch(query);
      if (response != null && response.status == true) {
        emit(EccTagsSearchLoaded(response));
      } else {
        emit(EccTagsSearchFailure("Something went wrong"));
      }
    } catch (e) {
      emit(EccTagsSearchFailure(e.toString()));
    }
  }

  void reset() {
    emit(EccTagsSearchInitially());
  }
}
