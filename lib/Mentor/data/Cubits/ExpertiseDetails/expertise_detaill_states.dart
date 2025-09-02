import '../../../Models/MentorExpertiseModel.dart';

abstract class MentorExpertiseStates {}

class MentorExpertiseInitially extends MentorExpertiseStates {}

class MentorExpertiseLoading extends MentorExpertiseStates {}

class MentorExpertiseLoaded extends MentorExpertiseStates {
  final MentorExpertiseModel mentorExpertiseModel;
  MentorExpertiseLoaded(this.mentorExpertiseModel);
}

class MentorExpertiseFailure extends MentorExpertiseStates {
  final String error;
  MentorExpertiseFailure(this.error);
}