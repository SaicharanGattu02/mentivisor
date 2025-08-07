import '../../../Models/WalletResponseModel.dart';

abstract class WalletmoneyState {}

class WalletmoneyStateIntially extends WalletmoneyState {}

class WalletmoneyStateLoading extends WalletmoneyState {}

class WalletmoneyStateLoaded extends WalletmoneyState {
  WalletResponseModel walletResponseModel ;
  WalletmoneyStateLoaded({required this.walletResponseModel});
}

class WalletmoneyStateFailure extends WalletmoneyState {
  final String msg;
  WalletmoneyStateFailure({required this.msg});


}