import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class PostCommentStates {}

class PostCommentInitially extends PostCommentStates {}

class PostCommentLoading extends PostCommentStates {}
class PostCommentOnLikeLoading extends PostCommentStates {}

class PostCommentLoaded extends PostCommentStates {
  SuccessModel successModel;
  PostCommentLoaded(this.successModel);
}
class PostCommentOnLikeSuccess extends PostCommentStates {
  SuccessModel successModel;
  PostCommentOnLikeSuccess(this.successModel);
}

class PostCommentFailure extends PostCommentStates {
  String error;
  PostCommentFailure(this.error);
}
