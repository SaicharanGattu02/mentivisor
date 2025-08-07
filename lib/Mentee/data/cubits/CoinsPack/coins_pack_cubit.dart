import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_state.dart';

class CoinsPackCubit extends Cubit<CoinsPackState> {
  final CoinsPackRepo coinsPackRepo;

  CoinsPackCubit(this.coinsPackRepo)
      : super(CoinsPackStateInitial());

  Future<void> fetchCoinsPack() async {
    emit(CoinsPackStateLoading());
    try {
      final result = await coinsPackRepo.getcoinspack();
      if (result != null) {
        emit(CoinsPackStateLoaded(coinsPackRespModel: result));
      } else {
        emit(CoinsPackStateFailure(msg: "No data found."));
      }
    } catch (e) {
      emit(CoinsPackStateFailure(msg: "An error occurred: $e"));
    }
  }
}