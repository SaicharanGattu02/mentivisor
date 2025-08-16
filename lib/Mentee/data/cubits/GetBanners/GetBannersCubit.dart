import 'package:flutter_bloc/flutter_bloc.dart';
import 'GetBannersRepository.dart';
import 'GetBannersState.dart';

class Getbannerscubit extends Cubit<Getbannersstate> {
  Getbannersrepository _getbannersrepository;

  Getbannerscubit(this._getbannersrepository)
    : super(GetbannersStateIntially());

  Future<void> getbanners() async {
    emit(GetbannersStateLoading());
    try {
      final res = await _getbannersrepository.getBannersApi();
      if (res != null && res.status == true) {
        emit(GetbannersStateLoaded(getbannerModel: res));
      } else {
        emit(GetbannersStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(GetbannersStateFailure(msg: "An error occurred: $e"));
    }
  }
}
