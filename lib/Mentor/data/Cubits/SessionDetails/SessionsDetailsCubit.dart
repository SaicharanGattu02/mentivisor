import 'package:flutter_bloc/flutter_bloc.dart';
import 'SessionsDetailsRepository.dart';
import 'SessionsDetailsStates.dart';

class SessionDetailsCubit extends Cubit<SessionDetailsStates> {
  SessionsDetailsRepo sessionsDetailsRepo;
  SessionDetailsCubit(this.sessionsDetailsRepo) : super(SessionDetailsInitially());

  Future<void> getSessionDetails(int sessionId) async {
    emit(SessionDetailsLoading());
    try {
      final response = await sessionsDetailsRepo.getSessionsDetails(sessionId);
      if (response != null && response.status == true) {
        emit(SessionDetailsLoaded(response));
      } else {
        emit(SessionDetailsFailure("Sessions getting Failed!"));
      }
    } catch (e) {
      emit(SessionDetailsFailure(e.toString()));
    }
  }
}
