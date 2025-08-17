import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_repo.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_states.dart';

class MentorProfileCubit extends Cubit<MentorProfileStates> {
  MentorProfileRepo mentorProfileRepo;
  MentorProfileCubit(this.mentorProfileRepo) : super(MentorProfileInitially());

  Future<void> getMentorProfile() async {
    emit(MentorProfileLoading());
    try {
      final response = await mentorProfileRepo.getMentorProfile();
      if (response != null && response.status == true) {
        emit(MentorProfileLoaded(response));
      } else {
        emit(MentorProfileFailure("Mentor Profile Details Loading Failed!"));
      }
    } catch (e) {
      emit(MentorProfileFailure(e.toString()));
    }
  }
}
