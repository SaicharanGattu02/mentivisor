

import 'package:mentivisor/Mentor/Models/MentorinfoResponseModel.dart';

abstract class MentorInfoStates {}

class MentorinfoInitially extends MentorInfoStates {}

class MentorinfoLoading extends MentorInfoStates {}

class MentorinfoLoaded extends MentorInfoStates {
  MentorinfoResponseModel mentorinfoResponseModel;
  MentorinfoLoaded(this.mentorinfoResponseModel);
}

class MentorinfoFailure extends MentorInfoStates {
  String error;
  MentorinfoFailure(this.error);
}
