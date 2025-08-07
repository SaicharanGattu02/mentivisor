import 'package:flutter_bloc/flutter_bloc.dart';
import 'StudyZoneReportRepo.dart';
import 'StudyZoneReportState.dart';

class StudyZoneReportCubit extends Cubit<StudyZoneReportState> {
  final StudyZoneReportRepository studyZoneReportRepository;

  StudyZoneReportCubit(this.studyZoneReportRepository)
    : super(StudyZoneReportInitial());

  Future<void> postStudyZoneReport(Map<String, dynamic> data) async {
    emit(StudyZoneReportLoading());
    try {
      final res = await studyZoneReportRepository.postStudyZoneReport(data);
      if (res != null && res.status == true) {
        emit(StudyZoneReportSuccess(res));
      } else {
        emit(StudyZoneReportFailure(message: res?.message ?? "Login failed"));
      }
    } catch (e) {
      emit(StudyZoneReportFailure(message: "An error occurred: $e"));
    }
  }
}
