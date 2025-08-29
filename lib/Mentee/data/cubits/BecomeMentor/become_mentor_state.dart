
import '../../../Models/BecomeMentorSuccessModel.dart';

abstract class BecomeMentorStates {}

class BecomeMentorInitially extends BecomeMentorStates {}

class BecomeMentorLoading extends BecomeMentorStates {}

class BecomeMentorSuccess extends BecomeMentorStates {
  BecomeMentorSuccessModel becomeMentorSuccessModel;
  BecomeMentorSuccess(this.becomeMentorSuccessModel);
}

class BecomeMentorFailure extends BecomeMentorStates {
  String error;
  BecomeMentorFailure(this.error);
}
