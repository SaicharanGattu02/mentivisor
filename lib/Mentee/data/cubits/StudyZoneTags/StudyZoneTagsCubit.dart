import 'package:flutter_bloc/flutter_bloc.dart';

import 'StudyZoneTagsRepository.dart';
import 'StudyZoneTagsState.dart';

class StudyZoneTagsCubit extends Cubit<StudyZoneTagsState> {
  final StudyZoneTagsRepository studyZoneTagsRepository;

  StudyZoneTagsCubit(this.studyZoneTagsRepository)
    : super(StudyZoneTagsInitial());

  Future<void> fetchStudyZoneTags() async {
    emit(StudyZoneTagsLoading());
    try {
      final studyZoneTags = await studyZoneTagsRepository.getStudyZoneTags();
      if (studyZoneTags != null && studyZoneTags.status == true) {
        emit(StudyZoneTagsLoaded(studyZoneTagsModel: studyZoneTags));
      } else {
        emit(StudyZoneTagsFailure(msg: 'No study zone tags found.'));
      }
    } catch (e) {
      emit(StudyZoneTagsFailure(msg: 'An error occurred: $e'));
    }
  }
}
