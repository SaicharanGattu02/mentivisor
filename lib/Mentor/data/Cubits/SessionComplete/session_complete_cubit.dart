import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/SessionComplete/session_complete_repo.dart';
import 'package:mentivisor/Mentor/data/Cubits/SessionComplete/session_complete_states.dart';


class SessionCompleteCubit extends Cubit<SessionCompleteStates> {
  SessionCompleteRepo sessionCompleteRepo;
  SessionCompleteCubit(this.sessionCompleteRepo) : super(SessionCompletdInitially());

  Future<void> sessionComplete(int sessionId) async {
    emit(SessionCompletdLoading(sessionId));
    try {
      final response = await sessionCompleteRepo.sessionComplete(sessionId);
      if (response != null && response.status == true) {
        emit(SessionCompletdSuccess(response,sessionId));
      } else {
        emit(SessionCompletdFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(SessionCompletdFailure(e.toString()));
    }
  }
}
