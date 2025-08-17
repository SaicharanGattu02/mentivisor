import '../../../Models/WalletModel.dart';

abstract class WalletmoneyState {}

class WalletmoneyStateIntially extends WalletmoneyState {}

class WalletmoneyStateLoading extends WalletmoneyState {}

class WalletmoneyStateLoaded extends WalletmoneyState {
  final WalletModel walletResponseModel;
  final bool hasNextPage;
  WalletmoneyStateLoaded(this.walletResponseModel, this.hasNextPage);
}

class WalletmoneyStateLoadingMore extends WalletmoneyState {
  final WalletModel walletResponseModel;
  final bool hasNextPage;
  WalletmoneyStateLoadingMore(this.walletResponseModel, this.hasNextPage);
}

class WalletmoneyStateFailure extends WalletmoneyState {
  final String msg;
  WalletmoneyStateFailure({required this.msg});
}
