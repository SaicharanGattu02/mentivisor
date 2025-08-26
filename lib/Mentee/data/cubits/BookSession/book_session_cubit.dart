import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/book_session_states.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/session_repository.dart';

class SessionBookingCubit extends Cubit<SessionBookingStates> {
  SessionBookingRepo sessionBookingRepo;
  SessionBookingCubit(this.sessionBookingRepo)
    : super(SessionBookingInitially());

  Future<void> sessionBooking(Map<String,dynamic> data) async {
    emit(SessionBookingLoading());
    try {
      final response = await sessionBookingRepo.sessionBooking(data
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
