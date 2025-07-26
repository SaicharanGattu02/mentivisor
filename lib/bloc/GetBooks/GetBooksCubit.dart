import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/GetBooks/GetBooksRepository.dart';

import '../GetBanners/GetBannersState.dart';
import 'GetBooksState.dart';

class Getbookscubit extends Cubit<Getbooksstate> {
  Getbooksrepository _getbannersrepository;

  Getbookscubit(this._getbannersrepository) : super(GetbookStateIntially());

  Future<void> getbooks() async {

    emit(GetbookStateStateLoading());
    try {
      final res = await _getbannersrepository.getbooks();
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