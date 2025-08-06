import 'package:flutter_bloc/flutter_bloc.dart';

import 'TopMentors_Repository.dart';
import 'TopMentors_State.dart';

class TopmentorsCubit extends Cubit<TopmentorsState> {
  TopmentorsRepository topmentorsRepository;

  TopmentorsCubit(this.topmentorsRepository) : super(TopmentorStateIntially());

  Future<void> topmentors() async {

    emit(TopmentorStateLoading());
    try {
      final res = await topmentorsRepository.topmentors();
      if (res != null) {
        emit(TopmentorStateLoaded(topmentersresponsemodel: res));
      } else {
        emit(TopmentorStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(TopmentorStateFailure(msg: "An error occurred: $e"));
    }
  }

}