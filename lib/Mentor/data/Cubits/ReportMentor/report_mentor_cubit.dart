import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/ReportMentor/report_mentor_states.dart';
import 'package:mentivisor/Mentor/data/Cubits/ReportMentor/report_repository.dart';

class ReportMentorCubit extends Cubit<ReportMentorStates> {
  ReportMentorRepository reportMentorRepository;
  ReportMentorCubit(this.reportMentorRepository) : super(ReportMentorInitially());

  Future<void> reportMentor(Map<String, dynamic> data) async {
    emit(ReportMentorLoading());
    try {
      final response = await reportMentorRepository.mentorReport(data);
      if (response != null && response.status == true) {
        emit(ReportMentorSuccess(response));
      } else {
        emit(ReportMentorFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(ReportMentorFailure(e.toString()));
    }
  }
}
