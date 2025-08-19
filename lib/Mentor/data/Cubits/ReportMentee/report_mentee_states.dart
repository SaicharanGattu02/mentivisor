import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class ReportMenteeStates {}

class ReportMenteeInitially extends ReportMenteeStates {}

class ReportMenteeLoading extends ReportMenteeStates {}

class ReportMenteeSuccess extends ReportMenteeStates {
  SuccessModel successModel;
  ReportMenteeSuccess(this.successModel);
}

class ReportMenteeFailure extends ReportMenteeStates {
  String error;
  ReportMenteeFailure(this.error);
}
