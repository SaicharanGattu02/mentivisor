import 'package:flutter_bloc/flutter_bloc.dart';

import 'CommonProfileRepo.dart';
import 'CommonProfileState.dart';

class CommonProfileCubit extends Cubit<CommonProfileState> {
  final CommonProfileRepository mentorProfileRepository;

  CommonProfileCubit(this.mentorProfileRepository)
    : super(CommonProfileInitial());

  Future<void> fetchCommonProfile(int id) async {
    emit(CommonProfileLoading());
    try {
      final mentorProfile = await mentorProfileRepository.commonProfile(id);
      if (mentorProfile != null && mentorProfile.status == true) {
        emit(CommonProfileLoaded(mentorProfileModel: mentorProfile));
      } else {
        emit(CommonProfileFailure(message: 'Failed to load common profile.'));
      }
    } catch (e) {
      emit(CommonProfileFailure(message: 'An error occurred: $e'));
    }
  }
}
