import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class MentorSessionCancleStates {}

class MentorsessioncancleInitially extends MentorSessionCancleStates {}

class MentorsessioncancleLoading extends MentorSessionCancleStates {}

class MentorsessioncancleLoaded extends MentorSessionCancleStates {
  SuccessModel successModel;
  MentorsessioncancleLoaded(this.successModel);
}

class MentorsessioncancleFailure extends MentorSessionCancleStates {
  String error;
  MentorsessioncancleFailure(this.error);
}