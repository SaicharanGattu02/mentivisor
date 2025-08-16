import 'package:mentivisor/Mentee/Models/DailySlotsModel.dart';

abstract class DailySlotsStates {}

class DailySlotsInitially extends DailySlotsStates {}

class DailySlotsLoading extends DailySlotsStates {}

class DailySlotsLoaded extends DailySlotsStates {
  DailySlotsModel dailySlotsModel;
  DailySlotsLoaded(this.dailySlotsModel);
}

class DailySlotsFailure extends DailySlotsStates {
  String error;
  DailySlotsFailure(this.error);
}
