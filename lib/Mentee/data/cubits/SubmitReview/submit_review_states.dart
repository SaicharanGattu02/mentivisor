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
class SessionReportReviewSuccess extends SubmitReviewStates {
  SuccessModel successModel;
  SessionReportReviewSuccess(this.successModel);
}

class SubmitReviewFailure extends SubmitReviewStates {
  String error;
  SubmitReviewFailure(this.error);
}
