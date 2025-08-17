import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class ReportMenteeStates {}

class ReportMenteeInitially extends ReportMenteeStates {}

class ReportMenteeLoading extends ReportMenteeStates {}

class ReportMenteeLoaded extends ReportMenteeStates {
  SuccessModel successModel;
  ReportMenteeLoaded(this.successModel);
}

class ReportMenteeFailure extends ReportMenteeStates {
  String error;
  ReportMenteeFailure(this.error);
}
