import '../../../Models/CompletedSessionModel.dart';


abstract class SessionCompletedStates {}

class SessionCompletedInitial extends SessionCompletedStates {}

class SessionCompletedLoading extends SessionCompletedStates {}

class SessionCompletedLoaded extends SessionCompletedStates {
  final CompletedSessionModel completedSessionModel;
  SessionCompletedLoaded({required this.completedSessionModel});
}

class SessionCompletedFailure extends SessionCompletedStates {
  final String msg;
  SessionCompletedFailure({required this.msg});
}
