import '../../../Models/CoinsPackRespModel.dart';

abstract class CoinsPackState {}

class CoinsPackStateInitial extends CoinsPackState {}

class CoinsPackStateLoading extends CoinsPackState {}

class CoinsPackStateLoaded extends CoinsPackState {
  final CoinsPackRespModel coinsPackRespModel;

  CoinsPackStateLoaded({required this.coinsPackRespModel});
}

class CoinsPackStateFailure extends CoinsPackState {
  final String msg;

  CoinsPackStateFailure({required this.msg});
}