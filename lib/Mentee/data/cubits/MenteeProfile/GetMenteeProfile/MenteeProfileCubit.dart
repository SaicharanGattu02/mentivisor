import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Models/MenteeProfileModel.dart';
import '../MenteeProfileRepository.dart';
import 'MenteeProfileState.dart';

class MenteeProfileCubit extends Cubit<MenteeProfileState> {
  final MenteeProfileRepository menteeProfileRepository;

  MenteeProfileCubit(this.menteeProfileRepository)
    : super(MenteeProfileInitial());

  Future<MenteeProfileModel?> fetchMenteeProfile() async {
    emit(MenteeProfileLoading());
    try {
      final menteeProfile = await menteeProfileRepository.getMenteeProfile();
      if (menteeProfile != null && menteeProfile.status == true) {
        emit(MenteeProfileLoaded(menteeProfileModel: menteeProfile));
        return menteeProfile;
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
    return null;
  }
}
