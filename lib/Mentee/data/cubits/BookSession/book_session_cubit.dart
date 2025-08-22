import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/book_session_states.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/session_repository.dart';

class SessionBookingCubit extends Cubit<SessionBookingStates> {
  SessionBookingRepo sessionBookingRepo;
  SessionBookingCubit(this.sessionBookingRepo)
    : super(SessionBookingInitially());

  Future<void> sessionBooking(int mentor_id, int slot_id) async {
    emit(SessionBookingLoading());
    try {
      final response = await sessionBookingRepo.sessionBooking(
        mentor_id,
        slot_id,
      );
      if (response != null && response.status == true) {
        emit(SessionBookingLoaded(response));
      } else {
        emit(SessionBookingFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(SessionBookingFailure(e.toString()));
    }
  }
}
