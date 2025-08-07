import 'package:flutter_bloc/flutter_bloc.dart';

import 'MentorProfileRepository.dart';
import 'MentorProfileState.dart';

class MentorProfileCubit extends Cubit<MentorProfileState> {
  final MentorProfileRepository mentorProfileRepository;

  MentorProfileCubit(this.mentorProfileRepository)
    : super(MentorProfileInitial());

  Future<void> fetchMentorProfile(int id) async {
    emit(MentorProfileLoading());
    try {
      final mentorProfile = await mentorProfileRepository.getMentorProfile(id);
      if (mentorProfile != null) {
        emit(MentorProfileLoaded(mentorProfileModel: mentorProfile));
      } else {
        emit(MentorProfileFailure(message: 'Failed to load mentor profile.'));
      }
    } catch (e) {
      emit(MentorProfileFailure(message: 'An error occurred: $e'));
    }
  }
}
