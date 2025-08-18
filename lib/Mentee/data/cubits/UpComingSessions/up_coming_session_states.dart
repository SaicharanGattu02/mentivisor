import '../../../Models/UpComingSessionModel.dart';

abstract class UpComingSessionStates {}

class UpComingSessionInitial extends UpComingSessionStates {}

class UpComingSessionsLoading extends UpComingSessionStates {}

class UpComingSessionLoaded extends UpComingSessionStates {
  final UpComingSessionModel upComingSessionModel;
  UpComingSessionLoaded({required this.upComingSessionModel});
}

class UpComingSessionFailure extends UpComingSessionStates {
  final String msg;
  UpComingSessionFailure({required this.msg});
}
