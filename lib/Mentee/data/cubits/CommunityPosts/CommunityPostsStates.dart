import 'package:mentivisor/Mentee/Models/CommunityPostsModel.dart';

abstract class CommunityPostsStates {}

class CommunityPostsInitially extends CommunityPostsStates {}

class CommunityPostsLoading extends CommunityPostsStates {}

class CommunityPostsLoaded extends CommunityPostsStates {
  CommunityPostsModel communityPostsModel;
  CommunityPostsLoaded(this.communityPostsModel);
}

class CommunityPostsFailure extends CommunityPostsStates {
  String error;
  CommunityPostsFailure(this.error);
}
