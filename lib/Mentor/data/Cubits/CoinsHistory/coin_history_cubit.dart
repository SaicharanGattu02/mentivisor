import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/CoinsHistory/coin_history_repo.dart';
import 'package:mentivisor/Mentor/data/Cubits/CoinsHistory/coin_history_states.dart';

class CoinHistoryCubit extends Cubit<CoinHistoryStates> {
  CoinHistoryRepo coinHistoryRepo;
  CoinHistoryCubit(this.coinHistoryRepo) : super(CoinhistoryInitially());

  Future<void> getCoinHistory(String filter) async {
    emit(CoinhistoryLoading());
    try {
      final response = await coinHistoryRepo.getCoinsHistory(filter);
      if (response != null && response.status == true) {
        emit(CoinhistoryLoaded(response));
      } else {
        emit(CoinhistoryFailure("Mentor Profile Details Loading Failed!"));
      }
    } catch (e) {
      emit(CoinhistoryFailure(e.toString()));
    }
  }
}
