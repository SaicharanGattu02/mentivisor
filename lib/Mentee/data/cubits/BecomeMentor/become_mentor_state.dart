import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class BecomeMentorStates {}

class BecomeMentorInitially extends BecomeMentorStates {}

class BecomeMentorLoading extends BecomeMentorStates {}

class BecomeMentorSuccess extends BecomeMentorStates {
  SuccessModel successModel;
  BecomeMentorSuccess(this.successModel);
}

class BecomeMentorFailure extends BecomeMentorStates {
  String error;
  BecomeMentorFailure(this.error);
}
