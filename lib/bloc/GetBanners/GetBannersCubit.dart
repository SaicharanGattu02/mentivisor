import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/GetBanners/GetBannersRepository.dart';
import 'package:mentivisor/bloc/GetBanners/GetBannersState.dart';

class Getbannerscubit extends Cubit<Getbannersstate> {
  Getbannersrepository _getbannersrepository;

  Getbannerscubit(this._getbannersrepository)
    : super(GetbannersStateIntially());

  Future<void> getbanners() async {
    emit(GetbannersStateLoading());
    try {
      final res = await _getbannersrepository.getBannersApi();
      if (res != null) {
        emit(GetbannersStateLoaded(getbannerModel: res));
      } else {
        emit(GetbannersStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(GetbannersStateFailure(msg: "An error occurred: $e"));
    }
  }
}
