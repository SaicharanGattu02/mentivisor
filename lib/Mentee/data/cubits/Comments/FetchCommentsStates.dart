import '../../../Models/CommentsModel.dart';

abstract class FetchCommentsStates {}
class FetchCommentsInitially extends FetchCommentsStates {}
class FetchCommentsLoading extends FetchCommentsStates {}
class FetchCommentsLoaded extends FetchCommentsStates {
  final CommentsModel commentsModel;
  FetchCommentsLoaded(this.commentsModel);
}
class FetchCommentsFailure extends FetchCommentsStates {
  final String error;
  FetchCommentsFailure(this.error);
}