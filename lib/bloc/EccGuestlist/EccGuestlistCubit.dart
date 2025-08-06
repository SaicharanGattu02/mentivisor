import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/EccGuestlist/EccGuestListRepository.dart';
import 'package:mentivisor/bloc/EccGuestlist/EccGuestListState.dart';

class Eccguestlistcubit extends Cubit<Eccguestliststate> {
  Eccguestlistrepository eccguestlistrepository;

  Eccguestlistcubit(this.eccguestlistrepository)
      : super(EccguestlistStateIntially());

  Future<void> eccguestlist() async {
    emit(EccguestlistStateLoading());
    try {
      final res = await eccguestlistrepository.eccguestlist();
      if (res != null) {
        emit(EccguestlistStateLoaded(eccGuestlist_Model: res));
      } else {
        emit(EccguestlistStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(EccguestlistStateFailure(msg: "An error occurred: $e"));
    }
  }
}