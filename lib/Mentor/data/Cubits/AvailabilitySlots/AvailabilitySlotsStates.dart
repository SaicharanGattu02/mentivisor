import 'package:mentivisor/Mentor/Models/AvailableSlotsModel.dart';

abstract class AvailableSlotsStates {}

class AvailableSlotsInitially extends AvailableSlotsStates {}

class AvailableSlotsLoading extends AvailableSlotsStates {}

class AvailableSlotsLoaded extends AvailableSlotsStates {
  final AvailableSlotsModel availableSlotsModel;
  AvailableSlotsLoaded(this.availableSlotsModel);
}

class AvailableSlotsFailure extends AvailableSlotsStates {
  final String error;
  AvailableSlotsFailure(this.error);
}
