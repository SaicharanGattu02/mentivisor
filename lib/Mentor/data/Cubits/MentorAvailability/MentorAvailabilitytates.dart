import '../../../../Mentee/Models/SuccessModel.dart';

abstract class MentorAvailabilityStates {}

class MentorAvailabilityInitially extends MentorAvailabilityStates {}

class MentorAvailabilityLoading extends MentorAvailabilityStates {}

class MentorAvailabilityLoaded extends MentorAvailabilityStates {
  final SuccessModel availabilityModel;
  MentorAvailabilityLoaded(this.availabilityModel);
}

class MentorAvailabilityFailure extends MentorAvailabilityStates {
  final String error;
  MentorAvailabilityFailure(this.error);
}