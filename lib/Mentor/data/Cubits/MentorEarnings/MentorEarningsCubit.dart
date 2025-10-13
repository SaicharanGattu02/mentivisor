import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsRepository.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsStates.dart';

import 'MentorEarningsRepository.dart';
import 'MentorEarningsStates.dart';

class MentorEarningsCubit extends Cubit<MentorEarningsStates> {
  MentorEarningsRepo mentorEarningsRepo;
  MentorEarningsCubit(this.mentorEarningsRepo)
    : super(MentorEarningsInitially());

  Future<void> getMentorEarnings() async {
    emit(MentorEarningsLoading());
    try {
      final response = await mentorEarningsRepo.getMentorEarnings();
      if (response != null && response.status == true) {
        emit(MentorEarningsLoaded(response));
      } else {
        emit(MentorEarningsFailure("Sessions getting Failed!"));
      }
    } catch (e) {
      emit(MentorEarningsFailure(e.toString()));
    }
  }
}
