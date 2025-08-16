import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class SessionBookingStates {}

class SessionBookingInitially extends SessionBookingStates {}

class SessionBookingLoading extends SessionBookingStates {}

class SessionBookingLoaded extends SessionBookingStates {
  SuccessModel successModel;
  SessionBookingLoaded(this.successModel);
}

class SessionBookingFailure extends SessionBookingStates {
  String error;
  SessionBookingFailure(this.error);
}
