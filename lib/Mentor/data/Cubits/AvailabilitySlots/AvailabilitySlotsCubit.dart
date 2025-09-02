import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/Models/AvailableSlotsModel.dart';

import '../MentorAvailability/MentorAvailabilityRepo.dart';
import 'AvailabilitySlotsStates.dart';

class AvailableSlotsCubit extends Cubit<AvailableSlotsStates> {
  final MentorAvailabilityRepo mentorAvailabilityRepo;
  AvailableSlotsCubit(this.mentorAvailabilityRepo)
    : super(AvailableSlotsInitially());

  Future<AvailableSlotsModel?> getAvailableSlots() async {
    emit(AvailableSlotsLoading());
    try {
      final response = await mentorAvailabilityRepo.getMentorAvailability();
      if (response != null && response.status == true) {
        emit(AvailableSlotsLoaded(response));
        return response;
      } else {
        emit(AvailableSlotsFailure("Available Slots Details Loading Failed!"));
      }
    } catch (e) {
      emit(AvailableSlotsFailure(e.toString()));
    }
    return null;
  }
}
