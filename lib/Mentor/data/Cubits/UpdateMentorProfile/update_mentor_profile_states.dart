import 'package:mentivisor/Mentee/Models/SuccessModel.dart';


abstract class UpdateMentorProfileStates {}

class UpdateMentorProfileInitially extends UpdateMentorProfileStates {}

class UpdateMentorProfileLoading extends UpdateMentorProfileStates {}

class UpdateMentorProfileLoaded extends UpdateMentorProfileStates {
  SuccessModel successModel;
  UpdateMentorProfileLoaded(this.successModel);
}

class UpdateMentorProfileFailure extends UpdateMentorProfileStates {
  String error;
  UpdateMentorProfileFailure(this.error);
}
