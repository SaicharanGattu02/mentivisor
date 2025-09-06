import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class SessionCompleteStates {}

class SessionCompletdInitially extends SessionCompleteStates {}

class SessionCompletdLoading extends SessionCompleteStates {}

class SessionCompletdSuccess extends SessionCompleteStates {
  SuccessModel successModel;
  SessionCompletdSuccess(this.successModel);
}

class SessionCompletdFailure extends SessionCompleteStates {
  String error;
  SessionCompletdFailure(this.error);
}
