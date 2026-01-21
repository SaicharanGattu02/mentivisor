import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class SessionCompleteStates {}

class SessionCompletdInitially extends SessionCompleteStates {}

class SessionCompletdLoading extends SessionCompleteStates {
  final int sessionId;
  SessionCompletdLoading(this.sessionId);
}

class SessionCompletdSuccess extends SessionCompleteStates {
  SuccessModel successModel;
  final int sessionId;
  SessionCompletdSuccess(this.successModel, this.sessionId);
}

class SessionCompletdFailure extends SessionCompleteStates {
  String error;
  SessionCompletdFailure(this.error);
}
