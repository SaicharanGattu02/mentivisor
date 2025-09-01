import 'package:flutter_bloc/flutter_bloc.dart';
import '../mentor_profile_repo.dart';
import 'MentorProfileState.dart';

class MentorProfileUpdateCubit extends Cubit<MentorProfileUpdateState> {
  final MentorProfileRepo1 mentorProfileRepository;

  MentorProfileUpdateCubit(this.mentorProfileRepository)
    : super(MentorProfileUpdateInitial());

  Future<void> updateMentorProfile(final Map<String, dynamic> data) async {
    emit(MentorProfileUpdateLoading());
    try {
      final menteeProfile = await mentorProfileRepository.updateMentorProfile(
        data,
      );
      if (menteeProfile != null && menteeProfile.status == true) {
        emit(MentorProfileUpdateSuccess(successModel: menteeProfile));
      } else {
        emit(
          MentorProfileUpdateFailure(
            message:
                menteeProfile?.message ?? 'Failed to update mentor profile.',
          ),
        );
      }
    } catch (e) {
      emit(MentorProfileUpdateFailure(message: 'An error occurred: $e'));
    }
  }
}
