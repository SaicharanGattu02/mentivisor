import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/DailySlots/daily_slots_states.dart';

import '../BookSession/session_repository.dart';

class DailySlotsCubit extends Cubit<DailySlotsStates> {
  SessionBookingRepo sessionBookingRepo;
  DailySlotsCubit(this.sessionBookingRepo) : super(DailySlotsInitially());

  Future<void> getDailySlots(int mentor_id, String date) async {
    emit(DailySlotsLoading());
    try {
      final response = await sessionBookingRepo.getDailySlots(mentor_id, date);
      if (response != null && response.status == true) {
        emit(DailySlotsLoaded(response));
      } else {
        emit(DailySlotsFailure("Something went wrong!"));
      }
    } catch (e) {
      emit(DailySlotsFailure(e.toString()));
    }
  }
}
