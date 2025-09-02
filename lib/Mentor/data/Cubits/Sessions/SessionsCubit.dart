import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsRepository.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsStates.dart';

class SessionCubit extends Cubit<SessionStates> {
  SessionSRepo sessionSRepo;
  SessionCubit(this.sessionSRepo) : super(SessionInitially());

  Future<void> getSessions(String sessionType) async {
    emit(SessionLoading());
    try {
      final response = await sessionSRepo.getSessions(sessionType);
      if (response != null && response.status == true) {
        emit(SessionLoaded(response));
      } else {
        emit(SessionFailure("Sessions getting Failed!"));
      }
    } catch (e) {
      emit(SessionFailure(e.toString()));
    }
  }
}
