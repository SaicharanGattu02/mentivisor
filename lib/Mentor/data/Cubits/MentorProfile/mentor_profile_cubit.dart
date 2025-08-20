import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_repo.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_states.dart';

class MentorProfileCubit1 extends Cubit<MentorProfileStates> {
  MentorProfileRepo1 mentorProfileRepo;
  MentorProfileCubit1(this.mentorProfileRepo) : super(MentorProfileInitially());

  Future<void> getMentorProfile() async {
    emit(MentorProfileLoading());
    try {
      final response = await mentorProfileRepo.getMentorProfile();
      if (response != null && response.status == true) {
        emit(MentorProfile1Loaded(response));
      } else {
        emit(MentorProfileFailure("Mentor Profile Details Loading Failed!"));
      }
    } catch (e) {
      emit(MentorProfileFailure(e.toString()));
    }
  }
}
