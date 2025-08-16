import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/session_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/WeeklySlots/weekly_slots_states.dart';

class WeeklySlotsCubit extends Cubit<WeeklySlotsStates> {
  SessionBookingRepo sessionBookingRepo;
  WeeklySlotsCubit(this.sessionBookingRepo) : super(WeeklySlotsInitially());

  Future<void> getWeeklySlots(int mentorId, {String week = 'this'}) async {
    emit(WeeklySlotsLoading());
    try {
      final response = await sessionBookingRepo.getWeeklySlots(mentorId,week: week);
      if (response != null && response.status == true) {
        emit(WeeklySlotsLoaded(response));
      } else {
        emit(WeeklySlotsFailure("Something went wrong!"));
      }
    } catch (e) {
      emit(WeeklySlotsFailure(e.toString()));
    }
  }
}
