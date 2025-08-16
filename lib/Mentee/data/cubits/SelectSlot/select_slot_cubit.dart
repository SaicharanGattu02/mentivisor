import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/SelectSlot/select_slot_states.dart';

import '../BookSession/session_repository.dart';

class SelectSlotCubit extends Cubit<SelectSlotsStates> {
  SessionBookingRepo sessionBookingRepo;
  SelectSlotCubit(this.sessionBookingRepo) : super(SelectSlotInitially());

  Future<void> getSelectSlot(int mentor_id, int slot_id) async {
    emit(SelectSlotLoading());
    try {
      final response = await sessionBookingRepo.selectSlot(mentor_id, slot_id);
      if (response != null && response.status == true) {
        emit(SelectSlotLoaded(response));
      } else {
        emit(SelectSlotFailure("Something went wrong!"));
      }
    } catch (e) {
      emit(SelectSlotFailure(e.toString()));
    }
  }
}
