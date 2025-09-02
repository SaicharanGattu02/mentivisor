import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorSessionCancel/mentor_Session_cancel_repo.dart';

import 'mentor_session_cancel_states.dart';

class MentorSessionCancelCubit extends Cubit<MentorSessionCancleStates> {
  final SessionCanceledRepo mentorSessionCancleRepo;

  MentorSessionCancelCubit(this.mentorSessionCancleRepo)
    : super(MentorsessioncancleInitially());

  Future<SuccessModel?> sessionCancelled(Map<String, dynamic> data) async {
    emit(MentorsessioncancleLoading());
    try {
      final response = await mentorSessionCancleRepo.cancleedsessions(data);
      if (response != null && response.status == true) {
        emit(MentorsessionCancelSuccess(response));
        return response;
      } else {
        emit(
          MentorsessioncancleFailure(
            response?.message ?? "Session cancel failed!",
          ),
        );
      }
    } catch (e) {
      emit(MentorsessioncancleFailure(e.toString()));
    }
    return null;
  }

  void reset() => emit(MentorsessioncancleInitially());
}
