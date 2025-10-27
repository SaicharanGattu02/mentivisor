import 'package:mentivisor/Mentee/Models/LeaderBoardModel.dart';

abstract class LeaderBoardStates {}

class LeaderBoardInitially extends LeaderBoardStates {}

class LeaderBoardLoading extends LeaderBoardStates {}

class LeaderBoardLoaded extends LeaderBoardStates {
  LeaderBoardModel leaderBoardModel;
  LeaderBoardLoaded(this.leaderBoardModel);
}

class LeaderBoardFailure extends LeaderBoardStates {
  String error;
  LeaderBoardFailure(this.error);
}
