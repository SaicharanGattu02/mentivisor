import 'package:mentivisor/Mentee/Models/MentorProfileModel.dart';

abstract class MentorProfileStates {}

class MentorProfileInitially extends MentorProfileStates {}

class MentorProfileLoading extends MentorProfileStates {}

class MentorProfileLoaded extends MentorProfileStates {
  MentorProfileModel mentorProfileModel;
  MentorProfileLoaded(this.mentorProfileModel);
}

class MentorProfileFailure extends MentorProfileStates {
  String error;
  MentorProfileFailure(this.error);
}
