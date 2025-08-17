import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/FeedBack/feedback_states.dart';

import 'feedback_repository.dart';

class FeedbackCubit extends Cubit<FeedbackStates> {
  FeedBackRepository feedBackRepository;
  FeedbackCubit(this.feedBackRepository) : super(FeedbackInitially());

  Future<void> getFeedback(int user_id) async {
    emit(FeedbackLoading());
    try {
      final response = await feedBackRepository.getFeedback(user_id);
      if (response != null && response.status == true) {
        emit(FeedbackLoaded(response));
      } else {
        emit(FeedbackFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(FeedbackFailure(e.toString()));
    }
  }
}
