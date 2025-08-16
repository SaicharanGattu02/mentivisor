import 'package:flutter_bloc/flutter_bloc.dart';

import '../MenteeProfileRepository.dart';
import 'MenteeProfileState.dart';

class MenteeProfileUpdateCubit extends Cubit<MenteeProfileUpdateState> {
  final MenteeProfileRepository menteeProfileRepository;

  MenteeProfileUpdateCubit(this.menteeProfileRepository)
    : super(MenteeProfileUpdateInitial());

  Future<void> updateMenteeProfile(final Map<String, dynamic> data) async {
    emit(MenteeProfileUpdateLoading());
    try {
      final menteeProfile = await menteeProfileRepository.menteeProfileUpdate(
        data,
      );
      if (menteeProfile != null && menteeProfile.status == true) {
        emit(MenteeProfileUpdateSuccess(successModel: menteeProfile));
      } else {
        emit(
          MenteeProfileUpdateFailure(
            message:
                menteeProfile?.message ?? 'Failed to update mentor profile.',
          ),
        );
      }
    } catch (e) {
      emit(MenteeProfileUpdateFailure(message: 'An error occurred: $e'));
    }
  }
}
