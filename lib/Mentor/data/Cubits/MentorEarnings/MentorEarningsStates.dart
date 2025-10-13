import '../../../Models/MentorEarningsModel.dart';

abstract class MentorEarningsStates {}

class MentorEarningsInitially extends MentorEarningsStates {}

class MentorEarningsLoading extends MentorEarningsStates {}

class MentorEarningsLoaded extends MentorEarningsStates {
  MentorEarningsModel mentorEarningsModel;
  MentorEarningsLoaded(this.mentorEarningsModel);
}

class MentorEarningsFailure extends MentorEarningsStates {
  String error;
  MentorEarningsFailure(this.error);
}
