import 'package:flutter_bloc/flutter_bloc.dart';

import 'MenteeProfileRepository.dart';
import 'MenteeProfileState.dart';

class MenteeProfileCubit extends Cubit<MenteeProfileState> {
  final MenteeProfileRepository menteeProfileRepository;

  MenteeProfileCubit(this.menteeProfileRepository)
    : super(MenteeProfileInitial());

  Future<void> fetchMenteeProfile() async {
    emit(MenteeProfileLoading());
    try {
      final menteeProfile = await menteeProfileRepository.getMenteeProfile();
      if (menteeProfile != null && menteeProfile.status == true) {
        emit(MenteeProfileLoaded(menteeProfileModel: menteeProfile));
      } else {
        emit(
          MenteeProfileFailure(
            message: menteeProfile?.message ?? 'Failed to load mentor profile.',
          ),
        );
      }
    } catch (e) {
      emit(MenteeProfileFailure(message: 'An error occurred: $e'));
    }
  }
}
