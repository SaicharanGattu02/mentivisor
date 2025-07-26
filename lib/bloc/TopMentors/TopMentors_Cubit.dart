import 'package:flutter_bloc/flutter_bloc.dart';

import 'TopMentors_Repository.dart';
import 'TopMentors_State.dart';

class Getbannerscubit extends Cubit<TopmentorsState> {
  TopmentorsRepository topmentorsRepository;

  Getbannerscubit(this.topmentorsRepository) : super(TopmentorStateIntially());

  Future<void> topmentors() async {

    emit(TopmentorStateLoading());
    try {
      final res = await topmentorsRepository.topmentors();
      if (res != null) {
        emit(TopmentorStateLoaded(getbannerModel: res));
      } else {
        emit(TopmentorStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(TopmentorStateFailure(msg: "An error occurred: $e"));
    }
  }

}