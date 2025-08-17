import 'package:mentivisor/Mentor/Models/SessionsModel.dart';

abstract class SessionStates {}

class SessionInitially extends SessionStates {}

class SessionLoading extends SessionStates {}

class SessionLoaded extends SessionStates {
  SessionsModel sessionsModel;
  SessionLoaded(this.sessionsModel);
}

class SessionFailure extends SessionStates {
  String error;
  SessionFailure(this.error);
}
