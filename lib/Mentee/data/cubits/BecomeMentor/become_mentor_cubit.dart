import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/BecomeMentor/become_mentor_state.dart';

import 'become_mentor_repository.dart';

class BecomeMentorCubit extends Cubit<BecomeMentorStates> {
  BecomeMentorRepository becomeMentorRepository;
  BecomeMentorCubit(this.becomeMentorRepository)
    : super(BecomeMentorInitially());

  Future<void> becomeMentor(Map<String, dynamic> data) async {
    emit(BecomeMentorLoading());
    try {
      final response = await becomeMentorRepository.postBecomeMentor(data);
      if (response != null && response.status == true) {
        emit(BecomeMentorSuccess(response));
      } else {
        emit(BecomeMentorFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(BecomeMentorFailure(e.toString()));
    }
  }
}
