import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

import '../../../Models/SessionBookingModel.dart';

abstract class SessionBookingStates {}

class SessionBookingInitially extends SessionBookingStates {}

class SessionBookingLoading extends SessionBookingStates {}

class SessionBookingLoaded extends SessionBookingStates {
  SessionBookingModel sessionBookingModel;
  SessionBookingLoaded(this.sessionBookingModel);
}

class SessionBookingFailure extends SessionBookingStates {
  String error;
  SessionBookingFailure(this.error);
}
