import '../../../Models/SessionDetailsModel.dart';

abstract class SessionDetailsStates {}

class SessionDetailsInitially extends SessionDetailsStates {}

class SessionDetailsLoading extends SessionDetailsStates {}

class SessionDetailsLoaded extends SessionDetailsStates {
  SessionDetailsModel sessionDetailsModel;
  SessionDetailsLoaded(this.sessionDetailsModel);
}

class SessionDetailsFailure extends SessionDetailsStates {
  String error;
  SessionDetailsFailure(this.error);
}
