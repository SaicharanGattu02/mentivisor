import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_repo.dart';
import 'package:mentivisor/Mentor/data/Cubits/UpdateMentorProfile/update_mentor_profile_states.dart';

class UpdateMentorProfileCubit extends Cubit<UpdateMentorProfileStates> {
  MentorProfileRepo mentorProfileRepo;
  UpdateMentorProfileCubit(this.mentorProfileRepo)
    : super(UpdateMentorProfileInitially());

  Future<void> updateMentorProfileDetails(Map<String, dynamic> data) async {
    emit(UpdateMentorProfileLoading());
    try {
      final response = await mentorProfileRepo.updateMentorProfile(data);
      if (response != null && response.status == true) {
        emit(UpdateMentorProfileLoaded(response));
      } else {
        emit(UpdateMentorProfileFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(UpdateMentorProfileFailure(e.toString()));
    }
  }
}
