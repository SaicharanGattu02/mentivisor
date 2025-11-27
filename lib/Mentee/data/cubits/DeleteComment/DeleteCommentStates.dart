import '../../../Models/SuccessModel.dart';

abstract class DeleteCommentStates {}

class DeleteCommentInitial extends DeleteCommentStates {}

class DeleteCommentLoading extends DeleteCommentStates {}

class DeleteCommentLoaded extends DeleteCommentStates {
  final SuccessModel successModel;

  DeleteCommentLoaded(this.successModel);
}

class DeleteCommentFailure extends DeleteCommentStates {
  final String error;

  DeleteCommentFailure(this.error);
}
