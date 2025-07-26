import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Models/GetCompusModel.dart';
import 'Campuses_Repository.dart';
import 'Campuses_State.dart';

class CampusesCubit extends Cubit<CampusesState> {
  CampusRepo campusRepo;

  CampusesCubit(this.campusRepo) : super(CampusesStateIntially());

  Future<void> getState() async {

    emit(CampusesStateLoading());
    try {
      final res = await campusRepo.getCampusApi();
      if (res != null) {
        emit(CampusesStateLoaded(getCompusModel: res));
      } else {
        emit(CampusesStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(CampusesStateFailure(msg: "An error occurred: $e"));
    }
  }

}
