import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/MentorExpertiseModel.dart';
import '../Expertises/ExpertiseRepo.dart';
import 'expertise_detaill_states.dart';

class MentorExpertiseCubit extends Cubit<MentorExpertiseStates> {
  ExpertisesRepo expertisesRepo;
  MentorExpertiseCubit(this.expertisesRepo) : super(MentorExpertiseInitially());

  Future<MentorExpertiseModel?> getMentorExpertise(int id) async {
    emit(MentorExpertiseLoading());
    try {
      final response = await expertisesRepo.getExpertiseDetails(id);
      if (response != null) {
        emit(MentorExpertiseLoaded(response));
        return response;
      } else {
        emit(MentorExpertiseFailure("Mentor expertise loading failed!"));
      }
    } catch (e) {
      emit(MentorExpertiseFailure(e.toString()));
    }
    return null;
  }
}
