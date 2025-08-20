import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorInfo/Mentor_Info_states.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorInfo/Mentor_info_repo.dart';

class MentorInfoCubit extends Cubit<MentorInfoStates> {
  MentorInfoRepo mentorProfileRepo;
  MentorInfoCubit(this.mentorProfileRepo) : super(MentorinfoInitially());

  Future<void> getMentorinfo() async {
    emit(MentorinfoLoading());

    try {
      final response = await mentorProfileRepo.getMentorinfo();
      if (response != null && response.status == true) {
        emit(MentorinfoLoaded(response));
      } else {
        emit(MentorinfoFailure("Mentor Profile Details Loading Failed!"));
      }
    } catch (e) {
      emit(MentorinfoFailure(e.toString()));
    }

  }

}
