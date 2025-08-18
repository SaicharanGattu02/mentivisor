import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/SessionCompleted/session_completed_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/SessionCompleted/session_completed_states.dart';

class SessionCompletedCubit extends Cubit<SessionCompletedStates> {
  final SessionCompletedRepository upComingSessionRepository;

  SessionCompletedCubit(this.upComingSessionRepository)
    : super(SessionCompletedInitial());

  Future<void> sessionComplete() async {
    emit(SessionCompletedLoading());
    try {
      final upComingSessions = await upComingSessionRepository
          .getSessionComplete();
      if (upComingSessions != null && upComingSessions.status == true) {
        emit(SessionCompletedLoaded(completedSessionModel: upComingSessions));
      } else {
        emit(SessionCompletedFailure(msg: upComingSessions?.message ?? ""));
      }
    } catch (e) {
      emit(SessionCompletedFailure(msg: 'An error occurred: $e'));
    }
  }
}
