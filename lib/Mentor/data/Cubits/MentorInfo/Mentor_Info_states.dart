

import 'package:mentivisor/Mentor/Models/MentorinfoResponseModel.dart';

abstract class MentorInfoStates {}

class MentorinfoInitially extends MentorInfoStates {}

class MentorinfoLoading extends MentorInfoStates {}

class MentorinfoLoaded extends MentorInfoStates {
  final MentorinfoResponseModel mentorinfoResponseModel;
  final bool hasNextPage;

  MentorinfoLoaded(this.mentorinfoResponseModel, this.hasNextPage);
}

class MentorinfoLoadingMore extends MentorInfoStates {
  final MentorinfoResponseModel mentorinfoResponseModel;
  final bool hasNextPage;

  MentorinfoLoadingMore(this.mentorinfoResponseModel, this.hasNextPage);
}

class MentorinfoFailure extends MentorInfoStates {
  final String error;
  MentorinfoFailure(this.error);
}

