import 'package:mentivisor/Mentor/Models/FeedbackModel.dart';

abstract class FeedbackStates {}

class FeedbackInitially extends FeedbackStates {}

class FeedbackLoading extends FeedbackStates {}

class FeedbackLoaded extends FeedbackStates {
  FeedbackModel feedbackModel;
  FeedbackLoaded(this.feedbackModel);
}

class FeedbackFailure extends FeedbackStates {
  String error;
  FeedbackFailure(this.error);
}
