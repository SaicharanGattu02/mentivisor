import 'package:flutter_bloc/flutter_bloc.dart';

import 'OnCampus_Repository.dart';
import 'OnCampus_State.dart';

class OncampusCubit extends Cubit<OncampusState> {
  OncampusRepository oncampusRepository;

  OncampusCubit(this.oncampusRepository) : super(GetbookStateIntially());

  Future<void> getbooks() async {

    emit(GetbookStateStateLoading());
    try {
      final res = await oncampusRepository.getoncampose();
      if (res != null) {
        emit(GetbookStateLoaded(getBooksRespModel: res));
      } else {
        emit(GetbooksStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(GetbooksStateFailure(msg: "An error occurred: $e"));
    }
  }

}