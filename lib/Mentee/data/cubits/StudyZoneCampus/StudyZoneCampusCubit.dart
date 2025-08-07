import 'package:flutter_bloc/flutter_bloc.dart';
import 'StudyZoneCampusRepository.dart';
import 'StudyZoneCampusState.dart';

class StudyZoneCampusCubit extends Cubit<StudyZoneCampusState> {
  final StudyZoneCampusRepository studyZoneCampusRepository;

  StudyZoneCampusCubit(this.studyZoneCampusRepository)
    : super(StudyZoneCampusInitial());

  Future<void> fetchStudyZoneCampus(String scope, String tag) async {
    emit(StudyZoneCampusLoading());
    try {
      final campusData = await studyZoneCampusRepository.getStudyZoneCampus(
        scope,
        tag,
      );
      if (campusData != null && campusData.status == true) {
        emit(StudyZoneCampusLoaded(studyZoneCampusModel: campusData));
      } else {
        emit(
          StudyZoneCampusFailure(message: 'Failed to load study zone campus.'),
        );
      }
    } catch (e) {
      emit(StudyZoneCampusFailure(message: 'An error occurred: $e'));
    }
  }
}
