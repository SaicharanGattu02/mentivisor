import 'package:flutter_bloc/flutter_bloc.dart';
import 'WalletMoney_State.dart';
import 'Walletmoney_Repository.dart';

class WalletmoneyCubit extends Cubit<WalletmoneyState> {
  WalletmoneyRepository walletmoneyRepository;

  WalletmoneyCubit(this.walletmoneyRepository)
    : super(WalletmoneyStateIntially());

  Future<void> getwalletmoney() async {
    emit(WalletmoneyStateLoading());
    try {
      final res = await walletmoneyRepository.getwalletmoney();
      if (res != null) {
        emit(WalletmoneyStateLoaded(walletResponseModel: res));
      } else {
        emit(WalletmoneyStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(WalletmoneyStateFailure(msg: "An error occurred: $e"));
    }
  }

}
