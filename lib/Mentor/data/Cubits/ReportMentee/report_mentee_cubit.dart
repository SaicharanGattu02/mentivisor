import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MyMentees/mymentees_repository.dart';
import 'package:mentivisor/Mentor/data/Cubits/ReportMentee/report_mentee_states.dart';

class ReportMenteeCubit extends Cubit<ReportMenteeStates> {
  MyMenteesRepo myMenteesRepo;
  ReportMenteeCubit(this.myMenteesRepo) : super(ReportMenteeInitially());

  Future<void> reportMentee(Map<String, dynamic> data) async {
    emit(ReportMenteeLoading());
    try {
      final response = await myMenteesRepo.reportMentee(data);
      if (response != null && response.status == true) {
        emit(ReportMenteeSuccess(response));
      } else {
        emit(ReportMenteeFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(ReportMenteeFailure(e.toString()));
    }
  }
}
