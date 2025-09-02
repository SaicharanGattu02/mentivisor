import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorSessionCancel/mentor_Session_cancle_repo.dart';

import 'mentor_session_cancle_states.dart';

class MentorSessionCancleCubit extends Cubit<MentorSessionCancleStates> {
  final SessionCanceledRepo mentorSessionCancleRepo;

  MentorSessionCancleCubit(this.mentorSessionCancleRepo)
      : super(MentorsessioncancleInitially());

  Future<SuccessModel?> sessionCancelled(Map<String, dynamic> data) async {
    emit(MentorsessioncancleLoading());
    try {
      final response = await mentorSessionCancleRepo.cancleedsessions(data);
      if (response != null && response.status == true) {
        emit(MentorsessioncancleLoaded(response));
        return response;
      } else {
        emit(MentorsessioncancleFailure(
          response?.message ?? "Session cancel failed!",
        ));
      }
    } catch (e) {
      emit(MentorsessioncancleFailure(e.toString()));
    }
    return null;
  }

  // Optional: bring state back to initial after a flow completes
  void reset() => emit(MentorsessioncancleInitially());
}
