import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Mentee/Models/SuccessModel.dart';
import 'MentorAvailabilityRepo.dart';
import 'MentorAvailabilitytates.dart';

class MentorAvailabilityCubit extends Cubit<MentorAvailabilityStates> {
  final MentorAvailabilityRepo mentorAvailabilityRepo;
  MentorAvailabilityCubit(this.mentorAvailabilityRepo)
    : super(MentorAvailabilityInitially());

  Future<SuccessModel?> addMentorAvailability(Map<String, dynamic> data) async {
    emit(MentorAvailabilityLoading());
    try {
      final response = await mentorAvailabilityRepo.addMentorAvailability(data);
      if (response != null && response.status == true) {
        emit(MentorAvailabilityLoaded(response));
        return response;
      } else {
        emit(MentorAvailabilityFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(MentorAvailabilityFailure(e.toString()));
    }
    return null;
  }
}
