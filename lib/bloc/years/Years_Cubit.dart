import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/years/Years_Repository.dart';
import 'package:mentivisor/bloc/years/Years_States.dart';

class YearsCubit extends Cubit<YearsStates> {
  YearsRepository campusRepo;

  YearsCubit(this.campusRepo) : super(YearsStatesIntially());

  Future<void> getyears() async {
    emit(YearsStatesLoading());
    try {
      final res = await campusRepo.getyears();
      if (res!= null) {
        emit(YearsStatesLoaded(getyearsModel: res));
      } else {
        emit(YearsStatesFailure(msg: "No years found."));
      }
    } catch (e) {
      emit(YearsStatesFailure(msg: "An error occurred: $e"));
    }
  }

}