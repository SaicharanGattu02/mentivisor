import 'package:flutter_bloc/flutter_bloc.dart';

import 'OnCampus_Repository.dart';
import 'OnCampus_State.dart';

class OncampusCubit extends Cubit<OncampusState> {
  OncampusRepository oncampusRepository;

  OncampusCubit(this.oncampusRepository) : super(GetoncamposeStateIntially());

  Future<void> getoncampose() async {

    emit(GetoncamposeStateLoading());
    try {

      final res = await oncampusRepository.getoncampose();
      if (res != null) {
        emit(GetoncamposeStateLoaded(getonCampusemodel: res));
      } else {
        emit(GetoncamposeStateFailure(msg: "No states found."));
      }

    } catch (e) {

      emit(GetoncamposeStateFailure(msg: "An error occurred: $e"));

    }
  }

}