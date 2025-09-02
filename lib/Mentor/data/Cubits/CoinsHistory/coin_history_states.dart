import 'package:mentivisor/Mentor/Models/MentorCoinHistoryModel.dart';

abstract class CoinHistoryStates {}

class CoinhistoryInitially extends CoinHistoryStates {}

class CoinhistoryLoading extends CoinHistoryStates {}

class CoinhistoryLoaded extends CoinHistoryStates {
  final MentorCoinHistoryModel coinHistoryModel;
  CoinhistoryLoaded(this.coinHistoryModel);
}

class CoinhistoryFailure extends CoinHistoryStates {
  final String error;

  CoinhistoryFailure(this.error);
}
