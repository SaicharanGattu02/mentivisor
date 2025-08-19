

import '../../../../Mentor/Models/MentorProfileModel.dart';

abstract class MentorProfileStates {}

class MentorProfileInitially extends MentorProfileStates {}

class MentorProfileLoading extends MentorProfileStates {}

class MentorProfile1Loaded extends MentorProfileStates {
  MentorprofileModel mentorProfileModel;
  MentorProfile1Loaded(this.mentorProfileModel);
}

class MentorProfileFailure extends MentorProfileStates {
  String error;
  MentorProfileFailure(this.error);
}
