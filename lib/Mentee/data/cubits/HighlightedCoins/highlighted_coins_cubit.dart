import 'package:flutter_bloc/flutter_bloc.dart';
import 'highlighted_coins_repository.dart';
import 'highlighted_coins_state.dart';

class HighlightedCoinsCubit extends Cubit<HighlightedCoinsState> {
  HighlightedCoinsRepository highlightedCoinsRepository;

  HighlightedCoinsCubit(this.highlightedCoinsRepository)
    : super(GetHighlightedCoinsIntially());

  Future<void> highlitedCoins(String category) async {
    emit(GetHighlightedCoinsLoading());
    try {
      final res = await highlightedCoinsRepository.getHighlitedCoins(category);
      if (res != null && res.status == true) {
        emit(GetHighlightedCoinsLoaded(highlightedCoinsModel: res));
      } else {
        emit(GetHighlightedCoinsFailure(msg: res?.message ?? ""));
      }
    } catch (e) {
      emit(GetHighlightedCoinsFailure(msg: "An error occurred: $e"));
    }
  }
}
