import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class ReportMentorStates {}

class ReportMentorInitially extends ReportMentorStates {}

class ReportMentorLoading extends ReportMentorStates {}

class ReportMentorSuccess extends ReportMentorStates {
  SuccessModel successModel;
  ReportMentorSuccess(this.successModel);
}

class ReportMentorFailure extends ReportMentorStates {
  String error;
  ReportMentorFailure(this.error);
}
