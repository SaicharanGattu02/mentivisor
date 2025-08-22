import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/SubmitReview/submit_review_states.dart';

import '../SessionCompleted/session_completed_repo.dart';

class SubmitReviewCubit extends Cubit<SubmitReviewStates> {
  SessionCompletedRepository sessionCompletedRepository;

  SubmitReviewCubit(this.sessionCompletedRepository)
    : super(SubmitReviewInitially());

  Future<void> submitReview(Map<String, dynamic> data, int id) async {
    emit(SubmitReviewLoading());
    try {
      final response = await sessionCompletedRepository.submitReview(data, id);
      if (response != null && response.status == true) {
        emit(SubmitReviewSuccess(response));
      } else {
        emit(SubmitReviewFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(SubmitReviewFailure(e.toString()));
    }
  }
  Future<void> reportReview(Map<String, dynamic> data,) async {
    emit(SessionReportReviewLoading());
    try {
      final response = await sessionCompletedRepository.sessionReportSubmit(data);
      if (response != null && response.status == true) {
        emit(SessionReportSuccess(response));
      } else {
        emit(SubmitReportFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(SubmitReviewFailure(e.toString()));
    }
  }
}
