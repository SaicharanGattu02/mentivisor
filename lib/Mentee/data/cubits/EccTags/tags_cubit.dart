import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/EccTags/tags_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/EccTags/tags_states.dart';

class EccTagsCubit extends Cubit<EccTagsState> {
  EccTagsRepository eccTagsRepository;
  EccTagsCubit(this.eccTagsRepository) : super(EccTagsInitially());

  Future<void> getEccTags() async {
    emit(EccTagsLoading());
    try {
      final response = await eccTagsRepository.getEccTags();
      if (response != null && response.status == true) {
        emit(EccTagsLoaded(response));
      } else {
        emit(EccTagsFailure("Something went wrong"));
      }
    } catch (e) {
      emit(EccTagsFailure(e.toString()));
    }
  }
}
