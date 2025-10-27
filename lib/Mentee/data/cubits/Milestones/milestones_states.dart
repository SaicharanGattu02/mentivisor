import 'package:mentivisor/Mentee/Models/MilestonesModel.dart';

abstract class MilesStoneStates {}

class MilesStoneInitially extends MilesStoneStates {}

class MilesStoneLoading extends MilesStoneStates {}

class MilesStoneLoaded extends MilesStoneStates {
  MilestonesModel milestonesModel;
  MilesStoneLoaded(this.milestonesModel);
}

class MilesStoneFailure extends MilesStoneStates {
  String error;
  MilesStoneFailure(this.error);
}
