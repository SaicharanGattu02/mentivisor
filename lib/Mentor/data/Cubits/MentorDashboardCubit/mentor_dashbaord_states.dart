import 'package:mentivisor/Mentee/Models/GetBannersRespModel.dart';
import 'package:mentivisor/Mentor/Models/SessionsModel.dart';

abstract class MentorDashBoardState {}

class MentorDashBoardInitially extends MentorDashBoardState {}

class MentorDashBoardLoading extends MentorDashBoardState {}

class MentorDashBoardLoaded extends MentorDashBoardState {
  final GetBannersRespModel? getBannersRespModel;
  final SessionsModel? sessionsModel;

  MentorDashBoardLoaded({this.getBannersRespModel, this.sessionsModel});
}

class MentorDashBoardFailure extends MentorDashBoardState {
  final String error;
  MentorDashBoardFailure(this.error);
}
