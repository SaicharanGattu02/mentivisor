import 'package:mentivisor/Mentee/Models/WeeklySlotsModel.dart';

abstract class WeeklySlotsStates {}

class WeeklySlotsInitially extends WeeklySlotsStates {}

class WeeklySlotsLoading extends WeeklySlotsStates {}

class WeeklySlotsLoaded extends WeeklySlotsStates {
  WeeklySlotsModel weeklySlotsModel;
  WeeklySlotsLoaded(this.weeklySlotsModel);
}

class WeeklySlotsFailure extends WeeklySlotsStates {
  String error;
  WeeklySlotsFailure(this.error);
}
