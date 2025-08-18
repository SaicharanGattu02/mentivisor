import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MyMentees/mymentees_repository.dart';

import 'mymentees_states.dart';

class MyMenteeCubit extends Cubit<MyMenteeStates> {
  MyMenteesRepo myMenteesRepo;
  MyMenteeCubit(this.myMenteesRepo) : super(MyMenteeInitially());

  Future<void> getMyMentees() async {
    emit(MyMenteeLoading());
    try {
      final response = await myMenteesRepo.getMyMentees();
      if (response != null && response.status == true) {
        emit(MyMenteeLoaded(response));
      } else {
        emit(MyMenteeFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(MyMenteeFailure(e.toString()));
    }
  }
}
