import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_states.dart';

class UpComingSessionCubit extends Cubit<UpComingSessionStates> {
  final UpComingSessionRepository upComingSessionRepository;

  UpComingSessionCubit(this.upComingSessionRepository)
    : super(UpComingSessionInitial());

  Future<void> upComingSessions() async {
    emit(UpComingSessionsLoading());
    try {
      final upComingSessions = await upComingSessionRepository
          .getUpComingSessions();
      if (upComingSessions != null && upComingSessions.status == true) {
        emit(UpComingSessionLoaded(upComingSessionModel: upComingSessions));
      } else {
        emit(UpComingSessionFailure(msg: upComingSessions?.message ?? ""));
      }
    } catch (e) {
      emit(UpComingSessionFailure(msg: 'An error occurred: $e'));
    }
  }
}
