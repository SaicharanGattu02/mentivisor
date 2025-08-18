import 'package:mentivisor/Mentee/Models/ReviewSubmitModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class SubmitReviewStates {}

class SubmitReviewInitially extends SubmitReviewStates {}

class SubmitReviewLoading extends SubmitReviewStates {}
class SessionReportReviewLoading extends SubmitReviewStates {}

class SubmitReviewSuccess extends SubmitReviewStates {
  ReviewSubmitModel reviewSubmitModel;
  SubmitReviewSuccess(this.reviewSubmitModel);
}
class SessionReportSuccess extends SubmitReviewStates {
  SuccessModel successModel;
  SessionReportSuccess(this.successModel);
}

class SubmitReviewFailure extends SubmitReviewStates {
  String error;
  SubmitReviewFailure(this.error);
}
class SubmitReportFailure extends SubmitReviewStates {
  String error;
  SubmitReportFailure(this.error);
}
