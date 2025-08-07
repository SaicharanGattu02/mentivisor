import 'package:mentivisor/Mentee/Models/CommunityPostsModel.dart';

abstract class CommunityPostsStates {}

class CommunityPostsInitially extends CommunityPostsStates {}

class CommunityPostsLoading extends CommunityPostsStates {}

class CommunityPostsLoadingMore extends CommunityPostsStates {
  final CommunityPostsModel communityPostsModel;
  final bool hasNextPage;

  CommunityPostsLoadingMore(this.communityPostsModel, this.hasNextPage);
}

class CommunityPostsLoaded extends CommunityPostsStates {
  final CommunityPostsModel communityPostsModel;
  final bool hasNextPage;
  CommunityPostsLoaded(this.communityPostsModel, this.hasNextPage);
}

class CommunityPostsFailure extends CommunityPostsStates {
  final String error;

  CommunityPostsFailure(this.error);
}
